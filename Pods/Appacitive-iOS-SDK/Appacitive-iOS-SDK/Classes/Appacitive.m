//
//  Appacitive.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. All rights reserved.
//

#import "Appacitive.h"
#import "APConstants.h"
#import "APHelperMethods.h"
#import "APdevice.h"
static NSString* _apiKey;
static BOOL enableLiveEnvironment = NO;

@implementation Appacitive

+ (NSString*) environmentToUse {
    if (enableLiveEnvironment) {
        return @"live";
    }
    return @"sandbox";
}

+ (void) useLiveEnvironment:(BOOL)answer {
    if(answer == YES)
        enableLiveEnvironment = YES;
    else
        enableLiveEnvironment = NO;
}

+ (NSString*) getApiKey {
    return _apiKey;
}

+ (void) initWithAPIKey:(NSString*)apiKey {
    _apiKey = apiKey;
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"appacitive-device-guid"] == nil) {
        NSString* deviceGUID = [self GetUUID];
        APDevice *device = [[APDevice alloc]initWithDeviceToken:deviceGUID deviceType:@"ios"];
        [device registerDeviceWithSuccessHandler:^{
            [[NSUserDefaults standardUserDefaults] setObject:deviceGUID forKey:@"appacitive-device-guid"];
        } failureHandler:^(APError *error) {
        }];
    }
}

#pragma mark - Private Methods

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end
