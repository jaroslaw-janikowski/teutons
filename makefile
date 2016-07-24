JAVA_HOME = C:/Program Files/Java/jdk1.6.0_26
ANDROID_HOME = C:/Program Files/Android/android-sdk
DEV_HOME = C:/Users/johnd/dev/AndroidTest

build: compile make_apt sign_apt align_apt

compile:
	ANDROID_HOME/platform-tools/aapt package -v -f -m -S DEV_HOME/res -J DEV_HOME/src -M DEV_HOME/AndroidManifest.xml -I ANDROID_HOME/platforms/android-7/android.jar
	JAVA_HOME/bin/javac -verbose -d DEV_HOME/obj -classpath ANDROID_HOME/platforms/android-7/android.jar;DEV_HOME/obj -sourcepath DEV_HOME/src DEV_HOME/src/com/mycompany/package1/*.java
	ANDROID_HOME/platform-tools/dx --dex --verbose --output=DEV_HOME/bin/classes.dex DEV_HOME/obj DEV_HOME/lib

make_apt:
	ANDROID_HOME/platform-tools/aapt package -v -f -M DEV_HOME/AndroidManifest.xml -S DEV_HOME/res -I ANDROID_HOME/platforms/android-7/android.jar -F DEV_HOME/bin/AndroidTest.unsigned.apk DEV_HOME/bin

sign_apt:
	JAVA_HOME/bin/jarsigner -verbose -keystore DEV_HOME/AndroidTest.keystore -storepass password -keypass password -signedjar DEV_HOME/bin/AndroidTest.signed.apk DEV_HOME/bin/AndroidTest.unsigned.apk AndroidTestKey

align_apt:
	ANDROID_HOME/tools/zipalign -v -f 4 DEV_HOME/bin/AndroidTest.signed.apk DEV_HOME/bin/AndroidTest.apk

install_in_emulator:
	ANDROID_HOME/platform-tools/adb shell rm /data/app/com.mycompany.package1.apk
	ANDROID_HOME/platform-tools/adb -e install DEV_HOME/bin/AndroidTest.apk
