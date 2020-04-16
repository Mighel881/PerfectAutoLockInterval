#import "CustomAutoLockInterval.h"
#import <Cephei/HBPreferences.h>

static HBPreferences *pref;
static BOOL enabled;
static BOOL customLockscreenAutoLockInterval;
static BOOL customDefaultAutoLockInterval;
static BOOL customChargingAutoLockInterval;
static BOOL customLowPowerAutoLockInterval;
static int lockScreenAutoLockInterval;
static int defaultAutoLockInterval;
static int chargingAutoLockInterval;
static int lowPowerAutoLockInterval;

static double autoLockIntervalsLockscreen[3] = {10, 20, 30};
static double autoLockIntervals[7][2] = {{20, 30}, {40, 60}, {100, 120}, {160, 180}, {220, 240}, {280, 300}, {DBL_MAX, DBL_MAX}};

%hook SBIdleTimerDescriptor

- (double)warnInterval
{
	double newInterval = 0;

	if(![[%c(SBCoverSheetPresentationManager) sharedInstance] hasBeenDismissedSinceKeybagLock])
	{
		if(customLockscreenAutoLockInterval)
			newInterval = autoLockIntervalsLockscreen[customLockscreenAutoLockInterval];
	}
	else if([[%c(SBUIController) sharedInstance] isBatteryCharging])
	{
		if(customChargingAutoLockInterval)
			newInterval = autoLockIntervals[chargingAutoLockInterval][0];
	}
	else if([[NSProcessInfo processInfo] isLowPowerModeEnabled])
	{
		if(customLowPowerAutoLockInterval)
			newInterval = autoLockIntervals[lowPowerAutoLockInterval][0];
	}
	else
	{
		if(customDefaultAutoLockInterval)
			newInterval = autoLockIntervals[defaultAutoLockInterval][0];
	}

	return (newInterval > 0) ? newInterval : %orig;
}

- (double)totalInterval
{
	double newInterval = 0;

	if(![[%c(SBCoverSheetPresentationManager) sharedInstance] hasBeenDismissedSinceKeybagLock])
	{
		if(customLockscreenAutoLockInterval)
			newInterval = autoLockIntervalsLockscreen[customLockscreenAutoLockInterval];
	}
	else if([[%c(SBUIController) sharedInstance] isBatteryCharging])
	{
		if(customChargingAutoLockInterval)
			newInterval = autoLockIntervals[chargingAutoLockInterval][1];
	}
	else if([[NSProcessInfo processInfo] isLowPowerModeEnabled])
	{
		if(customLowPowerAutoLockInterval)
			newInterval = autoLockIntervals[lowPowerAutoLockInterval][1];
	}
	else
	{
		if(customDefaultAutoLockInterval)
			newInterval = autoLockIntervals[defaultAutoLockInterval][1];
	}

	return (newInterval > 0) ? newInterval : %orig;
}

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.customautolockintervalprefs"];
		[pref registerDefaults:
		@{
			@"enabled": @NO,
			@"customLockscreenAutoLockInterval": @NO,
			@"customDefaultAutoLockInterval": @NO,
			@"customChargingAutoLockInterval": @NO,
			@"customLowPowerAutoLockInterval": @NO,
			@"lockScreenAutoLockInterval": @0,
			@"defaultAutoLockInterval": @1,
			@"chargingAutoLockInterval": @1,
			@"lowPowerAutoLockInterval": @0,
    	}];

		enabled = [pref boolForKey: @"enabled"];
		if(enabled)
		{
			customLockscreenAutoLockInterval = [pref boolForKey: @"customLockscreenAutoLockInterval"];
			customDefaultAutoLockInterval = [pref boolForKey: @"customDefaultAutoLockInterval"];
			customChargingAutoLockInterval = [pref boolForKey: @"customChargingAutoLockInterval"];
			customLowPowerAutoLockInterval = [pref boolForKey: @"customLowPowerAutoLockInterval"];

			lockScreenAutoLockInterval = [pref integerForKey: @"lockScreenAutoLockInterval"];
			defaultAutoLockInterval = [pref integerForKey: @"defaultAutoLockInterval"];
			chargingAutoLockInterval = [pref integerForKey: @"chargingAutoLockInterval"];
			lowPowerAutoLockInterval = [pref integerForKey: @"lowPowerAutoLockInterval"];

			%init;
		}
	}
}