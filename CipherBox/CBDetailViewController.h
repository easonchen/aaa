//
//  CipherBox
//
//  Created by boffo lin on 12/11/26.
//  Copyright (c) 2012年 wada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBDetailViewController : UIViewController{
    IBOutlet UIBarButtonItem *menuBtn;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)openMenu:(id)sender;

- (void)showLoginView;

@end
