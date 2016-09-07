//
//  KUGPSPositionProvider.h
//  KUDigitalMap
//
//  Created by Daniel Nielsen on 27/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapsIndoors/MapsIndoors.h>

#import  <MobileCoreServices/MobileCoreServices.h>

@interface GPSPositionProvider : NSObject<MPPositionProvider, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@end
