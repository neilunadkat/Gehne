//
//  Data.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "Data.h"
#import "AppacitiveLayer.h"
#import <AppacitiveSDK.h>
#import "ItemInfo.h"

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

-(void) getAllJewelryInfoWithSuccessHandler:(APObjectsSuccessBlock)successBlock {
    [Appacitive initWithAPIKey:@"QUAWXBwgjU7W0ma/zBtF/E7wwu3In4QyDEl7N61I8lU="];
    [Appacitive useLiveEnvironment:NO];
    
    NSString *query = @"psize=10";
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    [APObject searchAllObjectsWithTypeName:@"jewlery" withQueryString:query successHandler:^(NSArray *objects) {
        for(APObject *object in objects) {
            ItemInfo *item = [[ItemInfo alloc] init];
            
            item.name = [object getPropertyWithKey:@"name"];
            item.price = [object getPropertyWithKey:@"price"];
            item.short_Description = [object getPropertyWithKey:@"short_desc"];
            item.long_Description = [object getPropertyWithKey:@"long_desc"];
            item.itemType = [object getPropertyWithKey:@"type"];
            item.itemCode = [object getPropertyWithKey:@"itemcode"];
            item.imgUrls = (NSArray*) [object getPropertyWithKey:@"images"];
            
            [itemsArray addObject:item];
        }
        if(successBlock)
        {
            successBlock(itemsArray);
        }
    } failureHandler:^(APError *error) {
        NSLog(@"Error: %@",[error description]);
    }];
}

@end
