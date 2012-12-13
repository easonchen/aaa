//
//  AssetTablePicker.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"


@implementation ELCAssetTablePicker{
	ELCAsset* lastAsset;
}

//@synthesize parent;
//@synthesize selectedAssetsLabel;
//@synthesize assetGroup, elcAssets;

-(void)viewDidLoad {
        
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    _elcAssets = tempArray;

	
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
	[self.navigationItem setTitle:@"Loading..."];

	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    
    // Show partial while full list loads
	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.5];
}

-(void)preparePhotos {
//    NSLog(@"enumerating photos");
    [_assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {         
         if(result == nil) 
         {
             return;
         }
         
         ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
         [elcAsset setParent:self];
         [_elcAssets addObject:elcAsset];
     }];    
//    NSLog(@"done enumerating photos");

	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Pick a photo"];


}

- (void)setSelectAsset:(ELCAsset *)item{
	if(_singleSelection){

		[lastAsset setSelected:NO];
		lastAsset = item;
	}
}

- (void) doneAction:(id)sender {
	
	NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
	    
	for(ELCAsset *elcAsset in _elcAssets)
    {		
		if([elcAsset selected]) {
			
			[selectedAssetsImages addObject:[elcAsset asset]];
		}
	}
        
    [(ELCAlbumPickerController*)_parent selectedAssets:selectedAssetsImages];
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil([self.assetGroup numberOfAssets] / 4.0);
}

- (NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	// NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
    
	if(maxIndex < [_elcAssets count]) {
        
		return [NSArray arrayWithObjects:[_elcAssets objectAtIndex:index],
				[_elcAssets objectAtIndex:index+1],
				[_elcAssets objectAtIndex:index+2],
				[_elcAssets objectAtIndex:index+3],
				nil];
	}
    
	else if(maxIndex-1 < [_elcAssets count]) {
        
		return [NSArray arrayWithObjects:[_elcAssets objectAtIndex:index],
				[_elcAssets objectAtIndex:index+1],
				[_elcAssets objectAtIndex:index+2],
				nil];
	}
    
	else if(maxIndex-2 < [_elcAssets count]) {
        
		return [NSArray arrayWithObjects:[_elcAssets objectAtIndex:index],
				[_elcAssets objectAtIndex:index+1],
				nil];
	}
    
	else if(maxIndex-3 < [_elcAssets count]) {
        
		return [NSArray arrayWithObject:[_elcAssets objectAtIndex:index]];
	}
    
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
        
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) 
    {		        
        cell = [[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];
    }	
	else 
    {		
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}

- (int)totalSelectedAssets {
    
    int count = 0;
    
    for(ELCAsset *asset in _elcAssets)
    {
		if([asset selected]) 
        {            
            count++;	
		}
	}
    
    return count;
}

- (void)dealloc 
{
   
}

@end
