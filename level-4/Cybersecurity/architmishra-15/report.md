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

---

## 1. Summary

The Appointment booking web application on port 80 builds its login query directly from unsanitized user input. Submitting a SQL comment sequence in the username field closes off the rest of the query, allowing authentication to be bypassed without knowing any valid credentials.

---

## 2. Reconnaissance: Nmap

Command used:

```bash
nmap -sC -sV -p- 10.129.150.47
```

Full scan output:

```
<PASTE YOUR FULL NMAP OUTPUT HERE>
```

**Key finding:** TCP port **80** is open, serving an HTTP login page for an appointment-booking application.

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

---

## 4. Recovered flag

```
e3d0796d002a446c0e622226f42e9672
```

Flag submitted and accepted on HTB (Root flag owned).

---

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

---

## 7. Proof
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/759347ee-7bac-4989-adfe-c0fac366f765" />
