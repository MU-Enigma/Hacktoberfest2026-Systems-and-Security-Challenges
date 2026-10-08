## Identifying the Algorithm

The hash is 32 hexadecimal characters long, which is characteristic of an MD5 digest.

```
hashid '5fcfd41e547a12215b173ff47fdd3739'
Analyzing '5fcfd41e547a12215b173ff47fdd3739'
[+] MD2
[+] MD5
[+] MD4
```

Given the 32-character hexadecimal format and the absence of a prefix indicating a salted password-hashing scheme, the hash is **MD5**.

## Cracking23

I used **Hashcat** with mode `0` for MD5 and a dictionary attack against `rockyou.txt`:

```
hashcat -m 0 -a 0 hash.txt /usr/share/wordlists/rockyou.txt
```

- `-m 0` specifies the MD5 hash mode.
- `-a 0` selects a straight dictionary attack.
- `hash.txt` contains the target hash.
- `rockyou.txt` is the password wordlist.

**Cracked password:** `trustno1`
