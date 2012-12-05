//
//  CBMasterTableController.m
//  CipherBox
//
//  Created by Eason Chen on 11/30/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBMasterTableController.h"
#import "Box/Box.h"
//#import "Box/BoxObject.h"


@interface CBMasterTableController (){
	NSMutableArray *visibleChildren;
	
}

@end

@implementation CBMasterTableController

- (id)initWithFolderID:(BoxID *)folderID{
	self = [super init];
	if(self){
		self.folderID = folderID;
		self.folder = [Box folderWithID:folderID];
	}
	
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Loading...";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self refrashTableViewSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark refresh the folder tree
- (void)refrashTableViewSource{
	[self.folder updateWithCallbacks:^(id<BoxOperationCallbacks> on) {
		on.after(^(BoxCallbackResponse response){
			self.title = self.folder.name;
			NSMutableArray *tmp = [[NSMutableArray alloc] init];

			for(BoxObject* obj in self.folder.children){
				if([obj.name isEqualToString:@"ioh"] && [obj isFolder])
					continue;
				
				if([obj.name hasSuffix:@".ioh"] && [obj isFile])
					continue;
				
				[tmp addObject:obj];
			}
			visibleChildren = tmp;
			
			[self.tableView reloadData];
		});
	}];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
	return [visibleChildren count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
	BoxObject* inst = (BoxObject*)[visibleChildren objectAtIndex:indexPath.row];
	
	cell.textLabel.text = inst.name;
	cell.detailTextLabel.text = inst.subtitle;
	if([inst isFolder]){
		if([inst hasCollaboratorsObject])
			cell.imageView.image = [UIImage imageNamed:@"folder_user_4x"];
		else
			cell.imageView.image = [UIImage imageNamed:@"folder_4x"];
	}
	else{
		cell.imageView.image = [UIImage imageNamed:@"pages_4x"];
	}	
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	BoxObject *obj = (BoxObject*) [visibleChildren objectAtIndex:indexPath.row];
	
	// only handle the folder child for now
	if(obj.isFolder){
		CBMasterTableController *next = [[CBMasterTableController alloc] initWithFolderID:obj.boxID];
		[self.navigationController pushViewController:next animated:YES];
	}
	
}

@end
