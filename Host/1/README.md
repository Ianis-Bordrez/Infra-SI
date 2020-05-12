# Maîtrise de poste - Day 1

## Self-footprinting

### Host OS

* nom de la machine

```powershell
PS C:\Users\ianis> hostname
PC_DE_MOI
```

* OS et version

```powershell
PS C:\Users\ianis> Get-ComputerInfo  | select windowsversion

WindowsVersion
--------------
1909
```

* architecture processeur (32-bit, 64-bit, ARM, etc)

```powershell
PS C:\Users\ianis> Get-WmiObject Win32_Processor


Caption           : Intel64 Family 6 Model 158 Stepping 10
DeviceID          : CPU0
Manufacturer      : GenuineIntel
MaxClockSpeed     : 2592
Name              : Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
SocketDesignation : U3E1
```

* modèle du processeur

```powershell
PS C:\Users\ianis> Get-WmiObject Win32_Processor


Caption           : Intel64 Family 6 Model 158 Stepping 10
DeviceID          : CPU0
Manufacturer      : GenuineIntel
MaxClockSpeed     : 2592
Name              : Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
SocketDesignation : U3E1
```

* quantité RAM et modèle de la RAM

```powershell
PS C:\Users\ianis> Get-WmiObject Win32_PhysicalMemory | select Capacity, name, partnumber

  Capacity name             partnumber
  -------- ----             ----------
8589934592 Mémoire physique MSI26D4S9S8ME-8
8589934592 Mémoire physique MSI26D4S9S8ME-8
```

### Devices

**Trouver :**

* la marque et le modèle de votre processeur
  * identifier le nombre de processeurs, le nombre de coeur
	```powershell
	PS C:\Users\ianis> WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors,name
	DeviceID  Name                                      NumberOfCores  NumberOfLogicalProcessors
	CPU0      Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz  6              12
	```

  * si c'est un proc Intel, expliquer le nom du processeur (oui le nom veut dire quelque chose)
	```
	M : processeurs Intel Core mobiles bicœurs assez puissants avec une fréquence plutôt élevée (pour un portable). Ils équipent généralement des portables « normaux » moyennement puissants comme le MacBook Pro 13 pouces et 13 pouces Retina par exemple.
	T : il s’agit là d’une version « basse consommation »  avec des fréquences (de base et mode turbo) très inférieures au modèle standard.
	R : cette lettre est apparue avec la génération Haswell, elle désigne un modèle S avec une partie graphique intégrée (IGP) plus puissante, en l'occurrence l'Iris Pro Graphics 5200 qu'Intel réserve, à cette exception prés, aux processeurs mobiles haut de gamme
	```

* la marque et le modèle
  * de votre touchpad/trackpad

	```powershell
	
	```

  * de vos enceintes intégrées

 	```powershell
	 PS C:\Users\ianis> Get-CimInstance win32_sounddevice

	Manufacturer         Name                                                Status StatusInfo
	------------         ----                                                ------ ----------
	Intel(R) Corporation Son Intel(R) pour écrans                            OK              3
	Realtek              Realtek High Definition Audio                       OK              3
	Nahimic              Nahimic mirroring device                            OK              3
	NVIDIA               NVIDIA Virtual Audio Device (Wave Extensible) (WDM) OK              3
	NVIDIA               NVIDIA High Definition Audio                        OK              3
	```

  * de votre disque dur principal
  	```powershell
	  PS C:\Users\ianis> wmic diskdrive get Name,model,size
	Model                           Name                Size
	WDC PC SN520 SDAPNUW-256G-1032  \\.\PHYSICALDRIVE0  256052966400
	ST1000LM049-2GH172              \\.\PHYSICALDRIVE1  1000202273280
	WD My Passport 25E1 USB Device  \\.\PHYSICALDRIVE2  2000363420160
	```

**Disque dur :**

* identifier les différentes partitions de votre/vos disque(s) dur(s)
* déterminer le système de fichier de chaque partition
* expliquer la fonction de chaque partition

```powershell
PS C:\Users\ianis> Get-Volume

DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining      Size
----------- ------------ -------------- --------- ------------ ----------------- -------------      ----
            BIOS_RVY     NTFS           Fixed     Healthy      OK                    704.69 MB  17.64 GB
F           My Passport  NTFS           Fixed     Healthy      OK                       1.2 TB   1.82 TB
C           Windows      NTFS           Fixed     Healthy      OK                     48.71 GB 237.18 GB
D           Data         NTFS           Fixed     Healthy      OK                     67.44 GB 913.87 GB
            WinRE tools  NTFS           Fixed     Healthy      OK                    431.18 MB    900 MB
```

### Network

**Afficher la liste des cartes réseau de votre machine :**

* expliquer la fonction de chacune d'entre elles

