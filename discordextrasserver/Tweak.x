#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <RocketBootstrap/RocketBootstrap.h>
#import "NSTask.h"

@interface DiscordExtrasServer : NSObject {
	CPDistributedMessagingCenter * _messagingCenter;
}
@end

@implementation DiscordExtrasServer

	+(void)load {
		[self sharedInstance];
	}

	-(NSDictionary*)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary*) args {
		NSString *bundlePath = [args[@"bundlePath"] stringValue];
		NSString *patchedPath = [args[@"patchedPath"] stringValue];
		NSString *patchesPath = [args[@"patchesPath"] stringValue];

		NSTask *task = [[NSTask alloc] init];
		task.launchPath = @"/usr/bin/jsbundletools";
		task.arguments = @[
			@"-m",
			@"patch",
			@"-p",
			bundlePath,
			@"-d",
			patchesPath,
			@"-n",
			patchedPath
		];

		[task launch];
		[task waitUntilExit];

		int status = [task terminationStatus];

		NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

		if (status == 0) {
			result[@"success"] = @YES;
			result[@"path"] = patchedPath;
		} else {
			result[@"success"] = @NO;
		}

		return result;
	}

	+ (instancetype)sharedInstance {
		static dispatch_once_t once = 0;
		__strong static id sharedInstance = nil;
		dispatch_once(&once, ^{
			sharedInstance = [self new];
		});
		return sharedInstance;
	}

	- (instancetype)init {
		if ((self = [super init])) {
			_messagingCenter = [CPDistributedMessagingCenter centerNamed:@"moe.panties.discordextrasserver"];
			rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);

			[_messagingCenter runServerOnCurrentThread];
			[_messagingCenter registerForMessageName:@"applyPatches" target:self selector:@selector(handleMessageNamed:withUserInfo:)];
			NSLog(@"[DiscordExtrasServer] Server is running!");
		}

		return self;
	}

@end