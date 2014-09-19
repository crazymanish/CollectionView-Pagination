//
//  MR_ProgressIndicator.m
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

#import "MR_ProgressIndicator.h"

#define kCircleProgressIndicatorDefaultColor [UIColor grayColor]
#define kCircleProgressIndicatorDefaultStrokeWidthRatio 0.15

@implementation MR_ProgressIndicator

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

-(void)setupDefaultValues {
    self.backgroundColor = [UIColor clearColor];
    self.color = kCircleProgressIndicatorDefaultColor;
    self.strokeWidthRatio = kCircleProgressIndicatorDefaultStrokeWidthRatio;
}


#pragma mark - Property Implementations

-(void)setValue:(CGFloat)value {
    if(value < 0.0) value = 0.0;
    if(value > 1.0) value = 1.0;
    
    _value = value;
    [self setNeedsDisplay];
}

-(void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidthRatio = -1.0;
    _strokeWidth = strokeWidth;
}

-(void)setStrokeWidthRatio:(CGFloat)strokeWidthRatio {
    _strokeWidth = -1.0;
    _strokeWidthRatio = strokeWidthRatio;
}


#pragma mark - Appearance Properties

-(void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}


#pragma mark - Drawing

-(void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    float minSize = MIN(rect.size.width, rect.size.height);
    float lineWidth = _strokeWidth;
    if(lineWidth == -1.0) lineWidth = minSize*_strokeWidthRatio;
    float radius = (minSize-lineWidth)/2;
    float endAngle = M_PI*(self.value*2);
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, center.x, center.y);
    CGContextRotateCTM(ctx, -M_PI*0.5);
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    // "Full" Background Circle:
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, 0, 0, radius, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, [_color colorWithAlphaComponent:0.1].CGColor);
    CGContextStrokePath(ctx);
    
    // Progress Arc:
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, 0, 0, radius, 0, endAngle, 0);
    CGContextSetStrokeColorWithColor(ctx, [_color colorWithAlphaComponent:0.9].CGColor);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

@end
