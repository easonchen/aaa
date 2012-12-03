//
//  CipherBox
//
//  Created by boffo lin on 12/11/26.
//  Copyright (c) 2012年 wada. All rights reserved.
//

#import "CBDetailViewController.h"
#import "CBAppDelegate.h"
#import "DDMenuController.h"
#import "CBLoginViewController.h"
#import "CBLoginController.h"
#import "Box/Box.h"

@interface CBDetailViewController ()

@end

@implementation CBDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}
- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	if([[Box user] authToken].length > 0){	// already logged in
		[loginBtn setEnabled:NO];
		[self refreshAuthenticationStatus];
		// TODO: open master table and show the Cipher Root
	}
	else{
		CBLoginViewController *loginView = [[CBLoginViewController alloc] initWithNibName:@"CBLoginViewController" bundle:nil];
		[self presentModalViewController:loginView animated:YES];
	}
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

- (IBAction)performLogin:(id)sender {
	
	NSLog(@"start login...");
	[Box initiateLoginUsingURLRedirectWithCallbacks:nil];
}

- (IBAction)performLogout:(id)sender {
	[Box logoutWithCallbacks:^(id <BoxOperationCallbacks> on)
     {
         on.after(^(BoxCallbackResponse response)
				  {
					  labelID.text = @"-";
					  labelName.text = @"-";
					  labelToken.text = @"-";
					  
					  [loginBtn setEnabled:YES];
					  [logoutBtn setEnabled:NO];
				  });
     }];
	
}

- (void)viewDidUnload {
    [self setContentView:nil];

	logoutBtn = nil;
	loginBtn = nil;
	labelID = nil;
	labelName = nil;
	labelToken = nil;

    [super viewDidUnload];
}

- (void)refreshAuthenticationStatus{
	BoxCurrentUser *currentUser = [Box user];
	
	
	if(currentUser.username.length > 0){
		labelName.text = currentUser.username;
		labelID.text = currentUser.userID.stringValue;
		labelToken.text = currentUser.authToken;
	}
	else{
		[[Box user] updateAccountInformationWithCallbacks:^(id<BoxOperationCallbacks>on)
		 {
			 on.before(^
					   {
						   labelID.text = @"updating...";
						   labelName.text = @"...";
						   labelToken.text = @"...";
					   });
			 on.after(^(BoxCallbackResponse response)
					  {
						  if (response == BoxCallbackResponseSuccessful)
						  {
							  labelID.text = [[Box user] userID].stringValue;
							  labelName.text = [[Box user] username];
							  labelToken.text = [[Box user] authToken];
						  }
					  });
		 }];

	}
	
}



@end
