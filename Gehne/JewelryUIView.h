//
//  JewelryUIView.h
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInfo.h"

@interface JewelryUIView : UIView

 + (JewelryUIView *) initViewWithItemInfo:(ItemInfo *) info;
- (void) flip;

@property UIView * mainView;
@property UIView * detailsView;
@end
