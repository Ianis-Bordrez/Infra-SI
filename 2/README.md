# B1 Réseau 2019 - TP2

## Déterminer la liste de vos cartes réseau, les informations qui y sont liées, et la fonction de chacune

Name | IP | MAC | Fonction
--- | --- | --- | ---
`lo` | `127.0.0.1/8` | `00:00:00:00:00:00` | Carte Loopback

Name | IP | MAC | Fonction
--- | --- | --- | ---
`enp0s3` | `10.0.2.15/24` | `08:00:27:f4:30:9d` | Carte Nat

Name | IP | MAC | Fonction
--- | --- | --- | ---
`enp0s8` | `10.2.1.2/24` | `08:00:27:7d:38:78` | Carte Host-Only

## Changer la configuration de la carte réseau Host-Only

**Procédure :**

* sudo nano ifcfg-enp0s8
* IPADDR=10.2.0.3
* sudo ifdow enp0s8
* sudo ifdup enp0s8
* ip a

