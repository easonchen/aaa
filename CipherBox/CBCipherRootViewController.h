//
//  CBCipherRootViewController.h
//  CipherBox
//
//  Created by Eason Chen on 12/3/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Box/Box.h"

@interface CBCipherRootViewController : UITableViewController

@property (nonatomic, readwrite, retain) BoxID* folderID;
@property (nonatomic, readwrite, retain) BoxFolder* folder;

-(id)initCipherRoot;
@end
