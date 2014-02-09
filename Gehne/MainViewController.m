//
//  MainViewController.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "JewelryUIView.h"
#import "Data.h"

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
    
    Data *dataInst = [[Data alloc] init];
    [dataInst getAllJewelryInfoWithSuccessHandler:^(NSArray *objects) {
        NSLog(@"COUNT: %d",[objects count]);
        for(ItemInfo *item in objects)
            NSLog(@"%@", item.description);
    }];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 30, 21)];
    [button addTarget:self action:@selector(press:) forControlEvents:UIControlEventAllTouchEvents];
    [button setTitle:@"Press" forState:UIControlStateNormal];
    _items = [[NSMutableArray alloc] init];
    
    ItemInfo * info = [[ItemInfo alloc] init];
    info.name = @"Nakshatra Necklace";
    info.image = [UIImage imageNamed:@"Jewelry-Chains-6-1024x682.jpg"];
    info.long_Description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    info.price = @"1.7 Lakhs";
    [_items insertObject:info atIndex:0];
    info = [[ItemInfo alloc] init];
    info.name = @"Nakshatra Ring";
    info.image = [UIImage imageNamed:@"Jewelry-Chains-6-1024x682.jpg"];
    info.long_Description = @"dasdasd";
    info.price = @"1 Lakh";
    [_items insertObject:info atIndex:1];
//    UIView * mainView = [[UIView alloc] initWithFrame:self.view.frame];
    
    
    _views = [self getAllViewsForItems:_items];
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _mainScrollView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    UIView * coverView = [[UIView alloc] initWithFrame:self.view.frame];
    coverView.layer.backgroundColor = [[UIColor alloc] initWithWhite:0.6 alpha:0.6].CGColor;

    for (int i =0; i < _views.count ; i ++) {
//        CGRect frame;
//        frame.origin.x = 320 * i + 10;
//        frame.origin.y = 0;
//        frame.size = CGSizeMake(320, 540) ;
//        [[_views objectAtIndex:i] setFrame:frame];
        [coverView addSubview:[_views objectAtIndex:i] ];
    }
    
    coverView.frame = CGRectMake(coverView.frame.origin.x, coverView.frame.origin.y, 320 * _views.count, 540);
    
    [_mainScrollView addSubview:coverView];
    [_mainScrollView setContentSize:CGSizeMake(320 * _views.count, 540)];
    
//    UIScrollView * mainView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    mainView.contentSize = CGSizeMake(320, 720);
//    mainView.layer.backgroundColor = [[UIColor alloc]initWithWhite:0.6 alpha:0.6].CGColor;
//    _currentView =[JewelryUIView initViewWithItemInfo:info];
//
//    [mainView addSubview:_currentView];
    
    [self.view addSubview: _mainScrollView];
    
}




-(NSMutableArray *) getAllViewsForItems:(NSMutableArray *)items{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    for (int i =0; i < items.count; i ++) {
        [array insertObject:[self getViewForItem:[items objectAtIndex:i] atPosition:i] atIndex:i] ;
    }
    
    return  array;
}

-(UIView *) getViewForItem:(ItemInfo *)info atPosition:(int) pos{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(320 * pos, 20, 320, 520)];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:info.image];
    imageView.frame = CGRectMake(5, 27, 305, 540);
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(12, 33, 300, 21)];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:17] ;
    [name setTextColor:[UIColor whiteColor]];
    [name setFont:font];
    [name setText:info.name];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 33, 30, 21)];
    [btn setTitle:@"Flip" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(flip:) forControlEvents:UIControlEventAllEvents];
    btn.tag = pos;
    [view addSubview:imageView];
    [view addSubview:name];
    [view addSubview:btn];
    
    
    
    return view;
}

-(void) press:(id)sender{
    [_currentView flip];
}

-(UIView *)getMainView:(ItemInfo *) info{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.layer.backgroundColor =[UIColor whiteColor].CGColor;
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(8, 33, 200, 21)];
    [name setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
    [name setText:info.name];
    
    UIButton * back = [[UIButton alloc] initWithFrame:CGRectMake(200, 33, 30, 21)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(flip:) forControlEvents:UIControlEventAllEvents];
    
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
    
    UIView * view = [[UIView alloc] initWithFrame:self.view.frame];
    view.layer.backgroundColor =
    [[UIColor alloc] initWithWhite:0.6 alpha:0.6].CGColor;
    
    [view addSubview:name];
    [view addSubview:back];
    [view addSubview:imageView];
    [view addSubview:button];
    
    [view addSubview:descriptionView];
    
    scrollView.contentSize = CGSizeMake(320, 1500);
    
    
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
