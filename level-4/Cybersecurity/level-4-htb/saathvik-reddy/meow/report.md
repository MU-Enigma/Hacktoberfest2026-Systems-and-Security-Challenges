# HTB Starting Point - Meow

**Tier:** Task 1 - Entry  
**Target IP shown in the HTB session:** `10.129.49.135`  
**Operating system:** Linux

## Reconnaissance

The full-port scan checks TCP ports and saves the results to `nmap-full.txt`:

```bash
nmap -p- -T4 --min-rate 1000 --open -oN nmap-full.txt 10.129.49.135
```

The captured output reports the host up, `23/tcp open telnet`, 64,075 closed TCP ports and 1,459 filtered TCP ports. The screenshot contains the scan output excerpt; use the complete `nmap-full.txt` output if a complete transcript is required.

The follow-up scan checks port 23 and identifies service and version information:

```bash
nmap -sC -sV -T4 -p 23 -oN nmap-services.txt 10.129.49.135
```

Its output identifies `23/tcp open telnet Linux telnetd` and reports Linux service information.

![HTB session with Meow target IP](01-meow-target.png)

![Nmap scan evidence for Meow](02-meow-nmap.png)

## Enumeration and access

Telnet provides remote terminal access. In this assigned lab session, I connected to the target and logged in as `root` using an empty password:

```bash
telnet 10.129.49.135
```

In the resulting shell, `whoami` confirmed root access, `pwd` showed `/root`, and `ls -la` listed the directory contents, including `flag.txt`. I displayed the flag with:

```bash
cat flag.txt
```

![Meow root shell and flag verification](03-meow-flag.png)

## Flag

```text
b40abdfe23665f766f9c61ecba8a4c19
```
