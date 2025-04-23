#!/bin/bash

# GMod Server Installations-Skript für Proxmox

# Container erstellen
echo "Erstelle einen neuen Container..."
CTID=$(pct create 111 local:vztmpl/debian-12.7-1_amd64.tar.zst -hostname gmod-server -net0 name=eth0,bridge=vmbr0,ip=dhcp -cores 2 -memory 4096 -swap 512 -storage local-lvm -unprivileged 1)

if [ $? -ne 0 ]; then
  echo "Fehler beim Erstellen des Containers!"
  exit 1
fi

echo "Container $CTID wurde erstellt und läuft."

# Container starten
echo "Starte Container $CTID..."
pct start $CTID

# Warten bis der Container hochgefahren ist
echo "Warte 10 Sekunden, bis der Container bereit ist..."
sleep 10

# Updates und Installationen im Container durchführen
echo "Updating the system in container $CTID..."
pct exec $CTID -- apt update && pct exec $CTID -- apt upgrade -y

echo "Installing required packages..."
pct exec $CTID -- apt install -y curl wget git make g++ lib32gcc-s1 lib32stdc++6 lib32tinfo5 lib32z1

# SteamCMD installieren
echo "Installing SteamCMD..."
pct exec $CTID -- mkdir -p /home/steam
pct exec $CTID -- cd /home/steam && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
pct exec $CTID -- cd /home/steam && tar -xvzf steamcmd_linux.tar.gz
pct exec $CTID -- rm /home/steam/steamcmd_linux.tar.gz

# GMod-Server installieren
echo "Downloading and installing GMod server..."
pct exec $CTID -- /home/steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/gmod +app_update 4020 validate +quit

# Konfiguration einrichten
echo "Setting up server configuration..."
pct exec $CTID -- mkdir -p /home/steam/gmod/garrysmod/cfg
pct exec $CTID -- echo 'sv_lan 1' > /home/steam/gmod/garrysmod/cfg/server.cfg
pct exec $CTID -- echo '
