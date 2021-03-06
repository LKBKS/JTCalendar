//
//  JTCalendarDotsView.m
//  Pods
//
//  Created by Paweł Nużka on 08/07/15.
//
//

#import "JTCalendarDotsView.h"
#import "JTCircleViewCell.h"

@interface JTCalendarDotsView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSArray<UIColor *> *eventColors;
};
@property (nonatomic, strong) UICollectionView *dotsCollectionView;

@end

@implementation JTCalendarDotsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    eventColors = @[];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    _dotsCollectionView=[[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    [_dotsCollectionView setDataSource:self];
    [_dotsCollectionView setDelegate:self];
    [_dotsCollectionView setScrollEnabled:false];
    
    [_dotsCollectionView registerClass:[JTCircleViewCell class] forCellWithReuseIdentifier:[JTCircleViewCell identifier]];
    [_dotsCollectionView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:_dotsCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return eventColors.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // Add inset to the collection view if there are not enough cells to fill the width.
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = [self sizeForCollectionViewCell].width;
    NSInteger cellCount = eventColors.count;
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing))) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTCircleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[JTCircleViewCell identifier] forIndexPath:indexPath];
    [cell loadData:[self colorForIndexPath:indexPath]];
    return cell;
}

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath {
    //HotFix for eventColors, _ContiguousArrayStorage.deinit
    NSArray *eventColorsShallowCopy = [eventColors copy];
    if (indexPath.row < eventColorsShallowCopy.count) {
        //Exceptional case: colors tab is out of sync
        if (indexPath.row >= eventColors.count) {
            NSString *errorMsg = [NSString stringWithFormat:@"@EventColors:%@ is out of sync with indexPath:%@ eventColorsShallowCopy:%@",
                                  eventColors, indexPath, eventColorsShallowCopy];
            [self reportEventColorErrorWithMessage:errorMsg];
        }
        return eventColorsShallowCopy[indexPath.row];
    } else {
        //Exceptional case: no corresponding color for indexPath
        NSString *errorMsg = [NSString stringWithFormat:@"No coresponding color for indexPath:%@ eventColors:%@ eventColorsShallowCopy:%@",
                              indexPath, eventColors, eventColorsShallowCopy];
        [self reportEventColorErrorWithMessage:errorMsg];
        return [UIColor clearColor];
    }
}

- (void)reportEventColorErrorWithMessage:(NSString *)msg {
    if (msg && [self.manager.delegate respondsToSelector:@selector(calendar:failedToLoadEventColorWithError:)]) {
        NSError *error = [NSError errorWithDomain:@"JTCalendar" code:0 userInfo:@{NSLocalizedDescriptionKey:msg}];
        [self.manager.delegate calendar:self.manager failedToLoadEventColorWithError:error];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self sizeForCollectionViewCell];
}

- (CGSize)sizeForCollectionViewCell
{
    CGFloat sizeCircle = self.manager.settings.dayDotDiameter;
    CGFloat maxSizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    if (sizeCircle > maxSizeCircle) {
        sizeCircle = maxSizeCircle;
    }
    
    return CGSizeMake(sizeCircle, sizeCircle);
}

- (void)layoutSubviews {
    _dotsCollectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setEventColors:(NSArray<UIColor *> *)colors {
    int maxSize = self.manager.settings.dayDotLineWidthLimit * self.manager.settings.dayDotLineHeightLimit;
    if (colors.count > maxSize) {
        eventColors = [colors subarrayWithRange:NSMakeRange(0, maxSize)];
    } else {
        eventColors = colors;
    }
    self.hidden = NO;
    [_dotsCollectionView reloadData];
}

- (void)reload {
    [_dotsCollectionView reloadData];
}

@end
