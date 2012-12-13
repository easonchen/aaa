//
//  CBNewFolderCell.h
//  CipherBox
//
//  Created by Eason Chen on 12/6/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBNewFolderCell : UITableViewCell{
	//IBOutlet UITextField *textName;
}
@property IBOutlet UITextField *textName;
@property IBOutlet UILabel *subLabel;
@property IBOutlet UIActivityIndicatorView *indicator;
- (void)setParent:(id)parent;


@end
