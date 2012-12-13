//
//  CBSummaryCell.h
//  CipherBox
//
//  Created by Eason Chen on 12/12/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSummaryCell : UITableViewCell

+(UITableViewCell*)cellForFolderNumber:(int)numFolder andFileNumber:(int)numFile inTableView:(UITableView*)tableView;

@end
