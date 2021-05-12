#import "Tweak.h"

// Get list of available patches
NSArray* getPatches() {
  return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:PATCHES_FOLDER error:nil];
}

// Delete file
void deleteFile(NSString *filePath) {
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    NSLog(@"[DiscordExtras] Deleted %@", filePath);
	}
}

// Get hashes for a specific file
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