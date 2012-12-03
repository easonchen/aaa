//
//  CBMasterTableController.h
//  CipherBox
//
//  Created by Eason Chen on 11/30/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Box/BoxFolder.h>

@interface CBMasterTableController : UITableViewController{
}

@property (nonatomic, readwrite, retain) BoxID *folderID;
@property (nonatomic, readwrite, retain) BoxFolder *rootFolder;
@property (nonatomic, readwrite) BOOL isCipherRoot;

- (id)initWithFolderID:(BoxID*)folderID;
- (id)initWithCipherRoot;
- (void)refrashTableViewSource;

@end
