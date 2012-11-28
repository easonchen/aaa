//
//  CBLoginView.h
//  CipherBox
//
//  Created by Eason Chen on 11/28/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLoginView : UIView{
    IBOutlet UIButton *loginBtn;
    IBOutlet UIImageView *logoImg;
}

- (IBAction)performLogin:(id)sender;

@end
