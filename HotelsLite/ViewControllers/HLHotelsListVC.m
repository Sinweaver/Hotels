//
//  ViewController.m
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

#import "HLHotelsListVC.h"

#import "UIColor+HLColors.h"

#import "HLLayoutHelper.h"
#import "HLHotelLoader.h"

#import "HLHotel.h"

#import "HLHotelCell.h"
#import "HLHotelDetailVC.h"
#import "HCSStarRatingView.h"

static NSString * const hotelCellId = @"HLHotelCell";

typedef NS_ENUM(NSUInteger, SortType) {
    SortTypeNone,
    SortTypeByName,
    SortTypeByStars,
};

@interface HLHotelsListVC () <UITableViewDelegate, UITableViewDataSource,
UISearchBarDelegate>

@property(strong, nonatomic) UIBarButtonItem *sortButton;
@property(strong, nonatomic) UIRefreshControl *refreshControl;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) NSArray *layoutConstraints;

@property(strong, nonatomic) NSArray<HLHotel *> *originalHotels;
@property(strong, nonatomic) NSArray<HLHotel *> *sortedHotels;

@end

@implementation HLHotelsListVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Hotels.Title", nil);
    self.view.backgroundColor = [UIColor navigationBarColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.refreshControl];
    
    // Constraints.
    [NSLayoutConstraint activateConstraints:self.layoutConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // NavigationBar
    self.navigationItem.rightBarButtonItem = self.sortButton;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (!self.originalHotels) {
        [self _loadHotelsWithLoadingIndocator:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self _showLoadingIndicator:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Methods (Private)
- (void)_loadHotelsWithLoadingIndocator:(BOOL)indicator {
    [self _showLoadingIndicator:indicator];
    
    __weak typeof(self)weakSelf = self;
    HLHotelLoader *loader = [HLHotelLoader sharedInstance];
    [loader fetchHotelsWithBlock:^(NSArray<HLHotel *> * _Nullable hotels) {
        __strong typeof(self)strongSelf = weakSelf;
        
        strongSelf.originalHotels = hotels;
        strongSelf.sortedHotels = hotels;
        
        [strongSelf _showLoadingIndicator:NO];
        [strongSelf.refreshControl endRefreshing];
        [strongSelf.tableView reloadData];
        
        // Select first row on iPad.
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionTop];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
    }];
}

- (NSArray<HLHotel *> *)_filterHotels:(NSArray<HLHotel *> *)hotels text:(NSString *)text {
    if (text.length > 0) {
        NSString *format = @"self.hotelName CONTAINS[c] %@";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:format, text];
        
        return [self.originalHotels filteredArrayUsingPredicate:predicate];
    }
    else {
        return hotels;
    }
}

- (NSArray<HLHotel *> *)_sortHotels:(NSArray<HLHotel *> *)hotels sortType:(SortType)sortType {
    if (sortType == SortTypeByName) {
        return [hotels sortedArrayUsingComparator:^(HLHotel *obj1, HLHotel *obj2) {
            return [obj1.hotelName compare:obj2.hotelName];
        }];
    }
    else if (sortType == SortTypeByStars) {
        return [hotels sortedArrayUsingComparator:^(HLHotel *obj1, HLHotel *obj2) {
            return [obj2.hotelStars compare:obj1.hotelStars];
        }];
    }
    else {
        return hotels;
    }
}

- (void)_showLoadingIndicator:(BOOL)show {
    if (show) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self.activityIndicator startAnimating];
    }
    else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.activityIndicator stopAnimating];
    }
}

- (void)_resetSearchBar {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

#pragma mark - Actions
- (void)_onRefresh:(id)sender {
#pragma unused (sender)
    [self _loadHotelsWithLoadingIndocator:NO];
}

- (IBAction)_sortButtonPressed:(UIBarButtonItem *)sender {
    [self _resetSearchBar];
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:nil
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *destroyAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Hotels.SortByName", nil)
                             style:UIAlertActionStyleDefault
                           handler:
     ^(UIAlertAction *action) {
         self.sortedHotels = [self _sortHotels:self.originalHotels sortType:SortTypeByName];
         [self.tableView reloadData];
     }];
    
    UIAlertAction *otherAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Hotels.SortByRating", nil)
                             style:UIAlertActionStyleDefault
                           handler:
     ^(UIAlertAction *action) {
         self.sortedHotels = [self _sortHotels:self.originalHotels sortType:SortTypeByStars];
         [self.tableView reloadData];
     }];
    
    [alertController addAction:destroyAction];
    [alertController addAction:otherAction];
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    alertController.popoverPresentationController.barButtonItem = sender;
    alertController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:alertController animated:YES completion:nil];
    
    [alertController.view setTintColor:[UIColor blackColor]];
}

