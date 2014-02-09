//
//  MainViewController.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "JewelryUIView.h"


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MainViewController ()

- (IBAction)flip:(id)sender;

@property UIView * mainView;
@property UIScrollView * detailView;

@property NSMutableArray *views;
@property JewelryUIView * currentView;

@property UIScrollView* mainScrollView;
@property NSMutableArray * items;
@end

@implementation MainViewController


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:  animated];
    
//    if([[NSUserDefaults standardUserDefaults] objectForKey:AUAppacitiveUserIdKey] == nil){
//        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"] animated:NO completion:nil];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

//    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 30, 21)];
//    [button addTarget:self action:@selector(press:) forControlEvents:UIControlEventAllTouchEvents];
//    [button setTitle:@"Press" forState:UIControlStateNormal];
    _items = [[NSMutableArray alloc] init];
    
    ItemInfo * info = [[ItemInfo alloc] init];
    info.name = @"BEJEWELLED LOTUS DIAMOND EARRINGS";
    info.image = [UIImage imageNamed:@"necklace.jpg"];
    info.long_Description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    info.short_Description = @"Sterling Silver Bracelet with American diamonds & green colored stone";
    info.price = @"1.7 Lakhs";
    [_items insertObject:info atIndex:0];
    info = [[ItemInfo alloc] init];
    info.name = @"ELEGANT GOLD HUGGIES";
    info.image = [UIImage imageNamed:@"necklace2.jpg"];
    info.long_Description = @"dasdasd";
    info.short_Description = @"Sterling Silver Pendant Set with American diamonds & Blue stones";
    info.price = @"1 Lakh";
    [_items insertObject:info atIndex:1];
    
    
    _views = [self getAllViewsForItems:_items];
    _mainScrollView = [[UIScrollView alloc]
                       initWithFrame:CGRectMake(0, 20, 320, self.view.frame.size.height)];
    _mainScrollView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    UIView * coverView = [[UIView alloc] initWithFrame:self.view.frame];
    coverView.layer.backgroundColor = [UIColor clearColor].CGColor;

    for (int i =0; i < _views.count ; i ++) {
//        CGRect frame;
//        frame.origin.x = 320 * i + 10;
//        frame.origin.y = 0;
//        frame.size = CGSizeMake(320, 540) ;
//        [[_views objectAtIndex:i] setFrame:frame];
        [coverView addSubview:[_views objectAtIndex:i] ];
    }
    
    coverView.frame = CGRectMake(coverView.frame.origin.x, 20, 320 * _views.count, self.view.frame.size.height);
    
    [_mainScrollView addSubview:coverView];
    [_mainScrollView setContentSize:CGSizeMake(320 * _views.count, self.view.frame.size.height)];
    
//    UIScrollView * mainView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    mainView.contentSize = CGSizeMake(320, 720);
//    mainView.layer.backgroundColor = [[UIColor alloc]initWithWhite:0.6 alpha:0.6].CGColor;
//    _currentView =[JewelryUIView initViewWithItemInfo:info];
//
//    [mainView addSubview:_currentView];
    
    [self.view addSubview: _mainScrollView];
    UIView * statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.layer.backgroundColor = [[UIColor alloc] initWithWhite:0.8 alpha:0.5].CGColor;
    [self.view addSubview:statusBarView];

    
}


-(NSMutableArray *) getAllViewsForItems:(NSMutableArray *)items{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    for (int i =0; i < items.count; i ++) {
        [array insertObject:[self getViewForItem:[items objectAtIndex:i] atPosition:i] atIndex:i] ;
    }
    
    return  array;
}

-(UIView *) getViewForItem:(ItemInfo *)info atPosition:(int) pos{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(320 * pos, 0, 320, self.view.frame.size.height)];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:info.image];
    imageView.frame = CGRectMake(7, 95, 306, 375);
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 305, 22)];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:14] ;
    [name setTextColor:[UIColor blackColor]];
    [name setFont:font];
    [name setText:info.name];
    
    font =[UIFont fontWithName:@"Helvetica Neue" size:13];
    CGRect frame = [self getBoundsForText:info.short_Description
                                 withFont:font  withMaxWidth:305];

    UILabel * short_description = [[UILabel alloc]initWithFrame:CGRectMake(12, 27, 305, frame.size.height)];
    short_description.text = info.short_Description;
    [short_description setFont:font];
    [short_description setNumberOfLines:0];
    [short_description setTextColor:UIColorFromRGB(0xCC9900)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(9, short_description.frame.size.height + short_description.frame.origin.y + 5, 41, 21)];
    [btn setTitle:@"More.." forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
//    [btn setBackgroundColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(flip:) forControlEvents:UIControlEventAllEvents];
    btn.tag = pos;
   
    [view addSubview:name];
    [view addSubview:short_description];
    [view addSubview:btn];
    [view addSubview:imageView];
    
    
    
    return view;
}

