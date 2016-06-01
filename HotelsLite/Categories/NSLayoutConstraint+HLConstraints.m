//
//  NSLayoutConstraint+HLConstraints.m
//  HotelsLite
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Alexander Borovikov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "NSLayoutConstraint+HLConstraints.h"

@implementation NSLayoutConstraint (HLConstraints)

+ (nonnull NSArray *)constraintsWithFormatArray:(nonnull NSArray *)formatArray
                                        options:(NSLayoutFormatOptions)opts
                                        metrics:(nullable NSDictionary *)metrics
                                          views:(nonnull NSDictionary *)views {
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *format in formatArray) {
        NSArray *c = [self constraintsWithVisualFormat:format
                                               options:opts
                                               metrics:metrics
                                                 views:views];
        [result addObjectsFromArray:c];
    }
    
    return [result copy];
}

+ (nonnull NSLayoutConstraint *)constraintsCenterX:(nonnull id)view
                                            toItem:(nullable id)view2
                                        multiplier:(CGFloat)multiplier
                                          constant:(CGFloat)constant {
    
    return [self constraintWithItem:view
                          attribute:NSLayoutAttributeCenterX
                          relatedBy:NSLayoutRelationEqual
                             toItem:view2
                          attribute:NSLayoutAttributeCenterX
                         multiplier:multiplier
                           constant:constant];
}

+ (nonnull NSLayoutConstraint *)constraintsCenterY:(nonnull id)view
                                            toItem:(nullable id)view2
                                        multiplier:(CGFloat)multiplier
                                          constant:(CGFloat)constant {
    
    return [self constraintWithItem:view
                          attribute:NSLayoutAttributeCenterY
                          relatedBy:NSLayoutRelationEqual
                             toItem:view2
                          attribute:NSLayoutAttributeCenterY
                         multiplier:multiplier
                           constant:constant];
}

@end
