#ARCHS = armv7 armv7s arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCSSH
CCSSH_FRAMEWORKS = UIKit 
CCSSH_FILES = Tweak.xm
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += ccsshToggle
SUBPROJECTS += ccsshprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
