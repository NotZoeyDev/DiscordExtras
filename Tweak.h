#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <mach/mach.h>
#import "discordExtras_daemonUser.h"

kern_return_t bootstrap_look_up(mach_port_t port, const char *service, mach_port_t *server_port);

#define BUNDLE_PATH @"/Library/Application Support/DiscordExtrasFiles.bundle"
#define CACHE_PATH [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/"]
#define HASHES_PATH [CACHE_PATH stringByAppendingString:@"/hashes.plist"]
#define PATCHED_PATH [CACHE_PATH stringByAppendingString:@"patched.jsbundle"]
#define PATCHES_FOLDER [BUNDLE_PATH stringByAppendingString:@"/patches"]