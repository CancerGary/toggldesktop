//
//  Utils.m
//  TogglDesktop
//
//  Created by Tanel Lebedev on 07/05/14.
//  Copyright (c) 2014 Toggl Desktop developers. All rights reserved.
//

#import "Utils.h"
#import "NSAlert+Utils.h"
#ifdef SPARKLE
#import <Sparkle/Sparkle.h>
#endif

extern void *ctx;

@implementation ScriptResult

- (void)append:(NSString *)moreText
{
	if (!self.text)
	{
		self.text = @"";
	}
	self.text = [self.text stringByAppendingString:moreText];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"err: %ld, text: %@",
			(long)self.err, self.text];
}

@end

@implementation Utils

+ (void)runClearCommand
{
	NSString *location = @"Library/Application Support/TogglDesktop/.Sparkle";
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *userPath = NSHomeDirectory();
	NSString *directory = [userPath stringByAppendingPathComponent:location];
	NSError *error = nil;
	BOOL success = [fm removeItemAtPath:directory error:&error];

	if (!success)
	{
		NSLog(@"Failed to clear old updates folder at: %@", directory);
	}
}

+ (void)setUpdaterChannel:(NSString *)channel
{
#ifdef SPARKLE
	NSString *url = [NSString stringWithFormat:@"https://toggl-open-source.github.io/toggldesktop/assets/releases/darwin_%@_appcast.xml", channel];

	NSAssert([SUUpdater sharedUpdater], @"No updater found");
	NSLog(@"Setting updater feed URL to %@", url);
	[[SUUpdater sharedUpdater] setFeedURL:[NSURL URLWithString:url]];
#endif
}

+ (NSInteger)boolToState:(BOOL)value
{
	if (value)
	{
		return NSOnState;
	}
	return NSOffState;
}

+ (unsigned int)stateToBool:(NSInteger)state
{
	if (NSOnState == state)
	{
		return 1;
	}
	return 0;
}

+ (void)disallowDuplicateInstances
{
	if ([[NSRunningApplication runningApplicationsWithBundleIdentifier:
		  [[NSBundle mainBundle] bundleIdentifier]] count] > 1)
	{
		NSString *msg = [NSString
						 stringWithFormat:@"Another copy of %@ is already running.",
						 [[NSBundle mainBundle]
						  objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey]];
		[NSAlert alloc];
		[[NSAlert alertWithMessageText:msg
			 informativeTextWithFormat:@"This copy will now quit."] runModal];

		[NSApp terminate:nil];
	}
}

+ (NSString *)applicationSupportDirectory:(NSString *)environment
{
    NSString *oldPath;
    NSString *path;
    NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);

	if ([paths count] == 0)
	{
		NSLog(@"Unable to access application support directory!");
	}

    oldPath = [paths[0] stringByAppendingPathComponent:@"Kopsik"];
    path = [paths[0] stringByAppendingPathComponent:@"Toggl"];

    // Check if Kopsik dir exists and rename it
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:oldPath]){
        NSError *error = nil;
        [fileManager moveItemAtPath:oldPath toPath:path error:&error];
    }

	// Append environment name to path. So we can have
	// production and development running side by side.
	path = [path stringByAppendingPathComponent:environment];

	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		return path;
	}
	if (![[NSFileManager defaultManager] createDirectoryAtPath:path
								   withIntermediateDirectories:YES
													attributes:nil
														 error:&error])
	{
		NSLog(@"Create directory error: %@", error);
	}
	return path;
}

@end

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

// See https://codereview.chromium.org/7497056/patch/2002/4002 for inspiration
BOOL wasLaunchedAsLoginOrResumeItem()
{
	ProcessSerialNumber psn = { 0, kCurrentProcess };
	NSDictionary *process_info = CFBridgingRelease(ProcessInformationCopyDictionary(&psn, kProcessDictionaryIncludeAllInformationMask));

	long long temp = [[process_info objectForKey:@"ParentPSN"] longLongValue];
	ProcessSerialNumber parent_psn = { (temp >> 32) & 0x00000000FFFFFFFFLL, temp & 0x00000000FFFFFFFFLL };

	NSDictionary *parent_info = CFBridgingRelease(ProcessInformationCopyDictionary(&parent_psn,
																				   kProcessDictionaryIncludeAllInformationMask));

	return [[parent_info objectForKey:@"FileCreator"] isEqualToString:@"lgnw"];
}

// See https://codereview.chromium.org/7497056/patch/2002/4002 for inspiration
BOOL wasLaunchedAsHiddenLoginItem()
{
	if (!wasLaunchedAsLoginOrResumeItem())
	{
		return NO;
	}

	LSSharedFileListRef login_items = LSSharedFileListCreate(NULL,
															 kLSSharedFileListSessionLoginItems,
															 NULL);

	if (!login_items)
	{
		return NO;
	}

	CFArrayRef login_items_array = LSSharedFileListCopySnapshot(login_items,
																NULL);

	CFURLRef url_ref = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];

	for (int i = 0; i < CFArrayGetCount(login_items_array); i++)
	{
		LSSharedFileListItemRef item = (LSSharedFileListItemRef)CFArrayGetValueAtIndex(login_items_array, i);
		CFURLRef item_url_ref = NULL;
		if (!(LSSharedFileListItemResolve(item, 0, &item_url_ref, NULL) == noErr))
		{
			continue;
		}
		if (CFEqual(item_url_ref, url_ref))
		{
			CFBooleanRef hidden = LSSharedFileListItemCopyProperty(item, kLSSharedFileListLoginItemHidden);
			BOOL value = (hidden && kCFBooleanTrue == hidden);
            if (hidden != NULL) {
                CFRelease(hidden);
            }
            CFRelease(login_items_array);
            return value;
		}
	}

    CFRelease(login_items_array);
	return NO;
}

#pragma GCC diagnostic pop
