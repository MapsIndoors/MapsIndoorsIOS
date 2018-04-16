//
//  MPDirectionsView.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 01/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPDirectionsView.h"
#import "MPDirectionsViewModel.h"
#import "MPDirectionsViewHeadlineModel.h"
#import "UIImage+MapsPeople.h"
#import "UIColor+AppColor.h"
#import "MPDirectionsHeadlineView.h"
#import "MPDirectionsStepSequenceView.h"
#import "MPDirectionsStepSequenceViewModel.h"
#import "SectionModel.h"
#import "Global.h"
#import "NSString+MD5.h"


@interface MPDirectionsView ()

@property (nonatomic, strong) MPDirectionsViewModel*        viewModel;
@property (nonatomic, strong) MPRoute*                      currentRoute;
@property (nonatomic, strong) RoutingData*                  routingData;
@property (nonatomic, strong) NSArray<SectionModel*>*       modelArray;
@property (nonatomic, strong) NSString*                     originType;
@property (nonatomic, strong) NSString*                     destinationType;

@property (nonatomic, weak, readwrite) UIScrollView*        scrollView;
@property (nonatomic, weak) UIView*                         dimmingView;
@property (nonatomic, weak) UIView*                         highlighView;
@property (nonatomic, strong) NSMutableArray<UIImageView*>* actionPoints;
@property (nonatomic, strong) NSMutableArray<UILabel*>*     actionPointLabels;
@property (nonatomic, strong) NSMutableArray<UIImageView*>* routeSections;
@property (nonatomic, strong) NSMutableArray<MPDirectionsHeadlineView*>*    routeSectionHeadlines;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*,UIView*>*       routeSectionSupplementaryViews;
@property (nonatomic, strong) NSArray<NSNumber*>*           sectionIndexToVerticalOffset;

@property (nonatomic) CGSize                                routeSectionSize;

@property (nonatomic, strong) UIImage*                      indoorWalkingModeImage;
@property (nonatomic, strong) UIImage*                      transitModeImage;
@property (nonatomic, strong) NSMutableDictionary<NSString*,UIImage*>*  imageCache;

@property (nonatomic, strong) UITapGestureRecognizer*       tapGestureRecognizer;
@property (nonatomic) CGFloat                               routeStartYOffset;

@property (nonatomic, weak) MPDirectionsStepSequenceView*   stepView;

@property (nonatomic) BOOL                                  enableAutoCenterOnFocusedRouteSegment;

@property (nonatomic, strong) UIButton*                     transitSourcesButton;

@end


@implementation MPDirectionsView

#pragma mark - init

- (instancetype) initWithFrame:(CGRect)aRect {
    
    self = [super initWithFrame:aRect];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder*)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    
    _focusedRouteSegment = NSNotFound;
    
    self.imageCache = [NSMutableDictionary dictionary];
    
    self.actionPoints = [NSMutableArray array];
    self.actionPointLabels = [NSMutableArray array];
    self.routeSections = [NSMutableArray array];
    self.routeSectionHeadlines = [NSMutableArray array];
    self.routeSectionSupplementaryViews = [NSMutableDictionary dictionary];
    
    self.actionPointSize = CGSizeMake(21, 21);
    self.horizontalLegWidth = 128;
    self.verticalLegHeight = 88;
    
    self.userInteractionEnabled = YES;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDetected:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    UIScrollView*   scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    if ( @available(iOS 11.0, *) ) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.shouldDimNonFocusedRouteSegments = YES;
}

- (void) loadRoute:(MPRoute*)route
        withModels:(NSArray<SectionModel*>*)models
        originType:(NSString*)originType
   destinationType:(NSString*)destinationType
       routingData:(RoutingData*)routingData {
    
    if ( route != self.currentRoute ) {
        
        self.viewModel = [MPDirectionsViewModel newWithRoute:route routingData:routingData models:models originType:originType destinationType:destinationType];
        self.currentRoute = route;
        self.routingData = routingData;
        self.modelArray = models;
        self.originType = originType;
        self.destinationType = destinationType;
        
        _focusedRouteSegment = NSNotFound;
        [self configureForRoute];
        self.focusedRouteSegment = 0;
        self.enableAutoCenterOnFocusedRouteSegment = NO;
        [self setNeedsLayout];
    }
}

- (void) routeUpdated:(MPRoute*)route {
    
    if ( route == self.currentRoute ) {

        [self configureForRoute];
        [self setNeedsLayout];
    }
}

- (NSUInteger)numberOfRouteSegments {
    return self.modelArray.count;
}


#pragma mark - Widget creation

- (void)setShouldDimNonFocusedRouteSegments:(BOOL)shouldDimNonFocusedRouteSegments {

    if ( _shouldDimNonFocusedRouteSegments != shouldDimNonFocusedRouteSegments ) {
        _shouldDimNonFocusedRouteSegments = shouldDimNonFocusedRouteSegments;
        
        if ( shouldDimNonFocusedRouteSegments ) {
            [self dimmingView];     // Force creation of dimming view
        } else {
            [self.dimmingView removeFromSuperview];
            self.dimmingView = nil;
        }
    }
}

- (UIView*) dimmingView {
    
    UIView* dimmingViewInEffect = nil;
    
    if ( self.shouldDimNonFocusedRouteSegments ) {
        
        CGRect r = CGRectMake( 0, 0, self.sizeFittingRoute.width, self.sizeFittingRoute.height);
        if ( _dimmingView == nil ) {
            dimmingViewInEffect = [[UIView alloc] initWithFrame:r];
            _dimmingView = dimmingViewInEffect;
            _dimmingView.userInteractionEnabled = NO;
            _dimmingView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
            [self.scrollView addSubview:_dimmingView];
        } else {
            _dimmingView.frame = r;
        }
        
        dimmingViewInEffect = _dimmingView;
    }
    
    return dimmingViewInEffect;
}

- (UIView *) highlighView {
    
    if ( (_highlighView == nil) && self.shouldHighlightFocusedRouteSegment ) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectZero];
        _highlighView = v;
        _highlighView.backgroundColor = [UIColor colorWithWhite:0.83 alpha:.3];
        _highlighView.userInteractionEnabled = NO;
        [self.scrollView addSubview: v];
    }
    
    return _highlighView;
}

