//
//  MxMovingPlaceholderTextField.m
//  Copyright (c) 2013 Max Bäumle. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this
//  software and associated documentation files (the "Software"), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify,
//  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MxMovingPlaceholderTextField.h"

@interface MxMovingPlaceholderTextField () {
    CGFloat _placeholderWidth;
    BOOL _isMoving;
    CGFloat _x;
    BOOL _leftToRight;
}

- (void)movePlaceholder;

@end

@implementation MxMovingPlaceholderTextField

- (void)awakeFromNib {
    if ([[self superclass] instancesRespondToSelector:@selector(awakeFromNib)]) {
        [super awakeFromNib];
    }
    
    _placeholderWidth = [self.placeholder sizeWithFont:self.font].width;
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    _placeholderWidth = [placeholder sizeWithFont:self.font].width;
    _x = 0.0f;
    _leftToRight = NO;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    
    if (_placeholderWidth > placeholderRect.size.width) {
        if (_x >= _placeholderWidth - (placeholderRect.size.width - (bounds.size.width - placeholderRect.size.width) * 0.5)) {
            _leftToRight = YES;
        } else if (_x <= 0.0f) {
            _leftToRight = NO;
        }
        
        if (!_leftToRight) {
            _x += 1.0f;
        } else {
            _x -= 1.0f;
        }
        
        placeholderRect.origin.x -= _x;
        placeholderRect.size.width = _placeholderWidth;
    }
    
    return placeholderRect;
}

- (void)startMoving {
    if (!_isMoving) {
        _isMoving = YES;
        [self movePlaceholder];
    }
}

- (void)stopMoving {
    if (_isMoving) {
        _isMoving = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movePlaceholder) object:nil];
    }
}

- (void)movePlaceholder {
    if (!_isMoving) {
        return;
    }
    
    if ([self.text length] == 0 && [self.placeholder length] > 0) {
        [self setNeedsLayout];
    }
    
    [self performSelector:@selector(movePlaceholder) withObject:nil afterDelay:1.0 / 30.0]; // 30 FPS
}

@end
