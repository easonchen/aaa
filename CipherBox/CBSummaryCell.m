//
//  CBSummaryCell.m
//  CipherBox
//
//  Created by Eason Chen on 12/12/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBSummaryCell.h"

@implementation CBSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+(UITableViewCell*)cellForFolderNumber:(int)numFolder andFileNumber:(int)numFile inTableView:(UITableView *)tableView{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"emptyFolderCell"];
	if(nil == cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyFolderCell"];
		cell.textLabel.textColor = [UIColor lightGrayColor];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		[cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:14]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
	NSString* format;
	if(numFile == 0 && numFolder == 0)
		format = @"Empty folder";
	else if(numFile == 0)
		format = [NSString stringWithFormat:@"%d folders", numFolder];
	else if(numFolder == 0)
		format = [NSString stringWithFormat:@"%d files", numFile];
	else
		format = [NSString stringWithFormat:@"%d folders ∙ %d files", numFolder, numFile];
	
	cell.textLabel.text = format;
	
	return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
