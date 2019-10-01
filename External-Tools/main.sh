# External Tools

chmod -R 0755 $TMPDIR/addon/External-Tools
if $IS64BIT; then
  [ -d $TMPDIR/addon/External-Tools/tools/arm64 ] && mv -f $TMPDIR/addon/External-Tools/tools/arm64/* $TMPDIR/addon/External-Tools/tools/arm
  [ -d $TMPDIR/addon/External-Tools/tools/x64 ] && mv -f $TMPDIR/addon/External-Tools/tools/x64/* $TMPDIR/addon/External-Tools/tools/x86
fi
cp -R $TMPDIR/addon/External-Tools/tools $UF 2>/dev/null
[ -d "$UF/tools/other" ] && PATH=$UF/tools/other:$PATH
