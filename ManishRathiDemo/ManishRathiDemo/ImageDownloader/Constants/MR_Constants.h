//
//  MR_Constants.h
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


/**
 * Blocks TypeDef, which are used by many Classes
 */

typedef void (^MR_DownloadImageCompletionBlock)(UIImage *image,NSURL *imageUrl,NSError* error);
typedef void (^MR_DownloadImageProgressBlock)(NSURL *imageUrl,NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

/**
 * Just for DEMO, loading only two Images
 */
extern NSString * const kFirstImageUrlString;
extern NSString * const kSecondImageUrlString;