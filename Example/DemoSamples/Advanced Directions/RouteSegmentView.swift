//
//  RouteSegmentView.swift
//  Demos
//
//  Created by Daniel Nielsen on 21/04/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

/***
 ---
 title: Get Directions and Show Wayfinding Instructions
 ---
 
 In this tutorial we will show how to work with the route model returned from a directions service call. We will also show how you can utilize interaction between the route rendering on the map and textual instructions showed in another view.
 
 We will start by creating our implementation of a custom `UICollectionViewCell` that will hold the instructions for a single segment of a route.
 
 In the route model there are some text properties that we will interpret as enum values, so start out by creating enums `RouteContext` describing whether we are outside or inside and `WayType` describing what kind of facility we are walking/travelling through.
 ***/
enum RouteContext : String
{
    case insideBuilding = "InsideBuilding"
    case outsideOnVenue = "OutsideOnVenue"
}

enum WayType : String
{
    case stairs = "steps"
    case elevator = "elevator"
    case travellator = "travellator"
    case escalator = "escalator"
    case footway = "footway"
    case residential = "residential"
}

/***
 Create a subclass of `UICollectionViewCell` called `RouteSegmentView`
 ***/
class RouteSegmentView : UITableViewCell {
    
    /***
     Add a property called `route` that holds entire route model.
     ***/
    private var route:MPRoute = MPRoute()
    
    /***
     Add a property called `segment` that holds the actual segment of `route` that this view is going to reflect.
     ***/
    private var segment:MPRouteSegmentPath = MPRouteSegmentPath()
    
    /***
     Add a method called `renderRouteInstructions` that updates `segment` and `route`. Call the method `updateViews` when set.
     ***/
    func renderRouteInstructions(_ route:MPRoute, for segment:MPRouteSegmentPath) {
        self.route = route
        self.segment = segment
        updateViews()
    }
    
    /***
     ## Helper methods
     We will need some helper methods. First create a method that can get us the previous step for later comparison.
    ***/
    fileprivate func getPreviousStep(_ stepIndex: Int, _ legIndex: Int, _ route: MPRoute) -> MPRouteStep? {
        
        var previousStep: MPRouteStep?
        if stepIndex-1 < 0 {
            if segment.legIndex-1 >= 0 {
                let previousLeg = route.legs?[segment.legIndex-1] as? MPRouteLeg
                previousStep = previousLeg?.steps?.lastObject as? MPRouteStep
            }
        } else if let leg = route.legs?[segment.legIndex] as? MPRouteLeg {
            previousStep = leg.steps?[stepIndex-1] as? MPRouteStep
        }
        return previousStep
    }
    
    /***
     Create a method `getOutsideInsideInstructions` that can get us instructions for walking inside or out of a building. This is determined by the `routeContext` property of an `MPRouteStep`
     ***/
    fileprivate func getOutsideInsideInstructions(_ previousStep: MPRouteStep, _ currentStep: MPRouteStep) -> String? {
        var instructions:String?
        if let previousContext = previousStep.routeContext {
            if previousContext != currentStep.routeContext {
                
                let ctx = RouteContext.init(rawValue: currentStep.routeContext ?? "")
                
                if ctx == .insideBuilding {
                    instructions = "Walk inside"
                } else if ctx == .outsideOnVenue {
                    instructions = "Walk outside"
                }
                
            }
        }
        return instructions
    }
    
    /***
     Create a method `getElevationInstructions` that can get us instructions for taking the stairs or elevator to another floor. This is determined by the `highway` and `end_location.zLevel` properties of a `MPRouteStep`.
     ***/
    fileprivate func getElevationInstructions(_ currentStep: MPRouteStep) -> String? {
        var instructions:String?
        if currentStep.start_location?.zLevel?.intValue != currentStep.end_location?.zLevel?.intValue {
            
            let floor = currentStep.end_location?.floor_name ?? ""
            let wayType = WayType.init(rawValue: currentStep.highway ?? "") ?? .footway
            
            switch (wayType) {
                case .elevator, .escalator, .stairs, .travellator:
                    instructions = "Take the \(wayType.rawValue) to floor \(floor)"
                default:
                    instructions = "Go to level \(floor)"
            }
        }
        return instructions
    }
    
    /***
     Create a method `getDefaultInstructions` that can get us information about the default instructions in a route step. In some cases they are html formatted, so we need to pass it through an interpreter.
     ***/
    fileprivate func getDefaultInstructions(_ currentStep: MPRouteStep) -> String? {
        if let html = currentStep.html_instructions {
            return String(htmlEncodedString: html)
        }
        return nil
    }
    
    /***
     Create a method `getDistanceInstructions` that can get us information about the travelling distance. This is determined by the `duration` property of a `MPRouteLeg`. The distance is returned in meters so if you require imperial units, make a conversion.
     ***/
    fileprivate func getDistanceInstructions(_ distance:NSNumber?) -> String {
        let feet = Int((distance?.doubleValue ?? 0) * 3.28)
        return "Continue for \(feet) feet"
    }
    
    /***
     ## Suggested logic for generating meaningful instructions
     Obviously it is up to your application to present some instructions to the end user, but here a suggestion. Add a method called `updateViews` that will fire whenever our models change.
     ***/
    func updateViews() {
        /***
         Initialise an array of textual instructions and check for existence of a current leg.
         ***/
        if route.legs?.count ?? 0 > 0 {
            var instructions = [String]()
            if let currentLeg = route.legs?[segment.legIndex] as? MPRouteLeg {
                /***
                 Add instructions for inside/outside as well as elevation instruction if applicable.
                 ***/
                if segment.stepIndex >= 0, let currentStep = currentLeg.steps?[segment.stepIndex] as? MPRouteStep {
                    if let previousStep = getPreviousStep(segment.stepIndex, segment.legIndex, route) {
                        if let outsideInsideInstructions = getOutsideInsideInstructions(previousStep, currentStep) {
                            instructions.append(outsideInsideInstructions)
                        }
                    }
                    if let elevationInstructions = getElevationInstructions(currentStep) {
                        instructions.append(elevationInstructions)
                    }
                    if let defaultInstructions = getDefaultInstructions(currentStep) {
                        instructions.append(defaultInstructions)
                    }
                    instructions.append(getDistanceInstructions(currentStep.distance))
                }
                //
            }
            self.textLabel?.text = instructions.joined(separator: "\n")
            self.textLabel?.numberOfLines = instructions.count
            //
        }
    }
}

/***
 We need a method to parse html because the directions instructions from Google contains html.
 ***/
extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }

}

/***
 In [the next part we will create a controller](../advanceddirectionsroutesegmentscontroller) that displays the above generated instructions.
 ***/
