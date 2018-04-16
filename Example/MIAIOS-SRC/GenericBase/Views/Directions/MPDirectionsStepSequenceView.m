//
//  MPDirectionsStepSequenceView.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 15/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPDirectionsStepSequenceView.h"
#import "MPDirectionsStepSequenceViewModel.h"
#import "MPDirectionsStepView.h"


@class MPDirectionsStepViewModel;


@interface MPDirectionsStepSequenceView ()

@property (nonatomic, strong) NSMutableArray<MPDirectionsStepView*>*    stepViews;

@end


@implementation MPDirectionsStepSequenceView

- (instancetype) initWithFrame:(CGRect)aRect {
    
    self = [super initWithFrame:aRect];
    [self commonInit];
    return self;
}

- (instancetype) initWithCoder:(NSCoder*)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (void) commonInit {

    self.stepHeight = 56;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
}

- (void) setViewModel:(MPDirectionsStepSequenceViewModel *)viewModel {
    
    if ( _viewModel != viewModel ) {
        
        _viewModel = viewModel;
        [self setNeedsLayout];
        
        [[self.subviews copy] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        self.stepViews = [NSMutableArray array];
        [self generateStepViewsFromIndex:0 count:25];
        [self scheduleGenerationOfNextStepViewBatch];
    }
}

- (CGSize) intrinsicContentSize {
    
    CGFloat h = self.viewModel.numberOfSteps * self.stepHeight;
    CGFloat w = self.stepHeight * 5;        // 5: width is 1 part image, 4 parts text in the "step-views"
    
    return CGSizeMake( w, h );
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    if ( self.stepViews.count ) {
        
        CGFloat dy = self.bounds.size.height / (CGFloat)self.stepViews.count;

        if ( self.stepViews.count < self.viewModel.numberOfSteps ) {
            dy = self.stepHeight;
        }

        CGRect  r = CGRectMake(0, 0, self.bounds.size.width, self.stepHeight);
        for ( UIView* stepView in self.stepViews ) {
            if ( CGRectEqualToRect(r, stepView.frame) == NO ) {
                stepView.frame = r;
            }
            r.origin.y += dy;
        }
    }
}

- (void) generateStepViewsFromIndex:(NSUInteger)index count:(NSUInteger)count {
    
    for ( NSUInteger i=index; (i < self.viewModel.numberOfSteps) && (count > 0); ++i, --count ) {
        MPDirectionsStepView*       stepView = [[MPDirectionsStepView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.stepHeight)];
        [stepView configureWithModel:[self.viewModel modelForStepAtIndex:i]];
        [self.stepViews addObject:stepView];
        [self addSubview:stepView];
    }
}

- (void) scheduleGenerationOfNextStepViewBatch {
    
    if ( self.stepViews.count < self.viewModel.numberOfSteps ) {
        
        __weak __typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if ( strongSelf ) {
                [strongSelf generateStepViewsFromIndex:self.stepViews.count count:10];
                [strongSelf scheduleGenerationOfNextStepViewBatch];
            }
        });
    }
}

@end
