# Hash Cracking

## Finding the Hash Type

The hash is 32 characters long and only uses numbers and `a-f`, so it looks like an MD5 hash.

I also checked it with `hashid`:

```bash
hashid '5fcfd41e547a12215b173ff47fdd3739'
```

It showed MD2, MD5 and MD4 as possible matches. Since MD5 is the common one for this format, I used MD5.

## Cracking the Hash

I used Hashcat with the `rockyou.txt` wordlist.

```bash
hashcat -m 0 -a 0 ../../artifacts/hash.txt /usr/share/wordlists/rockyou.txt
```

- `-m 0` = MD5
- `-a 0` = dictionary attack
- `hash.txt` = file containing the hash
- `rockyou.txt` = wordlist used

Hashcat was able to crack the hash almost instantly.

## Password Found :)

The result was:

```text
5fcfd41e547a12215b173ff47fdd3739:trustno1
```

So the password is:

```text
trustno1
```

## Checking the Password

I checked the password with `md5sum`:

```bash
echo -n "trustno1" | md5sum
```

Output:

```text
5fcfd41e547a12215b173ff47fdd3739  -
```

It matches the given hash, so the password is correct.