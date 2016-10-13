//
//  ViewController.m
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "ViewController.h"
#import "DViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)clickmybutton:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:l];
    [l setBackgroundColor:[UIColor redColor]];
    [l setUserInteractionEnabled:YES];
    [l addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click11)]];
    
    
}

- (void)click11
{
    SEL aa = [self a];
    [self presentViewController:[[DViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)crashClick:(id)sender {
    
    NSMutableArray *a = [NSMutableArray array];
    [a addObject:nil];
}

- (IBAction)click:(UIButton *)sender {
    
//    NSMutableArray *a = [NSMutableArray array];
//    [a addObject:nil];
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//}


@end
