//
//  Demos-ObjCHeader.h
//  Demos
//
//  Created by Daniel Nielsen on 07/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#ifndef Demos_ObjCHeader_h
#define Demos_ObjCHeader_h

#import <MapsIndoors/MapsIndoors.h>

@interface MPMIAPI (DevEnv)

@property (nonatomic, readwrite) BOOL useDevEnvironment;
+ (MPMIAPI*) sharedInstance;
@end

#endif /* Demos_ObjCHeader_h */