-(void) press:(id)sender{
    [_currentView flip];
}

-(UIView *)getMainView:(ItemInfo *) info{
    
    UIScrollView * scrollView = [[UIScrollView alloc]
                                 initWithFrame:CGRectMake(0, 25, 320, self.view.frame.size.height)];
    scrollView.layer.backgroundColor =[UIColor whiteColor].CGColor;
    
    UIFont * nameFont = [UIFont fontWithName:@"Helvetica Neue" size:14];
    CGRect nameFrame = [self getBoundsForText:info.name withFont:nameFont withMaxWidth:305];
    float x = (320 - nameFrame.size.width) / 2;
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(x, 33, nameFrame.size.width, 21)];
    [name setFont:nameFont];
    [name setText:info.name];
    
    UIButton * back = [[UIButton alloc] initWithFrame:CGRectMake(1, 273, 62, 30)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setTitleColor:back.tintColor forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [back addTarget:self action:@selector(flip:) forControlEvents:UIControlEventAllEvents];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:info.image];
    
    
    [imageView setFrame:CGRectMake(60, 75, 200, 200)];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(250, 273, 70, 30)];
    [button setTitle:@"Call Us" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    //Set on touch to call;
    
    
    
    CGRect frame = [self getBoundsForText:info.long_Description withFont:[UIFont fontWithName:@"Helvetica Neue" size:14] withMaxWidth:274];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:17] ;
    UILabel * decr = [[UILabel alloc] initWithFrame:CGRectMake(7, 14, 100, 21)];
    [decr setFont:font];
    [decr setText:@"Description"];
    UITextView * description = [[UITextView alloc] initWithFrame:CGRectMake(14, 32, 274, 32 + frame.size.height)];
    description.text = info.long_Description;
    description.scrollEnabled = NO;
    
    UILabel * price_Label = [[UILabel alloc] initWithFrame:CGRectMake(7, description.frame.origin.y + description.frame.size.height + 10, 50, 21)];
    [price_Label setFont:font];
    [price_Label setText:@"Price"];
    
    UILabel *priceValue = [[UILabel alloc] initWithFrame:CGRectMake(20, price_Label.frame.origin.y  + 25, 70, 21)];
    [priceValue setText:info.price];
    [priceValue setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    
    
    UIView * descriptionView = [[UIView alloc] initWithFrame:CGRectMake(8, 310, 304, priceValue.frame.origin.y + 42)];
    [descriptionView addSubview:decr];
    [descriptionView addSubview:description];
    [descriptionView addSubview:price_Label];
    [descriptionView addSubview:priceValue];
    
    [descriptionView setBackgroundColor:[UIColor whiteColor]];
    descriptionView.layer.cornerRadius = 2;
    
    UIView * view = [[UIView alloc] initWithFrame:self.view.frame];
    view.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [view addSubview:name];
    [view addSubview:back];
    [view addSubview:imageView];
    [view addSubview:button];
    
    [view addSubview:descriptionView];
    
    scrollView.contentSize = CGSizeMake(320, descriptionView.frame.origin.y + descriptionView.frame.size.height + 50);
    
    
    [scrollView addSubview:view];
    return scrollView;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGRect) getBoundsForText:(NSString *)text withFont:(UIFont *) font withMaxWidth: (float) maxWidth{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth, 100)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    return rect;
}

- (IBAction)flip:(id)sender {
//    
//    [UIView transitionFromView:self.view.window toView:_currentView.detailsView duration:0.65f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//        _detailView.hidden = NO;
//        _mainView.hidden = YES;
//    }];
    UIButton * btn = (UIButton *) sender;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    
    if ([_mainScrollView superview])
    {
        [_mainScrollView removeFromSuperview];
        _mainView =[self getMainView:[self.items objectAtIndex:btn.tag]];
        [self.view addSubview:_mainView];
//        [self.view sendSubviewToBack:_mainScrollView];
    }
    else
    {
        [_mainView removeFromSuperview];
        [self.view addSubview:_mainScrollView];
//        [self.view sendSubviewToBack:_mainView];
    }
    
    [UIView commitAnimations];
}
@end
