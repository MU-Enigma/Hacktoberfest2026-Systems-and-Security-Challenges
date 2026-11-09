# Cybersecurity Level 3 — Crack the Vault & Web Basics

## Part 1 — Hash Cracking

### Hash Provided

```text
5fcfd41e547a12215b173ff47fdd3739
```

The provided hash contains 32 hexadecimal characters, corresponding to a 128-bit digest.

I used `hashid` to identify possible hashing algorithms:

```bash
hashid -m hash.txt
```
The output returned multiple possible algorithms, including MD5 (Hashcat mode 0), MD4 (mode 900), and NTLM (mode 1000).
Since hash length alone cannot conclusively identify an algorithm, I selected MD5 as an initial candidate and tested it using Hashcat.


I used **Hashcat v6.2.6** with the `rockyou.txt` wordlist.

The exact command used was:
```bash
hashcat -m 0 -a 0 ~/hash.txt ~/wordlists/rockyou.txt
```
- `-m 0` specifies MD5.
- `-a 0` selects a straight dictionary attack.
- `~/hash.txt` contains the target hash.
- `~/wordlists/rockyou.txt` contains the password candidates.

Hashcat successfully recovered the password and reported:

```text
Status...........: Cracked
Hash.Mode........: 0 (MD5)
Recovered........: 1/1 (100.00%)
```
Result:

```text
5fcfd41e547a12215b173ff47fdd3739:trustno1
```

**Identified algorithm:** MD5

**Cracked password:** `trustno1`

Verification command:

```bash
hashcat -m 0 ~/hash.txt --show
```

---

## Part 2 — Web SQL Injection

Both exercises were completed on PortSwigger Web Security Academy's authorised Apprentice-level practice labs.

### Lab 1 — SQL Injection Vulnerability in WHERE Clause Allowing Retrieval of Hidden Data

**Payload used:**

```sql
' OR 1=1--
```

**Explanation:**

The application uses a SQL query that filters products by category and release status.

The injected single quote closes the original category string. `OR 1=1` adds a condition that always evaluates to true, while `--` comments out the remaining query conditions.

As a result, the database returns products regardless of their category or release status, including hidden products.

**Result:** Successfully completed the lab.

### Lab 2 — SQL Injection Vulnerability Allowing Login Bypass

**Username payload:**

```sql
administrator'--
```

**Password:** Any value

**Explanation:**

The injected single quote closes the username string. The `--` sequence comments out the remaining SQL query, including the password verification condition.

Consequently, the application authenticates the administrator account without requiring the correct password.

**Result:** Successfully completed the lab and accessed the administrator account.

---
