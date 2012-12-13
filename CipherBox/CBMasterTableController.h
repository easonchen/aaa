//
//  CBMasterTableController.h
//  CipherBox
//
//  Created by Eason Chen on 11/30/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Box/BoxFolder.h>
#import "ELCImagePickerController.h"

@interface CBMasterTableController : UITableViewController <ELCImagePickerControllerDelegate,UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>{
}

@property (nonatomic, readwrite, retain) BoxID *folderID;
@property (nonatomic, readwrite, retain) BoxFolder *folder;

- (id)initWithFolderID:(BoxID*)folderID;

- (void)refrashTableViewSource;
- (void)confirmCreateFolder:(NSNumber*)resultN;
@end
