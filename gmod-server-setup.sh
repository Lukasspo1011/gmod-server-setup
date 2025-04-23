#!/bin/bash

# Schritt 1: System aktualisieren
echo "Aktualisiere das System..."
apt update && apt upgrade -y

# Schritt 2: Notwendige Pakete installieren
echo "Installiere notwendige Pakete..."
apt install -y curl wget git make g++ lib32gcc-s1 lib32stdc++6 lib32tinfo5 lib32z1 screen

# Schritt 3: SteamCMD installieren
echo "Installiere SteamCMD..."
mkdir -p /home/steam
cd /home/steam
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz

# Schritt 4: GMod-Server herunterladen und installieren
echo "Installiere den GMod-Server..."
./steamcmd.sh +login anonymous +force_install_dir /home/steam/gmod +app_update 4020 validate +quit

# Schritt 5: Server konfigurieren
echo "Konfiguriere den Server..."
mkdir -p /home/steam/gmod/garrysmod/cfg
echo 'sv_lan 1' > /home/steam/gmod/garrysmod/cfg/server.cfg
echo 'host_workshop_collection 0' >> /home/steam/gmod/garrysmod/cfg/server.cfg
echo 'sv_region 3' >> /home/steam/gmod/garrysmod/cfg/server.cfg
echo 'sv_cheats 0' >> /home/steam/gmod/garrysmod/cfg/server.cfg

# Schritt 6: GMod-Server starten
echo "Starte den GMod-Server..."
cd /home/steam/gmod
screen -dmS gmod_server ./srcds_run -game garrysmod +maxplayers 16 +map gm_flatgrass

echo "Der GMod-Server läuft jetzt im Hintergrund!"
