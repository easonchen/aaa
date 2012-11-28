//
//  CBMasterViewController.h
//  CipherBox
//
//  Created by boffo lin on 12/11/27.
//  Copyright (c) 2012年 wada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBMasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end
