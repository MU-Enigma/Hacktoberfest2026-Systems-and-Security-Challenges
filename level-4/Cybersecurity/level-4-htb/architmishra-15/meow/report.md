nmap result -
```bash
┌─[us-starting-point-1-dhcp]─[10.10.14.28]─[architmishra@htb-scho8zsr6v-htb-cloud-com]─[~]
└──╼ [★]$ nmap -sV 10.129.220.26
Starting Nmap 7.95 ( https://nmap.org ) at 2026-10-09 13:34 EDT
Nmap scan report for 10.129.220.26
Host is up (0.25s latency).
Not shown: 999 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
23/tcp open  telnet  Linux telnetd
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 40.07 seconds
```
## Step by Step Enumeration
- Run a `nmap` scan on the target IP to see the open ports. Here port 23 was open which is used by telnet.
- Use the telnet command -
    ```bash
    telnet 10.129.220.26
    ```
- Then enter root as user.
- Read the `flag.txt` file using the `cat` command

### Recovered flag -  `b40abdfe23665f766f9c61ecba8a4c19`

## Proof
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a964dc66-de5b-4a8d-841a-53d28b336923" />
URL - https://labs.hackthebox.com/achievement/machine/4070562/394
