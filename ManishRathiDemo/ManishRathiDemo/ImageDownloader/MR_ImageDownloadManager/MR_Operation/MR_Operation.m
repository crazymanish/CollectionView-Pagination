//
//  MR_Operation.m
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

#import "MR_Operation.h"

@interface MR_Operation ()
{
    MR_DownloadImageCompletionBlock completionBlock;
    MR_DownloadImageProgressBlock progressBlock;
    NSOperationQueue *operationQueue;
}

/**
 The request used by the operation's connection.
 */
@property (nonatomic,strong,readwrite) NSURLRequest *request;

/**
 The data received during the request.
 */
@property (nonatomic,strong,readwrite) NSMutableData *responseData;

/**
 UrlConnection
 */
@property (nonatomic,strong,readwrite) NSURLConnection *connection;

/** response-Data Length */
@property (nonatomic)long long dataLengthOfConnection;

/**
 * useful for KVO
 */
@property (nonatomic,readwrite,getter = isExecuting) BOOL executing;
@property (nonatomic,readwrite,getter = isFinished) BOOL finished;
@property (nonatomic,readwrite,getter = isCancelled) BOOL cancelled;

@end

@implementation MR_Operation

#pragma mark - Init
/**
 @param url ---->ImageUrl
 completionHandler ---->Download-Image CompletionBlock
 progressHandler ---->Download-Image CompletionBlock
 */
-(instancetype)initWithImageUrl:(NSURL *)url
              withOperationQueue:(NSOperationQueue *)queue
          withCompletionHandler:(MR_DownloadImageCompletionBlock)completionHandler
    withDownloadProgressHandler:(MR_DownloadImageProgressBlock)progressHandler;
{
    self = [super init];
    if (!self) {
		return nil;
    }
    
    //Request for Downloading Image
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:url];
    _request = urlRequest;
    completionBlock=completionHandler;
    progressBlock=progressHandler;
    operationQueue=queue;

    __weak MR_Operation *weakSelf = self;
    //__weak NSURLRequest *weakUrlRequest = _request;
    [self setCompletionBlock: ^{
        [weakSelf cancel];
       // NSLog(@"\n\n Connection released for URL: \n %@",weakUrlRequest.URL);
    }];
    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Toal Expected length
    _dataLengthOfConnection = [response expectedContentLength];
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //append Data
    [_responseData appendData:data];
    
    /**
     * Progress Block
     */
    progressBlock(_request.URL,[data length],[_responseData length],_dataLengthOfConnection);
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    //Finish
    [self finish];
    
    //Complition Block with Sucess Image
    UIImage *image = [UIImage imageWithData:_responseData];
    completionBlock(image,_request.URL,nil);
}

#pragma mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //Finish
    [self finish];
    
    //Complition Block with Failure Error
    completionBlock(nil,_request.URL,error);
}

#pragma mark - Override Start Function  @Manish
- (void)start
{
    //@Manish ----> lock Self here, for thread-safe
    @synchronized (self){
        if (!_executing && !_cancelled){
            [self willChangeValueForKey:@"isExecuting"];
            _executing = YES;
            _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
            _responseData = [[NSMutableData alloc] init];
           // [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            [_connection setDelegateQueue:operationQueue];
            [_connection start];
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

#pragma mark - Override Cancel Function  @Manish
- (void)cancel
{
        //@Manish ----> lock Self here, for thread-safe
    @synchronized (self){
        if (!_cancelled){
            [self willChangeValueForKey:@"isCancelled"];
            _cancelled = YES;
            [_connection cancel];
            [self didChangeValueForKey:@"isCancelled"];
            
            //call callback
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
            //Complition Block with Failure Error
            completionBlock(nil,_request.URL,error);
        }
    }
}

#pragma mark - Override Finish Function  @Manish
- (void)finish
{
        //@Manish ----> lock Self here, for thread-safe
    @synchronized (self){
        if (_executing && !_finished){
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            _executing = NO;
            _finished = YES;
            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

#pragma mark - dealloc  @Manish
-(void)dealloc
{
    _connection = nil;
    _responseData = nil;
    _request = nil;
}
@end
