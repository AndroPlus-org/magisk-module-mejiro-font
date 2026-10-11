#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

APILEVEL=$(getprop ro.build.version.sdk)

#Mejiro variable font (wght 100-800)
FONT=Mejiro-VF.ttf

if [ -e $MODDIR/system/fonts/disable-extra-weights ] ; then
	WEIGHTS="300 400 500 600 700"
else
	WEIGHTS="100 200 300 400 500 600 700 800"
fi

#Font file name with wght axis (for replacing static fonts)
mejiro() {
	echo "$FONT<axis tag=\"wght\" stylevalue=\"$1\" />"
}

#Font entries of ja family
ja_fonts() {
	local fallback=$1
	local attr=""
	if [ $APILEVEL -ge 31 ] ; then
		#Android 12 and later
		attr=" postScriptName=\"NotoSansCJKjp-Regular\""
	fi
	if [ -n "$fallback" ] ; then
		attr="$attr fallbackFor=\"$fallback\""
	fi
	for w in $WEIGHTS ; do
		printf '        <font weight="%s" style="normal"%s>%s</font>\\n' $w "$attr" "$(mejiro $w)"
	done
}

#Function to remove original ja
remove_ja() {
	sed -i -e '/<family lang="ja"/,/<\/family>/d' $1
}

#Function to add ja above zh-Hans
add_ja() {
	local ja="<family lang=\"ja\">\\n$(ja_fonts)$(ja_fonts serif)    </family>\\n    <family lang=\"zh-Hans\""
	sed -i "s@<family lang=\"zh-Hans\"@$ja@g" $1
}

#Function to replace Google Sans
replace_gsans() {
	sed -i 's@GoogleSans-Italic.ttf@GoogleSans-Regular.ttf\n      <axis tag="ital" stylevalue="1" />@g' $1
}

#Change fonts.xml / font_fallback.xml
patch_fonts_xml() {
	local xml=$1

	remove_ja $xml
	add_ja $xml

	#Goodbye, SomcUDGothic
	sed -i 's@SomcUDGothic-Light.ttf@null.ttf@g' $xml
	sed -i 's@SomcUDGothic-Regular.ttf@null.ttf@g' $xml

	#Goodbye, OnePlus Font
	sed -i 's@OpFont-@Roboto-@g' $xml
	sed -i 's@NotoSerif-@Roboto-@g' $xml

	#Goodbye, OPLUS Font
	if [ -f /system/fonts/SysSans-En-Regular.ttf ]; then
		sed -i 's@SysSans-En-Regular@Roboto-Regular@g' $xml
	fi

	#Goodbye, Xiaomi Font
	/system/bin/sed -i -z 's@<family name="sans-serif">\n    <!-- # MIUI Edit Start -->.*<!-- # MIUI Edit END -->@<family name="sans-serif">@' $xml
	sed -i 's@MiSansVF.ttf@Roboto-Regular.ttf@g' $xml
	#For MIUI 13+
	sed -i 's@MiSansVF_Overlay.ttf@Roboto-Regular.ttf@g' $xml

	#Goodbye, vivo Font
	sed -i "s@VivoFont.ttf@$FONT@g" $xml
	sed -i "s@DroidSansFallbackBBK.ttf@$FONT@g" $xml

	#Goodbye, Sansita Font
	sed -i 's@Sansita-@Roboto-@g' $xml
}

mkdir -p $MODDIR/system/etc $MODDIR/system/system_ext/etc $MODDIR/system/product/etc

#Copy original fonts.xml to the MODDIR to overwrite dummy file
cp /system/etc/fonts.xml $MODDIR/system/etc
patch_fonts_xml $MODDIR/system/etc/fonts.xml

#Android 15 and later read font_fallback.xml instead of fonts.xml.
#Patch the original one because fonts.xml may lack the latest font settings.
if [ -e /system/etc/font_fallback.xml ]; then
	cp /system/etc/font_fallback.xml $MODDIR/system/etc
	patch_fonts_xml $MODDIR/system/etc/font_fallback.xml
fi

gsans=/system/product/etc/fonts_customization.xml
if [ -e $gsans ]; then
	cp $gsans $MODDIR$gsans
	replace_gsans $MODDIR$gsans
fi

