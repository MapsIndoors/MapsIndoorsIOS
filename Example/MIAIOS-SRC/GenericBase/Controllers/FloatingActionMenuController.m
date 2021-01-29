//
//  FloatingActionMenuController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 08/09/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "FloatingActionMenuController.h"
#import "UIColor+AppColor.h"
#import "LocalizationSystem.h"
#import "LocalizedStrings.h"
#import "Global.h"
@import VCMaterialDesignIcons;
#import "UIImageView+MPCachingImageLoader.h"
@import PureLayout;
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"
#import "TCFKA_MDSnackbar.h"

#define MENU_OPENED_HEIGHT             240
#define MENU_CLOSED_HEIGHT              60
#define ACTION_BUTTON_EXTRA_VERT_SPACE  16


@interface FloatingActionMenuController ()

@property (nonatomic, strong) NSArray<NSNumber*>*                   menuItemBottomInsets;
@property (nonatomic, strong) NSLayoutConstraint*                   heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint*                   widthConstraint;
@property (nonatomic, strong) NSArray<NSLayoutConstraint*>*         menuItemPositionConstraints;
@property (nonatomic)         BOOL                                  isOpen;
@property (nonatomic, weak) UIButton*                               fabButton;
@property (nonatomic, strong) NSArray<UIButton*>*                   actionButtons;
@property (nonatomic, strong) NSMutableArray<UILabel*>*             infoLabels;
@property (nonatomic, strong) NSMutableArray<UIView*>*              infoLabelContainers;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint*>*  infoLabelContainerWidthConstraints;
@property (nonatomic, strong) NSArray*                              categories;

@end


@implementation FloatingActionMenuController {
    
    MPAppDataProvider* _appDataProvider;
    TCFKA_MDSnackbar* _bar;
    
    NSMutableArray* _menuItemModels;
    NSArray* _menuItemsTop;
    UIImageView* _menuOpenBtnImageView;
    UIImage* _menuCloseImage;
    UIImage* _menuOpenImage;
    BOOL _hideFab;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    
    self.isOpen = NO;
    self.menuItemBottomInsets = @[ @(-10),
                                   @(-70  -ACTION_BUTTON_EXTRA_VERT_SPACE),
                                   @(-130 -ACTION_BUTTON_EXTRA_VERT_SPACE),
                                   @(-190 -ACTION_BUTTON_EXTRA_VERT_SPACE) ];
    
    self.heightConstraint = [self.view autoSetDimension:ALDimensionHeight toSize:60];
    self.widthConstraint = [self.view autoSetDimension:ALDimensionWidth toSize:60];
    
    UITapGestureRecognizer* tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFloatingActionMenu)];
    [self.view addGestureRecognizer:tapToClose];

    // iPhone: close fab when open/closing sidemenu.  iPad: close fab when navigating the sidemenu.
    if ( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeFloatingActionMenu) name:kNotificationMenuOpenClose object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeFloatingActionMenu) name:kNotificationSideMenuWillNavigate object:nil];
    }

    _appDataProvider = [[MPAppDataProvider alloc] init];
    [_appDataProvider getAppDataWithCompletion:^(MPAppData *appData, NSError *error) {
        if (error && !self->_bar.isShowing) {
            self->_bar = [[TCFKA_MDSnackbar alloc] initWithText:kLangCouldNotFindContent actionTitle:@"" duration:4.0];
            [self->_bar show];
        }
        else {
            self->_hideFab = [[appData.appSettings objectForKey:@"hideFabMenu"] intValue];
            if (!self->_hideFab && [appData.menuInfo objectForKey:@"fabmenu"] != nil) {
                self->_menuItemModels = [NSMutableArray array];
                for (NSDictionary* item in [appData.menuInfo objectForKey:@"fabmenu"]) {
                    NSError* err;
                    MPMenuItem* menuItem = [[MPMenuItem alloc] initWithDictionary:item error:&err];
                    if (err == nil)
                        [self->_menuItemModels addObject:menuItem];
                }
                [self setupFloatingActionBtn];
                
                MPCategoriesProvider* categoriesProvider = [MPCategoriesProvider new];
                [categoriesProvider getCategoriesWithCompletion:^(NSArray *categories, NSError *error) {
                    if ( categories ) {
                        self.categories = [categories copy];
                        [self updateInfoLabelTitles];
                    }
                }];
            }
        }
    }];

    __weak typeof(self)weakSelf = self;
    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        [weakSelf closeFloatingActionMenu];
        [weakSelf createInfoLabels];
    }];
}

