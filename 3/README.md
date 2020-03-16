# B1 Réseau 2019 - TP3


## Préparation de l'environnement

### 1. Mise à jour du patron

```bash
- sudo yum update -y
- sudo yum upgrade -y
- sudo yum install tcpdump
- sudo yum install traceroute
- sudo yum install nc
- sudo yum install bind-utils
```

### 2. Mise en place du lab

**Prouvez que chacun des points de la préparation de l'environnement ci-dessus ont été respectés:**

*Carte NAT désactivée:* `ip a`

```bash
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:ec:83:ec brd ff:ff:ff:ff:ff:ff
```

*Serveur SSH fonctionnel qui écoute sur le port 7777/tcp:* `sudo ss -ltunp`

```bash
tcp    LISTEN     0      128                           *:7777                                      *:*                   users:(("sshd",pid=1087,fd=3))
```

*Pare-feu activé et configuré:* `sudo firewall-cmd --list-all`

```bash
ports: 7777/tcp
```

*Nom configuré:* `sudo nano /etc/hostname`

```bash
client1
```

*Fichiers /etc/hosts de toutes les machines configurés:* `sudo nano /etc/hosts`

```bash
10.3.1.254  router
10.3.2.11   server1
```

*Réseaux et adressage des machines:*
client1 <> router

*client:*

```bash
[root@client1 ~]# ping router
PING router (10.3.1.254) 56(84) bytes of data.
64 bytes from router (10.3.1.254): icmp_seq=1 ttl=64 time=0.308 ms
64 bytes from router (10.3.1.254): icmp_seq=2 ttl=64 time=0.294 ms
```

*router:*

```bash
[root@router home]# ping client1
PING client1 (10.3.1.11) 56(84) bytes of data.
64 bytes from client1 (10.3.1.11): icmp_seq=1 ttl=64 time=0.396 ms
64 bytes from client1 (10.3.1.11): icmp_seq=2 ttl=64 time=0.440 ms
```

server1 <> router

*server1:*

```bash
[root@server1 ~]# ping router
PING router (10.3.2.254) 56(84) bytes of data.
64 bytes from router (10.3.2.254): icmp_seq=1 ttl=64 time=0.239 ms
64 bytes from router (10.3.2.254): icmp_seq=2 ttl=64 time=0.326 ms
```

*router:*

```bash
[root@router home]# ping server1
PING server1 (10.3.2.11) 56(84) bytes of data.
64 bytes from server1 (10.3.2.11): icmp_seq=1 ttl=64 time=0.349 ms
64 bytes from server1 (10.3.2.11): icmp_seq=2 ttl=64 time=0.314 ms
```

## I. Mise en place du routage

## 1. Configuration du routage sur router

*router:*
temporaire :
`sudo sysctl -w net.ipv4.conf.all.forwarding=1`
permanent :
`echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf`

### 2. Ajouter les routes statiques

*client:*
Dans le fichier `/etc/sysconfig/network-scripts/route-enp0s8`
on ajoute:
`10.3.2.0/24 via 10.3.1.254 dev eth0`

*server:*
Dans le fichier `/etc/sysconfig/network-scripts/route-enp0s8`
on ajoute:
`10.3.1.0/24 via 10.3.2.254 dev eth0`

*ping du client vers le server:*

```bash
[root@client1 ~]# ping client1
PING client1 (10.3.1.11) 56(84) bytes of data.
64 bytes from client1 (10.3.1.11): icmp_seq=1 ttl=64 time=0.019 ms
64 bytes from client1 (10.3.1.11): icmp_seq=2 ttl=64 time=0.095 ms
```

### 3. Comprendre le routage

*router net1 :*
`tcpdump -i enp0s8 -w capture1.pcap`
*router net2 :*
`tcpdump -i enp0s9 -w capture2.pcap`

*client :*
`ping server1`

On récupère les fichiers sur notre pc :
`scp -P 7777 root@10.3.1.11:/root/capture1.pcap  ./`
`scp -P 7777 root@10.3.1.11:/root/capture2.pcap  ./`


|             | MAC src       | MAC dst       | IP src       | IP dst       |
| ----------- | ------------- | ------------- | ------------ | ------------ |
| Dans net1 (trame qui entre dans router) | 08:00:27:b9:25:08 | 08:00:27:aa:bc:cd | 10.3.1.11 | 10.3.2.11 |
| Dans net2 (trame qui sort de router) | 08:00:27:ae:ad:60 | 08:00:27:a9:e5:f5 | 10.3.1.11 | 10.3.2.11 |

## II. ARP

### 1. Tables ARP

*Voir sa table arp*:
```bash
[root@client1 ~]# ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:b9:25:08 STALE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:03 DELAY
```

### 2. Requêtes ARP

#### A. Table ARP 1

*Vider la table arp :* `sudo ip neigh flush all`
*Affichage de la table arp :*

```bash
[root@client1 ~]# ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:b9:25:08 REACHABLE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:03 REACHABLE
```

Le client a ajouté à sa table arp l'ip du router parce qu'il en avait besoin pour envoyer un paquet au server.

#### B. Table ARP 2

*Affichage de la table arp :*

```bash
[root@client1 ~]# ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:b9:25:08 REACHABLE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:03 REACHABLE
```

#### C. tcpdump 1

```bash
[root@client1 ~]# ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:b9:25:08 REACHABLE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:03 REACHABLE
```

#### D. tcpdump 2

```bash
[root@client1 ~]# ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:b9:25:08 REACHABLE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:03 REACHABLE
```

I'm not okay because this is the same thing ><
I don't know why :c


## Entracte : Donner un accès internet aux VMs

 **Permettre un accès WAN (Internet) à client1 :**

*Activation de la carte NAT :* ```ifup enp0s3```
*Activation de la NAT :*
```firewall-cmd --add-masquerade --permanent```
```firewall-cmd --reload```

*Ajout d'une route par défaut :*
Dans client1 ajouter à routes-enp0s8 : GATEWAY=10.3.1.254


## IV. Bonus

### 2. Serveur Web

*commandes :*

```bash
yum install epel-release
```

```bash
yum install nginx
```

```bash
systemctl enable nginx
```

```bash
systemctl start nginx
```

```bash
firewall-cmd --permanent --zone=public --add-service=http
```

```bash
firewall-cmd --reload
```
