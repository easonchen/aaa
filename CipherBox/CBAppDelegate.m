//
//  CBAppDelegate.m
//  CipherBox
//
//  Created by boffo lin on 12/11/26.
//  Copyright (c) 2012年 wada. All rights reserved.
//

#import "CBAppDelegate.h"
#import "DDMenuController.h"
#import "CBDetailViewController.h"
#import "CBMasterViewController.h"

#import <Box/Box.h>


@implementation CBAppDelegate
@synthesize menuController = _menuController;
NSString * const NSURLIsExcludedFromBackupKey = @"NSURLIsExcludedFromBackupKey";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	[Box setBoxAPIKey:@"bvnso5cp7mf3jyjwtsjtd18k4xqmk9un"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[CBDetailViewController alloc] initWithNibName:@"CBViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[CBDetailViewController alloc] initWithNibName:@"CBDetailViewController_iPad" bundle:nil];
    }
	
	// ===== initiallizing left and right views =====
    DDMenuController *menuCon = [[DDMenuController alloc] initWithRootViewController:self.viewController];
    
    _menuController = menuCon;
    
    CBMasterViewController *leftCon = [[CBMasterViewController alloc] initWithNibName:@"CBMasterViewController" bundle:nil];
    UINavigationController *leftNavi = [[UINavigationController alloc] initWithRootViewController:leftCon];
    
    _menuController.leftViewController = leftNavi;
    
    self.window.rootViewController = self.menuController;
	
	// TODO: load cipherFolderID,  check for user logged in and pop-up login window
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	NSInteger intKey = [defaults integerForKey:@"CipherFolderID"];
//	self.CipherID = [NSNumber numberWithInt:intKey ];
//	
//	NSLog(@"stored number:%@",self.CipherID);
	
    [self.window makeKeyAndVisible];
    return YES;
}

// return from safari login
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

	if ([[url scheme] isEqualToString:@"helloboxeasonchen"])
    {
        [Box initializeSessionWithRedirectURL:url callbacks:^(id <BoxOperationCallbacks>on)
         {
             on.after(^(BoxCallbackResponse response)
					  {
						  if (response == BoxCallbackResponseSuccessful)
						  {
							  //[[NSNotificationCenter defaultCenter] postNotificationName:BOX_USER_DID_LOGIN_NOTIFICATION_NAME object:self];
							  [self.viewController dismissModalViewControllerAnimated:YES];
							  
							  BoxFolder* rootFolder = [Box rootFolder];
							  [rootFolder updateWithCallbacks:^(id<BoxOperationCallbacks> on) {
								  on.before(^(BoxCallbackResponse response){
									  //NSLog(@"Start retrieve folder tree...");
								  });
								  on.after(^(BoxCallbackResponse response) {
									  for(BoxObject* obj in rootFolder.children){
										  BoxFolder* folder = (BoxFolder*)obj;
										  //NSLog(@"%@", folder.name);
										  
										  if([folder.name isEqualToString:@"CipherBox"]){
											  //NSLog(@"Cipher ID:%@", folder.boxID);
											  self.CipherID = folder.boxID;
											  break;
										  }
									  }
									  // write to database
									  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
									  [defaults setInteger:[self.CipherID integerValue] forKey:@"CipherFolderID"];
									  [defaults synchronize];
									  NSLog(@"key %@ stored", self.CipherID);
									  
									  // TODO: open master view with Cipher root 
								  });
								  
							  }];
							  
							  [self.viewController refreshAuthenticationStatus];
						  }
					  });
         }];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
