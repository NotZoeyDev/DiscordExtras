#include "discordExtrasRootListController.h"
#include <CepheiPrefs/HBAppearanceSettings.h>

#define BUNDLE_PATH @"/Library/Application Support/DiscordExtrasFiles.bundle"
#define PATCHES_FOLDER [BUNDLE_PATH stringByAppendingString:@"/patches"]

@implementation discordExtrasRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"DiscordExtras" target:self];
	}

	return _specifiers;
}

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		self.hb_appearanceSettings = appearanceSettings;
	}

	NSArray* patches = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:PATCHES_FOLDER error:NULL];

	for (NSString *file in patches) {
		NSString *extension = [[file pathExtension] lowercaseString];
    if ([extension isEqualToString:@"json"]) {
			NSString *patchName = [[file lastPathComponent] stringByDeletingPathExtension];

			PSSpecifier* spec = [PSSpecifier
				preferenceSpecifierNamed:patchName
				target:self
				set:nil
				get:nil
				detail:nil
				cell:PSStaticTextCell
				edit:nil
			];

			[self insertSpecifier:spec afterSpecifierID:@"PatchesList"];
    }
	}

	return self;
}

@end
