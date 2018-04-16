//
//  MPCiscoPositionResponse.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 08/04/14.
//  Copyright (c) 2014-2018 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>

@interface MPCiscoPositionResponse : MPJSONModel

@property NSNumber* status;
@property MPPositionResult<Optional>* result;

@end
