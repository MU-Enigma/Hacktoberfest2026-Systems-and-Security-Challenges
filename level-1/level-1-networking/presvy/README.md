# Level 1 — Inter-Subnet Office Networking

**Cisco Packet Tracer | HR and Tech office network**

## Overview

This project simulates a small office with two departments on separate IPv4 subnets. The goal is to connect the departments through a router and verify that PCs can communicate both **within their own subnet** and **across the two subnets**.

The topology consists of **four PCs**, **two Cisco 2960-24TT switches**, and **one Cisco 2901 router**.

## Network Topology

![Office network topology in Cisco Packet Tracer](<Screenshot 2026-11-08 192725.png>)

- **HR subnet — `192.168.10.0/24`:** PC0 and PC1 connect to Switch3.
- **Tech subnet — `192.168.20.0/24`:** PC2 and PC3 connect to Switch1.
- **Router0:** Connects both switches and routes packets between the two subnets.

> **Screenshot note:** The topology screenshot above was captured during setup, before the router links turned green. The ping results below were recorded after the connections were working. For a final submission, replace this image with a screenshot of the completed green-link topology, keeping the same filename.

## IP Addressing Table

| Device | Department | IP Address | Subnet Mask | Default Gateway |
|:--|:--|:--|:--|:--|
| PC0 | HR | `192.168.10.2` | `255.255.255.0` | `192.168.10.1` |
| PC1 | HR | `192.168.10.3` | `255.255.255.0` | `192.168.10.1` |
| PC2 | Tech | `192.168.20.2` | `255.255.255.0` | `192.168.20.1` |
| PC3 | Tech | `192.168.20.3` | `255.255.255.0` | `192.168.20.1` |
| Router0 (HR side) | HR | `192.168.10.1` | `255.255.255.0` | — |
| Router0 (Tech side) | Tech | `192.168.20.1` | `255.255.255.0` | — |

Each subnet uses a **/24 subnet mask**. The router interface on each subnet acts as the **default gateway** for its PCs.

### Address assignment

In this version, the PCs received their IPv4 addresses using **DHCP**. They initially showed `169.254.x.x` self-assigned addresses when no DHCP response was available; after configuring the network, they received the valid `192.168.10.x` and `192.168.20.x` addresses listed above.

**Assignment requirement:** The Level 1 challenge specifically calls for **static PC IP addressing**. Before final submission, change each PC to **Static** under *Desktop → IP Configuration*, enter the addresses/gateways from this table, save `level1.pkt`, and update this paragraph to state that static addressing was used. Routing works with either method, but the submission should match the challenge instructions.

## Router Configuration

Router0 was configured with one interface in each subnet and both interfaces were enabled using `no shutdown`:

```cisco
Router> enable
Router# configure terminal
Router(config)# interface gigabitEthernet 0/0
Router(config-if)# ip address 192.168.10.1 255.255.255.0
Router(config-if)# no shutdown
Router(config-if)# exit
Router(config)# interface gigabitEthernet 0/1
Router(config-if)# ip address 192.168.20.1 255.255.255.0
Router(config-if)# no shutdown
Router(config-if)# end
```

*The interface names above assume G0/0 connects to HR and G0/1 to Tech; the exact connected ports should be checked in the Packet Tracer project.* Since both subnets are directly connected to the same router, **no additional static routes** are required.

## Connectivity Testing

Connectivity was tested using `ping` from the PCs' **Desktop → Command Prompt**. Each screenshot below shows tests to one PC in the same subnet and one in the other subnet.

### 1. PC0 — HR subnet

PC0 (`192.168.10.2`) successfully pinged:

- **PC1:** `192.168.10.3` — 4/4 replies, **0% loss** (same subnet).
- **PC3:** `192.168.20.3` — 3/4 replies, **25% initial loss** (across the router).

![PC0 command prompt and ping results](<Screenshot (128).png>)

### 2. PC1 — HR subnet

PC1 (`192.168.10.3`) successfully pinged:

- **PC0:** `192.168.10.2` — 4/4 replies, **0% loss** (same subnet).
- **PC2:** `192.168.20.2` — 3/4 replies, **25% initial loss** (across the router).

![PC1 command prompt and ping results](<Screenshot (129).png>)

### 3. PC2 — Tech subnet

PC2 (`192.168.20.2`) successfully pinged:

- **PC0:** `192.168.10.2` — 4/4 replies, **0% loss** (across the router).
- **PC3:** `192.168.20.3` — 4/4 replies, **0% loss** (same subnet).

![PC2 command prompt and ping results](<Screenshot (130).png>)

### 4. PC3 — Tech subnet

PC3 (`192.168.20.3`) successfully pinged:

- **PC0:** `192.168.10.2` — 4/4 replies, **0% loss** (across the router).
- **PC2:** `192.168.20.2` — 4/4 replies, **0% loss** (same subnet).

![PC3 command prompt and ping results](<Screenshot (131).png>)

### Why did some first pings time out?

The first cross-subnet ping from PC0 and PC1 timed out, but the remaining replies succeeded. In Packet Tracer, this is commonly caused by **ARP (Address Resolution Protocol)**, which devices use to discover the next-hop MAC address before forwarding traffic. The successful later replies demonstrate that the destination PCs were reachable.

The replies from the other subnet show **TTL=127**, compared with **TTL=128** for same-subnet replies. This is consistent with the packet having passed through one router.

## Conclusion

The simulation demonstrates successful **inter-subnet routing** between the HR (`192.168.10.0/24`) and Tech (`192.168.20.0/24`) networks. The ping tests confirm that PCs can communicate within their own subnet and reach PCs on the other subnet through Router0.

## Project Files

- [**level1.pkt**](<level1.pkt>) — Cisco Packet Tracer topology and configuration.
- **README.md** — This project write-up.
- **Screenshot 2026-11-08 192725.png** — Network topology.
- **Screenshot (128).png** — PC0 ping tests.
- **Screenshot (129).png** — PC1 ping tests.
- **Screenshot (130).png** — PC2 ping tests.
- **Screenshot (131).png** — PC3 ping tests.

All screenshots are referenced using their **original filenames** and are expected to be in the same folder as `README.md`.
