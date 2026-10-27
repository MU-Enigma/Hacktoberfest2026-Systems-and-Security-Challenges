# Cybersecurity Level 3 - PortSwigger SQL Injection Labs

Both exercises were completed on PortSwigger Web Security Academy's designated practice labs.

## Lab 1: Retrieve hidden data

**Lab:** SQL injection vulnerability in WHERE clause allowing retrieval of hidden data  
**Injection point:** `category`

The category parameter included this payload:

```text
' OR 1=1--
```

The quote closes the original string value, `OR 1=1` makes the condition true, and the trailing comment marker removes the rest of the original condition. The solved-lab screenshot shows the product listing after the category filter was bypassed.

![Solved hidden-data lab](hidden-data-solved.png)

## Lab 2: Login bypass

**Lab:** SQL injection vulnerability allowing login bypass  
**Injection point:** username field

The username used was:

```text
administrator'--
```

The quote closes the username string in the query, and the comment marker causes the remainder of the query, including the password condition, to be ignored. The solved-lab screenshot shows the account authenticated as `administrator`.

![Solved login-bypass lab](login-bypass-solved.png)
