//
//  MR_Operation.h
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

#import <Foundation/Foundation.h>
#import "MR_Constants.h"

@interface MR_Operation : NSOperation

/**
 The request used by the operation's connection.
 */
@property (nonatomic,strong,readonly) NSURLRequest *request;

/**
 The data received during the request.
 */
@property (nonatomic,strong,readonly) NSMutableData *responseData;

/**
  UrlConnection
 */
@property (nonatomic,strong,readonly) NSURLConnection *connection;

/**
 * useful for KVO
 */
@property (nonatomic,readonly,getter = isExecuting) BOOL executing;
@property (nonatomic,readonly,getter = isFinished) BOOL finished;
@property (nonatomic,readonly,getter = isCancelled) BOOL cancelled;

//≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
// Init with URL for start downloading the Image
//≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠

/**
 @param url ---->ImageUrl
 completionHandler ---->Download-Image CompletionBlock
 progressHandler ---->Download-Image CompletionBlock
 */
-(instancetype)initWithImageUrl:(NSURL *)url
              withOperationQueue:(NSOperationQueue *)queue
          withCompletionHandler:(MR_DownloadImageCompletionBlock)completionHandler
    withDownloadProgressHandler:(MR_DownloadImageProgressBlock)progressHandler;

@end
