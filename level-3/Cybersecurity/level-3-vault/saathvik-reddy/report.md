# Cybersecurity Level 3 - Hash Cracking

## Identify the hash

The supplied hash is `5fcfd41e547a12215b173ff47fdd3739`. Its 32-character hexadecimal form is consistent with MD5, though length alone cannot distinguish MD5 from other algorithms with the same digest format. The captured John the Ripper command uses `Raw-MD5` mode.

## Crack and verify

The screenshot shows this John the Ripper command using `rockyou.txt`:

```bash
john --format=Raw-MD5 --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
```

John reported no hashes left to crack, which indicates this hash was already present in its local pot file. I displayed the stored result with:

```bash
john --show --format=Raw-MD5 hash.txt
```

The output showed:

```text
?:trustno1
```

**Recovered password:** `trustno1`

![John the Ripper output showing the hash check and recovered password](hash-cracking.png)
