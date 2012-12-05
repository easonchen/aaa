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

	IBOutlet UIBarButtonItem *logoutBtn;
    
}

- (IBAction)openMenu:(id)sender;

- (void)refreshAuthenticationStatus;
@end
