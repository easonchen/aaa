//
//  CBPopUpView.m
//  CipherBox
//
//  Created by Eason Chen on 12/6/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBPopUpView.h"
#import "CBMasterTableController.h"

@implementation CBPopUpView{
	float parent_width;
	float parent_height;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		float view_height = frame.size.height;
		float view_width = frame.size.width;
		float button_width = view_width / 2 - 10;
		float button_height = view_height - 10;
		
		self.backgroundColor = [UIColor grayColor];
		
		btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btnDone.frame = CGRectMake(5, 5, button_width, button_height);
		[btnDone addTarget:self action:@selector(onDonePressed:) forControlEvents:UIControlEventTouchUpInside];
		[btnDone setTitle:@"Done" forState:UIControlStateNormal];
		[self addSubview:btnDone];
		
		btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btnCancel.frame = CGRectMake(view_width/2 + 5, 5, button_width, button_height);
		[btnCancel addTarget:self action:@selector(onCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
		[btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
		[self addSubview:btnCancel];
		
	
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndParent:(CBMasterTableController*)p{
	parent = p;
	parent_height = parent.navigationController.view.frame.size.height;
	parent_width = parent.navigationController.view.frame.size.width;
	
	self = [self initWithFrame:frame];
	return self;
}

- (void)showWithAnimated:(BOOL)animate{
	[self setFrame:CGRectMake(0, parent_height, parent_width, 44)];
	[parent.navigationController.view addSubview:self];
	
	[UIView beginAnimations:@"foo" context:nil];
	[UIView setAnimationDuration:0.5f];
	
	self.frame = CGRectMake(0, parent_height - 44, parent_width, 44);
	
	[UIView commitAnimations];
}

- (void)hideWithAnimated:(BOOL)animate{
	
	if(animate){
		[UIView beginAnimations:@"animatePopUp" context:nil];
		[UIView animateWithDuration:0.5f
							  delay:0.0f
							options:UIViewAnimationOptionCurveLinear
						 animations:^{
							 [self setFrame:CGRectMake(0, parent_height, parent_width, 44)];
						 }
						 completion:^(BOOL finish){
							 [self removeFromSuperview];
						 }];
		
		[UIView commitAnimations];
	}
	else{
		[self setFrame:CGRectMake(0, parent_height, parent_width, 44)];
		[self removeFromSuperview];
	}
}




#pragma mark ---------- button actions ------------------

- (void)setConfirmAction:(SEL)callback{
	action = callback;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)onDonePressed:(id)sender{

	[parent performSelector:action withObject:[NSNumber numberWithBool:YES]];

}

- (void)onCancelPressed:(id)sender{

	[parent performSelector:action withObject:[NSNumber numberWithBool:NO]];
}

- (void)setEnable:(BOOL)able{
	[btnDone setEnabled:able];
	[btnCancel setEnabled:able];
}

#pragma clang diagnostic pop


@end
