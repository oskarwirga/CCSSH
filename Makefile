ARCHS = arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCSSH
CCSSH_FRAMEWORKS = UIKit 
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "cd /Applications/SSHAdmin.app; ldid -Sentitlements.xml SSHAdmin; chmod 6755 SSHAdmin; chmod 755 Info.plist;uicache;killall -9 SpringBoard"

SUBPROJECTS += ccsshToggle
SUBPROJECTS += ccsshprefs
SUBPROJECTS += sshadminapp

include $(THEOS_MAKE_PATH)/aggregate.mk
