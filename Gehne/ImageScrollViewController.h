//
//  ImageScrollViewController.h
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollViewController : UIViewController
{
@private
    NSMutableArray *galleryImages_;
    NSInteger currentIndex_;
    NSInteger previousPage_;
}

@property (nonatomic, retain) UIImageView *prevImgView; //reusable Imageview - always contains the previous image
@property (nonatomic, retain) UIImageView *centerImgView; //reusable Imageview - always contains the currently shown image
@property (nonatomic, retain) UIImageView *nextImgView; //reusable Imageview - always contains the next image image
@property(nonatomic, retain)NSMutableArray *galleryImages; //Array holding the image file paths
@property(nonatomic, retain)UIScrollView *imageHostScrollView; //UIScrollview to hold the images

@property (retain, nonatomic) IBOutlet UIButton *prevImage;
@property (retain, nonatomic) IBOutlet UIButton *nxtImage;

@property (nonatomic, assign) NSInteger currentIndex;

- (IBAction)nextImage:(id)sender;
- (IBAction)prevImage:(id)sender;
@end
