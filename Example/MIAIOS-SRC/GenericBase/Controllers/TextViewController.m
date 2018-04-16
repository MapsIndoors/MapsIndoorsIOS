//
//  TextViewController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 22/01/16.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "TextViewController.h"
#import "UIColor+AppColor.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.text;
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

@end
