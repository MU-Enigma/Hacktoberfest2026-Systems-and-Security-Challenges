
**Topology:**

![[topology.png]]


**Pings:**

![[pings.png]]


**IP Addressing Table:**

| Device    | Subnet | IP Address     | Subnet Mask     | Default Gateway |
| --------- | ------ | -------------- | --------------- | --------------- |
| PC-HR-1   | HR     | `192.168.10.2` | `255.255.255.0` | `192.168.10.1`  |
| PC-HR-2   | HR     | `192.168.10.3` | `255.255.255.0` | `192.168.10.1`  |
| PC-Tech-1 | Tech   | `192.168.20.2` | `255.255.255.0` | `192.168.20.1`  |
| PC-Tech-2 | Tech   | `192.168.20.3` | `255.255.255.0` | `192.168.20.1`  |

**Note:**
Router R1 was configured to provide inter-subnet routing between the HR and Tech networks.

The `GigabitEthernet0/0` interface was assigned `192.168.10.1/24` and connected to the HR subnet. The `GigabitEthernet0/1` interface was assigned `192.168.20.1/24` and connected to the Tech subnet. Both interfaces were enabled using the `no shutdown` command.

Each PC was configured with a static IP address and uses the router interface on its respective subnet as its default gateway. Since both networks are directly connected to R1, no additional static routing commands were required.

Connectivity was verified by successfully pinging between devices on the HR and Tech subnets in both directions.