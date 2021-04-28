#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <RocketBootstrap/RocketBootstrap.h>

#define BUNDLE_PATH @"/Library/Application Support/DiscordExtrasFiles.bundle"
#define CACHE_PATH [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/"]
#define PATCHED_PATH [CACHE_PATH stringByAppendingString:@"patched.jsbundle"]
#define PATCHES_FOLDER [BUNDLE_PATH stringByAppendingString:@"/patches"]

// Clear the cached jsbundle files + the patched jsbundle file on startup
void clearPatches(NSString *patchedPath) {
	NSLog(@"[DiscordExtras] Clearing cached files.");

	if ([[NSFileManager defaultManager] fileExistsAtPath:patchedPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:patchedPath error:nil];
	}

	NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:CACHE_PATH error:NULL];

	for (NSString *file in files) {
		if ([file containsString:@"main.jsbundle."]||[file containsString:@"manifest.json."]) {
			[[NSFileManager defaultManager] removeItemAtPath:[CACHE_PATH stringByAppendingString:file] error:nil];
		}
	}
}

// Create our patched bundle file and return the path to it
NSURL* createBundleFile(NSURL *originalBundle, NSString *patchedPath) {
	@try {
		CPDistributedMessagingCenter* center = [CPDistributedMessagingCenter centerNamed:@"moe.panties.discordextrasserver"];
		rocketbootstrap_distributedmessagingcenter_apply(center);

		NSDictionary *result = [center sendMessageAndReceiveReplyName:@"applyPatches" userInfo:@{
			@"bundlePath": originalBundle.path,
			@"patchedPath": patchedPath,
			@"patchesPath": PATCHES_FOLDER
		}];

		if ([[result objectForKey:@"success"] isEqual:@NO]) {
			NSLog(@"[DiscordExtras] Error creating patched jsbundle, using default one instead.");
			return originalBundle;
		}

		NSLog(@"[DiscordExtras] Patched jsbundle was created!");
		return [[NSURL alloc] initFileURLWithPath:[result objectForKey:@"path"]];
	} @catch(NSException *exception) {
		NSLog(@"[DiscordExtras] Something went really fucking wrong.");
		return originalBundle;
	}
}

%hook AppDelegate

- (id)sourceURLForBridge:(id)arg1 {
	id original = %orig;

	NSURL *jsBundlePath = original;
	NSURL *patchedBundlePath;
	NSString *patchedPath = [[jsBundlePath.path stringByDeletingLastPathComponent] stringByAppendingString:@"patched.jsbundle"];

	NSLog(@"[DiscordExtras] Original path: %@", jsBundlePath.path);
	NSLog(@"[DiscordExtras] Patched path: %@", patchedPath);

	clearPatches(patchedPath);

	if ([[NSFileManager defaultManager] fileExistsAtPath:patchedPath]) {
		NSLog(@"[DiscordExtras] Patched jsbundle found, using existing bundle.");
		patchedBundlePath = [[NSURL alloc] initFileURLWithPath:patchedPath];
	} else {
		NSLog(@"[DiscordExtras] Patched jsbundle not found, creating one!");
		patchedBundlePath = createBundleFile(jsBundlePath, patchedPath);
	}

	NSLog(@"[DiscordExtras] Loading bundle: %@", patchedBundlePath);

	return patchedBundlePath;
}

%end