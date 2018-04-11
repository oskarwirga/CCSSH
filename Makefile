ARCHS = arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCSSH
CCSSH_FRAMEWORKS = UIKit 
CCSSH_FILES = Tweak.xm
#CCSSH_CODESIGN_FLAGS = -Sentitlements.xml
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "cd /Applications/SSHAdmin.app; ldid -Sentitlements.xml SSHAdmin; chmod 6755 SSHAdmin;killall -9 SpringBoard"

SUBPROJECTS += ccsshToggle
SUBPROJECTS += ccsshprefs
SUBPROJECTS += sshadminapp

include $(THEOS_MAKE_PATH)/aggregate.mk
