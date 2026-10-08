# SQL Injection Lab Report

## Lab 1
![[Lab_1.jpg]

### Injection Point

The vulnerable parameter is the **category** parameter.

### Payload Used

```
+OR+1=1--
```

### Method

I modified the `category` parameter by assigning it the value:

```
+OR+1=1--
```

### Why It Works

The `OR 1=1` condition is always true. The `--` sequence acts as a SQL comment indicator, causing the remainder of the original SQL query to be ignored.

This effectively removes the remaining conditions from the query and allows the application to return the hidden data.

### Result

The modified `category` parameter bypasses the intended filtering logic and reveals the hidden data in the lab.

---

## Lab 2
![[Lab_2.jpg]

### Injection Point

The vulnerable parameter is the **username** parameter in the login form.

### Payload Used

```
administrator'--
```

### Method

I modified the username parameter by entering:

```
administrator'--
```

A random value can then be entered into the password field.

### Why It Works

The `'` closes the username string in the SQL query. The `--` sequence acts as a SQL comment indicator, causing the remainder of the query to be ignored.

This effectively removes the password-checking portion of the query, allowing the login to succeed as the `administrator` user without knowing the correct password.

### Result

The password check is bypassed, allowing access to the administrator account using the injected username.
