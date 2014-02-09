//
//  ItemInfo.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "ItemInfo.h"

@implementation ItemInfo

- (NSString*) description {
    NSString *itemDescription = [[NSString alloc] init];
    
    itemDescription = [NSString stringWithFormat:@"Item:\nName: %@\nItem Type: %@\nItem Code: %@\nShort Description: %@\nLong Description: %@\nImageUrls: %@",self.name, self.itemType, self.itemCode, self.short_Description, self.long_Description, self.imgUrls.description];
    
    return itemDescription;
}

@end
