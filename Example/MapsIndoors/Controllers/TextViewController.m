//
//  TextViewController.m
//  Bella Center Wayfinder
//
//  Created by Daniel Nielsen on 22/01/16.
//  Copyright © 2016 MapsPeople A/S. All rights reserved.
//

#import "TextViewController.h"
#import "UIColor+AppColor.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.text;
    // Do any additional setup after loading the view.
    self.textView.editable = NO;
    self.backIconView.image = [self.backIconView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.backIconView.tintColor = [UIColor appPrimaryColor];
    [self.backIconView setUserInteractionEnabled:YES];
    self.backIconView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pop:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.backIconView addGestureRecognizer:singleTap];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = self.text;
}

- (void) pop: (id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
