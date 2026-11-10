# Cybersecurity Level 2
## 1. PCAP Analysis – Network Forensics

### Investigation details ->

| Parameter | Finding |
|---|---|
| Artifact | `capture.pcap` |
| Analysis tool | Wireshark |
| Protocol investigated | HTTP |
| Request method | POST |
| Display filter 1 | `http` |
| Display filter 2 | `http.request.method == "POST"` |
| Analysis technique | Follow TCP Stream |
| Number of login requests identified | 3 |

### Extracted login credentials:

All three login requests used the same username but contained different passwords.

| Attempt | Username | Password | HTTP response | Result |
|---|---|---|---|---|
| 1 | `rwilliams` | `Summer2024` | 401 Unauthorized | Failed |
| 2 | `rwilliams` | `Summer2025!` | 302 Found | successful |
| 3 | `rwilliams` | `Password1!` | 401 Unauthorized | Failed |

**Conclusion:** The second login attempt is the likely successful authentication. The server returned HTTP 302 Found, whereas the other two attempts returned HTTP 401 Unauthorized.

The credentials were transmitted through unencrypted HTTP traffic and could therefore be inspected in the packet capture.

---

## 2. Image Forensics – Metadata Analysis

### Investigation details->

| Parameter | Finding |
|---|---|
| Artifact | `image.png` |
| Analysis tool | ExifTool |
| Metadata investigated | EXIF and GPS metadata |
| Metadata extraction technique | Command-line metadata inspection |

### Extracted GPS information:

| Metadata field | Extracted value |
|---|---|
| GPS Version ID | 2.3.0.0 |
| GPS Latitude Reference | North |
| GPS Latitude | 40° 25' 5.58" |
| GPS Longitude Reference | East |
| GPS Longitude | 90° 46' 3.82" |
| Decimal Latitude | 40.4182167 |
| Decimal Longitude | 90.7677278 |

**Resolved location:** The coordinates point to the Lop Nur region of Xinjiang, China. This is an approximate geographic identification based on the coordinates.

### Camera and software information

| Metadata field | Extracted value |
|---|---|
| Camera Make | Not identified in the extracted metadata |
| Camera Model | Not identified in the extracted metadata |
| Editing Software | GIMP 3.2.6 |

The software metadata identifies GIMP 3.2.6 as the software recorded in the image. Camera make and model information was not visible in the extracted output.

---

## 3. Tools and Commands Used

### 3.1 Wireshark

| Purpose | Filter / Technique |
|---|---|
| Display HTTP traffic | `http` |
| Identify POST requests | `http.request.method == "POST"` |
| Inspect request and response contents | Right-click packet → Follow → TCP Stream |

### 3.2 ExifTool

| Purpose | Command |
|---|---|
| Extract GPS and camera/software metadata | `exiftool -GPS:all -Make -Model -Software image.png` |
| Inspect GPS metadata groups | `exiftool -a -G1 -s -GPS:all -Make -Model -Software image.png` |
| Search relevant metadata fields | `exiftool -a -G1 image.png \| grep -Ei 'GPS|Latitude|Longitude|Make|Model|Software'` |

---

## 4. Final Summary

| Investigation | Objective | Outcome |
|---|---|---|
| PCAP Analysis | Extract login credentials from HTTP traffic | Completed |
| Authentication analysis | Identify the likely successful login | Completed |
| Image Forensics | Extract embedded GPS coordinates | Completed |
| Location identification | Identify the approximate location | Completed |
| Camera metadata | Identify camera make and model | Not available in extracted output |
| Software identification | Identify image editing software | GIMP 3.2.6 |
