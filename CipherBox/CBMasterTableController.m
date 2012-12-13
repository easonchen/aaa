//
//  CBMasterTableController.m
//  CipherBox
//
//  Created by Eason Chen on 11/30/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBMasterTableController.h"
#import "CBPopUpView.h"
#import "CBNewFolderCell.h"
#import "CBNormalCell.h"
#import "CBSummaryCell.h"
#import "Box/Box.h"
#import "Toast+UIView.h"
#import <QuartzCore/QuartzCore.h>

#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"

//#import "Box/BoxObject.h"

#define createFolderPopupTag 11

@interface CBMasterTableController (){
	NSMutableArray *visibleChildren;
	CBPopUpView* _popup;
	UIPopoverController *popover;
	BOOL isCreatingFolder;
	BOOL isDeleting;
	int numOfFolders;
	int numOfFiles;
}

@end

@implementation CBMasterTableController

- (id)initWithFolderID:(BoxID *)folderID{
	self = [super init];
	if(self){
		self.folderID = folderID;
		self.folder = [Box folderWithID:folderID];
		
		isCreatingFolder = NO;
		isDeleting = NO;
		numOfFiles = 0;
		numOfFolders = 0;
	}
	
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	//	NSLog(@"ViewDidLoad");
	self.title = @"Loading...";
	self.navigationController.toolbarHidden = NO;
	self.tableView.allowsMultipleSelectionDuringEditing = YES;
	
	// toolbar stuff
	UIBarButtonItem* flexiable = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem* upload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_upload"] style:UIBarButtonItemStylePlain target:self action:@selector(tbUpload:)];
	UIBarButtonItem* delete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(tbDelete:)];
	UIBarButtonItem* reload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_reload"] style:UIBarButtonItemStylePlain target:self action:@selector(tbReload:)];
	UIBarButtonItem* rename = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_rename"] style:UIBarButtonItemStylePlain target:self action:nil];
	UIBarButtonItem* add_foler = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_addfolder"] style:UIBarButtonItemStylePlain target:self action:@selector(tbCreateFolder:)];
	
	self.toolbarItems = @[upload,flexiable,delete,flexiable,rename,flexiable,add_foler,flexiable,reload, flexiable];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)viewDidUnload{
	[super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	visibleChildren = nil;
	_popup = nil;
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//	NSLog(@"viewWillAppear");
	[self refrashTableViewSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard notification
float org_height;

- (void)keyboardDidShow:(NSNotification *)notification {
	CGRect start, end;
	
	// position before keyboard animation
	[[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&start];
	// position after keyboard animation
	[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&end];
	
	double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	
	org_height = self.navigationController.view.frame.size.height;
	
	[UIView beginAnimations:@"foo" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:curve];

	_popup.frame = CGRectMake(0, _popup.frame.origin.y - end.size.height, _popup.frame.size.width, _popup.frame.size.height);
	
	[UIView commitAnimations];
	
	NSIndexPath* ipath = [NSIndexPath indexPathForRow: visibleChildren.count inSection: 0];
	CBNewFolderCell *cell =(CBNewFolderCell*)[self.tableView cellForRowAtIndexPath:ipath];
	[cell.textName becomeFirstResponder];
}

- (void) keyboardWillHide:(NSNotification *)notification {
	double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	
	[UIView beginAnimations:@"foo" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:curve];
	_popup.frame = CGRectMake(0, org_height - 44, _popup.frame.size.width, _popup.frame.size.height);
	[UIView commitAnimations];
}

#pragma mark - refresh the folder tree from Box.com
- (void)refrashTableViewSource{

	[self.folder updateWithCallbacks:^(id<BoxOperationCallbacks> on) {
		on.after(^(BoxCallbackResponse response){
			self.title = self.folder.name;
			NSMutableArray *tmp = [[NSMutableArray alloc] init];
			numOfFiles = 0;
			numOfFolders = 0;
			
			for(BoxObject* obj in self.folder.children){
				if(obj.isFolder){
					if([obj.name isEqualToString:@"ioh"])
						continue;
					else{
						numOfFolders ++;
					}
				}
				
				if(obj.isFile){
					if([obj.name hasSuffix:@".ioh"])
						continue;
					else{
						numOfFiles ++;
					}
				}
				
				
				[tmp addObject:obj];
			}
			visibleChildren = tmp;
			
			[self.tableView reloadData];
		});
	}];
	
}
#pragma mark - Toolbar actions

- (void)tbReload:(id)sender{
	[visibleChildren removeAllObjects];
	self.title = @"Loading...";
	[self.tableView reloadData];
	
	[self refrashTableViewSource];
}

- (void)tbUpload:(id)sender{
	
	ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setSingleSelection:YES];
	[albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
	
	popover = [[UIPopoverController alloc] initWithContentViewController:elcPicker];

    [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	//    [self presentModalViewController:imagePicker animated:YES];
}

- (void)tbCreateFolder:(id)sender{
	
	// ==== Create pop-up confirm subview ======
	float parent_height = self.navigationController.view.frame.size.height;
	float parent_width = self.navigationController.view.frame.size.width;
	//	double CurrentTime = CACurrentMediaTime();
	if(nil == _popup){
		_popup = [[CBPopUpView alloc] initWithFrame:CGRectMake(0, parent_height - 44, parent_width, 44) AndParent:self];
		[_popup setTag:createFolderPopupTag];
	}
	//	NSLog(@"total time:%f", CACurrentMediaTime() - CurrentTime);
	[_popup setEnable:YES];
	[_popup setConfirmAction:@selector(confirmCreateFolder:)];
	[_popup showWithAnimated:YES];
	
	[self.navigationItem setHidesBackButton:YES animated:YES];
	
	// ==== Create new empty cell view ====
	isCreatingFolder = YES;
	[self.tableView reloadData];
	
	
	// ==== Scroll to the end ====
	NSIndexPath* ipath = [NSIndexPath indexPathForRow: visibleChildren.count + 1 inSection: 0];
	[self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionNone animated: YES];
	
}

- (void)tbDelete:(id)sender{
	isDeleting = YES;
	[self.tableView reloadData];
	[self.tableView setEditing:YES animated:YES];

	self.title = @"Select files to delete";
	// ==== Create pop-up confirm subview ======
	float parent_height = self.navigationController.view.frame.size.height;
	float parent_width = self.navigationController.view.frame.size.width;
	//	double CurrentTime = CACurrentMediaTime();
	if(nil == _popup){
		
		_popup = [[CBPopUpView alloc] initWithFrame:CGRectMake(0, parent_height - 44, parent_width, 44) AndParent:self];
		[_popup setTag:createFolderPopupTag];
		
	}
	//	NSLog(@"total time:%f", CACurrentMediaTime() - CurrentTime);
	[_popup setConfirmAction:@selector(confirmDelete:)];
	[_popup setEnable:YES];
	
	// animation pop-out
	[_popup showWithAnimated:YES];
	
	[self.navigationItem setHidesBackButton:YES animated:YES];
	
}

#pragma mark - tool bar actions callback
-(void)confirmCreateFolder:(NSNumber*)resultN {
	
	// ==== dismiss confirm subview ====
	BOOL result = [resultN boolValue];
	
	// get new folder name
	NSIndexPath* ipath = [NSIndexPath indexPathForRow: visibleChildren.count inSection: 0];
	CBNewFolderCell *cell =(CBNewFolderCell*)[self.tableView cellForRowAtIndexPath:ipath];
	NSString * newname = [cell.textName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	// ==== create folder operation ===
	if(result && ![newname isEqualToString:@""]){	// if done && file name is not blank
		[cell.textName resignFirstResponder];
		[cell.indicator startAnimating];
		[cell.indicator setHidden:NO];
		cell.subLabel.text = @"Creating folder...";
		[_popup setEnable:NO];
		
		// create folder on Box.com
		[Box createFolderWithName:newname parentFolderID:self.folderID share:NO callbacks:^(id<BoxOperationCallbacks> on) {
			on.after(^(BoxCallbackResponse response) {
				
				// restore UI
				[_popup hideWithAnimated:YES];
				[self leaveCreateMode];
				
				if (response == BoxCallbackResponseSuccessful) {
					[self refrashTableViewSource];
				} else {

					UIAlertView* alert = [[UIAlertView alloc]
										  initWithTitle:@"Error!"
										  message:[NSString stringWithFormat:@"Unable to create folder: '%@', please check if there is any duplicated naming.",newname ]
										  delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
					[alert show];
					
					//[self.tableView reloadData];
				}
				
			});
		}];
		
	}
	else{
		[_popup hideWithAnimated:YES];
		[self leaveCreateMode];
	}
	
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	NSLog(@"return! %@",textField.text);
	[textField resignFirstResponder];
	[self confirmCreateFolder:[NSNumber numberWithBool:YES]];
	return YES;
}

-(void) confirmDelete:(NSNumber*)resultN{
	
	BOOL result = [resultN boolValue];

	[_popup hideWithAnimated:YES];
	
	NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
	
	if(result && selectedRows.count != 0){
		// pop up confirm action sheet
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
									  initWithTitle:@"Do you really want to delete these files?"
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:@"OK"
									  otherButtonTitles:@"Cancel",nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
		[actionSheet showInView:self.tableView];	// show from our table view (pops up in the middle of the table)
	}
	else{
		[self leaveDeleteMode];
	}
	
}

- (void)leaveCreateMode{
	isCreatingFolder = NO;
	[self.tableView reloadData];
	[self.navigationItem setHidesBackButton:NO animated:YES];
	
}

- (void)leaveDeleteMode{
	isDeleting = NO;
	[self.tableView reloadData];
	[self.tableView setEditing:NO animated:YES];
	[self.navigationItem setHidesBackButton:NO animated:YES];
	
	self.title = self.folder.name;

}

NSObject* locker;
int total;
int now;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex == 0){	// OK pressed
		NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
		locker = [[NSObject alloc]init];
		total = selectedRows.count;
		now = 0;
		
		// show the indicator
		[self.view makeToastActivity];
		
		// delete files in the queue
		for (NSIndexPath *selectionIndex in selectedRows)
		{
			BoxObject* obj = (BoxObject*)[visibleChildren objectAtIndex:selectionIndex.row];
			[self performSelectorInBackground:@selector(deleteThreadMethod:) withObject:obj];
		}
		
	}
	else{
		[self leaveDeleteMode];
	}
	
}


- (void)deleteThreadMethod:(id)del{
	@synchronized(locker){
		BoxObject* obj = (BoxObject*)del;
		
		[Box deleteItem:obj withCallbacks:^(id<BoxOperationCallbacks> on) {
			on.after(^(BoxCallbackResponse response) {
				if (response == BoxCallbackResponseSuccessful) {
					now++;
					NSLog(@"deleted %d of %d",now,total);
					if(obj.isFile)
						numOfFiles--;
					else
						numOfFolders--;
					
					if(now == total){
						[self performSelectorOnMainThread:@selector(endOfDeleteThreads) withObject:nil waitUntilDone:NO];
					}
					
				} else {
					[BoxErrorHandler presentErrorAlertViewForResponse:response];
				}
			});
		}];
	}
}

- (void)endOfDeleteThreads{
	// hide toast indicator
	[self.view hideToastActivity];
	//
	
	NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
	
	NSMutableArray *deletionArray = [NSMutableArray array];
	for (NSIndexPath *selectionIndex in selectedRows)
	{
		[deletionArray addObject:[visibleChildren objectAtIndex:selectionIndex.row]];
	}
	[visibleChildren removeObjectsInArray:deletionArray];

	// reload data??
	[self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView reloadData];
	
	[self leaveDeleteMode];
}


#pragma mark - ELCImagePicker delegate method
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
		[popover dismissPopoverAnimated:YES];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
	[popover dismissPopoverAnimated:YES];
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
	if(isCreatingFolder)
		return [visibleChildren count] + 2;
	else if(isDeleting)
		return [visibleChildren count];		// do not allow the folder count cell to appear in delete mode
	else
		return [visibleChildren count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

	int row = indexPath.row;
	
	if(row < visibleChildren.count){	// normal folders

		cell = [CBNormalCell cellForChild:visibleChildren atIndexPath:indexPath inTableView:tableView];
		
	}
	else if(isCreatingFolder && row == visibleChildren.count){	// last folder in creating mode
		cell = [tableView dequeueReusableCellWithIdentifier:@"newFolderCell"];
		//			double current = CACurrentMediaTime();
		if(nil == cell){
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CBNewFolderCell" owner:self options:nil];
			CBNewFolderCell* tmp = [topLevelObjects objectAtIndex:0];

			[tmp setParent:self];
			cell = tmp;
		}
		
	}
	else{				// the end of list, showing file counting information
		cell = [CBSummaryCell cellForFolderNumber:numOfFolders andFileNumber:numOfFiles inTableView:tableView];
		
	}
	
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	if(isCreatingFolder){
		// Do nothing if in creating folder mode
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else if(isDeleting){
		// Do nothing, let the default multi-selection icon works
	}
	else if(indexPath.row == visibleChildren.count){
		// Do nothing in the folder counts cell
	}
	else{
		BoxObject *obj = (BoxObject*) [visibleChildren objectAtIndex:indexPath.row];
		
		// only handle the folder child for now
		if(obj.isFolder){
			CBMasterTableController *next = [[CBMasterTableController alloc] initWithFolderID:obj.boxID];
			[self.navigationController pushViewController:next animated:YES];
		}
		else{
			NSLog(@"%@ owner: %@",obj.name,obj.owner.username);
		}
		
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

@end
