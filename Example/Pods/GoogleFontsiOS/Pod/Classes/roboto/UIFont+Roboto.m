#import "UIFont+Roboto.h"

#import <CoreText/CoreText.h>
#import "GFIFontLoader.h"

@implementation UIFont (Roboto)

+ (instancetype)robotoThinFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-Thin"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-Thin" size:size];
}

+ (instancetype)robotoThinItalicFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-ThinItalic"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-ThinItalic" size:size];
}

+ (instancetype)robotoLightFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-Light"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-Light" size:size];
}

+ (instancetype)robotoLightItalicFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-LightItalic"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-LightItalic" size:size];
}

+ (instancetype)robotoRegularFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-Regular"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-Regular" size:size];
}

+ (instancetype)robotoItalicFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-Italic"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-Italic" size:size];
}

+ (instancetype)robotoMediumFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-Medium"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-Medium" size:size];
}

+ (instancetype)robotoMediumItalicFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-MediumItalic"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-MediumItalic" size:size];
}

+ (instancetype)robotoBoldFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-Bold"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-Bold" size:size];
}

+ (instancetype)robotoBoldItalicFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-BoldItalic"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-BoldItalic" size:size];
}

+ (instancetype)robotoBlackFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-Black"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-Black" size:size];
}

+ (instancetype)robotoBlackItalicFontOfSize:(CGFloat)size {
  static dispatch_once_t onceToken;
  [GFIFontLoader loadFontFile:@"Roboto-BlackItalic"
                   fromBundle:@"Roboto"
                    onceToken:&onceToken];
  return [self fontWithName:@"Roboto-BlackItalic" size:size];
}

@end

