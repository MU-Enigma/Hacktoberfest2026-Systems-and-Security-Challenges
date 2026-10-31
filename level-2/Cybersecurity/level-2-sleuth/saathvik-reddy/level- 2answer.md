# Cybersecurity Level 2 — Sleuth Report

## 1. HTTP Credential Discovery

**Tool:** Wireshark

**Packet:** 491

**Source IP:** `192.168.1.45`

**Destination IP:** `192.168.1.10`

**Destination port:** `80/TCP`

**Protocol:** HTTP

The packet contains an HTTP form submission using `application/x-www-form-urlencoded`. The form fields expose the following credentials in plaintext:

- **Username:** `rwilliams`
- **Password:** `Summer2025!`

### Wireshark filters and analysis

Display filters used:

```text
http
http.request.method == "POST"
```

The relevant packet was inspected by expanding **Hypertext Transfer Protocol → HTML Form URL Encoded**. The username and password were visible in the decoded form fields.

## 2. Image GPS and Metadata

**Metadata inspection tool:** ExifTool metadata viewer

### GPS coordinates

- **Latitude:** `40.4182162138628° N`
- **Longitude:** `90.7677286814708° E`

**Resolved location:** Lop Nur region, Xinjiang, China (approximate; verify the nearest named feature using a map).

### Image software and camera information

- **Software:** `GIMP 3.2.6`
- **Date/time original:** `2026-10-04 00:35:48 (+05:30)`


### Metadata inspection command

```bash
exiftool evidence.jpg
```

## 3. Conclusion

The PCAP contains a plaintext HTTP login submission with recoverable credentials. The image metadata contains GPS coordinates and identifies GIMP 3.2.6 as the software field. Camera make and model were not available in the inspected metadata.
