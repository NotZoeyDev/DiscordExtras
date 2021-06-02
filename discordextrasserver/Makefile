ARCHS := arm64

include $(THEOS)/makefiles/common.mk

TOOL_NAME = DiscordExtrasServer

DiscordExtrasServer_FILES = discordExtras_helperServer.c main.m ../Utils.x
DiscordExtrasServer_CFLAGS = -fobjc-arc
DiscordExtrasServer_CODESIGN_FLAGS = -SEnt.plist

include $(THEOS_MAKE_PATH)/tool.mk
