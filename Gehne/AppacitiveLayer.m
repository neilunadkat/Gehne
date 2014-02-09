//
//  AppacitiveLayer.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "AppacitiveLayer.h"
#import "UserProfile.h"

static NSString * const kAppacitiveUrl = @"https://apis.appacitive.com/v1.0/";
static NSString * const userRegistration = @"{\"name\" : \"%@\" , \"phone\" : \"%@\"}";
static NSString * const kAppacitiveAPIEnvironment = @"sandbox";
static NSString * const kAppacitiveAPIKey = @"QUAWXBwgjU7W0ma/zBtF/E7wwu3In4QyDEl7N61I8lU=";
static NSString * const kAppacitiveEnvironmentKeyName = @"Appacitive-Environment";
static NSString * const kAppacitiveAPIKeyName = @"Appacitive-ApiKey";

@implementation AppacitiveLayer


+(AppacitiveLayer *) appacitiveObject{
    static AppacitiveLayer *appacitiveObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appacitiveObject = [[AppacitiveLayer alloc] init];
    });
    
    return appacitiveObject;
}

-(void) registerUser:(UserProfile *)user
                callOnSuccess:(void (^)(UserProfile * )) successHandler
                  callOnError:(void (^)(NSError *)) errorHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/object/person?fields=__id",kAppacitiveUrl];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * post = [NSString stringWithFormat:userRegistration,user.userName,user.phone];
    NSData * data = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [request setValue:kAppacitiveAPIEnvironment forHTTPHeaderField:kAppacitiveEnvironmentKeyName];
    [request setValue:kAppacitiveAPIKey forHTTPHeaderField:kAppacitiveAPIKeyName];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError != NULL){
            
        }
        else{
            NSError *e = Nil;
            NSDictionary * JSON = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
            
            NSDictionary * status = [JSON objectForKey:@"status"];
            if([[status objectForKey:@"code"] isEqualToString:@"200"] ==NO){
                //Error while creating user
                //Do something here
            }
            else{
                //This is when the user is registered.
                NSString * userId = [[JSON objectForKey:@"object"] objectForKey:@"__id"];
                user.userId = userId;
                successHandler(user);
            }
        }
    }];
    
}

-(void) updateUser:(UserProfile *)user{
    
}

-(NSString *) getCatalogueURL{
    return @"";
}

-(void) connectUser:(NSString *)userId withDevice:(NSString *)deviceId
      callOnSuccess: (void (^)(NSString *,NSString *)) successHandler
        callOnError:(void (^)(NSError *)) errorHandler
{
    
}

@end