- (void) setupFloatingActionBtn {
    
    if (!_hideFab && _menuItemModels.count > 2) {
        
        UIButton *nearestBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        nearestBtn.tag = NSNotFound;
        [self.view addSubview:nearestBtn];
        [nearestBtn configureForAutoLayout];
        [nearestBtn autoSetDimensionsToSize:CGSizeMake(60,60)];
        [nearestBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [nearestBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        nearestBtn.layer.cornerRadius = 30;
        self.fabButton = nearestBtn;
        self.fabButton.accessibilityLabel = kLangFindNearestAccLabel;
        
        CGFloat     btnClosedInset = - [self.menuItemBottomInsets[0] doubleValue];
        
        UIButton*   btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        btn1.tag = 0;
        [btn1 addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchDown];
        [self.view insertSubview:btn1 belowSubview:nearestBtn];
        [btn1 configureForAutoLayout];
        [btn1 autoSetDimensionsToSize:CGSizeMake(40,40)];
        [btn1 autoAlignAxis:ALAxisVertical toSameAxisOfView:nearestBtn];
        NSLayoutConstraint* btn1Pos = [btn1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:btnClosedInset];

        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        btn2.tag = 1;
        [btn2 addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchDown];
        [self.view insertSubview:btn2 belowSubview:nearestBtn];
        [btn2 autoSetDimensionsToSize:CGSizeMake(40,40)];
        [btn2 autoAlignAxis:ALAxisVertical toSameAxisOfView:nearestBtn];
        NSLayoutConstraint* btn2Pos = [btn2 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:btnClosedInset];

        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        btn3.tag = 2;
        [btn3 addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchDown];
        [self.view insertSubview:btn3 belowSubview:nearestBtn];
        [btn3 configureForAutoLayout];
        [btn3 autoSetDimensionsToSize:CGSizeMake(40,40)];
        [btn3 autoAlignAxis:ALAxisVertical toSameAxisOfView:nearestBtn];
        NSLayoutConstraint* btn3Pos = [btn3 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:btnClosedInset];

        btn1.backgroundColor = [UIColor whiteColor];
        btn2.backgroundColor = [UIColor whiteColor];
        btn3.backgroundColor = [UIColor whiteColor];
        nearestBtn.backgroundColor = [UIColor appAccentColor];
        
        //Image icons or fonts?
        
        VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_search fontSize:30];
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        _menuOpenImage = [UIImage imageNamed:@"Findnearest"];;
        
        VCMaterialDesignIcons* iconClose = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_close fontSize:30];
        [iconClose addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        _menuCloseImage = iconClose.image;
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:nearestBtn.frame];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = _menuOpenImage;
        [nearestBtn addSubview:imageView];
        [nearestBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [nearestBtn setTitleEdgeInsets:UIEdgeInsetsMake(3.0f, -190.0f, 0.0f, 20.0f)];
        
        MPMenuItem* item1 = [_menuItemModels objectAtIndex:0];
        
        UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:btn1.frame];
        imageView1.contentMode = UIViewContentModeScaleAspectFill;
        [imageView1 mp_setImageWithURL:item1.iconUrl];
        [btn1 addSubview:imageView1];
        
        MPMenuItem* item2 = [_menuItemModels objectAtIndex:1];
        
        UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:btn2.frame];
        imageView2.contentMode = UIViewContentModeScaleAspectFill;
        [imageView2 mp_setImageWithURL:item2.iconUrl];
        [btn2 addSubview:imageView2];
        
        MPMenuItem* item3 = [_menuItemModels objectAtIndex:2];
        
        UIImageView* imageView3 = [[UIImageView alloc] initWithFrame:btn3.frame];
        imageView3.contentMode = UIViewContentModeScaleAspectFill;
        [imageView3 mp_setImageWithURL:item3.iconUrl];
        [btn3 addSubview:imageView3];
        
        _menuOpenBtnImageView = imageView;
        
        self.menuItemPositionConstraints = @[ btn1Pos, btn2Pos, btn3Pos ];
        
        [nearestBtn addTarget:self action:@selector(toggleFloatingActionMenu:) forControlEvents:UIControlEventTouchDown];
        
        self.actionButtons = @[ btn1, btn2, btn3 ];
        [self createInfoLabels];

        // Finish off with some accessibility tweaking:
        for ( int i=0; i < self.actionButtons.count; ++i ) {
            UIButton*   button = self.actionButtons[i];
            NSString*   title = [self titleForCategoryKey:[_menuItemModels[i] categoryKey]];
            
            button.hidden = YES;
            button.accessibilityLabel = [NSString stringWithFormat:kLangShowCategoryButtonAccLabel, title];
        }

    } else {
    }
    
    [self.view layoutIfNeeded];
}

