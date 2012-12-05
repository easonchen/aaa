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
//#import "CBLoginController.h"
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
	
	if([[Box user] authToken].length <= 0){		// if not logged in, pop-up login window
		CBLoginViewController *loginView = [[CBLoginViewController alloc] initWithNibName:@"CBLoginViewController" bundle:nil];
		
		//		self.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		//		self.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentModalViewController:loginView animated:YES];
	}
	else{
		NSLog(@"user eamil: %@",[[Box user] username]);
		NSLog(@"authtoken: %@", [[Box user] authToken]);
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

- (IBAction)openMenu:(id)sender{
    CBAppDelegate *delegate = (CBAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate.menuController showLeftController:YES];
    
}

- (IBAction)performLoginOut:(id)sender{
	[logoutBtn setEnabled:NO];
	if([[Box user] authToken].length > 0){	// already logged in, button perform "logout" action

		[Box logoutWithCallbacks:^(id <BoxOperationCallbacks> on)
		 {
			 on.after(^(BoxCallbackResponse response)
					  {
						  //[loginBtn setEnabled:YES];
						  [logoutBtn setEnabled:YES];
						  [logoutBtn setTitle:@"Login"];
						  [logoutBtn setTintColor:[UIColor colorWithRed:51.0/255.0 green:153/255.0 blue:51.0/255.0 alpha:255]];
						  
					  });
		 }];

	}
	else{	// perform "login" action
		[Box initiateLoginUsingURLRedirectWithCallbacks:^(id <BoxOperationCallbacks> on)
		 {
			 on.after(^(BoxCallbackResponse response)
					  {
						  //[loginBtn setEnabled:YES];
						  //NSLog(@"user eamil: %@",[[Box user] username]);
						  //NSLog(@"authtoken: %@", [[Box user] authToken]);

						  [logoutBtn setEnabled:YES];
						  [logoutBtn setTitle:@"Logout"];
						  [logoutBtn setTintColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:255]];
						  
					  });
		 }];
	}
}


- (void)viewDidUnload {
	logoutBtn = nil;

    [super viewDidUnload];
}


  // disable for not showing this information anymore.....
- (void)refreshAuthenticationStatus{
	NSLog(@"user eamil: %@",[[Box user] username]);
	NSLog(@"authtoken: %@", [[Box user] authToken]);
	
	/*
	if(currentUser.username.length > 0){
		labelName.text = currentUser.username;
		labelID.text = currentUser.userID.stringValue;
		labelToken.text = currentUser.authToken;
		
	}
	else{
		[[Box user] updateAccountInformationWithCallbacks:^(id<BoxOperationCallbacks>on)
		 {
			 on.after(^(BoxCallbackResponse response)
					  {
						  if (response == BoxCallbackResponseSuccessful)
						  {
//							  labelID.text = [[Box user] userID].stringValue;
//							  labelName.text = [[Box user] username];
//							  labelToken.text = [[Box user] authToken];
							  
						  }
					  });
		 }];

	}
	 */
	
}



@end
