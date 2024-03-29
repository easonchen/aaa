//
//  AssetTablePicker.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAsset.h"
@interface ELCAssetTablePicker : UITableViewController
{
//	ALAssetsGroup *assetGroup;
	
//	NSMutableArray *elcAssets;
	int selectedAssets;
	
//	id parent;
	
	NSOperationQueue *queue;
}

@property (nonatomic, assign) id parent;
@property (nonatomic, assign) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) NSMutableArray *elcAssets;
@property (nonatomic, retain) IBOutlet UILabel *selectedAssetsLabel;
@property (nonatomic, assign) BOOL singleSelection;

-(int)totalSelectedAssets;
-(void)preparePhotos;
-(void)setSelectAsset:(ELCAsset*)item;
-(void)doneAction:(id)sender;

@end