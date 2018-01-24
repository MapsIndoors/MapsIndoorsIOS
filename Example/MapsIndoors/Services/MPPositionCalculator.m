//
//  PositionCalculator.m
//  MapsIndoors
//
//  Created by Martin Hansen on 5/19/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "MPPositionCalculator.h"
#import "PointXY.h"

@implementation MPPositionCalculator

+ (double)convertRSSItoMeter:(double) RSSI A:(double) A {
    //Signal at 1 meter. Typically just below -50db
    //double A = 46;
    //Path loss exponent. Depends on moisture in the air and how much is in the room.
    //Use higher numbers for very moist of cluttered conditions.
    double n = 2.2;
    return pow(10, (A-RSSI)/ (n*10));
}

//Returns the position based on trilateration on the given measurements given a reference point of (0,0).
// Note: The error margin is given as z.
- (MPPoint*) calcLatLngPos:(NSArray*) measurements {
    //Find the position given in meters from the reference position
    PointXY* pos = [self calcMyPos:measurements];
    PointXY* zeroPos = [[PointXY alloc] init];
    double distance = [self distanceBetween: zeroPos and:pos];
    double bearing = [self ToDeg:atan2(pos.Y, pos.X)];
    double errorMargin = [self calcErrorMargin:pos measurements:measurements];
    //Find the point from a given lat/long + a distance with bearing!
    CLLocationCoordinate2D destCoord = GMSGeometryOffset( [PointXY getRefPoint], distance, bearing );
    MPPoint* result = [[MPPoint alloc] initWithLat: destCoord.latitude lon: destCoord.longitude zValue: errorMargin];
    //Return the resulting LatLon placement
    return result;
}

//Returns the summed distance from a given point to a series of measurements.
- (double) calcErrorMargin:(PointXY*)pos measurements:(NSArray*)measurements {
    double result = 0;
    for( PointXY* p in measurements ) {
        result += fabs(p.distance - [self distanceBetween: p and:pos]);
    }
    return result;
}

- (double) distanceBetween:(PointXY*)p1 and:(PointXY*)p2 {
    double dx = p2.X - p1.X;
    double dy = p2.Y - p1.Y;
    return sqrt((dx * dx) + (dy * dy));
}

//Returns the position based on trilateration on the given measurements
//The output is in the form of a [0,0] based vector with a distance and bearing pointing to the endpoint.
//If used with a reference point this vector needs to be added to find a resulting lat/lng based position.
-(PointXY*) calcMyPos:(NSArray*) measurements {
    PointXY *guess = [self calcFirstGuess:measurements];
    //We can only trilaterate if we have 3 or more measurements
    if (measurements.count < 3)
        return guess;
    //Iterating until the guess moves less then 10cm or we tried 10 times.
    for (int i = 0; i < 10; i++)
    {
        double xBefore = guess.X;
        double yBefore = guess.Y;
        //Call calcNewGuess to refine the position guess further given a set of measurements
        [self calcNewGuess:guess measurements:measurements];
        double dx = xBefore - guess.X;
        double dy = yBefore - guess.Y;
        double dist = sqrt( (dx*dx) + (dy*dy) );
        //If the new guess is not far from the old one it's time to stop seaching
        if (dist < 0.1)
            break;
    }
    return guess;
}

//Calculate the first guess: The average of all measurement points
-(PointXY*) calcFirstGuess:(NSArray*) measurements {
    PointXY* result = [[PointXY alloc] init];
    for ( PointXY* b in measurements)
    {
        result.X += b.X;
        result.Y += b.Y;
    }
    result.X /= measurements.count;
    result.Y /= measurements.count;
    return result;
}

//Calculate new guess using Gauss-Newton least square estimation
- (void) calcNewGuess:(PointXY*) position measurements:(NSArray*)measurements
{
    double jtj[2][2];
    jtj[0][0] = 0;
    jtj[0][1] = 0;
    jtj[1][0] = 0;
    jtj[1][1] = 0;
    double jtf[2][2];
    jtf[0][0] = 0;
    jtf[0][1] = 0;
    jtf[1][0] = 0;
    jtf[1][1] = 0;
    [self calcJTJ:measurements guessPos:position result:jtj ];
    [self calcJTf:measurements guessPos:position result:jtf ];
    PointXY* correction = [self multiply:jtj JTf:jtf];
    position.X -= correction.X;
    position.Y -= correction.Y;
}

//Calculate inverse (Jacobian transposed * Jacobian)
-(void)calcJTJ:(NSArray*) measurements guessPos:(PointXY*) guessPos result:(double[2][2]) result
{
    double jtj[2][2];
    jtj[0][0] = 0;
    jtj[0][1] = 0;
    jtj[1][0] = 0;
    jtj[1][1] = 0;
    //Calc JTJ
    for ( PointXY* m in measurements)
    {
        double dx = guessPos.X - m.X;
        double dy = guessPos.Y - m.Y;
        double distSqr = (dx*dx) + (dy*dy);
        jtj[0][0] += (dx * dx) / distSqr;
        jtj[0][1] += (dx * dy) / distSqr;
        jtj[1][0] += (dx * dy) / distSqr;
        jtj[1][1] += (dy * dy) / distSqr;
    }
    //Inverse the matrix
    double det = 1.0/((jtj[0][0] * jtj[1][1]) - (jtj[1][0] * jtj[0][1]));
    result[0][0] = det * jtj[1][1];
    result[0][1] = det * -jtj[0][1];
    result[1][0] = det * -jtj[1][0];
    result[1][1] = det * jtj[0][0];
}

//Calculate Jacobian transposed * (error) function
- (void)calcJTf:(NSArray *) measurements  guessPos:(PointXY*) guessPos result:(double[2][2]) result
{
    //Calc JTJ
    for (PointXY* m in measurements)
    {
        double dx = guessPos.X - m.X;
        double dy = guessPos.Y - m.Y;
        double dist = sqrt((dx * dx) + (dy * dy));
        double fi = dist - m.distance;
        result[0][0] += (dx * fi) / dist;
        result[1][0] += (dy * fi) / dist;
    }
}

//Method for multiplying JTJ and JTf - so 2x2 multiplied with a 2x1 matrix
- (PointXY*)multiply:(double[2][2]) JTJ JTf:(double[2][2]) JTf {
    PointXY* result = [PointXY alloc];
    result.X = JTJ[0][0] * JTf[0][0] + JTJ[0][1] * JTf[1][0];
    result.Y = JTJ[1][0] * JTf[0][0] + JTJ[1][1] * JTf[1][0];
    return result;
}

- (double)ToRad:(double) deg
{
    return deg * ( M_PI / 180);
}

- (double)ToDeg:(double) rad
{
    return fmod(rad * (180 / M_PI), 360);
}


@end
