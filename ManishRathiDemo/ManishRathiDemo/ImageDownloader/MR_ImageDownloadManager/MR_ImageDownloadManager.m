//
//  MR_ImageDownloadManager.m
// 
//
//  Created by Manish Rathi on 01/09/14.
//  Copyright (c) 2014 Rathi Inc. All rights reserved.
//
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "MR_ImageDownloadManager.h"
#import "MR_Operation.h"

@interface MR_ImageDownloadManager ()

//Download-Queue
@property (nonatomic,strong,readwrite) NSOperationQueue *downloadQueue;

@end

//static Instance.
static MR_ImageDownloadManager *sharedInstance;

@implementation MR_ImageDownloadManager

//@Manish
#pragma mark - Singleton Instance
+(MR_ImageDownloadManager *)sharedInstance
{
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t onceToken;
    //@Manish ----This will make sure this class Instance will create only once.
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]){
        //Download Queue
        _downloadQueue=[[NSOperationQueue alloc] init];
    }
    return self;
}


#pragma mark - Cancel Operations
/** Cancel Operations */
-(void)cancelOperationForUrl:(NSURL *)url
{
    for (MR_Operation *operation in self.downloadQueue.operations) {
        if ([operation.request.URL isEqual:url]) {
            [operation cancel];
        }
    }
}
//Cancel All
-(void)cancelAllOperations
{
    [self.downloadQueue.operations makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark -  Download-Image Here
-(void)downloadImageWithUrlString:(NSString *)urlString
            withCompletionHandler:(MR_DownloadImageCompletionBlock)completionHandler
      withDownloadProgressHandler:(MR_DownloadImageProgressBlock)progressHandler
{
    NSURL *url=[NSURL URLWithString:urlString];
    [self downloadImageWithUrl:url withCompletionHandler:completionHandler withDownloadProgressHandler:progressHandler];
}

-(void)downloadImageWithUrl:(NSURL *)url
      withCompletionHandler:(MR_DownloadImageCompletionBlock)completionHandler
withDownloadProgressHandler:(MR_DownloadImageProgressBlock)progressHandler
{
    //Create Operation
    MR_Operation *operation=[[MR_Operation alloc] initWithImageUrl:url
                                                 withOperationQueue:_downloadQueue
                                             withCompletionHandler:completionHandler
                                       withDownloadProgressHandler:progressHandler];
    
    //Add operation into download Queue
    [self.downloadQueue addOperation:operation];
    
    //Add-Observer----Just for DEMO Purpose, HOW to USE KVO.... :)
    [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isFinished"]){
        MR_Operation *operation = object;
        if (operation.isFinished){
            [operation removeObserver:self forKeyPath:keyPath];
           // NSLog(@"\n\n Operation has been completed for URL =%@",operation.request.URL);
        }
    }
}
@end
