//
//  ItemInfo.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "ItemInfo.h"

@implementation ItemInfo

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.short_Description forKey:@"short_desc"];
    [encoder encodeObject:self.long_Description forKey:@"long_desc"];
    [encoder encodeObject:self.itemType forKey:@"type"];
    [encoder encodeObject:self.itemCode forKey:@"itemcode"];
    [encoder encodeObject:self.imgUrls forKey:@"images"];
}

- (instancetype) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.short_Description = [decoder decodeObjectForKey:@"short_desc"];
        self.long_Description = [decoder decodeObjectForKey:@"long_desc"];
        self.itemType = [decoder decodeObjectForKey:@"type"];
        self.itemCode = [decoder decodeObjectForKey:@"itemcode"];
        self.imgUrls = (NSArray*) [decoder decodeObjectForKey:@"images"];
    }
    return self;
}

- (NSString*) description {
    NSString *itemDescription = [[NSString alloc] init];
    
    itemDescription = [NSString stringWithFormat:@"ITEM:\nNAME: %@\nITEM TYPE: %@\nITEM CODE: %@\nSHORT DESCRIPTION: %@\nLONG DESCRIPTION: %@\nIMAGEURLS: %@",self.name, self.itemType, self.itemCode, self.short_Description, self.long_Description, self.imgUrls.description];
    
    return itemDescription;
}

@end
