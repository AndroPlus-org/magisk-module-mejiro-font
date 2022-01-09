#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

#Copy original fonts.xml to the MODDIR to overwrite dummy file
cp /system/etc/fonts.xml $MODDIR/system/etc

#Function to remove original ja
remove_ja() {
  sed -i -e '/<family lang="ja"/,/<\/family>/d' $1
}

#Function to add ja above zh-Hans
add_ja() {
	if [ $API -ge 31 ] ; then
		#Android 12 and later
		sed -i 's@<family lang="zh-Hans">@<family lang="ja">\n        <font weight="100" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Thin.ttf</font>\n        <font weight="300" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Bold.ttf</font>\n        <font weight="800" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Extrabold.ttf</font>\n        <font weight="100" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Thin.ttf</font>\n        <font weight="300" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Bold.ttf</font>\n        <font weight="800" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Extrabold.ttf</font>\n    </family>\n    <family lang="zh-Hans">@g' $1
	else
		sed -i 's@<family lang="zh-Hans">@<family lang="ja">\n        <font weight="100" style="normal">Mejiro-Thin.ttf</font>\n        <font weight="300" style="normal">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal">Mejiro-Bold.ttf</font>\n        <font weight="800" style="normal">Mejiro-Extrabold.ttf</font>\n        <font weight="100" style="normal" fallbackFor="serif">Mejiro-Thin.ttf</font>\n        <font weight="300" style="normal" fallbackFor="serif">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" fallbackFor="serif">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" fallbackFor="serif">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" fallbackFor="serif">Mejiro-Bold.ttf</font>\n        <font weight="800" style="normal" fallbackFor="serif">Mejiro-Extrabold.ttf</font>\n    </family>\n    <family lang="zh-Hans">@g' $1
	fi
}

#Function to replace Google Sans
replace_gsans() {
	sed -i 's@GoogleSans-Italic.ttf@GoogleSans-Regular.ttf\n      <axis tag="ital" stylevalue="1" />@g' $1
}

#Change fonts.xml file
remove_ja $MODDIR/system/etc/fonts.xml
add_ja $MODDIR/system/etc/fonts.xml

gsans=/system/product/etc/fonts_customization.xml
if [ -e $gsans ]; then
	cp $gsans $MODDIR$gsans
	replace_gsans $MODDIR$gsans
fi

#Goodbye, SomcUDGothic
sed -i 's@SomcUDGothic-Light.ttf@null.ttf@g' $MODDIR/system/etc/fonts.xml
sed -i 's@SomcUDGothic-Regular.ttf@null.ttf@g' $MODDIR/system/etc/fonts.xml

#Goodbye, OnePlus Font
sed -i 's@OpFont-@Roboto-@g' $MODDIR/system/etc/fonts.xml
sed -i 's@NotoSerif-@Roboto-@g' $MODDIR/system/etc/fonts.xml

#Goodbye, Xiaomi Font
sed -i 's@MiSansVF.ttf@Roboto-Regular.ttf@g' $MODDIR/system/etc/fonts.xml

#Copy fonts_slate.xml for OnePlus
opslate=fonts_slate.xml
if [ -e /system/etc/$opslate ]; then
    cp /system/etc/$opslate $MODDIR/system/etc
	
	#Change fonts_slate.xml file
	remove_ja $MODDIR/system/etc/$opslate
	add_ja $MODDIR/system/etc/$opslate

	sed -i 's@SlateForOnePlus-Thin.ttf@Mejiro-Light.ttf@g' $MODDIR/system/etc/$opslate
	sed -i 's@SlateForOnePlus-Light.ttf@Mejiro-Light.ttf@g' $MODDIR/system/etc/$opslate
	sed -i 's@SlateForOnePlus-Book.ttf@Mejiro-Regular.ttf@g' $MODDIR/system/etc/$opslate
	sed -i 's@SlateForOnePlus-Regular.ttf@Mejiro-Regular.ttf@g' $MODDIR/system/etc/$opslate
	sed -i 's@SlateForOnePlus-Medium.ttf@Mejiro-Semibold.ttf@g' $MODDIR/system/etc/$opslate
	sed -i 's@SlateForOnePlus-Bold.ttf@Mejiro-Bold.ttf@g' $MODDIR/system/etc/$opslate
	sed -i 's@SlateForOnePlus-Black.ttf@Mejiro-Extrabold.ttf@g' $MODDIR/system/etc/$opslate
fi

#Copy fonts_base.xml for OnePlus OxygenOS 11+
oos11=fonts_base.xml
if [ -e /system/etc/$oos11 ]; then
    cp /system/etc/$oos11 $MODDIR/system/etc
	
	#Change fonts_slate.xml file
	remove_ja $MODDIR/system/etc/$oos11
	add_ja $MODDIR/system/etc/$oos11

	sed -i 's@NotoSerif-@Roboto-@g' $MODDIR/system/etc/$oos11
fi