#import <Foundation/Foundation.h>
#import <MRYIPCCenter.h>
#import "NSTask.h"

@interface DiscordExtrasServer : NSObject
@end

@implementation DiscordExtrasServer {
		MRYIPCCenter* _server;
	}

	+(void)load {
		[self sharedInstance];
	}

	-(NSString*)executeJSbundleTools:(NSDictionary*)args {
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

		if (status == 0) {
			return patchedPath;
		}

		return @"error";
	}

	+(instancetype)sharedInstance {
		static dispatch_once_t onceToken = 0;
		__strong static DiscordExtrasServer* sharedInstance = nil;

		dispatch_once(&onceToken, ^{
			sharedInstance = [[self alloc] init];
		});

		return sharedInstance;
	}

	-(instancetype)init {
		if ((self = [super init])) {
			_server = [MRYIPCCenter centerNamed:@"moe.panties.discordextrasserver"];
			[_server addTarget:self action:@selector(executeJSbundleTools:)];
			NSLog(@"[DiscordExtrasServer] Server is running!");
		}

		return self;
	}

@end