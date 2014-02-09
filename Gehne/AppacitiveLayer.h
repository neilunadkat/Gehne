//
//  AppacitiveLayer.h
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@interface AppacitiveLayer : NSObject

+ (AppacitiveLayer * ) appacitiveObject;

- (void ) registerUser:(UserProfile *) user
                 callOnSuccess:(void (^)(UserProfile * )) successHandler
                   callOnError:(void (^)(NSError *)) errorHandler;

- (void) connectUser:(NSString *)userId withDevice:(NSString *) deviceId
       callOnSuccess: (void (^)(NSString *,NSString *)) successHandler
         callOnError:(void (^)(NSError *)) errorHandler;

- (void) updateUser: (UserProfile *) user;

-(NSString *) getCatalogueURL;

@end
