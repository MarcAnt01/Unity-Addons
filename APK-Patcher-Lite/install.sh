# APK-Patcher Lite: Recovery Flashable Zip
# by djb77 @ xda-developers
# Based on APK-Patcher by osm0sis @ xda-developers
#
# APK-Patcher Lite Changelog:
#
# - Initial transformation to Lite vesrion, based on the APK
#   Patching method used for TGP ROM.
# - Removed Baksmali / Smail / Apktool support, instead it will 
#   now copy pre-compiled files (xml, dex etc) to the APK file.
# - New script added to remove unwanted files from the APK,
#   a sample is located at scripts/apkname.sh. 
#   Please rename the .sh to the APK name you want to work on.

# working directory variables
ap=$INSTALLER/addon/APK-Patcher;
bin=$ap/$ARCH32/tools;
patch=$ap/patch;
script=$ap/script;

# set up extracted files and directories
rm -f $patch/placeholder $script/placeholder
chmod -R 755 $bin $script $ap/*.sh;

# dexed bak/smali and apktool jars (via: dx --dex --output=classes.dex <file>.jar)
baksmali=$bin/baksmali-*-dexed.jar;
smali=$bin/smali-*-dexed.jar;
apktool=$bin/apktool_*-dexed.jar;

ui_print " ";
ui_print "- Running APK Patcher Lite by djb77 @ xda-developers-";
ui_print "  Based on APK Patcher by osm0sis @ xda-developers";
ui_print " ";

ui_print "   Patching files...";
cd $ap;
for target in $apklist; do
  ui_print "   $target";
  apkname=$(basename $target .apk);

  # copy in target system file to patch
  sysfile=`find /system -mindepth 2 -name $target`;
  cp -fp $sysfile $ap;

  # file patches
  if [ -d $patch/$apkname ]; then
    mv $apkname.apk $apkname.zip;
    
    # delete unwanted files
    if [ -f $script/$apkname.sh ]; then
      ui_print "  Removing files...";
      . $script/$apkname.sh;
      for remove in $fileremove; do
        $bin/zip -d $apkname.zip $remove;
      done
    fi;
    
    # continue patching
    ui_print "  Inject files";
    cd $patch/$apkname;
    $bin/zip -r -9 $ap/$apkname.zip *;
    if [ -f resources.arsc ]; then
      $bin/zip -r -0 $ap/$apkname.zip resources.arsc;
    fi;
    cd $ap;
    mv $apkname.zip $apkname.apk;    
  fi;

  # zipalign updated file
  cp -f $target $apkname-preopt.apk;
  rm $target;
  $bin/zipalign -p 4 $apkname-preopt.apk $target;

  # copy patched file back to system
  cp_ch $ap/$target $UNITY$sysfile;
done;
ui_print " ";

# extra required non-patch changes
. $ap/extracmd.sh;

cd /