- (void) setShouldHighlightFocusedRouteSegment:(BOOL)shouldHighlightFocusedRouteSegment {
    
    if ( _shouldHighlightFocusedRouteSegment != shouldHighlightFocusedRouteSegment ) {
        
        _shouldHighlightFocusedRouteSegment = shouldHighlightFocusedRouteSegment;
        
        if ( shouldHighlightFocusedRouteSegment ) {
            [self highlighView];     // Force creation of highlight view
        } else {
            [self.highlighView removeFromSuperview];
            self.highlighView = nil;
        }
    }
}

- (UIImageView*) createActionPointImageView {
    
    UIImageView* v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.actionPointSize.width, self.actionPointSize.height)];
    [self.actionPoints addObject:v];
    v.clipsToBounds = NO;
    return v;
}

- (UILabel*) createActionPointLabel {
    
    UILabel*    l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.actionPointSize.width, self.actionPointSize.height)];
    
    l.textAlignment = NSTextAlignmentCenter;
    l.lineBreakMode = NSLineBreakByTruncatingTail;
    l.numberOfLines = 0;
    l.font = [UIFont systemFontOfSize:9];
    l.textColor = [UIColor blackColor];
    
    [self.actionPointLabels addObject:l];
    
    return l;
}

- (void) createRouteSectionViews {
    
    UIImageView* v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.actionPointSize.width, self.actionPointSize.height)];
    [self.routeSections addObject:v];
    
    MPDirectionsHeadlineView* headlineView = [[MPDirectionsHeadlineView alloc] initWithFrame:CGRectZero];
    [self.routeSectionHeadlines addObject:headlineView];
}

- (UIButton*) getTransitSourcesButtonWithCount:(NSUInteger)count {
    
    NSString*   fmt = NSLocalizedString( @"Tickets and information (%@)", );
    NSString*   title = [NSString stringWithFormat:fmt, @(count)];

    if ( self.transitSourcesButton == nil ) {
        
        UIButton*   b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.titleLabel.font = [UIFont systemFontOfSize:14];
        [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(sourcesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        b.frame = CGRectMake( 0, 0, 96, 24 );
        
        self.transitSourcesButton = b;
    }

    [self.transitSourcesButton setTitle:title forState:UIControlStateNormal];
    [self.transitSourcesButton sizeToFit];
    
    return self.transitSourcesButton;
}


#pragma mark - Images for leg travel mode visualization

- (UIImage*) createDotImageForSize:(CGSize)size {

    UIColor*    color = [UIColor appPrimaryColor] ;
    NSString*   cacheKey = [NSString stringWithFormat:@"dot_%@x%@_%@", @(size.width), @(size.height), color];
    UIImage*    image = self.imageCache[cacheKey];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize  sizeScaledForScreen = CGSizeMake(size.width * scale, size.height * scale );
    
    if ( CGSizeEqualToSize( image.size, sizeScaledForScreen ) == NO ) {
        CGFloat  dotSize = self.actionPointSize.width*0.3;
        CGFloat  inset = self.actionPointSize.width / 2;
    
        image = [UIImage imageWithRepeatingDots:size dotSize:dotSize dotInterval:dotSize*2.5 dotColor:color startEndInset:inset];
        
        self.imageCache[ cacheKey ] = image;
    }
    
    return image;
}

- (UIImage*) createSolidBarImageForSize:(CGSize)size barFraction:(CGFloat)barFraction color:(UIColor*)color {
    
    NSString*   cacheKey = [NSString stringWithFormat:@"bar_%@_%@x%@_%@", @(barFraction), @(size.width), @(size.height), color];
    UIImage*    image = self.imageCache[cacheKey];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize  sizeScaledForScreen = CGSizeMake(size.width * scale, size.height * scale );
    
    if ( CGSizeEqualToSize( image.size, sizeScaledForScreen ) == NO ) {
        image = [UIImage imageSolidBar:size barFraction:barFraction barColor:color];
        
        self.imageCache[ cacheKey ] = image;
    }
    
    return image;
}

- (UIImage *) outdoorWalkingModeImageWithSize:(CGSize)routeSectionSize {
    return [self createDotImageForSize:routeSectionSize];
}

- (UIImage *) indoorWalkingModeImageWithColor:(UIColor*)color size:(CGSize)routeSectionSize {
    return [self createSolidBarImageForSize:routeSectionSize barFraction:0.2 color:color];
}

- (UIImage *) bikeDriveModeImageWithColor:(UIColor*)color size:(CGSize)routeSectionSize {
    return [self createSolidBarImageForSize:routeSectionSize barFraction:0.45 color:color];
}

- (UIImage *) transitModeImageWithColor:(UIColor*)color size:(CGSize)routeSectionSize {
    return [self createSolidBarImageForSize:routeSectionSize barFraction:1 color:color];
}


#pragma mark - Images for action points

- (UIImage*) createCircleImageForSize:(CGSize)size circleFraction:(CGFloat)circleFraction lineWidth:(CGFloat)lineWidth lineColor:(UIColor*)lineColor fillColor:(UIColor*)fillColor innerCircle:(BOOL)innerCircle innerImageNamed:(NSString*)innerImageName {
    return [self createCircleImageForSize:size circleFraction:circleFraction lineWidth:lineWidth lineColor:lineColor fillColor:fillColor innerCircle:innerCircle innerImageNamed:innerImageName innerImage:nil];
}

- (UIImage*) createCircleImageForSize:(CGSize)size circleFraction:(CGFloat)circleFraction lineWidth:(CGFloat)lineWidth lineColor:(UIColor*)lineColor fillColor:(UIColor*)fillColor innerCircle:(BOOL)innerCircle innerImageNamed:(NSString*)innerImageName innerImage:(UIImage*)innerImage {
    NSString*   cacheKey = [NSString stringWithFormat:@"cir_%@x%@_%@_%@_%@_%@_%@_%@", @(size.width), @(size.height), @(circleFraction), @(lineWidth), lineColor, fillColor, @(innerCircle), innerImageName];
    UIImage*    image = self.imageCache[cacheKey];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize  sizeScaledForScreen = CGSizeMake(size.width * scale, size.height * scale );
    
    if ( CGSizeEqualToSize( image.size, sizeScaledForScreen ) == NO ) {
        image = [UIImage circleImageForSize:size circleFraction:circleFraction lineWidth:lineWidth lineColor:lineColor fillColor:fillColor innerCircle:innerCircle];
        
        if ( innerImage ) {
            image = [image imageWithEmbeddedImage:innerImage innerImageFraction:0.8];
        } else if (innerImageName) {
            image = [image imageWithEmbeddedImageNamed:innerImageName innerImageFraction:0.8];
        }
        
        self.imageCache[ cacheKey ] = image;
    }
    
    return image;
}

- (UIImage*) createCircleImageForSize:(CGSize)size circleFraction:(CGFloat)circleFraction lineWidth:(CGFloat)lineWidth lineColor:(UIColor*)lineColor fillColor:(UIColor*)fillColor innerCircle:(BOOL)innerCircle {
    return [self createCircleImageForSize:size circleFraction:circleFraction lineWidth:lineWidth lineColor:lineColor fillColor:fillColor innerCircle:innerCircle innerImageNamed:nil];
}

- (UIImage*) innerActionPointImageWithColor:(UIColor*)color {
    return [self createCircleImageForSize:self.actionPointSize circleFraction:1 lineWidth:3 lineColor:color fillColor:[UIColor whiteColor] innerCircle:NO];
}

- (UIImage*) startActionPointImage {
    return [self createCircleImageForSize:self.actionPointSize circleFraction:0.95 lineWidth:2 lineColor:[UIColor appPrimaryColor] fillColor:[UIColor whiteColor] innerCircle:NO];
}

- (UIImage*) endActionPointImage {
    return [self createCircleImageForSize:self.actionPointSize circleFraction:0.95 lineWidth:2 lineColor:[UIColor appPrimaryColor] fillColor:[UIColor whiteColor] innerCircle:YES];
}

- (UIImage*) actionPointImageWithCenterImageNamed:(NSString*)imageName {
    return [self createCircleImageForSize:self.actionPointSize circleFraction:0.95 lineWidth:2 lineColor:[UIColor appPrimaryColor] fillColor:[UIColor whiteColor] innerCircle:NO innerImageNamed:imageName];
}

- (UIImage*) actionPointImageWithCenterImageNamed:(NSString*)imageName centerImage:(UIImage*)centerImage {
    return [self createCircleImageForSize:self.actionPointSize circleFraction:0.95 lineWidth:2 lineColor:[UIColor appPrimaryColor] fillColor:[UIColor whiteColor] innerCircle:NO innerImageNamed:imageName innerImage:centerImage];
}


#pragma mark - String helpers

- (NSAttributedString*) attributedStringForActionPoint:(NSString*)actionPointText fontSize:(CGFloat)fontSize prefixText:(NSString*)prefixText prefixFontSize:(CGFloat)prefixFontSize {

    NSMutableAttributedString*  text = [NSMutableAttributedString new];
    
    if ( prefixText.length ) {
        NSDictionary*   prefixAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:prefixFontSize], NSForegroundColorAttributeName : [UIColor lightGrayColor] };
    
        [text appendAttributedString: [[NSAttributedString alloc] initWithString:prefixText attributes:prefixAttrs]];
    }

    NSDictionary*   textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName : [UIColor blackColor] };
    [text appendAttributedString: [[NSAttributedString alloc] initWithString:actionPointText ?: @"" attributes:textAttrs]];
    
    return [text copy];
}


