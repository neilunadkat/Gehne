//
//  Data.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "Data.h"
#import "AppacitiveLayer.h"

@implementation Data

+ (Data *)sharedDataObject{
    static Data *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[Data alloc] init];
    });
    
    return sharedData;
}

- (void) registerUser:(NSString *) userName withPhone:(NSString *) phone{

    AppacitiveLayer * appa = [AppacitiveLayer appacitiveObject];
    
    UserProfile * user = [[UserProfile alloc] init];
    user.userName = userName;
    user.phone = phone;
    [appa registerUser:user callOnSuccess:^(UserProfile *registeredUser) {
        [[NSUserDefaults standardUserDefaults] setObject:registeredUser.userId forKey:AUAppacitiveUserIdKey];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:UserRegisteredNotification object:nil];
        
    } callOnError:nil];
}

- (NSString *) getCatalogueViewUrl{

    return @"";
}
@end
