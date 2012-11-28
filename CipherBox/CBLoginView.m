//
//  CBLoginView.m
//  CipherBox
//
//  Created by Eason Chen on 11/28/12.
//  Copyright (c) 2012 wada. All rights reserved.
//

#import "CBLoginView.h"

@implementation CBLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"CBLoginView" owner:self options:nil];
        [self addSubview:[screens objectAtIndex:0]];
        
        [logoImg setImage:[UIImage imageNamed:@"cipherbox_logo"]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)performLogin:(id)sender{
    NSLog(@"login!");
    
}

@end
