#import "Tweak.h"

// Get hash for data file
NSString* getHashForFile(NSString *path) {
	NSData *data = [NSData dataWithContentsOfFile:path];
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
	CC_MD5([data bytes], (CC_LONG)data.length, md5Buffer);

	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", md5Buffer[i]];
	}

	return output;
}


// Clear the cached jsbundle files + the patched jsbundle file on startup
void clearPatches(NSString *patchedPath) {
	NSLog(@"[DiscordExtras] Clearing cached files.");

	if ([[NSFileManager defaultManager] fileExistsAtPath:patchedPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:patchedPath error:nil];
	}
}

// Check/save hashes and re-apply patches if needed
void checkHashes(NSString *jsbundleFile, NSString *patchedPath) {
	NSMutableDictionary *hashes = [NSMutableDictionary dictionary];

	if ([[NSFileManager defaultManager] fileExistsAtPath:HASHES_PATH]) {
		hashes = [[NSMutableDictionary alloc] initWithContentsOfFile:HASHES_PATH];
	}
	
	BOOL doClearPatches = false;

	// Check hash for bundle
	NSString *bundleHash = getHashForFile(jsbundleFile);
	NSString *savedBundleHash = [hashes objectForKey:@"bundleHash"];

	if (savedBundleHash) {
		if (![bundleHash isEqualToString:savedBundleHash]) {
			NSLog(@"[DiscordExtras] New bundle found.");
			[hashes setObject:bundleHash forKey:@"bundleHash"];
			doClearPatches = true;
		}
	} else {
		[hashes setObject:bundleHash forKey:@"bundleHash"];
		doClearPatches = true;
	}

	// Check for patches
	NSString *patchesHash = [[NSString alloc] init];
	NSString *savedPatchesHash = [hashes objectForKey:@"patchesHash"];
	NSArray *patches = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:PATCHES_FOLDER error:nil];

	for (NSString *patch in patches) {
		NSString *patchPath = [NSString stringWithFormat:@"%@/%@", PATCHES_FOLDER, patch];
		NSString *patchHash = getHashForFile(patchPath);
		patchesHash = [patchesHash stringByAppendingString:patchHash];
	}

	if (savedPatchesHash) {
		if (![patchesHash isEqualToString:savedPatchesHash]) {
			NSLog(@"[DiscordExtras] New patches found.");
			[hashes setObject:patchesHash forKey:@"patchesHash"];
			doClearPatches = true;
		}
	} else {
		[hashes setObject:patchesHash forKey:@"patchesHash"];
		doClearPatches = true;
	}

	BOOL success = [hashes writeToFile:HASHES_PATH atomically:YES];
	if (success) {
		NSLog(@"[DiscordExtras] Hashes were saved!");
	} else {
		NSLog(@"[DiscordExtras] Couldn't save hashed.");
	}

	if (doClearPatches) {
		clearPatches(patchedPath);
	}
}

// Create our patched bundle file and return the path to it
NSURL* createBundleFile(NSURL *originalBundle, NSString *patchedPath) {
	@try {
		mach_port_t server_port;
		kern_return_t err;
		if ((err = bootstrap_look_up(bootstrap_port, "lh:moe.panties.discordextras", &server_port)) != KERN_SUCCESS){
			NSLog(@"[DiscordExtras] Failed to get server: %s", mach_error_string(err));
			return originalBundle;
		}

		err = dex_discordExtras_patch(server_port,
			(unsigned char *)[originalBundle.path UTF8String],
			[originalBundle.path length],
			(unsigned char *)[patchedPath UTF8String],
			[patchedPath length],
			(unsigned char *)[PATCHES_FOLDER UTF8String],
			[PATCHES_FOLDER length]);

		if (err != KERN_SUCCESS) {
			NSLog(@"[DiscordExtras] Error creating patched jsbundle, using default one instead.");
			return originalBundle;
		}

		NSLog(@"[DiscordExtras] Patched jsbundle was created!");
		return [[NSURL alloc] initFileURLWithPath:patchedPath];
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
	NSString *patchedPath = [[jsBundlePath.path stringByDeletingLastPathComponent] stringByAppendingString:@"/patched.jsbundle"];
	
	checkHashes(jsBundlePath.path, patchedPath);

	if ([[NSFileManager defaultManager] fileExistsAtPath:patchedPath]) {
		NSLog(@"[DiscordExtras] Patched jsbundle found, using existing bundle.");
		patchedBundlePath = [[NSURL alloc] initFileURLWithPath:patchedPath];
	} else {
		NSLog(@"[DiscordExtras] Patched jsbundle not found, creating one!");
		patchedBundlePath = createBundleFile(jsBundlePath, patchedPath);
	}

	return patchedBundlePath;
}

%end