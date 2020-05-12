# TP 5 - Une "vraie" topologie ?

## Préparation de l'environnement

### I. Toplogie 1 - intro VLAN

#### 2. Setup clients

*guest1 vers guest2:*

```bash
guest1> ping 10.5.20.12
84 bytes from 10.5.20.12 icmp_seq=1 ttl=64 time=0.439 ms
84 bytes from 10.5.20.12 icmp_seq=2 ttl=64 time=0.482 ms
```

*admin1 vers admin2:*

```bash
admin1> ping 10.5.10.12
84 bytes from 10.5.10.12 icmp_seq=1 ttl=64 time=0.306 ms
84 bytes from 10.5.10.12 icmp_seq=2 ttl=64 time=0.523 ms
```

#### 3. Setup VLANs

**Mettez en place les VLANs sur vos switches:**

```bash
IOU1(config)#interface Ethernet0/0
IOU1(config-if)#switchport mode access
IOU1(config-if)#switchport access vlan 10
IOU1(config-if)#exit
IOU1(config)#interface Ethernet0/1
IOU1(config-if)#switchport access vlan 20
```

**Vérifier que les guests peuvent toujours se ping, idem pour les admins:**

```bash
guest1> ping 10.5.20.12
84 bytes from 10.5.20.12 icmp_seq=1 ttl=64 time=0.236 ms
84 bytes from 10.5.20.12 icmp_seq=2 ttl=64 time=0.365 ms
```

```bash
admin1> ping 10.5.10.12
84 bytes from 10.5.10.12 icmp_seq=1 ttl=64 time=0.875 ms
84 bytes from 10.5.10.12 icmp_seq=2 ttl=64 time=0.684 ms
```


**montrer que si un des guests change d'IP vers une IP du réseau admins, il ne peut PAS joindre les autres admins:**

```bash
guest1> ip 10.5.10.13
Checking for duplicate address...
PC1 : 10.5.10.13 255.255.255.0

guest1> ping 10.5.10.11
host (10.5.10.11) not reachable
```

### Topologie 2 - VLAN, sous-interface, NAT

#### 2. Adressage

**Vérifier que les guests peuvent ping les autres guests:*

```bash
guest3> ping 10.5.20.11
84 bytes from 10.5.20.11 icmp_seq=1 ttl=64 time=0.312 ms
84 bytes from 10.5.20.11 icmp_seq=2 ttl=64 time=0.285 ms
```

**les admins peuvent ping les autres admins:**

```bash
admin3> ping 10.5.10.11
84 bytes from 10.5.10.11 icmp_seq=1 ttl=64 time=0.194 ms
84 bytes from 10.5.10.11 icmp_seq=2 ttl=64 time=0.435 ms
```

#### 2. VLAN

**Configurez les VLANs sur l'ensemble des switches:**

```bash
conf t

(config)# vlan 10
(config-vlan)# name admins
(config-vlan)# exit

(config)# vlan 20
(config-vlan)# name guests
(config-vlan)# exit

(config)# interface ethernet <interface liée aux guests et admins>
(config-if)# switchport mode access
(config-if)# switchport access vlan <10 pour admins et 20 pour guests>
(config-if)# exit
```

**Vérifier et prouver qu'un guest qui prend un IP du réseau admins ne peut joindre aucune machine.**

```bash

guest3> ip 10.5.10.14
Checking for duplicate address...
PC1 : 10.5.10.14 255.255.255.0

guest3> ping 10.5.10.11
host (10.5.10.11) not reachable

guest2> ip 10.5.10.14
Checking for duplicate address...
PC1 : 10.5.10.14 255.255.255.0

guest2> ping 10.5.10.11
host (10.5.10.11) not reachable

guest1> ip 10.5.10.14
Checking for duplicate address...
PC1 : 10.5.10.14 255.255.255.0

guest1> ping 10.5.10.11
host (10.5.10.11) not reachable
```

#### 4. Sous-interfaces

**Configurez les sous-interfaces de votre routeur:**