#Goodbye, OPLUS Font
if [ -f /system/fonts/SysFont-Regular.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/SysFont-Regular.ttf
fi
if [ -f /system/fonts/SysFont-Static-Regular.ttf ]; then
	cp /system/fonts/RobotoStatic-Regular.ttf $MODDIR/system/fonts/SysFont-Static-Regular.ttf
fi
if [ -f /system/fonts/SysSans-En-Regular.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/SysSans-En-Regular.ttf
fi

#Goodbye, Xiaomi Font
if [ -e /system/fonts/MiSansVF.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/MiSansVF.ttf
fi
#For MIUI 13+
if [ -e /system/fonts/MiSansVF_Overlay.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/MiSansVF_Overlay.ttf
fi
#For HyperOS CN 1.0
if [ -e /system/fonts/MiSansTCVF.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/MiSansTCVF.ttf
fi
if [ -e /system/product/fonts/MiSansTCVF.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/product/fonts/MiSansTCVF.ttf
fi

#Goodbye, vivo Font
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

#Copy fonts_slate.xml for OnePlus
opslate=fonts_slate.xml
if [ -e /system/etc/$opslate ]; then
    cp /system/etc/$opslate $MODDIR/system/etc

	#Change fonts_slate.xml file
	remove_ja $MODDIR/system/etc/$opslate
	add_ja $MODDIR/system/etc/$opslate

	sed -i "s@SlateForOnePlus-Thin.ttf@$(mejiro 300)@g" $MODDIR/system/etc/$opslate
	sed -i "s@SlateForOnePlus-Light.ttf@$(mejiro 300)@g" $MODDIR/system/etc/$opslate
	sed -i "s@SlateForOnePlus-Book.ttf@$(mejiro 400)@g" $MODDIR/system/etc/$opslate
	sed -i "s@SlateForOnePlus-Regular.ttf@$(mejiro 400)@g" $MODDIR/system/etc/$opslate
	sed -i "s@SlateForOnePlus-Medium.ttf@$(mejiro 500)@g" $MODDIR/system/etc/$opslate
	sed -i "s@SlateForOnePlus-Bold.ttf@$(mejiro 700)@g" $MODDIR/system/etc/$opslate
	sed -i "s@SlateForOnePlus-Black.ttf@$(mejiro 800)@g" $MODDIR/system/etc/$opslate
fi

#Copy fonts_base.xml for OnePlus OxygenOS 11
oos11=fonts_base.xml
if [ -e /system/etc/$oos11 ]; then
    cp /system/etc/$oos11 $MODDIR/system/etc

	#Change fonts_base.xml file
	remove_ja $MODDIR/system/etc/$oos11
	add_ja $MODDIR/system/etc/$oos11

	sed -i 's@NotoSerif-@Roboto-@g' $MODDIR/system/etc/$oos11
fi

#Copy fonts_base.xml for OnePlus OxygenOS 12+
oos12=fonts_base.xml
if [ -e /system/system_ext/etc/$oos12 ]; then
    cp /system/system_ext/etc/$oos12 $MODDIR/system/system_ext/etc

	#Change fonts_base.xml file
	remove_ja $MODDIR/system/system_ext/etc/$oos12
	add_ja $MODDIR/system/system_ext/etc/$oos12

	sed -i 's@SysSans-En-Regular@Roboto-Regular@g' $MODDIR/system/system_ext/etc/$oos12
	sed -i 's@NotoSerif-@Roboto-@g' $MODDIR/system/system_ext/etc/$oos12
fi

#Function to replace OPLUS fonts in fonts_customization.xml
replace_oplus() {
	local xml=$1
	#File names (with wght axis)
	sed -i "s@OplusSansText-25Th.ttf@$(mejiro 300)@g" $xml
	sed -i "s@OplusSansText-35ExLt.ttf@$(mejiro 300)@g" $xml
	sed -i "s@OplusSansText-45Lt.ttf@$(mejiro 300)@g" $xml
	sed -i "s@OplusSansText-55Rg.ttf@$(mejiro 400)@g" $xml
	sed -i "s@OplusSansText-65Md.ttf@$(mejiro 600)@g" $xml
	sed -i "s@NHGMYHOplusHK-W4.ttf@$(mejiro 400)@g" $xml
	sed -i "s@NHGMYHOplusPRC-W4.ttf@$(mejiro 400)@g" $xml
	sed -i "s@OplusSansDisplay-45Lt.ttf@$(mejiro 300)@g" $xml
	#Other references (e.g. postScriptName)
	sed -i 's@OplusSansText-25Th@Mejiro-Light@g' $xml
	sed -i 's@OplusSansText-35ExLt@Mejiro-Light@g' $xml
	sed -i 's@OplusSansText-45Lt@Mejiro-Light@g' $xml
	sed -i 's@OplusSansText-55Rg@Mejiro-Regular@g' $xml
	sed -i 's@OplusSansText-65Md@Mejiro-Semibold@g' $xml
	sed -i 's@NHGMYHOplusHK-W4@Mejiro-Regular@g' $xml
	sed -i 's@NHGMYHOplusPRC-W4@Mejiro-Regular@g' $xml
	sed -i 's@OplusSansDisplay-45Lt@Mejiro-Light@g' $xml
}

#Copy fonts_customization.xml for OnePlus OxygenOS 12+
oos12c=fonts_customization.xml
if [ -e /system/system_ext/etc/$oos12c ]; then
    cp /system/system_ext/etc/$oos12c $MODDIR/system/system_ext/etc
	replace_oplus $MODDIR/system/system_ext/etc/$oos12c
fi

#Copy fonts_customization.xml for OnePlus OxygenOS 12+
oos12p=fonts_customization.xml
if [ -e /system/product/etc/$oos12p ]; then
	if [ ! -e $MODDIR/system/product/etc/$oos12p ]; then
		cp /system/product/etc/$oos12p $MODDIR/system/product/etc
	fi
	replace_oplus $MODDIR/system/product/etc/$oos12p
fi
