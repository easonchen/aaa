//
//  CipherBox
//
//  Created by boffo lin on 12/11/26.
//  Copyright (c) 2012年 wada. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BOX_USER_DID_LOGIN_NOTIFICATION_NAME    @"box_user_did_login_notification"
@interface CBDetailViewController : UIViewController{
    IBOutlet UIBarButtonItem *menuBtn;
	IBOutlet UIButton *loginBtn;
    IBOutlet UIButton *logoutBtn;
    
    IBOutlet UILabel *labelID;
    IBOutlet UILabel *labelName;
    IBOutlet UILabel *labelToken;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)openMenu:(id)sender;
- (IBAction)performLogin:(id)sender;
- (IBAction)performLogout:(id)sender;

- (void)showLoginView;
- (void)refreshAuthenticationStatus;
@end
