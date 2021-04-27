ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DiscordExtrasServer

DiscordExtrasServer_FILES = Tweak.x
DiscordExtrasServer_CFLAGS = -fobjc-arc
DiscordExtrasServer_LIBRARIES = rocketbootstrap
DiscordExtrasServer_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk
