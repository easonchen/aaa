//
//  CBPopUpView.h
//  CipherBox
//
//  Created by Eason Chen on 12/6/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBMasterTableController.h"

@interface CBPopUpView : UIView{
	UIButton* btnDone;
	UIButton* btnCancel;
	
	CBMasterTableController* parent;
	SEL action;
	id pp;
}

- (id)initWithFrame:(CGRect)frame AndParent:(CBMasterTableController*)p;
- (void)setConfirmAction:(SEL) callback;
- (void)setEnable:(BOOL)able;
- (void)showWithAnimated:(BOOL)animate;
- (void)hideWithAnimated:(BOOL)animate;

@end
