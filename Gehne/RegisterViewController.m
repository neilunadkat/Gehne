//
//  ViewController.m
//  Gehne
//
//  Created by Nikhil Prasad on 2/8/14.
//  Copyright (c) 2014 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "RegisterViewController.h"
#import "Data.h"

@interface RegisterViewController ()

- (IBAction)onRegister:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRegistered:) name:UserRegisteredNotification object:nil];
}

-(void) userRegistered : (NSNotification *) noti{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRegister:(id)sender {
    
    
    Data * data = [Data sharedDataObject];
    [data registerUser:UserName.text withPhone:Phone.text];
    
}
@end
