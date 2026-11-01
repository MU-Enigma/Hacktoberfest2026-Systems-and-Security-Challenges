
---

## Machine: 
**OS:** Linux 
**Name:** Appointment

---

## 1. Reconnaissance

nmap port scan
```
❯ sudo nmap -sC -sV 10.129.46.118
[sudo] password for ehe: 
Starting Nmap 7.992 ( https://nmap.org ) at 2026-11-02 02:28 +0530
Nmap scan report for 10.129.46.118
Host is up (0.30s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.38 ((Debian))
|_hnap-info: ERROR: Script execution failed (use -d to debug)
|_http-trane-info: ERROR: Script execution failed (use -d to debug)
|_http-server-header: ERROR: Script execution failed (use -d to debug)
|_https-redirect: ERROR: Script execution failed (use -d to debug)
|_vmware-version: ERROR: Script execution failed (use -d to debug)
|_rpcinfo: ERROR: Script execution failed (use -d to debug)
|_http-title: Login

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 203.82 seconds
```
ong bro the errors are annoying atp... even sudo is of no help aa

anyways, port 80/tcp is open and points toward a Login page

---

## 2. Enumeration

went to ``http://10.129.45.56`` on my browser and it loaded a login page

---

## 3. Exploitation

sql injection :d
entered ``admin'#`` for username and saygex for password, it worked cuz `'#` js comments whatever comes next, which is the check for password in this case.

took me to a page saying congratulations and showed me da flag :D

---

## 4. Flag

```
e3d0796d002a446c0e622226f42e9672
```

---

## Proof
![[appointmentproof.jpg]]