- (void) createInfoLabels {

    [self.infoLabels makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    self.infoLabels = nil;

    if ( (self.actionButtons.count > 0) && (self.infoLabels.count == 0) ) {

        self.infoLabels = [NSMutableArray array];
        self.infoLabelContainers = [NSMutableArray array];
        self.infoLabelContainerWidthConstraints = [NSMutableArray array];
        
        for ( int i=0; i < self.actionButtons.count; ++i ) {
            UIButton*   button = self.actionButtons[i];
            NSString*   title = [self titleForCategoryKey:[_menuItemModels[i] categoryKey]];
            [self createInfoLabelForButton:button title:title tag:button.tag];
        }
    }
}

- (void) updateInfoLabelTitles {

    for ( UILabel* l in self.infoLabels ) {
        NSUInteger  ix = l.tag;
        
        if ( ix < _menuItemModels.count ) {
            MPMenuItem* menuItem = _menuItemModels[ix];
            l.text = [self titleForCategoryKey:menuItem.categoryKey];
            [l sizeToFit];

            NSLayoutConstraint* widthConstraint = self.infoLabelContainerWidthConstraints[ix];
            widthConstraint.constant = l.frame.size.width +12;
            [l.superview setNeedsLayout];
        }
    }
}

- (UILabel*) createInfoLabelForButton:(UIButton*)btn title:(NSString*)title tag:(NSUInteger)tag {
    
    // Outer container view providing shadow:
    UIView*     containerView = [UIView new];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    containerView.layer.shadowOffset = CGSizeMake(1, 1);
    containerView.layer.shadowOpacity = 0.5;
    containerView.layer.shadowRadius = 1.0;
    containerView.alpha = 0;
    containerView.tag = tag;
    
    // Inner label with text and rounded corners
    UILabel*    infoLabel = [UILabel new];
    infoLabel.text = title;
    infoLabel.textColor = [UIColor appSecondaryTextColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor whiteColor];
    infoLabel.font = [AppFonts sharedInstance].buttonFont;
    [infoLabel sizeToFit];
    infoLabel.layer.cornerRadius = 8;
    infoLabel.layer.masksToBounds = YES;
    infoLabel.tag = tag;
    infoLabel.isAccessibilityElement = NO;

    // Add to view hierarchy and do autolayout
    [containerView configureForAutoLayout];
    [infoLabel configureForAutoLayout];
    
    [containerView addSubview:infoLabel];
    [self.view addSubview:containerView];
    [infoLabel autoPinEdgesToSuperviewEdges];

    [containerView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.fabButton withOffset:-20];
    [containerView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:btn];
    [containerView autoSetDimension:ALDimensionHeight toSize:infoLabel.frame.size.height +4];
    NSLayoutConstraint* widthConstraint = [containerView autoSetDimension:ALDimensionWidth toSize:infoLabel.frame.size.width +12];

    // Setup tap gesture on labels:
    if ( tag != NSNotFound )
    {
        containerView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoLabelTapped:)];
        [containerView addGestureRecognizer:tapToClose];
    }
    
    // Hold on to some objects for future (ab)use:
    [self.infoLabels addObject:infoLabel];
    [self.infoLabelContainers addObject:containerView];
    [self.infoLabelContainerWidthConstraints addObject:widthConstraint];
    
    return infoLabel;
}

