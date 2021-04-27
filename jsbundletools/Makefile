include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

ARCHS := arm64 arm64e

export GOOS=ios
export GOARCH=arm64
export CGO_ENABLED=1
export CC=$(shell go env GOROOT)/misc/ios/clangwrap.sh

all::
	go build -o jsbundletools main.go
	ldid -Sentitlements.plist jsbundletools
	mkdir -p layout/usr/bin
	cp jsbundletools layout/usr/bin

clean::
	rm -rf layout/usr/bin/jsbundletools