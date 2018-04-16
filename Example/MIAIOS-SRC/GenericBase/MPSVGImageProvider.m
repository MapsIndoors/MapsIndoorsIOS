//
//  MPSVGImageProvider.m
//  MIAIOS
//
//  Created by Amine on 29/06/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPSVGImageProvider.h"
#import <MapsIndoors/MapsIndoors.h>
#import "MPAssertionHandlerLogAll.h"

#pragma clang diagnostics push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
#pragma clang diagnostic ignored "-Wdocumentation"
#import "SVGKit.h"
#pragma clang diagnostics pop


@implementation MPSVGImageProvider

static NSMutableArray* tasks;
static NSString* classID = @"MPSVGImageProvider";

- (void) getImageFromUrlStringAsync: (NSString*)url imageSize: (CGSize) size completionHandler: (void (^)(UIImage* image, NSError* error)) completionHandler {
    
    
    Boolean imageIsSvg = NO;

    if ([[url pathExtension] isEqualToString:@"svg"])
        imageIsSvg = YES;

    NSURL *nsUrl = [NSURL URLWithString:url];
    
    // test if the url is valid
    if (nsUrl == nil || nsUrl.absoluteString.length == 0) {
        
        NSLog(@"%@", [classID stringByAppendingString: @": Url not valid"]);

        completionHandler(nil, [NSError errorWithDomain:kMPMapsIndoorsDomain code:kMPErrorCodeImageAssetNotFound userInfo:nil]);
        return;
    }
    
    //
    NSString* imgRelUrlPath = [nsUrl relativePath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString* imgPath = [@"mi" stringByAppendingString: [imgRelUrlPath stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imgPath];
    
    UIImage* localImage;
    
    // get the image from the cache
     if(imageIsSvg){
        
        SVGKImage* newImage = [SVGKImage  imageWithContentsOfFile:filePath];
         localImage= [self imageFromSVGKImage:newImage imageSize: size];
        
    } else
      localImage = [UIImage imageWithContentsOfFile:filePath];
    
    //get the image from the res
    if (localImage == nil) {
      
        NSString *resPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"res"] stringByAppendingPathComponent:imgPath];
      
        if(imageIsSvg){
            
            NSAssertionHandler* customAssertionHandler = [[MPAssertionHandlerLogAll alloc] init];
            [[[NSThread currentThread] threadDictionary] setValue:customAssertionHandler forKey:NSAssertionHandlerKey];
            
            @try {
                
                SVGKImage* newImage = [SVGKImage  imageWithContentsOfFile:resPath];
                localImage= [self imageFromSVGKImage:newImage imageSize: size];
        
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.reason);
                
                
            }
        }
        else
        localImage = [UIImage imageWithContentsOfFile:resPath];
      
    }
    
    //found the image locally
    if (localImage) {

       dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(localImage, nil);
        });
    } else {
        
        if ([MapsIndoors getOfflineMode]) {
            if (completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionHandler(nil, [NSError errorWithDomain:kMPMapsIndoorsDomain code:kMPErrorCodeOfflineContentNotFound userInfo:nil]);
                });
            }
            return;
        }
        
        if (tasks == nil) {
            tasks = [[NSMutableArray alloc] init];
        }
        
        // get the image from the network
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask* newTask = [session dataTaskWithURL: [NSURL URLWithString:url]
                                               completionHandler:^(NSData *data,
                                                                   NSURLResponse *response,
                                                                   NSError *error) {
                                                   if (error) {
                                                       dispatch_async(dispatch_get_main_queue(), ^(void){
                                                           completionHandler(nil, error);
                                                       });
                                                   } else {
                                                       UIImage* img;
                                                       
                                                       if(imageIsSvg) {
                                                           
                                                           NSAssertionHandler* customAssertionHandler = [[MPAssertionHandlerLogAll alloc] init];
                                                           [[[NSThread currentThread] threadDictionary] setValue:customAssertionHandler forKey:NSAssertionHandlerKey];
                                                           
                                                           @try {
                                                               SVGKImage* newImage = [SVGKImage  imageWithData:data];
                                                               img= [self imageFromSVGKImage:newImage imageSize: size];
                                                               
                                                           }
                                                           @catch (NSException *exception) {
                                                               NSLog(@"%@", exception.reason);

                                                               
                                                           }

                                                           
                                                       }else
                                                       img = [UIImage imageWithData:data];
                                                       
                                                       //save the image in a file
                                                       if (img) {
                                                            if(imageIsSvg)
                                                                [data writeToFile:filePath atomically:YES];
                                                           else
                                                               [UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
                                                       }
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^(void){
                                                           completionHandler(img, nil);
                                                       });
                                                   }
                                               }];
        [newTask resume];
        [tasks addObject:newTask];
        
    }
}


- (UIImage *)imageFromSVGKImage:(SVGKImage *)img imageSize:(CGSize) size
{
    
    [img scaleToFitInside:size];
    [img setSize:size];
    UIImage *outputImage = [img UIImage];
    
    
    return outputImage;
}


@end