#pragma mark - SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
#pragma unused (searchBar)
    
    self.sortedHotels = [self _filterHotels:self.originalHotels text:text];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLHotel *hotel = [self.sortedHotels objectAtIndex:(NSUInteger)indexPath.row];
    HLHotelDetailVC *vc = [[HLHotelDetailVC alloc] initWithHotel:hotel];
    
    if (self.splitViewController.viewControllers.count > 1) {
        UINavigationController *navController =
        [self.splitViewController.viewControllers objectAtIndex:1];
        
        navController.viewControllers = @[vc];
    }
    else {
        [[HLHotelLoader sharedInstance] cancelAllRequests];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sortedHotels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:hotelCellId];
    
    HLHotel *hotel = [self.sortedHotels objectAtIndex:(NSUInteger)indexPath.row];
    cell.tag = indexPath.row;
    cell.hotelNameLabel.text = hotel.hotelName;
    cell.hotelAddressLabel.text = hotel.hotelAddress;
    cell.hotelStars.value = (CGFloat)hotel.hotelStars.integerValue;
    cell.hotelImageView.image = nil;
    
    HLHotelLoader *loader = [HLHotelLoader sharedInstance];
    NSString *imagePath = [hotel.hotelImagesPath objectAtIndex:0];
    [loader fetchHotelImageWithName:imagePath caching:YES block:
     ^(UIImage * _Nullable image) {
         if (cell.tag == indexPath.row) {
             cell.hotelImageView.image = image;
         }
     }];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
#pragma unused (scrollView)
    [self.searchBar resignFirstResponder];
}

#pragma mark - Getters (Private)
- (UIBarButtonItem *)sortButton {
    if (!_sortButton) {
        _sortButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Sort"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(_sortButtonPressed:)];
    }
    
    return _sortButton;
}

- (UIRefreshControl *)refreshControl {
    if(!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self
                            action:@selector(_onRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    }
    
    return _refreshControl;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
        _searchBar.placeholder = @"Поиск";
        _searchBar.delegate = self;
    }
    
    return _searchBar;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    return _activityIndicator;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        [_tableView registerClass:[HLHotelCell class]
           forCellReuseIdentifier:hotelCellId];
        
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.rowHeight = 100.0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.allowsSelection = YES;
        _tableView.allowsSelectionDuringEditing = NO;
        _tableView.allowsMultipleSelection = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableHeaderView = self.searchBar;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //Required for iOS 9
        SEL selector = @selector(setCellLayoutMarginsFollowReadableWidth:);
        if ([_tableView respondsToSelector:selector]) {
            _tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        
        [_tableView addSubview:self.activityIndicator];
    }
    
    return _tableView;
}

- (NSArray *)layoutConstraints {
    if (!_layoutConstraints) {
        id topGuide = self.topLayoutGuide;
        NSDictionary *views = @{@"tableView" : self.tableView,
                                @"topGuide" : topGuide};
        
        NSArray *formatArray = @[@"V:[topGuide]-0-[tableView]-0-|",
                                 @"H:|-0-[tableView]-0-|"];
        
        NSArray *constraints = [HLLayoutHelper constraintsWithFormatArray:formatArray
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
        
        NSLayoutConstraint *centerX = [HLLayoutHelper constraintsCenterX:self.activityIndicator
                                                                  toItem:self.tableView
                                                              multiplier:1.0
                                                                constant:0.0];
        
        NSLayoutConstraint *centerY = [HLLayoutHelper constraintsCenterY:self.activityIndicator
                                                                  toItem:self.tableView
                                                              multiplier:1.0
                                                                constant:0.0];
        
        NSMutableArray *result = [NSMutableArray array];
        [result addObjectsFromArray:constraints];
        [result addObject:centerX];
        [result addObject:centerY];
        
        _layoutConstraints = [result copy];
    }
    
    return _layoutConstraints;
}

@end
