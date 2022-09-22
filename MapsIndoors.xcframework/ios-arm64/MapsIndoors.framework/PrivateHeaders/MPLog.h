//
//  MPLog.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/10/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#ifndef MPLog_h
#define MPLog_h

#if DEBUG && 1
  #define MPDebugLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
  #define MPDebugLog(...) do { } while (0)
#endif


#endif /* MPLog_h */