#pragma mark - Route config

- (void) configureForRoute {
    
    unsigned long   numberOfRouteSections = [self numberOfRouteSegments];

    if ( numberOfRouteSections ) {
        
        // Setup number of widgets for current route config:
        unsigned long   numberOfActionPoints = numberOfRouteSections +1;
        NSInteger       deltaActionPointCount = numberOfActionPoints - self.actionPoints.count;
        NSInteger       deltaRouteSectionCount = numberOfRouteSections - self.routeSections.count;
        
        [self.routeSectionSupplementaryViews.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.routeSectionSupplementaryViews = [NSMutableDictionary dictionary];
        
        if ( deltaActionPointCount > 0 ) {
            for ( int i=0; i < deltaActionPointCount; i++ ) {
                [self createActionPointImageView];
                [self createActionPointLabel];
                if ( i < deltaRouteSectionCount ) {
                    [self createRouteSectionViews];
                }
            }
        } else if ( deltaActionPointCount < 0 ) {
            // Figure out views to be removed:
            NSMutableArray<UIView*>*    removedViews = [NSMutableArray array];
            NSRange                     r = NSMakeRange(numberOfActionPoints, -deltaActionPointCount);
            
            [removedViews addObjectsFromArray: [self.actionPoints subarrayWithRange:r]];
            [removedViews addObjectsFromArray: [self.actionPointLabels subarrayWithRange:r]];
            [self.actionPoints removeObjectsInRange:r];
            [self.actionPointLabels removeObjectsInRange:r];
            
            --r.location;   // One less route leg than action points
            [removedViews addObjectsFromArray: [self.routeSections subarrayWithRange:r]];
            [self.routeSections removeObjectsInRange:r];
            [removedViews addObjectsFromArray: [self.routeSectionHeadlines subarrayWithRange:r]];
            [self.routeSectionHeadlines removeObjectsInRange:r];

            // ... and remove:
            [removedViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        [self populateRouteData];
    
    } else {
        
        NSMutableArray<UIView*>*    removedViews = [self.scrollView.subviews mutableCopy];
        [removedViews removeObject:self.headerViewInVerticalMode];
        [removedViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void) populateRouteData {

    unsigned long   numberOfRouteSections = [self numberOfRouteSegments];
    
    if ( numberOfRouteSections ) {
        
        unsigned long   numberOfActionPoints = numberOfRouteSections +1;
        // Configure sections:
        for ( int i=0; i < numberOfRouteSections; i++ ) {
            // NSLog( @"Section[%@].type = %@", @(i), @([self.viewModel routeSectionTypeForSectionAtIndex:i]) );
            
            RouteSectionType sectionType = [self.viewModel routeSectionTypeForSectionAtIndex:i];
            [self configureRouteSection:i withType:sectionType color:[self.viewModel colorForRouteSectionAtIndex:i]];
            
            MPDirectionsViewHeadlineModel*  headlineModel = [self.viewModel headlineModelForSectionAtIndex:i];
            [self configureRouteSection:i withHeadlineModel:headlineModel];
        }
        
        for ( int i=0; i < numberOfActionPoints; i++ ) {
            
            NSString*   imageName = [self.viewModel imageNameForActionPointAtIndex:i];
            UIImage*    image;

            NSURL *imgURL = [NSURL URLWithString:imageName];
            
            if ( imageName.length == 0 ) {
                if ( i == 0 ) {
                    image = [self startActionPointImage];
                } else if ( i >= (numberOfActionPoints -1) ) {
                    image = [self endActionPointImage];
                } else {
                    image = [self innerActionPointImageWithColor:[self.viewModel colorForActionPointImageAtIndex:i]];
                }
            } else if (imgURL && imgURL.scheme && imgURL.host) {
                //To discuss: How to support images from file system or from internet?
                UIImage* centerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgURL]];
                image = [self actionPointImageWithCenterImageNamed:[imgURL.description MD5String] centerImage:centerImage];

            } else {
                image = [self actionPointImageWithCenterImageNamed:imageName];
            }
            
            self.actionPoints[i].image = image;
            NSString*   actionPointText = [self.viewModel textForActionPointAtIndex:i];
            if ( self.verticalLayout ) {
                NSString*   prefixText = [[self.viewModel prefixTextForActionPointAtIndex:i] stringByAppendingString:@": "];
                self.actionPointLabels[i].attributedText = [self attributedStringForActionPoint:actionPointText fontSize:15 prefixText:prefixText prefixFontSize:12];
            } else {
                self.actionPointLabels[i].text = actionPointText;
                self.actionPointLabels[i].font = [UIFont systemFontOfSize:9];
            }
        }
    }
}

- (void) populateLayoutDependentRouteData {
    
    unsigned long   numberOfRouteSections = [self numberOfRouteSegments];
    
    for ( int i=0; i < numberOfRouteSections; i++ ) {
        // NSLog( @"Section[%@].type = %@", @(i), @([self.viewModel routeSectionTypeForSectionAtIndex:i]) );
        
        RouteSectionType sectionType = [self.viewModel routeSectionTypeForSectionAtIndex:i];
        
        // Route section images can first be made when we know the size for them:
        [self configureRouteSection:i withType:sectionType color:[self.viewModel colorForRouteSectionAtIndex:i]];
        
        MPDirectionsViewHeadlineModel*  headlineModel = [self.viewModel headlineModelForSectionAtIndex:i];
        [self configureRouteSection:i withHeadlineModel:headlineModel];
    }
}

- (CGSize) sizeForRouteSectionAtIndex:(NSUInteger)routeSectionIndex {
    
    CGSize  s = self.routeSectionSize;
    
    if ( self.verticalLayout && (routeSectionIndex == self.viewModel.routeSegmentIndexShowingDirections) ) {
        CGFloat y = [self.sectionIndexToVerticalOffset[routeSectionIndex] floatValue];
        CGFloat yNext = [self.sectionIndexToVerticalOffset[routeSectionIndex +1] floatValue];
        
        s.height = yNext - y;
    }
    
    return s;
}

- (void) configureRouteSection:(NSUInteger)index withType:(RouteSectionType)sectionType color:(UIColor*)color {
    
    UIImage*    image;
    CGSize      size = [self sizeForRouteSectionAtIndex:index];
    
    switch ( sectionType ) {
        case RouteSectionType_Dots:
            image = [self outdoorWalkingModeImageWithSize:size];
            break;
            
        case RouteSectionType_LineNarrow:
            image = [self indoorWalkingModeImageWithColor:color size:size];
            break;
            
        case RouteSectionType_LineMedium:
            image = [self bikeDriveModeImageWithColor:color size:size];
            break;

        case RouteSectionType_LineWide:
            image = [self transitModeImageWithColor:color size:size];
            break;
            
        case RouteSectionType_Unknown:
            break;
    }
    
    UIImageView*    imageView = self.routeSections[index];

    if ( CGSizeEqualToSize( image.size, imageView.image.size ) ) {
        imageView.image = image;

    } else {
        CGFloat duration = 0.1;
        
        if ( self.verticalLayout && (image.size.height < imageView.image.size.height) ) {
            duration = 0.3;
        }
        
        [UIView transitionWithView:imageView
                          duration:duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            imageView.image = image;
                        } completion:NULL];
    }
}

- (void) configureRouteSection:(NSUInteger)index withHeadlineModel:(MPDirectionsViewHeadlineModel*)headlineModel {
    
    if ( headlineModel ) {
//        NSLog( @"Headline[%@]: %@", @(index), [[self.viewModel headlineModelForSectionAtIndex:index] debugDescription] );
        
        MPDirectionsHeadlineView* headlineView = self.routeSectionHeadlines[index];
        [headlineView configureWithModel:headlineModel];
    }
}


#pragma mark - Layout

- (void)setVerticalLayout:(BOOL)verticalLayout {
    
    if ( _verticalLayout != verticalLayout ) {

        _verticalLayout = verticalLayout;
        self.shouldDimNonFocusedRouteSegments = verticalLayout == NO;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    [self calculateLayout];
    [self populateLayoutDependentRouteData];
    [self focusRouteSegmentAtIndex:_focusedRouteSegment];
}

- (void) calculateLayout {

    if ( self.verticalLayout ) {
        [self calculateVerticalLayout];
    } else {
        [self calculateHorizontalLayout];
    }
    
//    NSLog( @"%@", self.debugDescription );
}

- (CGRect) rectForSectionAtIndex:(NSUInteger)routeSectionIndex {
    
    CGRect r = CGRectZero;
    
    if ( self.verticalLayout ) {

        if ( self.sectionIndexToVerticalOffset.count > (routeSectionIndex +1) ) {
            
            CGFloat halfActionPointHeight = self.actionPointSize.height / 2;
            CGFloat y = [self.sectionIndexToVerticalOffset[routeSectionIndex] floatValue] - halfActionPointHeight;
            CGFloat yNext = [self.sectionIndexToVerticalOffset[routeSectionIndex +1] floatValue] + halfActionPointHeight;
            CGFloat sectionHeight = yNext - y;
            
            r = CGRectMake( 0, y, self.bounds.size.width, sectionHeight );
        }
        
    } else {
        
        CGFloat x = self.horizontalLegWidth / 2 - self.actionPointSize.width / 2;
        CGFloat w = self.horizontalLegWidth + self.actionPointSize.width / 2;
        
        r = CGRectMake( x, 0, w, self.bounds.size.height );
    }
    
    return r;
}

- (void) calculateHorizontalLayout {

    CGSize calcSize = CGSizeZero;
    
    if ( self.modelArray.count > 0 ) {
        unsigned long   numberOfActionPoints = self.modelArray.count;
        
        calcSize.height = self.heightInHorizontalMode ?: self.bounds.size.height;
        calcSize.width  = (numberOfActionPoints + 1) * self.horizontalLegWidth;
        
        CGFloat x = self.horizontalLegWidth / 2;
        CGFloat y = (self.bounds.size.height - self.actionPointSize.width) / 2;
        
        self.routeSectionSize = CGSizeMake(self.horizontalLegWidth, self.actionPointSize.height);
        
        for ( int i=0; i < self.routeSections.count; i++ ) {
            
            // Route section "body" view:
            UIImageView* bodyView = self.routeSections[i];
            CGRect       r = CGRectMake(x,y, self.horizontalLegWidth, self.actionPointSize.height);
            
            if ( (CGRectEqualToRect(r, bodyView.frame) == NO) || (bodyView.superview == nil) ) {
                bodyView.frame = r;
                [self.scrollView addSubview:bodyView];
            }
            [self.scrollView sendSubviewToBack:bodyView];     // Make sure section images are behind action points etc.
            
            // Route section "headline" view:
            MPDirectionsHeadlineView* headlineView = self.routeSectionHeadlines[i];
            if ( [self.viewModel headlineModelForSectionAtIndex:i] ) {
                r.origin.y -= self.actionPointSize.height +8;
                if ( (CGRectEqualToRect(r, headlineView.frame) == NO) || (headlineView.superview == nil) ) {
                    headlineView.frame = r;
                    [self.scrollView addSubview:headlineView];
                }
                headlineView.verticalLayout = NO;
                [self.scrollView sendSubviewToBack:headlineView];     // Make sure headline views are behind action points etc.
            
            } else if ( headlineView.superview ) {
                [headlineView removeFromSuperview];
            }
            
            x += self.horizontalLegWidth;
        }
        
        x = (self.horizontalLegWidth - self.actionPointSize.width) / 2;
        for ( int i=0; i < self.actionPoints.count; i++ ) {
            UIImageView* v = self.actionPoints[i];
            CGRect  r = CGRectMake(x,y, self.actionPointSize.height, self.actionPointSize.height);
            
            if ( (CGRectEqualToRect(r, v.frame) == NO) || (v.superview == nil) ) {
                v.frame = r;
                [self.scrollView addSubview:v];
            }
            
            x += self.horizontalLegWidth;
        }

        CGSize  sizeForActionPointLabels = CGSizeMake( self.horizontalLegWidth *0.8, 30 );
        x = ((self.horizontalLegWidth - sizeForActionPointLabels.width) / 2) ;
        y += self.actionPointSize.height;
        CGRect rLabel = CGRectMake( x, y, sizeForActionPointLabels.width, sizeForActionPointLabels.height  );
        for ( int i=0; i < self.actionPoints.count; i++ ) {
            UILabel* v = self.actionPointLabels[i];
            
            if ( (CGRectEqualToRect(rLabel, v.frame) == NO) || (v.superview == nil) ) {
                v.frame = rLabel;
                v.textAlignment = NSTextAlignmentCenter;
                [self.scrollView addSubview:v];
            }
            
            rLabel.origin.x += self.horizontalLegWidth;
        }
    }
    
    self.sizeFittingRoute = calcSize;
    self.scrollView.contentSize = self.sizeFittingRoute;
}

#define kVerticalLayoutHorizontalMargin       18

- (void) calculateVerticalLayout {

    CGSize calcSize = CGSizeZero;
    
    CGFloat headerHeight = 0;
    if ( self.headerViewInVerticalMode ) {
        CGRect  headerFrame = CGRectMake(0, 0, self.bounds.size.width, self.headerViewInVerticalMode.bounds.size.height);
        
        self.headerViewInVerticalMode.frame = headerFrame;
        [self.scrollView addSubview: self.headerViewInVerticalMode];
        
        headerHeight = self.headerViewInVerticalMode.bounds.size.height;
    }
    
    self.routeStartYOffset = headerHeight ? headerHeight + (self.actionPointSize.height / 2) : self.verticalLegHeight / 2;
    
    if ( self.numberOfRouteSegments == 0 ) {
        
        // Nothing to show.
        
    } else {
        
        CGFloat y = self.routeStartYOffset;
        CGFloat x = kVerticalLayoutHorizontalMargin;
        CGFloat bodyWidth = self.bounds.size.width -kVerticalLayoutHorizontalMargin -self.actionPointSize.width *1.5 -kVerticalLayoutHorizontalMargin;
        
        NSMutableArray<NSNumber*>*  sectionIndexToVerticalOffset = [NSMutableArray array];
        for ( int i=0; i < self.numberOfRouteSegments; ++i ) {
            [sectionIndexToVerticalOffset addObject:@(y)];
            
            y += self.verticalLegHeight;
            if ( i == self.viewModel.routeSegmentIndexShowingDirections ) {
                UIView* directionsView = [self supplementaryViewForRouteSegment:i];
                y += [directionsView intrinsicContentSize].height;
                y += self.actionPointSize.height;
            }
        }
        [sectionIndexToVerticalOffset addObject:@(y)];
        self.sectionIndexToVerticalOffset = [sectionIndexToVerticalOffset copy];
        
        calcSize.height = y + (self.verticalLegHeight / 2);
        calcSize.width  = self.widthInVerticalMode ?: self.bounds.size.width;
        
        y = self.routeStartYOffset;
        
        self.routeSectionSize = CGSizeMake(self.actionPointSize.width, self.verticalLegHeight);
        
        for ( int i=0; i < self.routeSections.count; ++i ) {
            
            y = [self.sectionIndexToVerticalOffset[i] floatValue];
            CGFloat yNext = [self.sectionIndexToVerticalOffset[i +1] floatValue];
            CGFloat sectionHeight = yNext - y;
            
            // Route section "body" view:
            UIImageView* bodyView = self.routeSections[i];
            CGRect       r = CGRectMake(x,y, self.actionPointSize.width, sectionHeight);
            
            if ( (CGRectEqualToRect(r, bodyView.frame) == NO) || (bodyView.superview == nil) ) {
                bodyView.frame = r;
                [self.scrollView addSubview:bodyView];
            }
            [self.scrollView sendSubviewToBack:bodyView];     // Make sure section images are behind action points etc.
            
            // Route section "headline" view:
            MPDirectionsHeadlineView* headlineView = self.routeSectionHeadlines[i];
            if ( [self.viewModel headlineModelForSectionAtIndex:i] ) {
                r.origin.x += self.actionPointSize.width *1.5;
                r.origin.y = y + self.actionPointSize.height / 2;
                r.size.height = self.verticalLegHeight - self.actionPointSize.height;
                r.size.width = bodyWidth;
                if ( (CGRectEqualToRect(r, headlineView.frame) == NO) || (headlineView.superview == nil) ) {
                    headlineView.frame = r;
                    [self.scrollView addSubview:headlineView];
                }
                headlineView.verticalLayout = YES;
                [self.scrollView sendSubviewToBack:headlineView];     // Make sure headline views are behind action points etc.
                
            } else if ( headlineView.superview ) {
                [headlineView removeFromSuperview];
            }
            
            // Directions view:
            UIView* directionsView = [self supplementaryViewForRouteSegment:i];
            if ( directionsView ) {
                CGRect rDirections = headlineView.frame;
                rDirections.origin.y += headlineView.frame.size.height;
                rDirections.size.height = 0;
                
                if ( i == self.viewModel.routeSegmentIndexShowingDirections ) {
                    rDirections.size.height = sectionHeight - headlineView.frame.size.height - self.actionPointSize.height;
                }
                
                if ( CGRectEqualToRect(directionsView.frame,rDirections) == NO ) {
                    directionsView.frame = rDirections;
                }
                
                [self.scrollView sendSubviewToBack:directionsView];
            }
        }
        
        for ( int i=0; i < self.actionPoints.count; ++i ) {
            
            y = [self.sectionIndexToVerticalOffset[i] floatValue] - (self.actionPointSize.height / 2);
            
            UIImageView* v = self.actionPoints[i];
            CGRect  r = CGRectMake(x,y, self.actionPointSize.height, self.actionPointSize.height);
            
            if ( (CGRectEqualToRect(r, v.frame) == NO) || (v.superview == nil) ) {
                v.frame = r;
                [self.scrollView addSubview:v];
            }
        }
        
        CGSize  sizeForActionPointLabels = CGSizeMake( bodyWidth, self.actionPointSize.height );
        x += self.actionPointSize.width * 1.5;
        for ( int i=0; i < self.actionPoints.count; ++i ) {
            
            y = [self.sectionIndexToVerticalOffset[i] floatValue] - (self.actionPointSize.height / 2);
            CGRect rLabel = CGRectMake( x, y, sizeForActionPointLabels.width, sizeForActionPointLabels.height  );
            
            UILabel* v = self.actionPointLabels[i];
            
            if ( (CGRectEqualToRect(rLabel, v.frame) == NO) || (v.superview == nil) ) {
                v.frame = rLabel;
                v.textAlignment = NSTextAlignmentLeft;
                [self.scrollView addSubview:v];
            }
        }
        
        [self.scrollView bringSubviewToFront:self.headerViewInVerticalMode];
        
        NSArray<MPTransitAgency*>*  sources = [self.viewModel transitAgenciesContributingToRoute];
        if ( sources.count ) {
            calcSize.height += 44;
            
            UIButton*   b = [self getTransitSourcesButtonWithCount:sources.count];
            CGRect r = b.frame;
            r.origin = CGPointMake( 24, calcSize.height - 48 );
            b.frame = r;
            
            [self.scrollView addSubview:b];
            
        } else if ( self.transitSourcesButton ) {
            [self.transitSourcesButton removeFromSuperview];
        }
    }
    
    self.sizeFittingRoute = calcSize;
    self.scrollView.contentSize = self.sizeFittingRoute;
}


#pragma mark - Tap detection

- (void) onTapDetected:(UITapGestureRecognizer*)recognizer {

    if ( self.numberOfRouteSegments > 0 ) {
        
        CGPoint point      = [recognizer locationInView:self];
        UIView* tappedView = [self hitTest:point withEvent:nil];
        
        if ( tappedView == self.scrollView ) {
            
            if ( self.verticalLayout ) {
                
                CGFloat y = point.y + self.scrollView.contentOffset.y;
                if ( y >= self.routeStartYOffset ) {
                    NSUInteger indexOfTappedView = (y - self.routeStartYOffset) / self.verticalLegHeight;
                    
                    for ( indexOfTappedView=0; indexOfTappedView < (self.sectionIndexToVerticalOffset.count -1); ++indexOfTappedView ) {
                        CGFloat ySectionTop    = [self.sectionIndexToVerticalOffset[indexOfTappedView] floatValue];
                        CGFloat ySectionBottom = [self.sectionIndexToVerticalOffset[indexOfTappedView +1] floatValue];
                        
                        if ( (y >= ySectionTop) && (y < ySectionBottom) ) {
                            break;
                        }
                    }
                    
                    if ( indexOfTappedView < self.routeSections.count ) {
                        
                        BOOL    didHitDirectionsLabel = NO;
                        
                        if ( [self.viewModel isDirectionsAvailableForRouteSegmentAtIndex:indexOfTappedView] ) {
                            MPDirectionsHeadlineView* headlineView = self.routeSectionHeadlines[indexOfTappedView];
                            CGPoint headlinePoint = [recognizer locationInView:headlineView];
                            didHitDirectionsLabel = [headlineView isHitForDirectionsLabel:headlinePoint];
                            
                            if ( !didHitDirectionsLabel && (y > CGRectGetMaxY(headlineView.frame)) ) {
                                didHitDirectionsLabel = YES;
                            }
                        }
                        
                        if ( didHitDirectionsLabel == NO ) {
                            [self.delegate directionsView:self didSelectRouteSegmentAtIndex:indexOfTappedView sectionModel:self.modelArray[indexOfTappedView]];
                        } else {
                            [self.delegate directionsView:self didSelectDirectionsForRouteSegmentAtIndex:indexOfTappedView sectionModel:self.modelArray[indexOfTappedView]];
                        }
                    }
                }
                
            } else {
                
                CGFloat x = point.x + self.scrollView.contentOffset.x;
                if ( x >= (self.horizontalLegWidth / 2) ) {
                    NSUInteger indexOfTappedView = (x - (self.horizontalLegWidth / 2)) / self.horizontalLegWidth;
                    
                    if ( indexOfTappedView < self.routeSections.count ) {
                        [self.delegate directionsView:self didSelectRouteSegmentAtIndex:indexOfTappedView sectionModel:self.modelArray[indexOfTappedView]];
                    }
                }
            }
        }
    }
}


#pragma mark - Route segment focus

- (void) setFocusedRouteSegment:(NSUInteger)focusedRouteSegment {
    
    if ( _focusedRouteSegment != focusedRouteSegment ) {

        // NSLog( @"MPDirectionsView.focusedRouteSegment: %@ -> %@", @(_focusedRouteSegment), @(focusedRouteSegment) );
        
        _focusedRouteSegment = focusedRouteSegment;
        [self focusRouteSegmentAtIndex:_focusedRouteSegment];
        [self.delegate directionsView:self didChangeFocusedRouteSegment:_focusedRouteSegment];
    } else {
        [self centerRouteSegmentAtIndex:focusedRouteSegment];
    }
}

- (BOOL) canFocusNextRouteSegment {
    return self.focusedRouteSegment < self.numberOfRouteSegments-1;
}

- (BOOL) canFocusPrevRouteSegment {
    return (self.focusedRouteSegment > 0) && (self.focusedRouteSegment != NSNotFound);
}

- (BOOL) focusNextRouteSegment {
    if ( [self canFocusNextRouteSegment] ) {
        ++self.focusedRouteSegment;
        return YES;
    }
    return NO;
}

- (BOOL) focusPrevRouteSegment {
    if ( [self canFocusPrevRouteSegment] ) {
        --self.focusedRouteSegment;
        return YES;
    }
    return NO;
}

- (void) focusRouteSegmentAtIndex:(NSUInteger)index {

    self.enableAutoCenterOnFocusedRouteSegment = YES;
    
    [self _focusRouteSegmentAtIndex:index];
}

- (void) _focusRouteSegmentAtIndex:(NSUInteger)index {
    
    if ( self.enableAutoCenterOnFocusedRouteSegment ) {

        if ( index < self.numberOfRouteSegments ) {
            
            [UIView animateWithDuration:0.3 animations:^{
                if ( self.dimmingView ) {
                    [self.scrollView bringSubviewToFront:self.dimmingView];
                    [self.scrollView bringSubviewToFront:self.routeSections[index]];
                    [self.scrollView bringSubviewToFront:self.routeSectionHeadlines[index]];
                    [self.scrollView bringSubviewToFront:self.actionPoints[index]];
                    [self.scrollView bringSubviewToFront:self.actionPoints[index+1]];
                    [self.scrollView bringSubviewToFront:self.actionPointLabels[index]];
                    [self.scrollView bringSubviewToFront:self.actionPointLabels[index+1]];
                }

                if ( self.highlighView ) {
                    [self.scrollView sendSubviewToBack:self.highlighView];
                    
                    CGRect r = [self rectForSectionAtIndex:index];
                    r.origin.y -= 4;
                    r.size.height += 8;
                    
                    self.highlighView.frame = r;
                }
                
                [self centerRouteSegmentAtIndex:index];
            }];
        }
    }
}

- (void) centerRouteSegmentAtIndex:(NSUInteger)index {
    
    if ( index < self.routeSections.count ) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if ( self.verticalLayout) {
                
                if ( self.scrollView.bounds.size.height < self.scrollView.contentSize.height ) {
                    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
                    CGFloat centerYOfFocusedSegment = CGRectGetMidY( self.routeSections[index].frame );
                    CGFloat centerYscrollView = self.scrollView.contentOffset.y + self.scrollView.bounds.size.height / 2;
                    CGFloat dy = centerYOfFocusedSegment - centerYscrollView;
                    
                    contentOffsetY += dy;
                    if ( contentOffsetY < 0 ) {
                        contentOffsetY = 0;
                    } else if ( (contentOffsetY + self.scrollView.bounds.size.height) > self.scrollView.contentSize.height ) {
                        contentOffsetY = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
                    }
                    
                    if ( contentOffsetY > CGRectGetMinY( self.routeSections[index].frame ) ) {
                        contentOffsetY = CGRectGetMinY( self.routeSections[index].frame );
                    }
                    
                    self.scrollView.contentOffset = CGPointMake(0, contentOffsetY);
                }
            } else {
                
                CGFloat contentOffsetX = self.scrollView.contentOffset.x;
                CGFloat centerXOfFocusedSegment = CGRectGetMidX( self.routeSections[index].frame );
                CGFloat centerXscrollView = self.scrollView.contentOffset.x + self.scrollView.bounds.size.width / 2;
                CGFloat dx = centerXOfFocusedSegment - centerXscrollView;
                
                contentOffsetX += dx;
                if ( contentOffsetX < 0 ) {
                    contentOffsetX = 0;
                } else if ( (contentOffsetX + self.scrollView.bounds.size.width) > self.scrollView.contentSize.width ) {
                    contentOffsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
                }
                
                self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
            }
        }];
    }
    
}


