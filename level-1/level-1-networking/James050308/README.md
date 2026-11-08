# Level 1 – Networking Challenge

IP Adressing Table : 
| Device | Department | IP Address | Subnet Mask | Default Gateway |
|---|---|---|---|---|
| PC-HR-1 | HR | 192.168.10.2 | 255.255.255.0 | 192.168.10.1 |
| PC-HR-2 | HR | 192.168.10.3 | 255.255.255.0 | 192.168.10.1 |
| PC-Tech-1 | Tech | 192.168.20.2 | 255.255.255.0 | 192.168.20.1 |
| PC-Tech-2 | Tech | 192.168.20.3 | 255.255.255.0 | 192.168.20.1 |

Router Configuration
The router was configured with two interfaces:

- GigabitEthernet0/0: 192.168.10.1/24 (HR network)
- GigabitEthernet0/1: 192.168.20.1/24 (Tech network)

Both interfaces were enabled using the `no shutdown` command.

The router enables communication between the HR and Tech subnets.
