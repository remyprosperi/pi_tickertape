#!/bin/bash

LOG="/home/digitalli/usb_script.log"

# 1. Identifier le périphérique USB automatiquement en cherchant "usb" dans la colonne TRAN
usb_device=$(lsblk -o NAME,TRAN | grep 'usb' | awk '{print $1}')

if [ -z "$usb_device" ]; then
  echo "Aucune clé USB détectée." >>$LOG
  exit 1
fi

# 2. Créer un point de montage
mount_point="/media/usb_ticker_tape"
sudo mkdir -p $mount_point

# 3. Monter la clé USB (généralement la première partition est sdX1)
sudo mount /dev/${usb_device}1 $mount_point

if [ $? -ne 0 ]; then
  echo "Le montage de la clé USB a échoué.">>$LOG
  exit 1
fi

echo "Clé USB montée sur $mount_point.">>$LOG

# 4. Exécuter le script sur la clé USB
script_path="$mount_point/update_tape.sh"

if [ -f "$script_path" ]; then
  chmod +x $script_path
  $script_path
  echo "run update_tape.sh" >>$LOG
else
  echo "Aucun script trouvé sur la clé USB.">>$LOG
fi

# 5. Démonter la clé USB après exécution
#sudo umount $mount_point

#if [ $? -eq 0 ]; then
#  echo "Clé USB démontée avec succès."
#else
#  echo "Échec du démontage de la clé USB."
#fi

# 6. Nettoyage (supprimer le point de montage)
#sudo rmdir $mount_point
