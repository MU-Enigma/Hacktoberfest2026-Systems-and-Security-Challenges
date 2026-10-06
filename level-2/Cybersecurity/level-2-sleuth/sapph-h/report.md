
| Part 1              | PCAP Analysis                            |
| ------------------- | ---------------------------------------- |
| Username            | `rwilliams`                              |
| Password            | `Summer2025!`                            |
| HTTP Endpoint       | `POST /login.php`                        |
| Successful Response | `302 Found`                              |
| Wireshark Filter    | `http.request.method == "POST"`          |
|                     |                                          |
| **Part 2**          | **Image Forensics**                      |
| GPS Latitude        | `40 deg 25' 5.58" N`                     |
| GPS Longitude       | `90 deg 46' 3.82" E`                     |
| GPS Position        | `40 deg 25' 5.58" N, 90 deg 46' 3.82" E` |
| Software            | `GIMP 3.2.6`                             |
| Location            | `Lop Nur`                                |
| ExifTool Command    | `exiftool ./image.png`                   |
