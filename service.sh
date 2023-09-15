#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/momohide.sh" &
TMPPROP="$(magisk --path)/riru.prop"
MIRRORPROP="$(magisk --path)/.magisk/modules/riru-core/module.prop"
sh -Cc "cat '$MODDIR/module.prop' > '$TMPPROP'"
if [ $? -eq 0 ]; then
  mount --bind "$TMPPROP" "$MIRRORPROP"
  sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ⛔ post-fs-data.sh fails to run. Magisk is broken on this device. ] /g' "$MODDIR/module.prop"
  exit
fi

if mountpoint -q /cache; then
    logcat=/cache/riru_master.log
else
    logcat=/data/cache/riru_master.log
fi 
rm -rf ${logcat}.bak
mv -f $logcat ${logcat}.bak
logcat Riru:I *:S >>$logcat &
logcat MomoHider:I *:S >>$logcat &
