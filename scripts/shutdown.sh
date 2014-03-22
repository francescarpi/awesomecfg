#!/bin/sh

ACTION=`yad --on-top --skip-taskbar --height=200 --center --list --radiolist --text="Selecciona acció" --title="Sortir..." --column "Opció" --column "Acció" FALSE LockScreen FALSE Suspend FALSE Shutdown FALSE Restart`
ACTION=$(echo $ACTION | awk 'BEGIN {FS="|" } { print $2 }')

if [ -n "${ACTION}" ];then
  case $ACTION in
  Suspend)
    beesu pm-suspend
    slock
    ;;
  LockScreen)
    slock
    ;;
  Shutdown)
    shutdown -h now
    ;;
  Restart)
    shutdown -r now
    ;;
  esac
fi
