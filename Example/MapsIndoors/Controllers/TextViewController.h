//
//  TextViewController.h
//  Bella Center Wayfinder
//
//  Created by Daniel Nielsen on 22/01/16.
//  Copyright © 2016 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController


@property (nonatomic, strong) NSString *text;
@property (nonatomic, weak) IBOutlet UIImageView *backIconView;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
