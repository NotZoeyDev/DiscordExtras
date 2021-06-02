#import "Tweak.h"

#define substrateService "cy:moe.panties.discordextras";
#define libhookerService "lh:moe.panties.discordextras";

// Get list of available patches
NSArray* getPatches() {
  return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:PATCHES_FOLDER error:nil];
}

char* getServiceName() {
	char* serviceName = "";

	if (access("/usr/lib/libhooker.dylib", F_OK) == 0) {
		serviceName = libhookerService;
	} else {
		serviceName = substrateService;
	}

	return serviceName;
}

// Create a patch for patches list
void createPatchesJSON() {}

// Delete file
void deleteFile(NSString *filePath) {
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    NSLog(@"[DE] Deleted %@", filePath);
	}
}

// Get hashes for a specific file
NSString* getHashForFile(NSString *path) {
	NSData *data = [NSData dataWithContentsOfFile:path];
	unsigned char result[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(data.bytes, data.length, result);

	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", result[i]];
	}

	return output;
}

BOOL shouldCheckHashes() {
	NSString* checkHashFile = @".skip_hashes";

	return ![[NSFileManager defaultManager] fileExistsAtPath:[CACHE_PATH stringByAppendingString:checkHashFile]];
}