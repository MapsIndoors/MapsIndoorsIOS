//
//  MPSize.h
//  MapsIndoors App
//
//  Created by Daniel Nielsen on 05/07/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>

@interface MPSize : MPJSONModel

@property (nonatomic, strong) NSNumber<Optional>* width;
@property (nonatomic, strong) NSNumber<Optional>* height;

@end
