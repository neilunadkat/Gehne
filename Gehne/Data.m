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
#import "AFNetworking.h"

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
    
//    Uncomment below line to set 'LastFetchDate' to current date
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastFetchDate"];

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"LastFetchDate"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate distantPast] forKey:@"LastFetchDate"];
    }
    
//    Uncomment below line to reset 'LastFetchDate' to a past date
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate distantPast] forKey:@"LastFetchDate"];
    
    APSimpleQuery *dateQurey = [[APQuery queryExpressionWithProperty:@"__utcdatecreated"] isGreaterThanOrEqualTo:[APHelperMethods jsonDateStringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"LastFetchDate"]]];
    NSString *query = [NSString stringWithFormat:@"psize=10&query=%@",[dateQurey stringForm]];
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    [APObject searchAllObjectsWithTypeName:@"jewlery" withQueryString:query successHandler:^(NSArray *objects) {
        if([objects count] > 0) {
            for(APObject *object in objects) {
                ItemInfo *item = [[ItemInfo alloc] init];
                
                item.name = [object getPropertyWithKey:@"name"];
                item.price = [object getPropertyWithKey:@"price"];
                item.short_Description = [object getPropertyWithKey:@"short_desc"];
                item.long_Description = [object getPropertyWithKey:@"long_desc"];
                item.itemType = [object getPropertyWithKey:@"type"];
                item.itemCode = [object getPropertyWithKey:@"itemcode"];
                item.imgUrls = (NSArray*) [object getPropertyWithKey:@"images"];

//                AFHTTPRequestOperation *imgDownloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[item.imgUrls firstObject]]]];
//                [imgDownloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
////                    NSLog(@"Response: %@", responseObject);
//                    item.image = responseObject;
//                    
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"Image error: %@", error);
//                }];
//                [imgDownloadOperation start];
                [itemsArray addObject:item];
            }
        }
        if(successBlock)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *itemArchiveFile = [documentsDirectory stringByAppendingPathComponent:@"items.txt"];
            
            NSMutableArray *archivedItems = [[NSMutableArray alloc] init];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:itemArchiveFile isDirectory:NO])
                [archivedItems addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:itemArchiveFile]];
            
            if([itemsArray count] > 0)
            [archivedItems addObjectsFromArray:itemsArray];
            
            [NSKeyedArchiver archiveRootObject:archivedItems toFile:itemArchiveFile];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastFetchDate"];
            
            successBlock(archivedItems);
        }
    } failureHandler:^(APError *error) {
        NSLog(@"Error: %@",[error description]);
    }];
}

@end
