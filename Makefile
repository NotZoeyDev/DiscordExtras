ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard Discord

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DiscordExtras
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_LIBRARIES = colorpicker rocketbootstrap
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = AppSupport
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

BUNDLE_NAME = DiscordExtrasFiles
$(BUNDLE_NAME)_INSTALL_PATH = /Library/Application Support

SUBPROJECTS += jsbundletools

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

SUBPROJECTS += discordextrasprefs
SUBPROJECTS += discordextrasserver
include $(THEOS_MAKE_PATH)/aggregate.mk
