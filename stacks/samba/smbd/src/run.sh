#!/bin/bash

if [ ! -f /var/lib/extrausers/passwd ]; then
  touch /var/lib/extrausers/passwd
fi

if [ ! -f /var/lib/extrausers/shadow ]; then
  touch /var/lib/extrausers/shadow
fi

if [ ! -f /var/lib/extrausers/group ]; then
  touch /var/lib/extrausers/group
fi


if [ $(dpkg-query -W -f='${Status}' samba 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
  /opt/rootlogin-fileserver/prepare_samba.sh
fi

if [ ! -d /home/associations ]; then
  #Création du dossier commun aux association
  mkdir /home/associations
  /opt/rootlogin-fileserver/manage.sh manage add_group associations
  useradd -m -g associations sambaadmin
  chown -R sambaadmin:associations /home/associations
  chmod -R 770 /home/associations
fi

if [ "$1" == "manage" ]; then
  exec /opt/rootlogin-fileserver/manage.sh "$@"
else
  exec "$@"
fi