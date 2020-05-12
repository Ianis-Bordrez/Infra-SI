# B1 Réseau 2019 - TP2

## I. Création et utilisation simples d'une VM CentOS

### Déterminer la liste de vos cartes réseau, les informations qui y sont liées, et la fonction de chacune

Name | IP | MAC | Fonction
--- | --- | --- | ---
`lo` | `127.0.0.1/8` | `00:00:00:00:00:00` | Carte Loopback
`enp0s3` | `10.0.2.15/24` | `08:00:27:f4:30:9d` | Carte Nat
`enp0s8` | `10.2.1.2/24` | `08:00:27:7d:38:78` | Carte Host-Only

### Changer la configuration de la carte réseau Host-Only

**Procédure :**

* sudo nano ifcfg-enp0s8
* IPADDR=10.2.1.3
* sudo ifdown enp0s8
* sudo ifdup enp0s8
* ip a

Ensuite nous pouvons ping la vm depuis notre pc host grâce à la commande : ping 10.2.1.3

### 5. Appréhension de quelques commandes

**faites un scan nmap du réseau host-only:**

```bash
[ianis@patron ~]$ nmap -sP 10.2.1.0/24

Starting Nmap 6.40 ( http://nmap.org ) at 2020-02-27 15:31 CET
Nmap scan report for 10.2.1.1
Host is up (0.00059s latency).
Nmap scan report for 10.2.1.3
Host is up (0.00032s latency).
Nmap done: 256 IP addresses (2 hosts up) scanned in 3.02 seconds
```

**Adresse physique:**

```bash
Carte Ethernet VirtualBox Host-Only Network #2 :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter #2
   Adresse physique . . . . . . . . . . . : 0A-00-27-00-00-03
```

**Liste des ports TCP & UDP:**

```bash
[ianis@patron ~]$ sudo ss -ltunp
Netid  State      Recv-Q Send-Q               Local Address:Port                              Peer Address:Port
udp    UNCONN     0      0                                *:68                                           *:*                   users:(("dhclient",pid=3035,fd=6))
tcp    LISTEN     0      128                              *:22                                           *:*                   users:(("sshd",pid=3259,fd=3))
tcp    LISTEN     0      100                      127.0.0.1:25                                           *:*                   users:(("master",pid=3490,fd=13))
tcp    LISTEN     0      128                             :::22                                          :::*                   users:(("sshd",pid=3259,fd=4))
tcp    LISTEN     0      100                            ::1:25                                          :::*                   users:(("master",pid=3490,fd=14))
```

## II. Notion de ports

### 1. SSH

**IP & PORT que écoute le serveur ssh:**

```bash
[ianis@patron ~]$ sudo ss -ltunp
tcp    LISTEN     0      128                              *:22                                           *:*                   users:(("sshd",pid=3259,fd=3))
```

Pour se connecter en ssh, on utilise la commande suivante : ssh user@ip_vm (port par defaut 22, si besoin de préciser utiliser -p port)

### 2. Firewall

#### A. SSH

Procédure :

* sudo nano /etc/ssh/sshd_config
* Modifier #port 22 -> port 2222
* sudo systemctl restart sshd (il faut penser à désactiver SElinux)
* Pour vérifier si le port à bien changer : sudo ss -ltnup
* depuis la machine host : ssh ianis@10.2.1.3 -p 2222
* La connexion échoue, parce que le firewall bloque le port

**Pour autoriser le port, nous devons configurer le firewall:**

* sudo firewall-cmd --add-port=2222/tcp --permanent
* sudo firewall-cmd --reload

Après l'autorisation du port, la connexion ssh fonctionne bien.

#### B. Netcat

**(VM server)Procédure:**
Ouverture du port 3333 pour netcat

* sudo firewall-cmd --add-port=3333/tcp --permanent
* sudo firewall-cmd --reload

Depuis la vm :

* nc -l 3333

Depuis l'hote :

* nc 10.2.1.3 3333

**(Host server)Procédure:**

Depuis l'hote :

* .\nc.exe -l -p 3333

Depuis la VM :

* [ianis@patron ~]$ nc 192.168.56.1 3333

Vérification :

```bash
tcp    ESTAB      0      0                     10.0.2.15:55170                          192.168.56.1:3333                users:(("nc",pid=4051,fd=3))
```

### 3. Wireshark

## III. Routage statique

### 2. Configuration du routage

#### A. PC1

Ping de PC2(10.2.2.1) depuis PC1:

```bash
C:\Windows\system32>ping 10.2.2.1

Envoi d’une requête 'Ping'  10.2.2.1 avec 32 octets de données :
Réponse de 10.2.2.1 : octets=32 temps=3 ms TTL=127
Réponse de 10.2.2.1 : octets=32 temps=1 ms TTL=127
Réponse de 10.2.2.1 : octets=32 temps=1 ms TTL=127
Réponse de 10.2.2.1 : octets=32 temps=2 ms TTL=127

Statistiques Ping pour 10.2.2.1:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 1ms, Maximum = 3ms, Moyenne = 1ms
```

