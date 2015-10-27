# VCMaterialDesignIcons
Material Design Icons for IOS - Objective C 

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)

##About
Material Design Icon Fonts are from http://zavoloklom.github.io/material-design-iconic-font/icons.html

##Usage

    #import <VCMaterialDesignIcons/VCMaterialDesignIcons>

    // create icon with Material Design code and font size
    // font size is the basis for icon size
    VCMaterialDesignIcons *icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_bug_report fontSize:30.f];
    
    // add attribute to icon
    [icon addAttribute:NSForegroundColorAttributeName value:[self getRandomColor]];
    
    // the icon will be drawn to UIImage in a given size
    UIImage *image = [icon image];
    
##Installation (CocoaPods)

    pod 'VCMaterialDesignIcons'
    
##Running Demo

before running demo do: 

`pod update` on `MaterialDesignDemo` directory and open MaterialDesignDemo project through MaterialDesignDemo.xcworkspace

##Contribution

Forks for this library are welcome.
