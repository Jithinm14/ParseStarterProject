//
//  MasterSyncFromParse.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/20/15.
//
//

#import <Foundation/Foundation.h>

@interface MasterSyncFromParse : NSObject

+(MasterSyncFromParse *)sharedMasterSync;

-(void)doMasterSyncFromParseWithCompletionBlock:(void (^)(void))completionBlock;
-(NSArray *)fetchFromCoreData:(NSString *)entity;

@end