```powershell
PS C:\Users\ianis> Get-NetAdapter | fl Name, InterfaceIndex


Name           : Connexion réseau Bluetooth
InterfaceIndex : 19

Name           : VirtualBox Host-Only Network #3
InterfaceIndex : 17

Name           : Ethernet 2
InterfaceIndex : 16

Name           : VirtualBox Host-Only Network
InterfaceIndex : 15

Name           : Ethernet
InterfaceIndex : 8

Name           : Wi-Fi
InterfaceIndex : 7

Name           : VirtualBox Host-Only Network #2
InterfaceIndex : 3
```

**Lister tous les ports TCP et UDP en utilisation :**

```powershell
PSPS C:\Users\ianis> netstat -a

Connexions actives

  Proto  Adresse locale         Adresse distante       État
  TCP    0.0.0.0:80             PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:135            PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:445            PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:808            PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:5040           PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:7518           PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:9001           PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:49664          PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:49665          PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:49666          PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:49667          PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:49668          PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:49669          PC_DE_MOI:0            LISTENING
  TCP    0.0.0.0:49697          PC_DE_MOI:0            LISTENING
  TCP    10.3.1.1:139           PC_DE_MOI:0            LISTENING
  TCP    10.3.2.1:139           PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:3213         PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:5939         PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:5939         PC_DE_MOI:8383         ESTABLISHED
  TCP    127.0.0.1:6463         PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:8383         PC_DE_MOI:5939         ESTABLISHED
  TCP    127.0.0.1:8386         PC_DE_MOI:8387         ESTABLISHED
  TCP    127.0.0.1:8387         PC_DE_MOI:8386         ESTABLISHED
  TCP    127.0.0.1:8460         PC_DE_MOI:8461         ESTABLISHED
  TCP    127.0.0.1:8461         PC_DE_MOI:8460         ESTABLISHED
  TCP    127.0.0.1:8462         PC_DE_MOI:8463         ESTABLISHED
  TCP    127.0.0.1:8463         PC_DE_MOI:8462         ESTABLISHED
  TCP    127.0.0.1:8465         PC_DE_MOI:8466         ESTABLISHED
  TCP    127.0.0.1:8466         PC_DE_MOI:8465         ESTABLISHED
  TCP    127.0.0.1:8494         PC_DE_MOI:8495         ESTABLISHED
  TCP    127.0.0.1:8495         PC_DE_MOI:8494         ESTABLISHED
  TCP    127.0.0.1:8739         PC_DE_MOI:8740         ESTABLISHED
  TCP    127.0.0.1:8740         PC_DE_MOI:8739         ESTABLISHED
  TCP    127.0.0.1:9074         PC_DE_MOI:9075         ESTABLISHED
  TCP    127.0.0.1:9075         PC_DE_MOI:9074         ESTABLISHED
  TCP    127.0.0.1:9197         PC_DE_MOI:9198         ESTABLISHED
  TCP    127.0.0.1:9198         PC_DE_MOI:9197         ESTABLISHED
  TCP    127.0.0.1:9285         PC_DE_MOI:9286         ESTABLISHED
  TCP    127.0.0.1:9286         PC_DE_MOI:9285         ESTABLISHED
  TCP    127.0.0.1:9308         PC_DE_MOI:9309         ESTABLISHED
  TCP    127.0.0.1:9309         PC_DE_MOI:9308         ESTABLISHED
  TCP    127.0.0.1:9364         PC_DE_MOI:9365         ESTABLISHED
  TCP    127.0.0.1:9365         PC_DE_MOI:9364         ESTABLISHED
  TCP    127.0.0.1:12025        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:12110        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:12119        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:12143        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:12465        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:12563        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:12993        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:12995        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:27275        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:56100        PC_DE_MOI:65001        ESTABLISHED
  TCP    127.0.0.1:56155        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:56155        PC_DE_MOI:56183        ESTABLISHED
  TCP    127.0.0.1:56183        PC_DE_MOI:56155        ESTABLISHED
  TCP    127.0.0.1:65001        PC_DE_MOI:0            LISTENING
  TCP    127.0.0.1:65001        PC_DE_MOI:56100        ESTABLISHED
  TCP    192.168.0.38:139       PC_DE_MOI:0            LISTENING
```

```powershell

```

### Users

**Déterminer la liste des utilisateurs de la machine :**

 * La liste complète des utilisateurs de la machine (je vous vois les Windowsiens...)

	```powershell
	PS C:\Users\ianis> Get-LocalUser

	Name               Enabled Description
	----               ------- -----------
	Administrateur     False   Compte d’utilisateur d’administration
	DefaultAccount     False   Compte utilisateur géré par le système.
	ianis              True
	Invité             False   Compte d’utilisateur invité
	WDAGUtilityAccount False   Compte d’utilisateur géré et utilisé par le système pour les scénarios Windows Defender Application Guard.
	YNOV01             True    Local user account for execution of R scripts in SQL Server instance YNOV
	YNOV02             True    Local user account for execution of R scripts in SQL Server instance YNOV
	```
