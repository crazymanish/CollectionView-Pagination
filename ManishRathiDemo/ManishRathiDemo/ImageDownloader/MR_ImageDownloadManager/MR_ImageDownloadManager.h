//
//  MR_ImageDownloadManager.h
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

@interface MR_ImageDownloadManager : NSObject

//Singleton Instance
+(MR_ImageDownloadManager *)sharedInstance;

//Download-Queue Readonly access for other classes
@property (nonatomic,strong,readonly) NSOperationQueue *downloadQueue;

/** Cancel Operations */
-(void)cancelOperationForUrl:(NSURL *)url;
//Cancel All
-(void)cancelAllOperations;

/** Download-Image Here */
-(void)downloadImageWithUrlString:(NSString *)urlString
      withCompletionHandler:(MR_DownloadImageCompletionBlock)completionHandler
withDownloadProgressHandler:(MR_DownloadImageProgressBlock)progressHandler;

-(void)downloadImageWithUrl:(NSURL *)url
      withCompletionHandler:(MR_DownloadImageCompletionBlock)completionHandler
withDownloadProgressHandler:(MR_DownloadImageProgressBlock)progressHandler;

@end