- (void) toggleFloatingActionMenu:(id)sender {
    if (!_hideFab) {
        
        self.isOpen = self.isOpen == NO;
        CGFloat infoLabelAlpha;
        CGFloat h, w;
        
        if ( self.isOpen ) {
            h = 260;
            w = 320;
            infoLabelAlpha = 1;
            for ( int i=0; i < self.menuItemPositionConstraints.count; ++i ) {
                NSLayoutConstraint* c = self.menuItemPositionConstraints[i];
                c.constant = [self.menuItemBottomInsets[i+1] doubleValue];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FABWillOpen" object:nil];
        } else {
            h = 60;
            w = 60;
            infoLabelAlpha = 0;
            for ( NSLayoutConstraint* c in self.menuItemPositionConstraints ) {
                c.constant = [self.menuItemBottomInsets[0] doubleValue];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FABWillClose" object:nil];
        }

        BOOL    shouldHideButtons = infoLabelAlpha < 1;
        if ( shouldHideButtons == NO ) {
            for ( UIView* c in self.actionButtons ) {
                c.hidden = NO;
            }
        }

        [UIView animateWithDuration:.3 animations:^{
            [self.view layoutIfNeeded];
            for ( UIView* c in self.infoLabelContainers ) {
                c.alpha = infoLabelAlpha;
            }
        } completion:^(BOOL finished) {
            for ( UIView* c in self.actionButtons ) {
                c.hidden = shouldHideButtons;
            }
        }];
        
        self.heightConstraint.constant = h;
        self.widthConstraint.constant = w;

        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, 0);
        _menuOpenBtnImageView.transform = rotationTransform;
        
        [UIView animateWithDuration:0.15 animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformIdentity;
            rotationTransform = CGAffineTransformRotate(rotationTransform, 3.14f);
            self->_menuOpenBtnImageView.transform = rotationTransform;
        } completion:^(BOOL finished) {
            if (self->_menuOpenBtnImageView.image == self->_menuOpenImage) {
                self->_menuOpenBtnImageView.image = self->_menuCloseImage;
            } else {
                self->_menuOpenBtnImageView.image = self->_menuOpenImage;
            }
            [UIView animateWithDuration:0.15 animations:^{
                CGAffineTransform rotationTransform = CGAffineTransformIdentity;
                rotationTransform = CGAffineTransformRotate(rotationTransform, 6.28f);
                self->_menuOpenBtnImageView.transform = rotationTransform;
            }];
        }];
    }
}

- (void) closeFloatingActionMenu {
    
    if ( !_hideFab && self.isOpen ) {
        [self toggleFloatingActionMenu:nil];
    }
}

- (void) infoLabelTapped:(UIGestureRecognizer*)tapGesture {

    [self showOnMap:tapGesture.view];
}

- (void) showOnMap:(UIView*)sender {
    
    MPMenuItem* selectedItem = [_menuItemModels objectAtIndex:sender.tag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowOnMap" object: selectedItem.categoryKey];
    
    [self toggleFloatingActionMenu:nil];
}

- (NSString*) titleForCategoryKey:(NSString*)categoryKey {
    
    for ( MPDataField* field in self.categories ) {
        if ( [field.key isEqualToString:categoryKey] ) {
            return field.value;
        }
    }
    
    return categoryKey;     // Use the key as fallback.  Better then nothing, yes?
}

@end
