
//
//  DViewController.m
//  dwdmonitor
//
//  Created by dianwoda on 16/10/13.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "DViewController.h"

@interface DViewController ()

@end

@implementation DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [b setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:b];
    [b addTarget:self action:@selector(myclick:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)myclick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
