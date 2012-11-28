//
//  CBMasterViewController.m
//  CipherBox
//
//  Created by boffo lin on 12/11/27.
//  Copyright (c) 2012年 wada. All rights reserved.
//

#import "CBMasterViewController.h"

@interface CBMasterViewController ()

@end

@implementation CBMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"master view"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
}

#pragma mark UITableViewDataSource
-(UITableViewCell*) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"Test";
    cell.detailTextLabel.text = @"under line";
    cell.imageView.image = [UIImage imageNamed:@"cipherbox_icon"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBMasterViewController *next = [[CBMasterViewController alloc] initWithNibName:@"CBMasterViewController" bundle:nil];
    
    [self.navigationController pushViewController:next animated:YES];
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}
@end