#pragma mark - Header view support

- (void)setHeaderViewInVerticalMode:(UIView *)headerViewInVerticalMode {
    
    if ( _headerViewInVerticalMode != headerViewInVerticalMode ) {
        
        if ( _headerViewInVerticalMode && (_headerViewInVerticalMode.superview == self.scrollView) ) {
            [_headerViewInVerticalMode removeFromSuperview];
        }
        
        _headerViewInVerticalMode = headerViewInVerticalMode;
        
        [self.headerViewInVerticalMode removeFromSuperview];    // We'll add it to the scrollview if the layout pleases...
        [self setNeedsLayout];
    }
}


#pragma mark - Direction expand/collapse

- (void) toggleDirectionsDisplayForRouteSegment:(NSUInteger)routeSegmentIndex {
    
    if ( self.verticalLayout ) {
        
        NSUInteger  routeSegmentIndexShowingDirections = self.viewModel.routeSegmentIndexShowingDirections;
        
        if ( routeSegmentIndexShowingDirections != NSNotFound ) {
            [self collapseDirectionsForRouteSegment:routeSegmentIndexShowingDirections];
        }
        
        if ( [self.viewModel isDirectionsAvailableForRouteSegmentAtIndex:routeSegmentIndex] ) {
            if ( routeSegmentIndexShowingDirections != routeSegmentIndex ) {
                [self expandDirectionsForRouteSegment:routeSegmentIndex];
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
            
            [self centerRouteSegmentAtIndex:routeSegmentIndex];
        }];
    }
}

