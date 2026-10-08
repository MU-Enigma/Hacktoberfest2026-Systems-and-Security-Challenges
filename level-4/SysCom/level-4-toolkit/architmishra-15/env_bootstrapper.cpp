#include <cstdlib>
#include <fstream>
#include <iostream>
#include <optional>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
#include <sys/utsname.h>
#include <unistd.h>

struct Manager {
    std::string refresh;
    std::string install;
    std::string python_pkg;
};

const std::unordered_map<std::string, std::string> distro_to_manager = {
    {"ubuntu", "apt"},    {"debian", "apt"},
    {"fedora", "dnf"},    {"rhel", "dnf"},    {"centos", "dnf"},
    {"arch", "pacman"},   {"manjaro", "pacman"},
    {"suse", "zypper"},   {"opensuse-leap", "zypper"}, {"opensuse-tumbleweed", "zypper"},
    {"alpine", "apk"},
    {"macos", "brew"},
};

const std::unordered_map<std::string, Manager> managers = {
    {"apt",    {"apt-get update", "env DEBIAN_FRONTEND=noninteractive apt-get install -y", "python3"}},
    {"dnf",    {"", "dnf install -y", "python3"}},
    {"pacman", {"", "pacman -S --noconfirm --needed", "python"}},
    {"zypper", {"", "zypper --non-interactive install", "python3"}},
    {"apk",    {"", "apk add --no-cache", "python3"}},
    {"brew",   {"", "brew install", "python"}},
};

std::vector<std::string> detect_distro_ids() {
    utsname info;
    uname(&info);
    if (std::string(info.sysname) == "Darwin") return {"macos"};

    std::vector<std::string> ids;
    std::ifstream file("/etc/os-release");
    std::string line;
    while (std::getline(file, line)) {
        auto eq = line.find('=');
        if (eq == std::string::npos) continue;

        std::string key = line.substr(0, eq);
        std::string value = line.substr(eq + 1);
        std::erase(value, '"');
        std::erase(value, '\'');

        if (key == "ID") {
            ids.insert(ids.begin(), value);
        } else if (key == "ID_LIKE") {
            std::istringstream words(value);
            for (std::string word; words >> word;) ids.push_back(word);
        }
    }
    return ids;
}

std::optional<std::string> pick_manager(const std::vector<std::string>& ids) {
    for (const auto& id : ids)
        if (auto it = distro_to_manager.find(id); it != distro_to_manager.end())
            return it->second;
    return std::nullopt;
}

bool is_installed(const std::string& command) {
    return std::system(("command -v " + command + " >/dev/null 2>&1").c_str()) == 0;
}

bool run(const std::string& command) {
    std::cout << "$ " << command << "\n";
    return std::system(command.c_str()) == 0;
}

int main() {
    auto ids = detect_distro_ids();
    auto manager_name = pick_manager(ids);
    if (!manager_name) {
        std::cerr << "Unsupported OS (detected: " << (ids.empty() ? "unknown" : ids.front())
                  << "). Supported package managers: apt, dnf, pacman, zypper, apk, brew.\n";
        return 1;
    }

    const Manager& manager = managers.at(*manager_name);
    std::cout << "Using package manager: " << *manager_name << "\n";

    const std::vector<std::pair<std::string, std::string>> tools = {
        {"git", "git"}, {"curl", "curl"}, {"python3", manager.python_pkg},
    };

    std::string packages;
    for (const auto& [command, package] : tools) {
        if (is_installed(command)) std::cout << command << ": already installed, skipping\n";
        else packages += " " + package;
    }
    if (packages.empty()) {
        std::cout << "Nothing to do.\n";
        return 0;
    }

    std::string sudo = (*manager_name == "brew" || geteuid() == 0) ? "" : "sudo -n ";

    if (!manager.refresh.empty() && !run(sudo + manager.refresh)) {
        std::cerr << "Failed to refresh package index. Need root or passwordless sudo?\n";
        return 1;
    }
    if (!run(sudo + manager.install + packages)) {
        std::cerr << "Installation failed. Need root or passwordless sudo?\n";
        return 1;
    }
    std::cout << "Done.\n";
}
