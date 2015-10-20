//
//  HelperClass.m
//  ParseStarterProject
//
//  Created by Jithin M on 9/19/15.
//
//

#import "HelperClass.h"

@implementation HelperClass

+(NSString *)pathForFileInDocumentsDirectory:(NSString *)fileName
{
    NSString *documentsDirectory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

@end
