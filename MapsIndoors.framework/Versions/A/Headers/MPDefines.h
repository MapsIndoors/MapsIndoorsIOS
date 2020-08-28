//
//  MPDefines.h
//  MapsIndoorsSDK
//
//  Created by Michael Bech Hansen on 08/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#ifndef MPDefines_h
#define MPDefines_h


#if defined(MP_DISABLE_DEPRECATION_WARNINGS)
    #define MP_DEPRECATED_MSG_ATTRIBUTE(mESSAGE)    /* disabled */
    #define MP_DEPRECATED_ATTRIBUTE                 /* disabled */
#else
    #define MP_DEPRECATED_MSG_ATTRIBUTE(mESSAGE)    DEPRECATED_MSG_ATTRIBUTE(mESSAGE)
    #define MP_DEPRECATED_ATTRIBUTE                 DEPRECATED_ATTRIBUTE
#endif

#define kMPUIApplicationDidReceiveMemoryWarningNotification @"UIApplicationDidReceiveMemoryWarningNotification"
#define kMPRequestClearCacheMemoryNotification @"MPRequestClearCacheMemoryNotification"
#define kMPRequestResetMapNotification @"MPRequestResetMapNotification"

#endif /* MPDefines_h */
