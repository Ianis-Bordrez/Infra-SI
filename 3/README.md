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
`sudo sysctl -w net.ipv4.conf.all.forwarding=1`

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

|             | MAC src       | MAC dst       | IP src       | IP dst       |
| ----------- | ------------- | ------------- | ------------ | ------------ |
| Dans net1 (trame qui entre dans router) | <mac_address> | <mac_address> | <ip_address> | <ip_address> |
| Dans net2 (trame qui sort de router) | <mac_address> | <mac_address> | <ip_address> | <ip_address> |




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