# GoogleFontsiOS [![CocoaPods](https://img.shields.io/cocoapods/v/GoogleFontsiOS.svg?style=flat)](http://cocoapods.org/?q=name%3AGoogleFontsiOS) [![CocoaPods](https://img.shields.io/cocoapods/p/GoogleFontsiOS.svg?style=flat)](https://github.com/parakeety/GoogleFontsiOS) [![CocoaPods](https://img.shields.io/cocoapods/l/GoogleFontsiOS.svg?style=flat)](https://github.com/parakeety/GoogleFontsiOS/blob/master/LICENSE)

GoogleFontsiOS is a collection of CococPods subspec encapsulating Google Fonts.


## Installation
Each fonts are encapsulated as a subspec. For example, if you'd like to install `ABeeZee`, write as below in your Podfile.

```ruby
pod 'GoogleFontsiOS/ABeeZee'
```

Installing all the fonts will take a lot of time and is not recommended.


## Usage
Each font has a corresponding header and implementaton file in the form of UIFont category.
```objective-c
#import <UIKit/UIKit.h>
@interface UIFont (ABeeZee)

+ (instancetype)aBeeZeeItalicFontOfSize:(CGFloat)size;
+ (instancetype)aBeeZeeRegularFontOfSize:(CGFloat)size;

@end
```

```objective-c
UIFont *font = [UIFont aBeeZeeRegularFontOfSize:12.0f];
```


## License
The code itself is under MIT License. The fonts belong to their respective owners and are under corresponding licenses.

## Contribution
Pull Requests are welcome, especially for ruby codes in `CodeGenerator` directory, as I'm new to ruby.

