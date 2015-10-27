//
//  MapsIndoorsTests.m
//  MapsIndoorsTests
//
//  Created by Daniel Nielsen on 10/26/2015.
//  Copyright (c) 2015 Daniel Nielsen. All rights reserved.
//

// https://github.com/Specta/Specta

#define EXP_SHORTHAND
//
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
//#import <Expecta+Snapshots/EXPMatchers+FBSnapshotTest.h>

#import "MapViewController.h"

#define test_expect(a) [expect(a) test]
#define assertPass(expr) \
XCTAssertNoThrow((expr))


SpecBegin(InitialSpecs)

__block CGRect frame = CGRectMake(0, 0, 64, 64);
__block NSFileManager *fileManager = [[NSFileManager alloc] init];
__block NSString *imagesDirectory = [NSString stringWithFormat:@"%s/%@", FB_REFERENCE_IMAGE_DIR, @"FBExampleViewSpec"];

describe(@"snapshots", ^{
    
//    dispatch_block_t deleteSnapshots = ^{
//        NSArray *files = [fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil];
//        for (NSString *file in files) {
//            NSString *fullPath = [imagesDirectory stringByAppendingPathComponent:file];
//            [fileManager removeItemAtPath:fullPath error:nil];
//        }
//    };
//    
//    beforeEach(deleteSnapshots);
//    afterAll(deleteSnapshots);
//    
//    describe(@"with a view controller", ^{
//        __block MapViewController *controller;
//        
//        before(^{
//            controller = [[MapViewController alloc] init];
//            controller.view.frame = frame;
//        });
//        
//        
//        describe(@"recording", ^{
//            it(@"named", ^{
//                expect(controller).toNot.recordSnapshotNamed(@"view controller 1");
//                expect(controller.viewWillAppearCalled).to.beTruthy();
//                expect(controller.viewDidAppearCalled).to.beTruthy();
//                NSString *imageName = [[fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil] firstObject];
//                expect(imageName).to.contain(@"view controller 1");
//            });
    
            
//            it(@"unnamed", ^{
//                expect(controller).toNot.to.recordSnapshot();
//                expect(controller.viewWillAppearCalled).to.beTruthy();
//                expect(controller.viewDidAppearCalled).to.beTruthy();
//                NSString *imageName = [[fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil] firstObject];
//                expect(imageName).to.contain(@"snapshots_with_a_view_controller_recording_unnamed");
//            });
//        });
        
//        describe(@"matching", ^{
//            
//            describe(@"named", ^{
//                it(@"matches view controller", ^{
//                    expect(controller).toNot.recordSnapshotNamed(@"view controller 2");
//                    
//                    MapViewController *newVC = [[MapViewController alloc] init];
//                    newVC.view.frame = frame;
//                    expect(newVC).to.haveValidSnapshotNamed(@"view controller 2");
//                    expect(newVC.viewWillAppearCalled).to.beTruthy();
//                    expect(newVC.viewDidAppearCalled).to.beTruthy();
//                });

//                it(@"doesn't match if file doesn't exist", ^{
//                    expect(controller).toNot.haveValidSnapshotNamed(@"nonexistent image");
//                    expect(controller.viewWillAppearCalled).to.beTruthy();
//                    expect(controller.viewDidAppearCalled).to.beTruthy();
//                });
                
//                it(@"doesn't match if files differ", ^{
//                    expect(controller).toNot.recordSnapshotNamed(@"view controller 3");
//                    
//                    MapViewController *newVC = [[MapViewController alloc] init];
//                    newVC.view.frame = frame;
//                    expect(newVC).toNot.haveValidSnapshotNamed(@"view controller 3");
//                    expect(newVC.viewWillAppearCalled).to.beTruthy();
//                    expect(newVC.viewDidAppearCalled).to.beTruthy();
//                });
//            });
            
//            describe(@"unnamed", ^{
//                it(@"matches view controller", ^{
//                    expect(controller).toNot.recordSnapshot();
//                    
//                    FBViewController *newVC = [[FBRedViewController alloc] init];
//                    newVC.view.frame = frame;
//                    expect(newVC).to.haveValidSnapshot();
//                    expect(newVC.viewWillAppearCalled).to.beTruthy();
//                    expect(newVC.viewDidAppearCalled).to.beTruthy();
//                });
//                
//                it(@"doesn't match if file doesn't exist", ^{
//                    expect(controller).toNot.haveValidSnapshot();
//                    expect(controller.viewWillAppearCalled).to.beTruthy();
//                    expect(controller.viewDidAppearCalled).to.beTruthy();
//                });
//                
//                it(@"doesn't match if files differ", ^{
//                    expect(controller).toNot.recordSnapshot();
//                    
//                    FBViewController *newVC = [[FBBlueViewController alloc] init];
//                    newVC.view.frame = frame;
//                    expect(newVC).toNot.haveValidSnapshot();
//                    expect(newVC.viewWillAppearCalled).to.beTruthy();
//                    expect(newVC.viewDidAppearCalled).to.beTruthy();
//                });
//            });
            
//        });
        
//    });

});

SpecEnd

