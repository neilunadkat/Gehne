//
//  ImageScrollViewController.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "ImageScrollViewController.h"

@interface ImageScrollViewController ()

@property UIScrollView * scrollView;

@end

@implementation ImageScrollViewController

#define safeModulo(x,y) ((y + x % y) % y)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.imageHostScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.imageHostScrollView.frame)*3, CGRectGetHeight(self.imageHostScrollView.frame));
    self.imageHostScrollView.delegate = self;
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(CGRectGetWidth(self.imageHostScrollView.frame), CGRectGetHeight(self.imageHostScrollView.frame));
    // add prevView as first in line
    UIImageView *prevView = [[UIImageView alloc] initWithFrame:rect];
    self.prevImgView = prevView;
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:rect];
    [self.imageHostScrollView addSubview:scrView];
    
    scrView.delegate = self;
    [scrView addSubview:self.prevImgView];
    
    //Centre
    rect.origin.x += CGRectGetWidth(self.imageHostScrollView.frame);
    UIImageView *currentView = [[UIImageView alloc] initWithFrame:rect];
    self.centerImgView = currentView;
    //    [self.imageHostScrollView addSubview:self.centerImgView];
    
    scrView = [[UIScrollView alloc] initWithFrame:rect];
    scrView.delegate = self;
    [self.imageHostScrollView addSubview:scrView];
    [scrView addSubview:self.centerImgView];
    
    
    //Third
    rect.origin.x += CGRectGetWidth(self.imageHostScrollView.frame);
    UIImageView *nextView = [[UIImageView alloc] initWithFrame:rect];
    self.nextImgView = nextView;
    //    [self.imageHostScrollView addSubview:self.nextImgView];
    
    scrView = [[UIScrollView alloc] initWithFrame:rect];
    [self.imageHostScrollView addSubview:scrView];
    scrView.delegate = self;
    
    [scrView addSubview:self.nextImgView];
    self.nextImgView.frame = scrView.bounds;
    
    
    // center the scrollview to show the middle view only
    [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
    self.imageHostScrollView.userInteractionEnabled=YES;
    self.imageHostScrollView.pagingEnabled = YES;
    self.imageHostScrollView.delegate = self;
    
    self.prevImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.centerImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.nextImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
//    self.galleryImages = [[NSMutableArray alloc] init];
    self.galleryImages = [[NSMutableArray alloc] initWithCapacity:5];
    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"Jewelry-Chains-6-1024x682" ofType:@"jpg"] atIndex:0];
    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"Jewelry-Chains-6-1024x682" ofType:@"jpg"] atIndex:1];
    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"Jewelry-Chains-6-1024x682" ofType:@"jpg"] atIndex:2];
    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"Jewelry-Chains-6-1024x682" ofType:@"jpg"] atIndex:3];
    
    self.currentIndex = 0;

    
    // similarly add centerImgView and nextImgView
    // center the scrollview to show the middle view only
    [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0) animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender{
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //incase we are still in same page, ignore the swipe action
    if(previousPage_ == page) return;
    if(sender.contentOffset.x >= sender.frame.size.width) {
        //swipe left, go to next image
        [self setRelativeIndex:1];
        // center the scrollview to the center UIImageView
        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0) animated:NO];
    }
    else if(sender.contentOffset.x < sender.frame.size.width) {
        //swipe right, go to previous image
        [self setRelativeIndex:-1];
        // center the scrollview to the center UIImageView
        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0) animated:NO];
    }
}
- (void)setRelativeIndex:(NSInteger)inIndex {
    [self setCurrentIndex:self.currentIndex + inIndex];
}


- (NSInteger)totalImages {
    return [self.galleryImages count];
}
- (void)setCurrentIndex:(NSInteger)inIndex {
    currentIndex_ = inIndex;
    
    
    if([self.galleryImages count] > 0){
        self.prevImgView.image   = [self imageAtIndex:[self relativeIndex:-1]];
        self.centerImgView.image = [self imageAtIndex:[self relativeIndex: 0]];
        self.nextImgView.image   = [self imageAtIndex:[self relativeIndex: 1]];
    }
}
- (NSInteger)relativeIndex:(NSInteger)inIndex {
    return safeModulo(([self currentIndex] + inIndex), [self totalImages]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *)imageAtIndex:(NSInteger)inImageIndex;{
    // limit the input to the current number of images, using modulo math
    inImageIndex = safeModulo(inImageIndex, [self totalImages]);
    
    NSString *filePath = [self.galleryImages objectAtIndex:inImageIndex];
    
	UIImage *image = nil;
    //Otherwise load from the file path
    if (nil == image)
    {
		NSString *imagePath = filePath;
		if(imagePath){
			if([imagePath isAbsolutePath]){
				image = [UIImage imageWithContentsOfFile:imagePath];
			}
			else{
				image = [UIImage imageNamed:imagePath];
			}
            
            if(nil == image){
				image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
				
			}
        }
    }
    
	return image;
}

@end