```bash
conf t
(config)# interface fastEthernet1/0.10
(config-subif)# encapsulation dot1Q 10
(config-subif)# ip address 10.5.10.254 255.255.255.0
(config-subif)# exit
(config)# interface fastEthernet1/0.20
(config-subif)# encapsulation dot1Q 20
(config-subif)# ip address 10.5.20.254 255.255.255.0
(config-subif)# exit
(config)# interface fastEthernet1/0
(config)# no shut
(config-if)# exit
```

**Vérifier que les clients et les guests peuvent maintenant ping leur passerelle respective:**

```bash
guest2> ping 10.5.20.254
84 bytes from 10.5.20.254 icmp_seq=1 ttl=255 time=2.647 ms
84 bytes from 10.5.20.254 icmp_seq=2 ttl=255 time=2.234 ms

guest2> ip 10.5.10.15
Checking for duplicate address...
PC1 : 10.5.10.15 255.255.255.0

guest2> ping 10.5.10.254
host (10.5.10.254) not reachable

admin1> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=9.458 ms
84 bytes from 10.5.10.254 icmp_seq=2 ttl=255 time=7.746 ms

guest1> ping 10.5.20.254
84 bytes from 10.5.20.254 icmp_seq=1 ttl=255 time=5.389 ms
84 bytes from 10.5.20.254 icmp_seq=2 ttl=255 time=6.681 ms

admin2> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=3.465 ms
84 bytes from 10.5.10.254 icmp_seq=2 ttl=255 time=4.357 ms

guest2> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=2.764 ms
84 bytes from 10.5.10.254 icmp_seq=2 ttl=255 time=6.741 ms
```

#### 5.NAT

**Configurer un source NAT sur le routeur (comme au TP4):**

```bash
Interfaces "externes" :
(config)# interface fastEthernet 0/0
(config-if)# ip nat outside

(config)#interface fastethernet 0/0
(config-if)#ip address dhcp

Interfaces "internes" :
(config)# interface fastEthernet 1/0.10 (.20 plus tard)
(config-if)# ip nat inside

(config)# access-list 1 permit any

(config)# ip nat inside source list 1 interface fastEthernet 0/0 overload
```

**Vérifier que les clients et les admins peuvent joindre Internet:**

```bash
admin1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=51 time=45.254 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=51 time=64.854 ms

guest1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=51 time=84.984 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=51 time=65.428 ms
```

### III. Topologie 3 - Ajouter des services

#### 3. Serveur DHCP

**Vérifier et prouver qu'un client branché à client-sw3 peut récupérer une IP dynamiquement:**

#### 4. Serveur Web

**Tester que le serveur Web fonctionne:**

*Depuis le serveur web:*

