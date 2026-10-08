# Level 2

## Part 1: PCAP Analysis

- **Wireshark Filter Used:** `http.request.method == "POST"` (or `http`)
- **Target Host & Endpoint:** `intranet.officecorp.local` -> `POST /login.php`
- **Extracted Credentials:**
  - **Username:** `rwilliams`
  - **Password:** `Summer2025!`
- **Notes:**
  - Checked HTTP traffic for login requests.
  - User `rwilliams` made 3 login attempts:
    - `Summer2024` -> returned `401 Unauthorized`
    - `Password1!` -> returned `401 Unauthorized`
    - `Summer2025!` -> returned `302 Found` (redirects to `/dashboard.php`, successful login)

---

## Part 2: Image Forensics

- **Tool Used:** `exiftool image.png`
- **GPS Coordinates:**
  - Latitude: `40° 25' 5.58" N` (`40.418216° N`)
  - Longitude: `90° 46' 3.82" E` (`90.767729° E`)
  - Position: `40° 25' 5.58" N, 90° 46' 3.82" E`
- **Location:** Lop Nur (Xinjiang, China)
- **Software & Camera Details:**
  - Software: `GIMP 3.2.6`
  - Camera Make/Model: None / not present in EXIF metadata (exported via GIMP)
