#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

APILEVEL=$(getprop ro.build.version.sdk)

#Copy original fonts.xml to the MODDIR to overwrite dummy file
mkdir -p $MODDIR/system/etc $MODDIR/system/system_ext/etc $MODDIR/system/product/etc
cp /system/etc/fonts.xml $MODDIR/system/etc

#Function to remove original ja
remove_ja() {
  sed -i -e '/<family lang="ja"/,/<\/family>/d' $1
}

#Function to add ja above zh-Hans
add_ja() {
	if [ -e $MODDIR/system/fonts/disable-extra-weights ] ; then
		if [ $APILEVEL -ge 31 ] ; then
			#Android 12 and later
			sed -i 's@<family lang="zh-Hans">@<family lang="ja">\n        <font weight="300" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Bold.ttf</font>\n        <font weight="300" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Bold.ttf</font>\n    </family>\n    <family lang="zh-Hans">@g' $1
		else
			sed -i 's@<family lang="zh-Hans">@<family lang="ja">\n        <font weight="300" style="normal">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal">Mejiro-Bold.ttf</font>\n        <font weight="300" style="normal" fallbackFor="serif">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" fallbackFor="serif">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" fallbackFor="serif">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" fallbackFor="serif">Mejiro-Bold.ttf</font>\n    </family>\n    <family lang="zh-Hans">@g' $1
		fi
	else
		if [ $APILEVEL -ge 31 ] ; then
			#Android 12 and later
			sed -i 's@<family lang="zh-Hans">@<family lang="ja">\n        <font weight="100" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Thin.ttf</font>\n        <font weight="300" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Bold.ttf</font>\n        <font weight="800" style="normal" postScriptName="NotoSansCJKjp-Regular">Mejiro-Extrabold.ttf</font>\n        <font weight="100" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Thin.ttf</font>\n        <font weight="300" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Bold.ttf</font>\n        <font weight="800" style="normal" postScriptName="NotoSansCJKjp-Regular" fallbackFor="serif">Mejiro-Extrabold.ttf</font>\n    </family>\n    <family lang="zh-Hans">@g' $1
		else
			sed -i 's@<family lang="zh-Hans">@<family lang="ja">\n        <font weight="100" style="normal">Mejiro-Thin.ttf</font>\n        <font weight="300" style="normal">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal">Mejiro-Bold.ttf</font>\n        <font weight="800" style="normal">Mejiro-Extrabold.ttf</font>\n        <font weight="100" style="normal" fallbackFor="serif">Mejiro-Thin.ttf</font>\n        <font weight="300" style="normal" fallbackFor="serif">Mejiro-Light.ttf</font>\n        <font weight="400" style="normal" fallbackFor="serif">Mejiro-Regular.ttf</font>\n        <font weight="600" style="normal" fallbackFor="serif">Mejiro-Semibold.ttf</font>\n        <font weight="700" style="normal" fallbackFor="serif">Mejiro-Bold.ttf</font>\n        <font weight="800" style="normal" fallbackFor="serif">Mejiro-Extrabold.ttf</font>\n    </family>\n    <family lang="zh-Hans">@g' $1
		fi
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

#Goodbye, OPLUS Font
if [ -f /system/fonts/SysFont-Regular.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/SysFont-Regular.ttf
fi
if [ -f /system/fonts/SysFont-Static-Regular.ttf ]; then
	cp /system/fonts/RobotoStatic-Regular.ttf $MODDIR/system/fonts/SysFont-Static-Regular.ttf
fi
if [ -f /system/fonts/SysSans-En-Regular.ttf ]; then
	sed -i 's@SysSans-En-Regular@Roboto-Regular@g' $MODDIR/system/etc/fonts.xml
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/SysSans-En-Regular.ttf
fi

#Goodbye, Xiaomi Font
/system/bin/sed -i -z 's@<family name="sans-serif">\n    <!-- # MIUI Edit Start -->.*<!-- # MIUI Edit END -->@<family name="sans-serif">@' $MODDIR/system/etc/fonts.xml
sed -i 's@MiSansVF.ttf@Roboto-Regular.ttf@g' $MODDIR/system/etc/fonts.xml
if [ -e /system/fonts/MiSansVF.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/MiSansVF.ttf
fi
#For MIUI 13+
sed -i 's@MiSansVF_Overlay.ttf@Roboto-Regular.ttf@g' $MODDIR/system/etc/fonts.xml
if [ -e /system/fonts/MiSansVF_Overlay.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/MiSansVF_Overlay.ttf
fi
#For HyperOS CN 1.0
if [ -e /system/product/fonts/MiSansTCVF.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/product/fonts/MiSansTCVF.ttf
fi

#Goodbye, vivo Font
sed -i 's@VivoFont.ttf@Mejiro-Regular.ttf@g' $MODDIR/system/etc/fonts.xml
sed -i 's@DroidSansFallbackBBK.ttf@Mejiro-Regular.ttf@g' $MODDIR/system/etc/fonts.xml
if [ -e /system/fonts/HYQiHei-50.ttf ]; then
cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/HYQiHei-50.ttf
fi
if [ -e /system/fonts/DroidSansFallbackBBK.ttf ]; then
cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/DroidSansFallbackBBK.ttf
fi
if [ -e /system/fonts/DroidSansFallbackMonster.ttf ]; then
cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/DroidSansFallbackMonster.ttf
fi
if [ -e /system/fonts/DroidSansFallbackZW.ttf ]; then
cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/DroidSansFallbackZW.ttf
fi

#Goodbye, Sansita Font
sed -i 's@Sansita-@Roboto-@g' $MODDIR/system/etc/fonts.xml

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

#Copy fonts_base.xml for OnePlus OxygenOS 11
oos11=fonts_base.xml
if [ -e /system/etc/$oos11 ]; then
    cp /system/etc/$oos11 $MODDIR/system/etc
	
	#Change fonts_slate.xml file
	remove_ja $MODDIR/system/etc/$oos11
	add_ja $MODDIR/system/etc/$oos11

	sed -i 's@NotoSerif-@Roboto-@g' $MODDIR/system/etc/$oos11
fi

#Copy fonts_base.xml for OnePlus OxygenOS 12+
oos12=fonts_base.xml
if [ -e /system/system_ext/etc/$oos12 ]; then
    cp /system/system_ext/etc/$oos12 $MODDIR/system/system_ext/etc
	
	#Change fonts_slate.xml file
	remove_ja $MODDIR/system/system_ext/etc/$oos12
	add_ja $MODDIR/system/system_ext/etc/$oos12

	sed -i 's@SysSans-En-Regular@Roboto-Regular@g' $MODDIR/system/system_ext/etc/$oos12
	sed -i 's@NotoSerif-@Roboto-@g' $MODDIR/system/system_ext/etc/$oos12
fi

#Copy fonts_customization.xml for OnePlus OxygenOS 12+
oos12c=fonts_customization.xml
if [ -e /system/system_ext/etc/$oos12c ]; then
    cp /system/system_ext/etc/$oos12c $MODDIR/system/system_ext/etc
	sed -i 's@OplusSansText-25Th@Mejiro-Light@g' $MODDIR/system/system_ext/etc/$oos12c
	sed -i 's@OplusSansText-35ExLt@Mejiro-Light@g' $MODDIR/system/system_ext/etc/$oos12c
	sed -i 's@OplusSansText-45Lt@Mejiro-Light@g' $MODDIR/system/system_ext/etc/$oos12c
	sed -i 's@OplusSansText-55Rg@Mejiro-Regular@g' $MODDIR/system/system_ext/etc/$oos12c
	sed -i 's@OplusSansText-65Md@Mejiro-Semibold@g' $MODDIR/system/system_ext/etc/$oos12c
	sed -i 's@NHGMYHOplusHK-W4@Mejiro-Regular@g' $MODDIR/system/system_ext/etc/$oos12c
	sed -i 's@NHGMYHOplusPRC-W4@Mejiro-Regular@g' $MODDIR/system/system_ext/etc/$oos12c
	sed -i 's@OplusSansDisplay-45Lt@Mejiro-Light@g' $MODDIR/system/system_ext/etc/$oos12c
fi

#Copy fonts_customization.xml for OnePlus OxygenOS 12+
oos12p=fonts_customization.xml
if [ -e /system/product/etc/$oos12p ]; then
    cp /system/product/etc/$oos12p $MODDIR/system/product/etc
	sed -i 's@OplusSansText-25Th@Mejiro-Light@g' $MODDIR/system/product/etc/$oos12p
	sed -i 's@OplusSansText-35ExLt@Mejiro-Light@g' $MODDIR/system/product/etc/$oos12p
	sed -i 's@OplusSansText-45Lt@Mejiro-Light@g' $MODDIR/system/product/etc/$oos12p
	sed -i 's@OplusSansText-55Rg@Mejiro-Regular@g' $MODDIR/system/product/etc/$oos12p
	sed -i 's@OplusSansText-65Md@Mejiro-Semibold@g' $MODDIR/system/product/etc/$oos12p
	sed -i 's@NHGMYHOplusHK-W4@Mejiro-Regular@g' $MODDIR/system/product/etc/$oos12p
	sed -i 's@NHGMYHOplusPRC-W4@Mejiro-Regular@g' $MODDIR/system/product/etc/$oos12p
	sed -i 's@OplusSansDisplay-45Lt@Mejiro-Light@g' $MODDIR/system/product/etc/$oos12p
fi