- (void) collapseDirectionsDisplayIfShowing {
    
    if ( self.verticalLayout ) {
        
        NSUInteger  routeSegmentIndexShowingDirections = self.viewModel.routeSegmentIndexShowingDirections;
        
        if ( routeSegmentIndexShowingDirections != NSNotFound ) {
            [self collapseDirectionsForRouteSegment:routeSegmentIndexShowingDirections];
            
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
                
                [self centerRouteSegmentAtIndex:routeSegmentIndexShowingDirections];
            }];
        }
    }
}

- (UIView*) supplementaryViewForRouteSegment:(NSUInteger)routeSegmentIndex {
    
    return self.routeSectionSupplementaryViews[@(routeSegmentIndex)];
}

- (void) collapseDirectionsForRouteSegment:(NSUInteger)routeSegmentIndex {
    
    self.viewModel.routeSegmentIndexShowingDirections = NSNotFound;

    UIView* directionsView = [self supplementaryViewForRouteSegment:routeSegmentIndex];
    
    if ( directionsView ) {
        [self setNeedsLayout];
    }
}

- (void) expandDirectionsForRouteSegment:(NSUInteger)routeSegmentIndex {
    
    self.viewModel.routeSegmentIndexShowingDirections = routeSegmentIndex;
    
    UIView* directionsView = [self supplementaryViewForRouteSegment:routeSegmentIndex];

    if ( directionsView == nil ) {
        
        NSArray<MPRouteStep*>*              steps = [self.viewModel stepsForRouteSegmentAtIndex:routeSegmentIndex];
        MPDirectionsStepSequenceViewModel*  stepSequenceViewModel = [MPDirectionsStepSequenceViewModel newWithSteps:steps];
        
        UIView*                             headlineView = self.routeSectionHeadlines[routeSegmentIndex];
        CGRect                              stepSequenceRect = headlineView.frame;
        stepSequenceRect.origin.y += stepSequenceRect.size.height;
        stepSequenceRect.size.height = 0;
        
        MPDirectionsStepSequenceView*       stepSequenceView = [[MPDirectionsStepSequenceView alloc] initWithFrame: stepSequenceRect ];
        stepSequenceView.viewModel = stepSequenceViewModel;
        
        [self.scrollView insertSubview:stepSequenceView belowSubview:headlineView];
        
        directionsView = stepSequenceView;
        self.routeSectionSupplementaryViews[@(routeSegmentIndex)] = stepSequenceView;
    }
    
    if ( directionsView ) {
        [self setNeedsLayout];
    }
}


