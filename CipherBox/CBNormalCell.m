//
//  CBNormalCell.m
//  CipherBox
//
//  Created by Eason Chen on 12/12/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBNormalCell.h"
#import "Box/Box.h"

@implementation CBNormalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UITableViewCell*)cellForChild:(NSArray *)children atIndexPath:(NSIndexPath *)index inTableView:(UITableView *)tableView{

	static NSString *CellIdentifier = @"Cell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(nil == cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	
	BoxObject* inst = (BoxObject*)[children objectAtIndex:index.row];
	BoxFolder* fo = [Box folderWithID:inst.boxID];
	
	cell.textLabel.text = inst.name;
	cell.detailTextLabel.text = inst.subtitle;
	
	
	if(inst.isFolder){
		if(fo.hasCollaborators){
			
			cell.imageView.image = [UIImage imageNamed:@"folder_user"];
		}
		else
			cell.imageView.image = [UIImage imageNamed:@"folder"];
	}
	else
		cell.imageView.image = [UIImage imageNamed:@"page_white_text"];
	
	return cell;

}

@end
