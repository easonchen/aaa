//
//  Asset.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAsset.h"
#import "ELCAssetTablePicker.h"

@implementation ELCAsset

@synthesize asset;
//@synthesize parent;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset {
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		
		self.asset = _asset;
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];

        
        
        // Eason modeified: add timestamp of video
        if([self.asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo){
            
            timestamp = [[UILabel alloc]init];
            timestamp.frame = CGRectMake(0, 55, 75, 20);
            timestamp.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            timestamp.textColor = [UIColor whiteColor];
            timestamp.textAlignment = UITextAlignmentRight;
            timestamp.userInteractionEnabled = NO;
            timestamp.font = [UIFont systemFontOfSize:14];
            timestamp.text = @"00:00";
            
            [self addSubview:timestamp];
            
            
            int seconds =(int)[(NSNumber *) [self.asset valueForProperty:ALAssetPropertyDuration] doubleValue];
            int sec = seconds % 60;
            int min = seconds / 60;
            
            timestamp.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
            
            videoIcon = [[UIImageView alloc] init];
            [videoIcon setImage:[UIImage imageNamed:@"video_icon"]];
            videoIcon.frame = CGRectMake(4, 55 + 3, 14, 14);
            [self addSubview:videoIcon];
            
        }
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
    }
    
	return self;	
}

-(void)toggleSelection {
    
	overlayView.hidden = !overlayView.hidden;
    [(ELCAssetTablePicker*)self.parent setSelectAsset:self];
//    if([(ELCAssetTablePicker*)self.parent totalSelectedAssets] >= 10) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Maximum Reached" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//		[alert show];
//		[alert release];	
//
//        [(ELCAssetTablePicker*)self.parent doneAction:nil];
//    }
}

-(BOOL)selected {
	
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {
    
	[overlayView setHidden:!_selected];
}

- (void)dealloc 
{    
    self.asset = nil;
}

@end

