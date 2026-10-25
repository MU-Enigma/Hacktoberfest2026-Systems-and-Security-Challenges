## Topology

<img width="1960" height="1197" alt="topo" src="https://github.com/user-attachments/assets/d1c988b8-f6ec-4820-a086-2b796d10e5b5" />

## Ping

<img width="1747" height="1270" alt="1" src="https://github.com/user-attachments/assets/5bc32082-996c-4a1c-9eb7-9e968bbe0099" />


## IP Addressing Table

| Device | Subnet | IP Address | Subnet Mask | Gateway |
|---|---|---|---|---|
| PC1 | HR | `192.168.10.2` | `255.255.255.0` | `192.168.10.1` |
| PC2 | HR | `192.168.10.3` | `255.255.255.0` | `192.168.10.1` |
| PC-Tech1 | Tech | `192.168.20.2` | `255.255.255.0` | `192.168.20.1` |
| PC-Tech2 | Tech | `192.168.20.3` | `255.255.255.0` | `192.168.20.1` |


The router interfaces were assigned gateway IPs (192.168.10.1 for HR and 192.168.20.1 for Tech) and enabled with the no shutdown command. 

Inter-subnet routing happens automatically via directly connected routes, and connectivity was successfully verified using the ping command between the HR and Tech PCs.
