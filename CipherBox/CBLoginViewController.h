//
//  CBLoginViewController.h
//  CipherBox
//
//  Created by Eason Chen on 11/28/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLoginViewController : UIViewController{
	IBOutlet UIImageView *logoImg;

}
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)startLogin:(id)sender;

@end
