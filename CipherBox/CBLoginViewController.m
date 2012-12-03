//
//  CBLoginViewController.m
//  CipherBox
//
//  Created by Eason Chen on 11/28/12.
//  Copyright (c) 2012 wada. All rights reserved.
//
//#import "Box/Box.h"
#import "CBLoginViewController.h"
#import "Box/Box.h"

@interface CBLoginViewController ()

@end

@implementation CBLoginViewController

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
    // Do any additional setup after loading the view from its nib.
	logoImg.image = [UIImage imageNamed:@"cipherbox_logo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startLogin:(id)sender {
	NSLog(@"Login!!");
	[Box initiateLoginUsingURLRedirectWithCallbacks:nil];
}

@end
