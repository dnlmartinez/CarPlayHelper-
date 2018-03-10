//
//  CPManager.h
//  CarPlay
//
//  Created by daniel martinez gonzalez on 20/11/17.
//  Copyright © 2017. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CP_ConnectionManager.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <UIKit/UIKit.h>


@protocol CPDelegate <NSObject>
@required

@optional
    - (void) secondScreen:(BOOL *)connected;
    - (void) accesoryInfo: (NSDictionary *)dictAccesory;
@end


@interface CPManager : NSObject {
    NSString *CPversion;
    NSString *CPmanufacturer;
    NSString *CPname;
    NSString *CPfirmwareRevision;
    CP_ConnectionManager *connectionManager;
    BOOL notifiedSecondScreen;
}


@property (nonatomic, retain) NSString *CPversion;
@property (nonatomic, retain) NSString *CPmanufacturer;
@property (nonatomic, retain) NSString *CPname;
@property (nonatomic, retain) NSString *CPfirmwareRevision;
@property (nonatomic, retain) CP_ConnectionManager *connectionManager;
@property BOOL notifiedSecondScreen;


+ (CPManager *)sharedInstance;
- (void)initialize;
- (void)addReceiver:(id<CPDelegate>)receiver;
- (BOOL)CarPlayScreen;
- (UIScreen *)returnCarPlayScreen;

@end

