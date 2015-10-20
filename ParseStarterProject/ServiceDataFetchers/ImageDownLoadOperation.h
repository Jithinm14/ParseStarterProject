//
//  ImageDownLoadOperation.h
//  ParseStarterProject
//
//  Created by Jithin M on 10/17/15.
//
//

#import <Foundation/Foundation.h>

@interface ImageDownLoadOperation : NSOperation

-(id)initWithParseFileToDownload:(PFFile *)pffile;

@end
