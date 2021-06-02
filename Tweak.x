#import "Tweak.h"
#import "Utils.h"

// Check/save hashes and re-apply patches if needed
BOOL checkHashes(NSString *jsbundleFile, NSString *patchedPath) {
	NSMutableDictionary *hashes = [NSMutableDictionary dictionary];

	if ([[NSFileManager defaultManager] fileExistsAtPath:HASHES_PATH]) {
		hashes = [[NSMutableDictionary alloc] initWithContentsOfFile:HASHES_PATH];
	}
	
	BOOL doClearPatches = false;

	// Check hash for bundle
	NSString *bundleHash = getHashForFile(jsbundleFile);
	NSString *savedBundleHash = [hashes objectForKey:@"bundleHash"];

#ifndef NDEBUG
	NSLog(@"[DE] bundleHash: %@", bundleHash);
#endif

	if (savedBundleHash) {
		if (![bundleHash isEqualToString:savedBundleHash]) {
			NSLog(@"[DE] New bundle found");
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
	NSArray* patches = getPatches();

	for (NSString *patch in patches) {
		NSString *patchPath = [NSString stringWithFormat:@"%@/%@", PATCHES_FOLDER, patch];
		NSString *patchHash = getHashForFile(patchPath);
		patchesHash = [patchesHash stringByAppendingString:patchHash];
	}

#ifndef NDEBUG
	NSLog(@"[DE] patchesHash: %@", patchesHash);
#endif

	if (savedPatchesHash) {
		if (![patchesHash isEqualToString:savedPatchesHash]) {
			NSLog(@"[DE] New patches found");
			[hashes setObject:patchesHash forKey:@"patchesHash"];
			doClearPatches = true;
		}
	} else {
		[hashes setObject:patchesHash forKey:@"patchesHash"];
		doClearPatches = true;
	}

	[hashes writeToFile:HASHES_PATH atomically:YES];

	return doClearPatches;
}

// Create our patched bundle file and return the path to it
NSURL* createBundleFile(NSURL *originalBundle, NSString *patchedPath) {
	@try {
		mach_port_t server_port;
		kern_return_t err;
		if ((err = bootstrap_look_up(bootstrap_port, getServiceName(), &server_port)) != KERN_SUCCESS){
			NSLog(@"[DE] Failed to get server: %s", mach_error_string(err));
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
			NSLog(@"[DE] Error creating patched jsbundle");
			return originalBundle;
		}

		NSLog(@"[DE] Patched jsbundle was created");
		return [[NSURL alloc] initFileURLWithPath:patchedPath];
	} @catch(NSException *exception) {
		NSLog(@"[DE] Something went really fucking wrong");
		return originalBundle;
	}
}

%hook AppDelegate

- (id)sourceURLForBridge:(id)arg1 {
	id original = %orig;
	
	NSURL *jsBundlePath = original;
	NSString *patchedPath = [[jsBundlePath.path stringByDeletingLastPathComponent] stringByAppendingString:@"/patched.jsbundle"];

#ifndef NDEBUG
	NSLog(@"[DE] jsBundlePath: %@", jsBundlePath);
	NSLog(@"[DE] patchedPath: %@", patchedPath);
#endif

	if (shouldCheckHashes()) {
		if (checkHashes(jsBundlePath.path, patchedPath)) {
			NSLog(@"[DE] Hashed check failed");
			return createBundleFile(jsBundlePath, patchedPath);
		}
		
		NSLog(@"[DE] Hashes check pass");
	} else {
		NSLog(@"[DE] Skipping hashes check");
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:patchedPath]) {
		NSLog(@"[DE] Using patched jsbundle");
		return [[NSURL alloc] initFileURLWithPath:patchedPath];
	}

	NSLog(@"[DE] Patching jsbundle");
	return createBundleFile(jsBundlePath, patchedPath);
}

%end
