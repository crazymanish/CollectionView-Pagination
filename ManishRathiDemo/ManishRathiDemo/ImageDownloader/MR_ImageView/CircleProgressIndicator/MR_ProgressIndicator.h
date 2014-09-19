//
//  MR_ProgressIndicator.h
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

#import <UIKit/UIKit.h>

@interface MR_ProgressIndicator : UIView

/**
 * Represents the displayed progress value. Set it to update the progress indicator.
 * Pass a float number between 0.0 and 1.0.
 */
@property (nonatomic) CGFloat value;

/**
 * The color which is used to draw the progress indicator. Use UIAppearance to
 * style according your needs.
 */
@property (nonatomic, strong) UIColor *color UI_APPEARANCE_SELECTOR;

/**
 * The stroke width ratio is used to calculate the circle thickness regarding the
 * actual size of the progress indicator view. When setting this, strokeWidth is
 * ignored.
 * Use UIAppearance to style according your needs.
 */
@property (nonatomic) CGFloat strokeWidthRatio UI_APPEARANCE_SELECTOR;

/**
 * If you'd like to specify the stroke thickness of the progress indicator circle
 * explicitly, use the strokeWidth property. When setting this, strokeWidthRatio
 * is ignored.
 * Use UIAppearance to style according your needs.
 */
@property (nonatomic) CGFloat strokeWidth UI_APPEARANCE_SELECTOR;

@end
