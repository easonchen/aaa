//
//  CBNormalCell.h
//  CipherBox
//
//  Created by Eason Chen on 12/12/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBNormalCell : UITableViewCell


+ (UITableViewCell*)cellForChild:(NSArray*)children atIndexPath:(NSIndexPath*)index inTableView:(UITableView*)tableView;
@end
