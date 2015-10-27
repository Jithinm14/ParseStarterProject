//
//  ImageDownLoadOperation.m
//  ParseStarterProject
//
//  Created by Jithin M on 10/17/15.
//
//

#import "ImageDownLoadOperation.h"

@interface ImageDownLoadOperation ()

@property (strong, nonatomic) PFFile *imageFile;

@end

@implementation ImageDownLoadOperation

-(id)initWithParseFileToDownload:(PFFile *)pffile{
    if (self=[super init]) {
        self.imageFile = pffile;
    }
    return self;
}

-(void)main{
    //Add Code here.
}

@end
