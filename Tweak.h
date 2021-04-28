#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <RocketBootstrap/RocketBootstrap.h>
#import <CommonCrypto/CommonDigest.h>

#define BUNDLE_PATH @"/Library/Application Support/DiscordExtrasFiles.bundle"
#define CACHE_PATH [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/"]
#define HASHES_PATH [CACHE_PATH stringByAppendingString:@"/hashes.plist"]
#define PATCHED_PATH [CACHE_PATH stringByAppendingString:@"patched.jsbundle"]
#define PATCHES_FOLDER [BUNDLE_PATH stringByAppendingString:@"/patches"]