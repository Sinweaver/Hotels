//
//  HLHotelDescriptionCell.m
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

#import "HLHotelDescriptionCell.h"

#import "HLLayoutHelper.h"
#import "HCSStarRatingView.h"

@interface HLHotelDescriptionCell ()

@property(strong, nonatomic) NSArray *layoutConstraints;

@end

@implementation HLHotelDescriptionCell

#pragma mark - Initializer
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        self.separatorInset = UIEdgeInsetsZero;
        
        [self.contentView addSubview:self.hotelDescriptionLabel];
        
        [NSLayoutConstraint activateConstraints:self.layoutConstraints];
    }
    return self;
}

#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Getters (Public)
- (UILabel *)hotelDescriptionLabel {
    if (!_hotelDescriptionLabel) {
        _hotelDescriptionLabel = [[UILabel alloc] init];
        _hotelDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _hotelDescriptionLabel.font = [UIFont systemFontOfSize:14.0];
        _hotelDescriptionLabel.textColor = [UIColor blackColor];
        _hotelDescriptionLabel.numberOfLines = 0;
        _hotelDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _hotelDescriptionLabel.text = @"<description>";
    }
    
    return _hotelDescriptionLabel;
}

#pragma mark - Getters (Private)
- (NSArray *)layoutConstraints {
    if (!_layoutConstraints) {
        NSDictionary *views = @{@"hotelDescriptionLabel" : self.hotelDescriptionLabel};
        
        NSArray *formatArray = @[@"V:|-10-[hotelDescriptionLabel]-10-|",
                                 @"H:|-10-[hotelDescriptionLabel]-10-|"];
        
        _layoutConstraints = [HLLayoutHelper constraintsWithFormatArray:formatArray
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    }
    
    return _layoutConstraints;
}

@end