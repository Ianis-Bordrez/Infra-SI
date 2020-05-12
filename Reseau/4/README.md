# TP 4 - Cisco, Routage, DHCP

## Préparation de l'environnement

### I. Topologie 1 : simple

#### 2. Mise en place

##### B. Définition d'IPs statiques

**Configurer la machine CentOS7 :**

*Définition d'une IP statique:*

```bash
nano /etc/sysconfig/network-script/ifcfg-enp0s8

IPADDR=10.4.1.11
```

*définition d'un nom d'hôte:*

```bash
nano /etc/hostname

admins1
```

**Configurer le routeur :**
*Définition d'une IP statique:*

```bash
R2#conf t
R2(config)#interface fastethernet0/0
R2(config-if)#ip address 10.4.1.254 255.255.255.0
R2(config-if)#no shut
```

On fait la même manipulation pour la deuxième interface.

*définition d'un nom d'hôte:*
On double clique sur le nom (R2) et on change en R1.

**Configurer le VPCS :**
*Définition d'une IP statique:*

```bash
guest1> ip 10.4.2.11 255.255.255.0
guest1> save
```

 **Vérifier et PROUVER que :**
*guest1 peut joindre le routeur:*

```bash
guest1> ping 10.4.2.254
84 bytes from 10.4.2.254 icmp_seq=1 ttl=255 time=9.061 ms
```

*admin1 peut joindre le routeur:*

```bash
[root@admins1]# ping 10.4.1.254
PING 10.4.1.254 (10.4.1.254) 56(84) bytes of data.
64 bytes from 10.4.1.254: icmp_seq=1 ttl=255 time=20.5 ms
```

*router1 peut joindre les deux autres machines:*

Vers guest1

```bash
R1#ping 10.4.2.11

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.4.2.11, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 40/51/56 ms
```

Vers admin1

```bash
R1#ping 10.4.1.11

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.4.1.11, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 40/49/60 ms
```

##### C. Routage

*Ajouter une route sur admin1 pour qu'il puisse joindre le réseau guests:*

```bash
nano /etc/sysconfig/network-scripts/route-enp0s8

10.4.2.0/24 via 10.4.1.254 dev enp0s8
```

```bash
guest1> ip 10.4.2.11/24 10.4.2.254
```

*Vérification:*

```bash
guest1> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=31.515 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=15.250 ms
84 bytes from 10.4.1.11 icmp_seq=3 ttl=63 time=18.863 ms
```

### II. Topologie 2 : dumb switches

Après la mise en place des switchs, il est toujours possible de ping

```bash
guest1> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=18.278 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=21.765 ms
```

### III. Topologie 3 : adding nodes and NAT

#### 2. Mise en place

##### B. VPCS

**Configurer les VPCS:**

*guest2:*

```bash
guest2> ip 10.4.2.12/24 10.4.2.254
```

*guest3:*

```bash
guest3> ip 10.4.2.13/24 10.4.2.254
```

*Vérifier et PROUVER que les VPCS joignent le réseau admins:*

```bash
guest2> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=16.141 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=10.839 ms

guest3> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=20.276 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=10.731 ms
```


