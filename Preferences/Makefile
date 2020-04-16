ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CustomAutoLockIntervalPrefs
CustomAutoLockIntervalPrefs_FILES = CLIAppearanceSettings.m CLIRootHeaderView.mm CLIRootListController.xm
CustomAutoLockIntervalPrefs_INSTALL_PATH = /Library/PreferenceBundles
CustomAutoLockIntervalPrefs_FRAMEWORKS = UIKit
CustomAutoLockIntervalPrefs_PRIVATE_FRAMEWORKS = Preferences
CustomAutoLockIntervalPrefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
CustomAutoLockIntervalPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CustomAutoLockIntervalPrefs.plist$(ECHO_END)
