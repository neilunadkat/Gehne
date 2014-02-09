//
//  ItemInfo.h
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppacitiveSDK.h>

@interface ItemInfo : NSObject

@property NSString * name;
@property NSString * short_Description;
@property NSString * long_Description;
@property NSString * itemCode;
@property NSString *itemType;
@property NSArray *imgUrls;
@property UIImage * image;
@property BOOL showPrice;
@property NSString * price;

- (NSString*) description;

@end
