//
//  HLHotelDetailVC.m
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

#import "HLHotelDetailVC.h"

#import "HLHotelLoader.h"

#import "HLHotel.h"

#import "HCSStarRatingView.h"
#import "HLHotelGalleryHeader.h"

#import "HLHotelDetailCell.h"
#import "HLHotelDescriptionCell.h"

#import "UIColor+HLColors.h"
#import "UIViewController+HLBackButton.h"
#import "NSLayoutConstraint+HLConstraints.h"

static NSString * const detailCellId        = @"HLHotelDetailCell";
static NSString * const defaultCellId       = @"UITableViewCell";
static NSString * const descriptionCellId   = @"HLHotelDescriptionCell";

static CGFloat const kTableHeaderHeight = 280.0;

@interface HLHotelDetailVC () <UITableViewDelegate, UITableViewDataSource> {
    HLHotel *_hotel;
}

@property(strong, nonatomic) HLHotelGalleryHeader *headerView;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIImageView *emptyImageView;

@property(strong, nonatomic) NSLayoutConstraint *topConstraint;
@property(strong, nonatomic) NSLayoutConstraint *heightConstraint;
@property(strong, nonatomic) NSArray *layoutConstraints;

@end

@implementation HLHotelDetailVC

#pragma mark - Initializer
- (nullable instancetype)initWithHotel:(nullable HLHotel *)hotel {
    self = [super init];
    if (self) {
        _hotel = hotel;
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.hotel.hotelName;
    self.view.backgroundColor = [UIColor navigationBarColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.emptyImageView];
    [self.tableView addSubview:self.headerView];
    
    // Constraints.
    [NSLayoutConstraint activateConstraints:self.layoutConstraints];
    [NSLayoutConstraint activateConstraints:@[self.topConstraint,
                                              self.heightConstraint]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // NavigationBar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    // Replace the default back button
    [self setBackButtonWithImage:[UIImage imageNamed:@"Back"]];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [self _calculateHeaderConstraints:self.tableView];
    
    [super viewWillLayoutSubviews];
}

#pragma mark - Methods (Private)
- (void)_calculateHeaderConstraints:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset < -kTableHeaderHeight) {
        self.topConstraint.constant = offset;
        self.heightConstraint.constant = -offset;
    }
    else {
        self.topConstraint.constant = -kTableHeaderHeight;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self _calculateHeaderConstraints:scrollView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.hotel ? 2 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        HLHotelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellId];
        cell.hotelNameLabel.text = self.hotel.hotelName;
        cell.hotelAddressLabel.text = self.hotel.hotelAddress;
        cell.hotelPhoneLabel.text = self.hotel.hotelPhone;
        cell.hotelStars.value = (CGFloat)self.hotel.hotelStars.integerValue;
        return cell;
    }
    if(indexPath.row == 1) {
        HLHotelDescriptionCell *cell =
        [tableView dequeueReusableCellWithIdentifier:descriptionCellId];
        cell.hotelDescriptionLabel.text = self.hotel.hotelDescription;
        return cell;
    }
    else {
        return [tableView dequeueReusableCellWithIdentifier:defaultCellId];
    }
}

#pragma mark - Getters (Public)
- (HLHotel *)hotel {
    return _hotel;
}

#pragma mark - Getters (Private)
- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] init];
        _emptyImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _emptyImageView.contentMode = UIViewContentModeCenter;
        _emptyImageView.image = [UIImage imageNamed:@"Hotel"];
        _emptyImageView.clipsToBounds = YES;
        _emptyImageView.hidden = self.hotel;
    }
    
    return _emptyImageView;
}

- (HLHotelGalleryHeader *)headerView {
    if (!_headerView) {
        _headerView = [[HLHotelGalleryHeader alloc] initWithImagePathArray:
                       self.hotel.hotelImagesPath];
        _headerView.translatesAutoresizingMaskIntoConstraints = NO;
        _headerView.hidden = !self.hotel;
    }
    
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        [_tableView registerClass:[HLHotelDetailCell class]
           forCellReuseIdentifier:detailCellId];
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:defaultCellId];
        [_tableView registerClass:[HLHotelDescriptionCell class]
           forCellReuseIdentifier:descriptionCellId];
        
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 95.0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.contentInset = UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0);
        _tableView.contentOffset = CGPointMake(0, -kTableHeaderHeight);
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.allowsSelection = NO;
        _tableView.allowsSelectionDuringEditing = NO;
        _tableView.allowsMultipleSelection = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:
                                      CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //Required for iOS 9
        SEL selector = @selector(setCellLayoutMarginsFollowReadableWidth:);
        if ([_tableView respondsToSelector:selector]) {
            _tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
    }
    
    return _tableView;
}

- (NSLayoutConstraint *)topConstraint {
    if (!_topConstraint) {
        _topConstraint =
        [NSLayoutConstraint constraintWithItem:self.headerView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.tableView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:-kTableHeaderHeight];
    }
    
    return _topConstraint;
}

- (NSLayoutConstraint *)heightConstraint {
    if (!_heightConstraint) {
        _heightConstraint =
        [NSLayoutConstraint constraintWithItem:self.headerView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:0
                                        toItem:nil
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1.0
                                      constant:kTableHeaderHeight];
    }
    
    return _heightConstraint;
}

- (NSArray *)layoutConstraints {
    if (!_layoutConstraints) {
        id topGuide = self.topLayoutGuide;
        NSDictionary *views = @{@"tableView" : self.tableView,
                                @"headerView" : self.headerView,
                                @"emptyImageView" : self.emptyImageView,
                                @"topGuide" : topGuide};
        
        NSArray *formatArray = @[@"V:[topGuide]-0-[tableView]-0-|",
                                 @"V:[emptyImageView(80)]",
                                 
                                 @"H:|-0-[tableView]-0-|",
                                 @"H:|-0-[headerView(==tableView)]",
                                 @"H:[emptyImageView(80)]"];
        
        NSArray *constraints = [NSLayoutConstraint constraintsWithFormatArray:formatArray
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintsCenterX:self.emptyImageView
                                                                      toItem:self.tableView
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintsCenterY:self.emptyImageView
                                                                      toItem:self.tableView
                                                                  multiplier:1.0
                                                                    constant:-kTableHeaderHeight];
        
        NSMutableArray *result = [NSMutableArray array];
        [result addObjectsFromArray:constraints];
        [result addObject:centerX];
        [result addObject:centerY];
        
        _layoutConstraints = [result copy];
    }
    
    return _layoutConstraints;
}

@end
