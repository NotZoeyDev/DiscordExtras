ARCHS := arm64 arm64e
TARGET := iphone:clang:latest:12.4
INSTALL_TARGET_PROCESSES = Discord

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DiscordExtras
$(TWEAK_NAME)_FRAMEWORKS = UIKit coregraphics
$(TWEAK_NAME)_FILES = Tweak.x Utils.x discordExtras_helperUser.c
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

BUNDLE_NAME = DiscordExtrasFiles
$(BUNDLE_NAME)_INSTALL_PATH = /Library/Application Support

SUBPROJECTS += jsbundletools

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

SUBPROJECTS += discordextrasserver
include $(THEOS_MAKE_PATH)/aggregate.mk
