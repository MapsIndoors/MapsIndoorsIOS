//
//  AppInfoAcknowledgementViewController.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 12/10/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "AppInfoAcknowledgementViewController.h"
#import "UIViewController+Custom.h"


@interface AppInfoAcknowledgementViewController ()

@property (nonatomic, weak) UITextView*         textView;
@property (nonatomic, strong) NSDictionary*     acknowledgementDict;

@end


@implementation AppInfoAcknowledgementViewController

- (instancetype) initWithAcknowledgementDict:(NSDictionary*)ackDict {
    
    self = [super init];
    if (self) {
        _acknowledgementDict = ackDict;
    }

    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.acknowledgementDict[@"Title"];
    [self presentCustomBackButton];
    
    UITextView* textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.font = [UIFont systemFontOfSize:17];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textView.alwaysBounceVertical = YES;
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];

    self.textView = textView;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *marginsGuide = self.view.readableContentGuide;
    [NSLayoutConstraint activateConstraints:@[[textView.topAnchor constraintEqualToAnchor:marginsGuide.topAnchor], [textView.bottomAnchor constraintEqualToAnchor:marginsGuide.bottomAnchor], [textView.leadingAnchor constraintEqualToAnchor:marginsGuide.leadingAnchor], [textView.trailingAnchor constraintEqualToAnchor:marginsGuide.trailingAnchor]]];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];

    // Need to set the textView text after the layout is completed, so that the content inset and offset properties can be adjusted automatically.
    NSString*   hdr = [NSString stringWithFormat:NSLocalizedString(@"License: %@",), self.acknowledgementDict[@"License"]];
    
    self.textView.text = [hdr stringByAppendingFormat:@"\n\n%@", self.acknowledgementDict[@"FooterText"]];
}

@end
