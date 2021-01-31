ANDROID_HOME = ~/apps/android-sdk-linux
DEV_HOME = ~/workspace/Teutons
SDK_VER = 24.0.0
APP_NAME = Teutons
APP_PACKAGE = com.bps.teutons

debug: compile make_apt sign_apt_debug
release: compile make_apt sign_apt_release align_apt

compile:
	$(ANDROID_HOME)/build-tools/$(SDK_VER)/aapt package -v -f -m -S $(DEV_HOME)/res -J $(DEV_HOME)/src -M $(DEV_HOME)/AndroidManifest.xml -I $(ANDROID_HOME)/platforms/android-23/android.jar
	java -jar $(ANDROID_HOME)/build-tools/$(SDK_VER)/jack.jar --classpath $(DEV_HOME)/lib/android.jar --output-dex $(DEV_HOME)/obj --import-resource $(DEV_HOME)/res $(DEV_HOME)/src/ $(DEV_HOME)/gen

make_apt:
	$(ANDROID_HOME)/build-tools/$(SDK_VER)/aapt package -v -f -M $(DEV_HOME)/AndroidManifest.xml -S $(DEV_HOME)/res -I $(ANDROID_HOME)/platforms/android-23/android.jar -F $(DEV_HOME)/bin/$(APP_NAME).unsigned.apk
	jar -uf $(DEV_HOME)/bin/$(APP_NAME).unsigned.apk -C $(DEV_HOME)/obj classes.dex

sign_apt_debug:
	jarsigner -verbose -keystore ~/.android/debug.keystore -storepass android -keypass android -signedjar $(DEV_HOME)/bin/Teutons.signed.apk $(DEV_HOME)/bin/$(APP_NAME).unsigned.apk AndroidDebugKey

sign_apt_release:
	jarsigner -verbose -keystore DEV_HOME/release.keystore -storepass password -keypass password -signedjar $(DEV_HOME)/bin/$(APP_NAME).signed.apk $(DEV_HOME)/bin/$(APP_NAME).unsigned.apk AndroidTestKey

align_apt:
	$(ANDROID_HOME)/tools/zipalign -v -f 4 $(DEV_HOME)/bin/$(APP_NAME).signed.apk $(DEV_HOME)/bin/$(APP_NAME).apk

install_in_emulator:
	$(ANDROID_HOME)/platform-tools/adb shell rm /data/app/$(APP_PACKAGE).apk
	$(ANDROID_HOME)/platform-tools/adb -e install $(DEV_HOME)/bin/$(APP_NAME).apk

do_jill:
	java -jar $(ANDROID_HOME)/build-tools/$(SDK_VER)/jill.jar --output $(DEV_HOME)/lib/android.jar $(ANDROID_HOME)/platforms/android-23/android.jar

clean:
	rm -rf $(DEV_HOME)/obj/*
	rm -rf $(DEV_HOME)/bin/*
	rm -rf $(DEV_HOME)/gen/*
	rm -rf $(DEV_HOME)/lib/*
