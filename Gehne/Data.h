//
//  Data.h
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

+ (Data *) sharedDataObject;

- (void) registerUser:(NSString *) userName withPhone:(NSString *) phone;

- (NSString *) getCatalogueViewUrl;
@end