```bash
[root@web ~]# curl localhost:80

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css">

        html {
        background-image:url(img/html-background.png);
        background-color: white;
        font-family: "DejaVu Sans", "Liberation Sans", sans-serif;
        font-size: 0.85em;
        line-height: 1.25em;
        margin: 0 4% 0 4%;
        }

        body {
        border: 10px solid #fff;
        margin:0;
        padding:0;
        background: #fff;
        }

        /* Links */

        a:link { border-bottom: 1px dotted #ccc; text-decoration: none; color: #204d92; }
        a:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
        a:active {  border-bottom:1px dotted #ccc; text-decoration: underline; color: #204d92; }
        a:visited { border-bottom:1px dotted #ccc; text-decoration: none; color: #204d92; }
        a:visited:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }

        .logo a:link,
        .logo a:hover,
        .logo a:visited { border-bottom: none; }

        .mainlinks a:link { border-bottom: 1px dotted #ddd; text-decoration: none; color: #eee; }
        .mainlinks a:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
        .mainlinks a:active { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
        .mainlinks a:visited { border-bottom:1px dotted #ddd; text-decoration: none; color: white; }
        .mainlinks a:visited:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }

        /* User interface styles */

        #header {
        margin:0;
        padding: 0.5em;
        background: #204D8C url(img/header-background.png);
        text-align: left;
        }

        .logo {
        padding: 0;
        /* For text only logo */
        font-size: 1.4em;
        line-height: 1em;
        font-weight: bold;
        }

        .logo img {
        vertical-align: middle;
        padding-right: 1em;
        }

        .logo a {
        color: #fff;
        text-decoration: none;
        }

        p {
        line-height:1.5em;
        }

        h1 {
                margin-bottom: 0;
                line-height: 1.9em; }
        h2 {
                margin-top: 0;
                line-height: 1.7em; }

        #content {
        clear:both;
        padding-left: 30px;
        padding-right: 30px;
        padding-bottom: 30px;
        border-bottom: 5px solid #eee;
        }

    .mainlinks {
        float: right;
        margin-top: 0.5em;
        text-align: right;
    }

    ul.mainlinks > li {
    border-right: 1px dotted #ddd;
    padding-right: 10px;
    padding-left: 10px;
    display: inline;
    list-style: none;
    }

    ul.mainlinks > li.last,
    ul.mainlinks > li.first {
    border-right: none;
    }

  </style>

</head>

<body>

<div id="header">

    <ul class="mainlinks">
        <li> <a href="http://www.centos.org/">Home</a> </li>
        <li> <a href="http://wiki.centos.org/">Wiki</a> </li>
        <li> <a href="http://wiki.centos.org/GettingHelp/ListInfo">Mailing Lists</a></li>
        <li> <a href="http://www.centos.org/download/mirrors/">Mirror List</a></li>
        <li> <a href="http://wiki.centos.org/irc">IRC</a></li>
        <li> <a href="https://www.centos.org/forums/">Forums</a></li>
        <li> <a href="http://bugs.centos.org/">Bugs</a> </li>
        <li class="last"> <a href="http://wiki.centos.org/Donate">Donate</a></li>
    </ul>

        <div class="logo">
                <a href="http://www.centos.org/"><img src="img/centos-logo.png" border="0"></a>
        </div>

</div>

<div id="content">

        <h1>Welcome to CentOS</h1>

        <h2>The Community ENTerprise Operating System</h2>

        <p><a href="http://www.centos.org/">CentOS</a> is an Enterprise-class Linux Distribution derived from sources freely provided

to the public by Red Hat, Inc. for Red Hat Enterprise Linux. CentOS conforms fully with the upstream vendors
redistribution policy and aims to be functionally compatible. (CentOS mainly changes packages to remove upstream vendor
branding and artwork.)</p>

        <p>CentOS is developed by a small but growing team of core

developers.&nbsp; In turn the core developers are supported by an active user community
including system administrators, network administrators, enterprise users, managers, core Linux contributors and Linux enthusiasts from around the world.</p>

        <p>CentOS has numerous advantages including: an active and growing user community, quickly rebuilt, tested, and QAed errata packages, an extensive <a href="http://www.centos.org/download/mirrors/">mirror network</a>, developers who are contactable and responsive, Special Interest Groups (<a href="http://wiki.centos.org/SpecialInterestGroup/">SIGs</a>) to add functionality to the core CentOS distribution, and multiple community support avenues including a <a href="http://wiki.centos.org/">wiki</a>, <a

href="http://wiki.centos.org/irc">IRC Chat</a>, <a href="http://wiki.centos.org/GettingHelp/ListInfo">Email Lists</a>, <a href="https://www.centos.org/forums/">Forums</a>, <a href="http://bugs.centos.org/">Bugs Database</a>, and an <a
href="http://wiki.centos.org/FAQ/">FAQ</a>.</p>

        </div>

</div>

</body>
</html>
```

*Depuis une autre machine:*

```bash
curl 10.5.30.10:80
```

