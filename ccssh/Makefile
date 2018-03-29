include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CCSSH
CCSSH_FILES = OW2RootListController.m
CCSSH_INSTALL_PATH = /Library/PreferenceBundles
CCSSH_FRAMEWORKS = UIKit
CCSSH_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CCSSH.plist$(ECHO_END)