* déterminer le nom de l'utilisateur qui est full admin sur la machine
	```
	Name               Enabled Description
	----               ------- -----------
	Administrateur     False   Compte d’utilisateur d’administration
	```

### Processus

**Déterminer la liste des processus de la machine :**

```powershell
PS C:\Users\ianis> ps

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    204      15     3528       9908       0,13  15160   2 acrotray
    558      33    35204      37628       4,31  14040   2 ApplicationFrameHost
    450      25    55928     112284      31,67  10960   0 aswEngSrv
    970      29    60628      68232             10884   0 aswidsagent
    453      25    29180      26284     473,27  21860   0 audiodg
   6871     105   248700     176748              4392   0 AVGSvc
   2208      55    38740      65316     158,52   2200   2 AVGUI
    632      31    13904      27852       0,36  21068   2 AVGUI
    548      29    21868        128       0,42  13004   2 Calculator
    423      46    62124      83036      15,55   2832   2 Code
    346      21    10708      22968       0,44   5000   2 Code
    615      94   180252     201992     101,27   6116   2 Code
```

* choisissez 5 services système et expliquer leur utilité

	```powershell

	```

* déterminer les processus lancés par l'utilisateur qui est full admin sur la machine
 	
	 ```powershell

	```

### Scripting

* trouvez un langage natif par rapport à votre OS
	Comme langage de script sous Windows10, j'ai trouvé Batch et Powershell.
	Powershell est le plus adapté 

	```powershell

	```



```powershell

```

### Gestion de softs

*Expliquer l'intérêt de l'utilisation d'un gestionnaire de paquets:*
Un gestionnaire de paquet permet d'installer des logiciels, de les désinstaller et de les mettre à jour en une seule commande. Tous ces paquets sont centralisés dans un seul dépôt ce qui permet de ne pas parcourir le web pour une seule installation. Tous les logiciels sont dépourvus de malwares. Les dépendances sont automatiquement installées.

*Utiliser un gestionnaire de paquet propres à votre OS pour*:

```powershell
PS C:\WINDOWS\system32> choco list -l
Chocolatey v0.10.15
chocolatey 0.10.15
1 packages installed.
```

### Partage de fichiers

*Monter et accéder à un partage de fichiers:*

### Chiffrement et notion de confiance

*Expliquer en détail l'utilisation de certificats:*

#### Chiffrement de mails


#### TLS

*que garantit HTTPS par rapport à HTTP ? (deux réponses attendues):*
Le https garantit le chiffrement des données qui transitent entre le client et le serveur. Il garantit aussi l'authenticité du site sur lequel on est.

*qu'est-ce que signifie précisément et techniquement le cadenas vert que nous présente nos navigateurs lorsque l'on visite un site web "sécurisé":*
Le cadena vert signifit qu'un certificat SSL sécurisé est utilisé pendant la connexion https.

*Accéder à un serveur web sécurisé (client)*

* accéder à un site web en HTTPS
  https://gitlab.com/
* visualiser le certificat
  (firefox) : Clique sur le cadenas, afficher les détails de la connexion, plus d'informations, afficher le certificat.
* 

#### SSH

##### Client

*Générer une nouvelle paire de clés SSH:*

```powershell
ssh-keygen
```

*Déposer la clé nécessaire sur le serveur pour pouvoir vous y connecter:*
On met la clé publique dans un fichier ~/.ssh/authorized_keys.

*Expliquer tout ce qui est nécessaire pour se connecter avec un échange de clés, en ce qui concerne le client:*
* quelle(s) clé(s) sont générée(s) ? Comment ?
  Les clés privées et publiques sont générées grace à un chiffrement basé sur des clés asymétriques.
* quelle clé est déposée ? Pourquoi pas l'autre ?
  La clé déposée est la clé publique. On dépose celle ci parce que c'est la norme et pour une autre raison que tu avais expliqué dans un cours bonus mais j'ai zapé.
* à quoi ça sert précisément de déposer cette clé sur le serveur distant, qu'est-ce qu'il va pouvoir faire, précisément avec ?
  Cela permettra de déchiffrer les paquets envoyés par le client.
* dans quel fichier est stocké la clé ? Quelles permissions sur ce fichier ?
  ~/.ssh/authorized_keys avec les permissions -rw-------

*Le fingerprint SSH:*
 C'est pour une identification / vérification facile de l'hôte auquel on se connecte

*Créer un fichier ~/.ssh/config et y définir une connexion:


#### SSH avancé

##### SSH tunnels

*Mettez en place un serveur Web dans une VM:*

##### SSH jumps



#### Forwarding de ports at home








