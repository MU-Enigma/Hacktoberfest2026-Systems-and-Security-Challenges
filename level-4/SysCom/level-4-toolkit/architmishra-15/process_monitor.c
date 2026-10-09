#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#ifdef _WIN32
#include <windows.h>
#include <tlhelp32.h>
#define nap(ms) Sleep(ms)
#define lt(t, r) localtime_s(r, t)

static int alive(long p) {
    HANDLE h = OpenProcess(SYNCHRONIZE | PROCESS_QUERY_LIMITED_INFORMATION, 0, p);
    if (!h) return GetLastError() == ERROR_ACCESS_DENIED;
    int r = WaitForSingleObject(h, 0) == WAIT_TIMEOUT;
    CloseHandle(h);
    return r;
}

static long find(const char *n) {
    char x[MAX_PATH + 5];
    snprintf(x, sizeof x, "%s.exe", n);
    PROCESSENTRY32 e = {sizeof e};
    HANDLE h = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    long r = -1;
    for (int ok = Process32First(h, &e); ok && r < 0; ok = Process32Next(h, &e))
        if (e.th32ProcessID != GetCurrentProcessId() && (!_stricmp(e.szExeFile, n) || !_stricmp(e.szExeFile, x)))
            r = e.th32ProcessID;
    CloseHandle(h);
    return r;
}
#else
#include <dirent.h>
#include <unistd.h>
#define nap(ms) usleep((ms) * 1000)
#define lt(t, r) localtime_r(t, r)

static int state(long p, char *comm) {
    char b[512], path[40];
    snprintf(path, sizeof path, "/proc/%ld/stat", p);
    FILE *f = fopen(path, "r");
    if (!f) return 0;
    b[fread(b, 1, sizeof b - 1, f)] = 0;
    fclose(f);
    char *o = strchr(b, '('), *c = strrchr(b, ')');
    if (!o || !c || !c[1]) return 0;
    if (comm) snprintf(comm, 32, "%.*s", (int)(c - o - 1), o + 1);
    return c[2];
}

static int alive(long p) {
    int s = state(p, 0);
    return s && s != 'Z';
}

static long find(const char *n) {
    DIR *d = opendir("/proc");
    struct dirent *e;
    char c[32];
    long r = -1, p;
    while (d && r < 0 && (e = readdir(d)))
        if ((p = atol(e->d_name)) > 0 && p != getpid() && alive(p) && state(p, c) && !strncmp(c, n, 15))
            r = p;
    if (d) closedir(d);
    return r;
}
#endif

static FILE *lg;
static volatile sig_atomic_t done;

static void stop(int s) { done = s; }

static void say(const char *f, ...) {
    char ts[32];
    time_t t = time(0);
    struct tm tm;
    lt(&t, &tm);
    strftime(ts, sizeof ts, "%Y-%m-%d %H:%M:%S", &tm);
    FILE *o[] = {lg, stdout};
    for (int i = 0; i < 2; i++) {
        va_list a;
        va_start(a, f);
        fprintf(o[i], "[%s] ", ts);
        vfprintf(o[i], f, a);
        fputc('\n', o[i]);
        fflush(o[i]);
        va_end(a);
    }
}

int main(int c, char **v) {
    if (c < 2) return fprintf(stderr, "usage: %s <name|pid> [interval_s=5] [log=alerts.log]\n", v[0]), 1;
    char *t = v[1], *e;
    long pid = strtol(t, &e, 10);
    int byp = e != t && !*e, sec = c > 2 ? atoi(v[2]) : 5, rc = 0;
    if (sec < 1) sec = 5;
    if (!(lg = fopen(c > 3 ? v[3] : "alerts.log", "a"))) return perror("log"), 1;
    signal(SIGINT, stop);
    signal(SIGTERM, stop);
    if (!byp) pid = find(t);
    if (byp && !alive(pid)) return say("ERROR: PID %ld does not exist", pid), 1;
    say("monitoring %s every %ds", t, sec);
    if (pid < 0) say("ALERT: '%s' is not running", t);
    while (!done) {
        for (int i = 0; i < sec * 10 && !done; i++) nap(100);
        if (done) break;
        if (pid >= 0 && !alive(pid)) {
            say("ALERT: '%s' (PID %ld) is DOWN", t, pid);
            if (byp) { rc = 2; break; }
            pid = -1;
        }
        if (pid < 0 && (pid = find(t)) >= 0) say("RECOVERED: '%s' running again (PID %ld)", t, pid);
    }
    say("monitor stopped");
    return fclose(lg), rc;
}