#pragma mark - DEBUG Support

- (NSString*) stringForTravelMode:(TRAVEL_MODE)travelMode {

    switch ( travelMode ) {
        case WALK:      return @"WALK";
        case BIKE:      return @"BIKE";
        case DRIVE:     return @"DRIVE";
        case TRANSIT:   return @"TRANSIT";
    }
    NSAssert( NO, @"Unknown travel mode" );
}

- (NSString*) stringForLegType:(MPRouteLegType)legType {
    
    switch ( legType ) {
        case MPRouteLegTypeGoogle:      return @"LegTypeGOOGLE";
        case MPRouteLegTypeMapsIndoors: return @"LegTypeMAPSINDOORS";
    }
    NSAssert( NO, @"Unknown leg type" );
}

- (NSString *)debugDescription {
    
    NSMutableString*    s = [NSMutableString stringWithFormat:@"<MPDirectionsView %p: ", self ];
    [s appendFormat:@"\n  verticalLayout = %@", @(self.verticalLayout)];
    [s appendFormat:@"\n  sizeFittingRoute = h%@, w%@", @(self.sizeFittingRoute.height), @(self.sizeFittingRoute.width)];
    [s appendFormat:@"\n  routingData: %@, from %@ to %@", self.routingData.travelMode, self.routingData.origin.name, self.routingData.destination.name];
    [s appendFormat:@"\n  sections[%@] {", @(self.modelArray.count)];
    for ( SectionModel* sm in self.modelArray) {
        [s appendFormat:@"\n    %@[%@]: %@", [self stringForTravelMode:sm.travelMode], [self stringForLegType:sm.legType], sm.leg.start_address];
        if ( sm.step ) {
            [s appendFormat:@"\n      Step %@, %@, ctx=%@, dist=%@, dur=%@", sm.step.travel_mode, sm.step.highway, sm.step.routeContext, sm.step.distance, sm.step.duration];
            [s appendFormat:@"\n        Steps[%@]", @(sm.step.steps.count)];
            for ( MPRouteStep* subStep in sm.step.steps ) {
                [s appendFormat:@"\n          Step %@, %@, ctx=%@, dist=%@, dur=%@", subStep.travel_mode, subStep.highway, subStep.routeContext, subStep.distance, subStep.duration];
            }
        }
        if ( sm.leg ) {
            MPRouteLeg* leg = sm.leg;
            [s appendFormat:@"\n      Leg %p, %@m (%@)", leg, leg.distance, leg.duration];
            [s appendFormat:@"\n        Steps[%@]", @(leg.steps.count)];
            int i=0;
            for ( MPRouteStep* rs in leg.steps ) {
                [s appendFormat:@"\n          Step[%@]: %@, %@, ctx=%@, dist=%@, dur=%@", @(i), rs.travel_mode, rs.highway, rs.routeContext, rs.distance, rs.duration];
                if ( ++i > 4 ) {
                    if ( leg.steps.count > i ) {
                        [s appendFormat:@"\n          ... %@ more steps.", @(leg.steps.count -i)];
                    }
                    break;
                }
            }
        }
    }
    [s appendString:@"\n  }"];
    [s appendString:@"\n>"];
    
    return [s copy];
}


#pragma mark - Transit sources button

- (void) sourcesButtonTapped:(UIButton*)sourcesButton {
    
    if ( [self.delegate respondsToSelector:@selector(directionsView:didRequestDisplayTransitSources:)] ) {
        
        [self.delegate directionsView:self didRequestDisplayTransitSources:[self.viewModel transitAgenciesContributingToRoute]];
    }
}

@end
