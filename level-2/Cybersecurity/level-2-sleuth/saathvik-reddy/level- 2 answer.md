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

[Open GPS coordinates in Google Maps](https://www.google.com/maps?q=40.4182162138628,90.7677286814708)

### Image software and camera information

- **Software:** `GIMP 3.2.6`
- **Camera make:** Not present in the inspected metadata.
- **Camera model:** Not present in the inspected metadata.
- **Date/time original:** `2026-10-04 00:35:48 (+05:30)`

The supplied metadata does not contain camera make or model fields, so these details could not be determined from that output.

### Metadata inspection command

```bash
exiftool evidence.jpg
```

Relevant fields to inspect:

```bash
exiftool -GPSLatitude -GPSLongitude -Make -Model -Software evidence.jpg
```

**Note:** Confirm that the metadata was extracted from the original `evidence.jpg` artifact before submitting. The supplied metadata output identifies its file as PNG.

## 3. Conclusion

The PCAP contains a plaintext HTTP login submission with recoverable credentials. The image metadata contains GPS coordinates and identifies GIMP 3.2.6 as the software field. Camera make and model were not available in the inspected metadata.

## 4. Evidence

- Wireshark packet 491 showing the decoded HTTP form fields.
- Image metadata output showing GPS coordinates and software information.