```html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css">

        html {
        background-image:url(img/html-background.png);
        background-color: white;
        font-family: "DejaVu Sans", "Liberation Sans", sans-serif;
        font-size: 0.85em;
        line-height: 1.25em;
        margin: 0 4% 0 4%;
        }

        body {
        border: 10px solid #fff;
        margin:0;
        padding:0;
        background: #fff;
        }

        /* Links */

        a:link { border-bottom: 1px dotted #ccc; text-decoration: none; color: #204d92; }
        a:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
        a:active {  border-bottom:1px dotted #ccc; text-decoration: underline; color: #204d92; }
        a:visited { border-bottom:1px dotted #ccc; text-decoration: none; color: #204d92; }
        a:visited:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }

        .logo a:link,
        .logo a:hover,
        .logo a:visited { border-bottom: none; }

        .mainlinks a:link { border-bottom: 1px dotted #ddd; text-decoration: none; color: #eee; }
        .mainlinks a:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
        .mainlinks a:active { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
        .mainlinks a:visited { border-bottom:1px dotted #ddd; text-decoration: none; color: white; }
        .mainlinks a:visited:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }

        /* User interface styles */

        #header {
        margin:0;
        padding: 0.5em;
        background: #204D8C url(img/header-background.png);
        text-align: left;
        }

        .logo {
        padding: 0;
        /* For text only logo */
        font-size: 1.4em;
        line-height: 1em;
        font-weight: bold;
        }

        .logo img {
        vertical-align: middle;
        padding-right: 1em;
        }

        .logo a {
        color: #fff;
        text-decoration: none;
        }

        p {
        line-height:1.5em;
        }

        h1 {
                margin-bottom: 0;
                line-height: 1.9em; }
        h2 {
                margin-top: 0;
                line-height: 1.7em; }

        #content {
        clear:both;
        padding-left: 30px;
        padding-right: 30px;
        padding-bottom: 30px;
        border-bottom: 5px solid #eee;
        }

    .mainlinks {
        float: right;
        margin-top: 0.5em;
        text-align: right;
    }

    ul.mainlinks > li {
    border-right: 1px dotted #ddd;
    padding-right: 10px;
    padding-left: 10px;
    display: inline;
    list-style: none;
    }

    ul.mainlinks > li.last,
    ul.mainlinks > li.first {
    border-right: none;
    }

  </style>

</head>

<body>

<div id="header">

    <ul class="mainlinks">
        <li> <a href="http://www.centos.org/">Home</a> </li>
        <li> <a href="http://wiki.centos.org/">Wiki</a> </li>
        <li> <a href="http://wiki.centos.org/GettingHelp/ListInfo">Mailing Lists</a></li>
        <li> <a href="http://www.centos.org/download/mirrors/">Mirror List</a></li>
        <li> <a href="http://wiki.centos.org/irc">IRC</a></li>
        <li> <a href="https://www.centos.org/forums/">Forums</a></li>
        <li> <a href="http://bugs.centos.org/">Bugs</a> </li>
        <li class="last"> <a href="http://wiki.centos.org/Donate">Donate</a></li>
    </ul>

        <div class="logo">
                <a href="http://www.centos.org/"><img src="img/centos-logo.png" border="0"></a>
        </div>

</div>

<div id="content">

        <h1>Welcome to CentOS</h1>

        <h2>The Community ENTerprise Operating System</h2>

        <p><a href="http://www.centos.org/">CentOS</a> is an Enterprise-class Linux Distribution derived from sources freely provided

to the public by Red Hat, Inc. for Red Hat Enterprise Linux. CentOS conforms fully with the upstream vendors
redistribution policy and aims to be functionally compatible. (CentOS mainly changes packages to remove upstream vendor
branding and artwork.)</p>

        <p>CentOS is developed by a small but growing team of core

developers.&nbsp; In turn the core developers are supported by an active user community
including system administrators, network administrators, enterprise users, managers, core Linux contributors and Linux enthusiasts from around the world.</p>

        <p>CentOS has numerous advantages including: an active and growing user community, quickly rebuilt, tested, and QAed errata packages, an extensive <a href="http://www.centos.org/download/mirrors/">mirror network</a>, developers who are contactable and responsive, Special Interest Groups (<a href="http://wiki.centos.org/SpecialInterestGroup/">SIGs</a>) to add functionality to the core CentOS distribution, and multiple community support avenues including a <a href="http://wiki.centos.org/">wiki</a>, <a

href="http://wiki.centos.org/irc">IRC Chat</a>, <a href="http://wiki.centos.org/GettingHelp/ListInfo">Email Lists</a>, <a href="https://www.centos.org/forums/">Forums</a>, <a href="http://bugs.centos.org/">Bugs Database</a>, and an <a
href="http://wiki.centos.org/FAQ/">FAQ</a>.</p>

        </div>

</div>

</body>
</html>
```