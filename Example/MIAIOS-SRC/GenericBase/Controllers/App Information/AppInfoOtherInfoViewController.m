//
//  AppInfoOtherInfoViewController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 13/08/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "AppInfoOtherInfoViewController.h"
#import "UIColor+AppColor.h"

@interface AppInfoOtherInfoViewController ()

@property (nonatomic, strong) NSURL* file;

@end

@implementation AppInfoOtherInfoViewController

- (instancetype)initWithTitle:(NSString*)title textFile:(NSURL*)file {
    
    self = [super init];
    
    self.file = file;
    self.title = title;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView* tw = [[UITextView alloc] init];
    
    tw.text = [NSString stringWithContentsOfURL:self.file encoding:NSUTF8StringEncoding error:nil];
    tw.font = [UIFont systemFontOfSize:14];
    tw.textColor = [UIColor appPrimaryTextColor];
    tw.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    
    self.view = tw;
    
    
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
