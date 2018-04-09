include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = SSHAdmin
SSHAdmin_FILES = main.m AppDelegate.m ViewController.m
SSHAdmin_FRAMEWORKS = UIKit CoreGraphics
SSHAdmin_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"SSHAdmin\"" || true
