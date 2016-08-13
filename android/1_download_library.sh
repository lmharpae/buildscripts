#!/bin/bash

# abort on errors
set -e

# Supported os : "darwin" or "linux"
os=`uname`
darwin="Darwin"
linux="Linux"

if [ $os = $darwin ] ; then
	echo "Darwin detected"
	brew install hg
	brew install autoconf
fi

export WORKSPACE=$PWD

# helper
function msg {
  echo ""
  echo $1
}

function download_and_extract {
	url=$1
	file=${url##*/}

	msg "Downloading and extracting $file..."

	wget -nv -N $url
	tar xf $file
}

# prepare toolchain

msg " [1] Installing Android SDK"
rm -rf android-sdk/
# Linux
if [ $os = $linux ]; then
	download_and_extract http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
	mv android-sdk-linux android-sdk
# Mac
elif [ $os = $darwin ]; then
	download_and_extract http://dl.google.com/android/android-sdk_r24.4.1-macosx.zip
	mv android-sdk-macosx android-sdk
else
	msg "Your platform is unsupported!"
	exit 1
fi

PATH=$PATH:$WORKSPACE/android-sdk/tools

msg " [2] Installing SDK and Platform-tools"
# Android SDK Build-tools, revision 23.0.2
echo "y" | android update sdk -u -a -t build-tools-23.0.2
# Android SDK Platform-tools
echo "y" | android update sdk -u -a -t platform-tools
# SDK Platform Android 3.1, API 12
echo "y" | android update sdk -u -a -t android-12
# Android SDK Platform 23, API 23
echo "y" | android update sdk -u -a -t android-23
# Android Support Library
echo "y" | android update sdk -u -a -t extra-android-support
# Android Support Library Repository
echo "y" | android update sdk -u -a -t extra-android-m2repository
# Google Repository
echo "y" | android update sdk -u -a -t extra-google-m2repository


msg " [3] Android NDK"
rm -rf android-ndk-r10e/
# Linux
if [ $os = $linux ] ; then
	wget -nv -N http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin
	chmod u+x android-ndk-r10e-linux-x86_64.bin
	./android-ndk-r10e-linux-x86_64.bin
# Mac
elif [ $os = $darwin ] ; then
	wget -nv -N http://dl.google.com/android/ndk/android-ndk-r10e-darwin-x86_64.bin
	chmod u+x android-ndk-r10e-darwin-x86_64.bin
	./android-ndk-r10e-darwin-x86_64.bin
fi

msg " [4] preparing libraries"

# libpng
rm -rf libpng-1.6.23/
download_and_extract http://prdownloads.sourceforge.net/libpng/libpng-1.6.23.tar.xz

# freetype
rm -rf freetype-2.6.3/
download_and_extract http://download.savannah.gnu.org/releases/freetype/freetype-2.6.3.tar.bz2

# harfbuzz
rm -rf harfbuzz-1.2.3/
download_and_extract http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.2.3.tar.bz2

# pixman
rm -rf pixman-0.34.0/
download_and_extract http://cairographics.org/releases/pixman-0.34.0.tar.gz

# libogg
rm -rf libogg-1.3.2/
download_and_extract http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.xz

# libvorbis
rm -rf libvorbis-1.3.5/
download_and_extract http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz

# libmodplug
rm -rf libmodplug-0.8.8.5/
download_and_extract http://sourceforge.net/projects/modplug-xmms/files/libmodplug/0.8.8.5/libmodplug-0.8.8.5.tar.gz

# mpg123
rm -rf mpg123-1.23.4
download_and_extract http://www.mpg123.de/download/mpg123-1.23.4.tar.bz2

# libsndfile
rm -rf libsndfile-1.0.27
download_and_extract http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.27.tar.gz

# speexdsp
rm -rf speexdsp-1.2rc3 
download_and_extract http://downloads.xiph.org/releases/speex/speexdsp-1.2rc3.tar.gz

msg "Cloning SDL2"
rm -rf SDL/
hg clone http://hg.libsdl.org/SDL

msg "Cloning SDL2_mixer"
rm -rf SDL_mixer/
hg clone http://hg.libsdl.org/SDL_mixer

# ICU
rm -rf icu
download_and_extract http://download.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.tgz

# icudata
rm -f icudt*.dat
download_and_extract https://easy-rpg.org/jenkins/job/icudata/lastSuccessfulBuild/artifact/icu/source/data/out/icudata.tar.gz
