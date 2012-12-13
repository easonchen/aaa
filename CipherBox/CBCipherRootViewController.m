//
//  CBCipherRootViewController.m
//  CipherBox
//
//  Created by Eason Chen on 12/3/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBCipherRootViewController.h"
#import "CBMasterTableController.h"
#import "CBShareViewController.h"
#import "Box/Box.h"
@interface CBCipherRootViewController (){
	BoxObject* myfiles;
	BoxObject* shared;
}

@end

@implementation CBCipherRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initCipherRoot{
	NSLog(@"init cipher root");
	self = [super init];
	if(self){
		BoxID* rootID = [BoxID numberWithInt:0];
		self.folderID = rootID;
		self.folder = [Box folderWithID:rootID];
		
		//========= called once, fetch the Cipher Root ID
		//self.title = @"Loading...";
		NSLog(@"start fetch cipher root....");
		[self.folder updateWithCallbacks:^(id<BoxOperationCallbacks> on) {
			on.after(^(BoxCallbackResponse response) {
				for(BoxObject* obj in self.folder.children){
					if([obj.name isEqualToString:@"CipherBox"]){
						NSLog(@"cipher ID:%@", obj.boxID);
						self.folderID = obj.boxID;
						self.folder = [Box folderWithID:obj.boxID];
						break;
					}
				}
				[self refreshFolderTree];
				//            [self.tableView reloadData];
			});
		}];
		NSLog(@"wait for cipher ID");
		
	}
	
	return self	;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
//	//========= called once, fetch the Cipher Root ID
	self.title = @"Loading...";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[self refreshFolderTree];

}

- (void)refreshFolderTree{
	if(self.folderID.intValue == 0){
		return;
	}
	
	[self.folder updateWithCallbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response) {
			self.title = self.folder.name;
			for(BoxObject* obj in self.folder.children){
				if([obj.name hasPrefix:@"My"])
					myfiles = obj;
				else if([obj.name hasPrefix:@"Files"]){
					shared = obj;
				}
			}
			
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
	if(self.folderID.intValue == 0)
		return 0;
	else
		return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(nil == cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
	
	switch (indexPath.row) {
		case 0:{
			cell.textLabel.text = myfiles.name;
			cell.detailTextLabel.text = myfiles.subtitle;
			cell.imageView.image = [UIImage imageNamed:@"folder"];
			break;
		}
		case 1:{
			cell.textLabel.text = shared.name;
			cell.detailTextLabel.text = shared.subtitle;
			cell.imageView.image = [UIImage imageNamed:@"folder_user"];
			break;
		}
		default:
			break;
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
	
	if(indexPath.row == 0){
		CBMasterTableController *next = [[CBMasterTableController alloc] initWithFolderID:myfiles.boxID];
		[self.navigationController pushViewController:next animated:YES];
	}
	else if(indexPath.row == 1){
		CBShareViewController *share = [[CBShareViewController alloc] initShareFolder];
		[self.navigationController pushViewController:share animated:YES];
	}
	
}

@end
