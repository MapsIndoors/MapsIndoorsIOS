#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "SDKDemos/PlacesSamples/SDKDemoPlacePickerViewController.h"

#import "SDKDemos/SDKDemoAPIKey.h"


@implementation SDKDemoPlacePickerViewController {
  GMSPlacePicker *_placePicker;
}

- (instancetype)init {
  if ((self = [super init])) {
    CLLocationCoordinate2D southWestSydney = CLLocationCoordinate2DMake(-33.8659, 151.1953);
    CLLocationCoordinate2D northEastSydney = CLLocationCoordinate2DMake(-33.8645, 151.1969);
    GMSCoordinateBounds *sydneyBounds =
        [[GMSCoordinateBounds alloc] initWithCoordinate:southWestSydney coordinate:northEastSydney];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:sydneyBounds];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  __block UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
  textView.delegate = self;
  textView.editable = NO;
  [self.view addSubview:textView];
  [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
    if (place) {
      NSMutableAttributedString *text =
          [[NSMutableAttributedString alloc] initWithString:[place description]];
      [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
      [text appendAttributedString:place.attributions];
      textView.attributedText = text;
    } else if (error) {
      textView.text = [NSString stringWithFormat:@"Place picking failed with error: %@", error];
    } else {
      textView.text = @"Place picking cancelled.";
    }
  }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView
    shouldInteractWithURL:(NSURL *)url
                  inRange:(NSRange)characterRange {
  // Make links clickable.
  return YES;
}
@end
