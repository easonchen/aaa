//
//  CBShareViewController.m
//  CipherBox
//
//  Created by Eason Chen on 12/3/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBShareViewController.h"
#import "Box/Box.h"


@interface CBShareViewController (){
	NSMutableArray* _sharedFolders;
	BoxID* _rootID;
	BoxFolder* _rootFolder;
	NSOperationQueue* opQueue;
}

@end

@implementation CBShareViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initShareFolder{
	self = [super init];
	if(self){
		BoxID* rootID = [BoxID numberWithInt:0];
		_rootID = rootID;
		_rootFolder = [Box folderWithID:rootID];
		_sharedFolders = nil;
		opQueue = [[NSOperationQueue alloc]init];
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

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self refreashShareTree];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreashShareTree{
	
	[_rootFolder updateWithCallbacks:^(id<BoxOperationCallbacks> on) {
		on.after(^(BoxCallbackResponse response) {
			self.title = @"Files shared with me";
			if(_sharedFolders){
				[_sharedFolders removeAllObjects];
				_sharedFolders = nil;
			}
			_sharedFolders = [[NSMutableArray alloc] init];
			
			for(BoxObject* obj in _rootFolder.children){
				if([obj isFolder] && [obj.hasCollaboratorsObject intValue] > 0 ){
					//NSLog(@"%@ collaborators:%@ id:%@",obj.name, obj.hasCollaboratorsObject,obj.boxID);
					// ========== synchronous version =====
					NSNumber* ownerID = [self getFolderOwner:obj.boxID];
					//NSLog(@"owner id: %@", ownerID);
					NSNumber* myID = [Box.user userID];
				
					if(myID.intValue != ownerID.intValue){
						[_sharedFolders addObject:obj];
						[self.tableView reloadData];
					}
					
					// =========== asynchronous version =========
					//[self compareFolderOwner:obj.boxID];
				}
				
			}
			
			
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
	
	if(_sharedFolders)
		return [_sharedFolders count];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
    // Configure the cell...
	BoxObject* folder = (BoxObject*) [_sharedFolders objectAtIndex:indexPath.row];
	cell.textLabel.text = folder.name;
	cell.detailTextLabel.text = folder.subtitle;
	cell.imageView.image = [UIImage imageNamed:@"folder_user_4x"];
    
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
}

#pragma mark - call REST API to get the folder owner
//====== synchronous version ======
- (NSNumber*)getFolderOwner:(BoxID*)id{
	NSString* api_key = [Box boxAPIKey];
	NSString* auth_token = [[Box user] authToken];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSString* url = [NSString stringWithFormat:@"https://api.box.com/2.0/folders/%@",id.stringValue];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:url]];
	
	NSString *auth = [NSString stringWithFormat:@"BoxAuth api_key=%@&auth_token=%@", api_key, auth_token];
	[request setValue:auth forHTTPHeaderField:@"Authorization"];
	
	
	NSError* err = [[NSError alloc] init];
	NSHTTPURLResponse *responseCode = nil;
	
	
	// ========= synchronous version ======
	NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&err];

	if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
	
	NSDictionary* list = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingAllowFragments error:&err];
	NSDictionary* owner = [list objectForKey:@"owned_by"];
	NSNumber* uid = [owner objectForKey:@"id"];
	
		 
	
	
	return uid;
}

//========= asynchronous version ==========
-(void) compareFolderOwner:(BoxID*)folderID{
	NSString* api_key = [Box boxAPIKey];
	NSString* auth_token = [[Box user] authToken];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSString* url = [NSString stringWithFormat:@"https://api.box.com/2.0/folders/%@",folderID.stringValue];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:url]];
	
	NSString *auth = [NSString stringWithFormat:@"BoxAuth api_key=%@&auth_token=%@", api_key, auth_token];
	[request setValue:auth forHTTPHeaderField:@"Authorization"];
	
	// =========== asynchronous version =========
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[[NSOperationQueue alloc] init]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
	 {
         if ([data length] >0 && error == nil)
         {
			 NSError *err = [[NSError alloc]init];
			 NSDictionary* list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
			 
			 NSDictionary* owner = [list objectForKey:@"owned_by"];
			 NSNumber* uid = [owner objectForKey:@"id"];
			 
			 if([Box.user userID].intValue != uid.intValue){
				 [_sharedFolders addObject:[Box folderWithID:folderID]];
				 [self.tableView reloadData];
			 }
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
         }
		 
     }];

}


@end
