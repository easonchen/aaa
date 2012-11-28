//
//  CipherBox
//
//  Created by boffo lin on 12/11/26.
//  Copyright (c) 2012年 wada. All rights reserved.
//

#import "CBDetailViewController.h"
#import "CBAppDelegate.h"
#import "DDMenuController.h"
#import "CBLoginView.h"

@interface CBDetailViewController ()

@end

@implementation CBDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self showLoginView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openMenu:(id)sender{
    CBAppDelegate *delegate = (CBAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate.menuController showLeftController:YES];
    
}

- (void)viewDidUnload {
    [self setContentView:nil];

    [super viewDidUnload];
}

#pragma mark open views

- (void)showLoginView{
    CBLoginView *loginView = [[CBLoginView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    
    [_contentView addSubview:loginView];
}


@end
