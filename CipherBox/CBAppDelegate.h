//
//  CBAppDelegate.h
//  CipherBox
//
//  Created by boffo lin on 12/11/26.
//  Copyright (c) 2012年 wada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Box/Box.h>

@class CBDetailViewController;
@class DDMenuController;

@interface CBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CBDetailViewController *viewController;

@property (strong, nonatomic) DDMenuController *menuController;

@property (nonatomic, readwrite, retain) BoxID *CipherID;

@end
