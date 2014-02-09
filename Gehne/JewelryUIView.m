//
//  JewelryUIView.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "JewelryUIView.h"

@interface JewelryUIView ()



@property BOOL isFlipped;
@end

@implementation JewelryUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (JewelryUIView * ) initViewWithItemInfo:(ItemInfo *)info{
    JewelryUIView * view = [[JewelryUIView alloc] init];
    view.isFlipped = NO;
    [view setViewsFromItemInfo:info];
    return  view;
}

- (void) setViewsFromItemInfo:(ItemInfo *) info{
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 540)];
    _detailsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 540)];
    
    
    [self setDetailsPageViewFromItemInfo:info];
    [self setMainPageViewFromItemInfo:info];
//    _detailsView.hidden = YES;
    [self addSubview:_detailsView];
    [self addSubview:_mainView];
}

- (void) setMainPageViewFromItemInfo:(ItemInfo *) info{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:info.image];
    imageView.frame = CGRectMake(0, 27, 320, 540);
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(9, 33, 300, 21)];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:17] ;
    [name setTextColor:[UIColor whiteColor]];
    [name setFont:font];
    [name setText:info.name];

    [_mainView addSubview:imageView];
    [_mainView addSubview:name];
    
}

-(void) setDetailsPageViewFromItemInfo:(ItemInfo *) info{
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:_detailsView.frame];

    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(8, 33, 200, 21)];
    [name setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
    [name setText:info.name];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:info.image];
    
    [imageView setFrame:CGRectMake(0, 62, 320, 200)];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(247, 227, 70, 30)];
    [button setTitle:@"Call Us" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //Set on touch to call;
    
    CGRect frame = [self getBoundsForText:info.long_Description withFont:[UIFont fontWithName:@"Helvetica Neue" size:14] withMaxWidth:274];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:17] ;
    UILabel * decr = [[UILabel alloc] initWithFrame:CGRectMake(7, 14, 100, 21)];
    [decr setFont:font];
    [decr setText:@"Description"];
    UITextView * description = [[UITextView alloc] initWithFrame:CGRectMake(14, 32, 274, 32 + frame.size.height)];
    description.text = info.long_Description;
    
    UILabel * price_Label = [[UILabel alloc] initWithFrame:CGRectMake(7, description.frame.origin.y + description.frame.size.height + 10, 50, 21)];
    [price_Label setFont:font];
    [price_Label setText:@"Price"];
    
    UILabel *priceValue = [[UILabel alloc] initWithFrame:CGRectMake(20, price_Label.frame.origin.y  + 25, 70, 21)];
    [priceValue setText:info.price];
    [priceValue setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    
    
    UIView * descriptionView = [[UIView alloc] initWithFrame:CGRectMake(8, 281, 304, priceValue.frame.origin.y + 42)];
    [descriptionView addSubview:decr];
    [descriptionView addSubview:description];
    [descriptionView addSubview:price_Label];
    [descriptionView addSubview:priceValue];
    
    [descriptionView setBackgroundColor:[UIColor whiteColor]];
    descriptionView.layer.cornerRadius = 2;
    
    [scrollView addSubview:name];
    
    [scrollView addSubview:imageView];
    [scrollView addSubview:button];
    
    [scrollView addSubview:descriptionView];
    
    scrollView.contentSize = CGSizeMake(320, 1500);
    
    [_detailsView addSubview: scrollView];
    //Add the name label
    //Add the image view
    //Add the call us button on the image
    
    //Add the description and price view
        //Add the description label and text in the this view
        //Adde the price label and text in this view
    
}

-(void) call{
    
}

-(void) flip{
    [UIView transitionFromView:_mainView toView:_detailsView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//        _detailsView.hidden = NO;
//        _mainView.hidden = YES;
    }];
}

-(CGRect) getBoundsForText:(NSString *)text withFont:(UIFont *) font withMaxWidth: (float) maxWidth{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth, 100)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: font}
                                        context:nil];
    return rect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