#### B. PC2

Ping de PC1(10.2.1.1) depuis PC2 :

```bash
C:\WINDOWS\system32>ping 10.2.1.1

Envoi d’une requête 'Ping'  10.2.1.1 avec 32 octets de données :
Réponse de 10.2.1.1 : octets=32 temps=1 ms TTL=127
Réponse de 10.2.1.1 : octets=32 temps=2 ms TTL=127

Statistiques Ping pour 10.2.1.1:
    Paquets : envoyés = 2, reçus = 2, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 1ms, Maximum = 2ms, Moyenne = 1ms
```

#### C. VM1

Commande utiliser pour ajouter une route :

```bash
ip route add 10.2.2.0/24 via 10.2.1.1 dev enp0s8
```

Ping PC2(10.2.2.1) depuis VM1 :

```bash
[ianis@patron ~]$ ping 10.2.2.1
PING 10.2.2.1 (10.2.2.1) 56(84) bytes of data.
64 bytes from 10.2.2.1: icmp_seq=1 ttl=126 time=1.88 ms
64 bytes from 10.2.2.1: icmp_seq=2 ttl=126 time=1.98 ms
64 bytes from 10.2.2.1: icmp_seq=3 ttl=126 time=2.78 ms
^C
--- 10.2.2.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2018ms
rtt min/avg/max/mdev = 1.889/2.222/2.789/0.404 ms
```

#### D. VM2

Ping PC1 depuis VM2:

```bash
[ianis@patron ~]$ ping 10.2.1.1
PING 10.2.1.1 (10.2.1.1) 56(84) bytes of data.
64 bytes from 10.2.1.1: icmp_seq=1 ttl=126 time=2.01 ms
64 bytes from 10.2.1.1: icmp_seq=2 ttl=126 time=2.56 ms
64 bytes from 10.2.1.1: icmp_seq=3 ttl=126 time=3.22 ms
64 bytes from 10.2.1.1: icmp_seq=4 ttl=126 time=2.84 ms
64 bytes from 10.2.1.1: icmp_seq=5 ttl=126 time=2.57 ms
^C
--- 10.2.1.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4009ms
rtt min/avg/max/mdev = 2.015/2.644/3.229/0.398 ms
```

#### E. El gran final

Ping VM1(10.2.1.2) depuis VM2:

```bash
[ianis@patron ~]$ ping 10.2.1.2
PING 10.2.1.2 (10.2.1.2) 56(84) bytes of data.
64 bytes from 10.2.1.2: icmp_seq=1 ttl=62 time=1.90 ms
64 bytes from 10.2.1.2: icmp_seq=2 ttl=62 time=2.37 ms
64 bytes from 10.2.1.2: icmp_seq=3 ttl=62 time=2.78 ms
64 bytes from 10.2.1.2: icmp_seq=4 ttl=62 time=3.02 ms
64 bytes from 10.2.1.2: icmp_seq=5 ttl=62 time=2.26 ms
^C
--- 10.2.1.2 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4011ms
rtt min/avg/max/mdev = 1.906/2.469/3.023/0.397 ms
```

Ping VM2 depuis VM1:

```bash
[ianis@patron ~]$ ping 10.2.2.2
PING 10.2.2.2 (10.2.2.2) 56(84) bytes of data.
64 bytes from 10.2.2.2: icmp_seq=1 ttl=62 time=1.85 ms
64 bytes from 10.2.2.2: icmp_seq=2 ttl=62 time=3.16 ms
64 bytes from 10.2.2.2: icmp_seq=3 ttl=62 time=3.54 ms
^C
--- 10.2.2.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2007ms
rtt min/avg/max/mdev = 1.853/2.855/3.544/0.724 ms
```

### 3. Configuration des noms de domaine

VM1 ping VM2 avec nom dommaine:

```bash
[ianis@patron ~]$ ping vm2.tp2.b1
PING vm2.tp2.b1 (10.2.2.2) 56(84) bytes of data.
64 bytes from vm2.tp2.b1 (10.2.2.2): icmp_seq=1 ttl=62 time=3.89 ms
64 bytes from vm2.tp2.b1 (10.2.2.2): icmp_seq=2 ttl=62 time=3.01 ms
64 bytes from vm2.tp2.b1 (10.2.2.2): icmp_seq=3 ttl=62 time=2.47 ms
^C
--- vm2.tp2.b1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 2.477/3.127/3.894/0.584 ms
```

Traceroute de la VM2 depuis VM1 :

```bash
[ianis@patron ~]$ traceroute vm2.tp2.b1
traceroute to vm2.tp2.b1 (10.2.2.2), 30 hops max, 60 byte packets
 1  gateway (10.0.2.2)  0.191 ms  0.101 ms  0.070 ms
 2  gateway (10.0.2.2)  2.520 ms  2.408 ms  2.307 ms
 ```
