//
//  CBNewFolderCell.m
//  CipherBox
//
//  Created by Eason Chen on 12/6/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBNewFolderCell.h"
#import "CBMasterTableController.h"

@interface CBNewFolderCell(){
	CBMasterTableController* _parent;
}

@end

@implementation CBNewFolderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		
    }
    return self;
}


- (void)awakeFromNib{
	[super awakeFromNib];
	NSLog(@"awakeFromNib");
	
	[_indicator stopAnimating];
	[_indicator setHidden:YES];
	//[textName becomeFirstResponder];
	//[textName setBorderStyle:UITextBorderStyleBezel];
}

- (void)setParent:(id)parent{
	_parent = parent;
	_textName.delegate = parent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	[_textName becomeFirstResponder];
    // Configure the view for the selected state
}

@end
