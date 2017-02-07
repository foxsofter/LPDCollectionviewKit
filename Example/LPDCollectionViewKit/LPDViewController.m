//
//  LPDViewController.m
//  LPDCollectionViewKit
//
//  Created by foxsofter on 12/04/2016.
//  Copyright (c) 2016 foxsofter. All rights reserved.
//

#import <LPDCollectionViewKit/LPDCollectionViewKit.h>
#import <LPDNetworkingKit/LPDNetworkingKit.h>
#import <LPDAdditionsKit/LPDAdditionsKit.h>
#import <Masonry/Masonry.h>
#import "LPDViewController.h"
#import "LPDPhotoModel.h"
#import "LPDCollectionPhotoCellViewModel.h"
#import "LPDCollectionViewPhotoCell.h"

@interface LPDViewController ()

@property (nonatomic, strong) LPDCollectionView *collectionView;
@property (nonatomic, strong) LPDCollectionViewModel *collectionViewModel;
@property (nonatomic, strong) LPDApiClient *apiClient;

@end

@implementation LPDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
  collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  collectionViewFlowLayout.itemSize = CGSizeMake((UIScreen.width - 30) / 2, (UIScreen.width - 30) / 2);
  collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
  collectionViewFlowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
  collectionViewFlowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 1);
  
  self.collectionView =
  [[LPDCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.collectionViewModel = [[LPDCollectionViewModel alloc] init];
  [self.collectionView bindingTo:self.collectionViewModel];
  [self.view addSubview:self.collectionView];
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsZero);
  }];

  UIBarButtonItem *addCellBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"ac" style:UIBarButtonItemStylePlain target:self action:@selector(addCell)];
  
  UIBarButtonItem *addCellsBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"acs" style:UIBarButtonItemStylePlain target:self action:@selector(addCells)];
  
  UIBarButtonItem *insertCellBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"ic" style:UIBarButtonItemStylePlain target:self action:@selector(insertCell)];
  
  UIBarButtonItem *insertCellsBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"ics" style:UIBarButtonItemStylePlain target:self action:@selector(insertCells)];
  
  UIBarButtonItem *removeCellBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"rc" style:UIBarButtonItemStylePlain target:self action:@selector(removeCell)];
  
  UIBarButtonItem *removeCellsBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"rcs" style:UIBarButtonItemStylePlain target:self action:@selector(removeCells)];
  
  UIBarButtonItem *replaceCellsBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"rpcs" style:UIBarButtonItemStylePlain target:self action:@selector(replaceCells)];
  
  UIBarButtonItem *insertSectionBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"is" style:UIBarButtonItemStylePlain target:self action:@selector(insertSection)];

  self.navigationController.toolbarHidden = NO;
  [self setToolbarItems:@[addCellBarButtonItem,
                          addCellsBarButtonItem,
                          insertCellBarButtonItem,
                          insertCellsBarButtonItem,
                          removeCellBarButtonItem,
                          removeCellsBarButtonItem,
                          replaceCellsBarButtonItem,
                          insertSectionBarButtonItem,]
               animated:YES];

  @weakify(self);
  LPDApiServer *apiSever = [[LPDApiServer alloc]init];
  [apiSever setServerUrl:@"https://jsonplaceholder.typicode.com" forServerType:LPDApiServerTypeAlpha];
  [apiSever setServerType:LPDApiServerTypeAlpha];
  _apiClient = [[LPDApiClient alloc] initWithServer:apiSever];
  [[_apiClient rac_GET:kLPDApiEndpointPhotos parameters:nil] subscribeNext:^(RACTuple *tuple){
    @strongify(self);
    NSMutableArray *datas = [NSMutableArray arrayWithArray:tuple.first];
    [self reloadCollection:[datas subarrayWithRange:NSMakeRange(0, 3)]];
  } error:^(NSError *error) {
    
  } completed:^{
    
  }];
}

-(void)reloadCollection:(NSArray *)datas {
  if (datas && datas.count > 0) {
    NSMutableArray *cellViewModels = [NSMutableArray array];
    for (LPDPhotoModel *model in datas) {
      LPDCollectionPhotoCellViewModel *cellViewModel = [[LPDCollectionPhotoCellViewModel alloc]initWithViewModel:self.collectionViewModel];
      cellViewModel.model = model;
      [cellViewModels addObject:cellViewModel];
    }
    [self.collectionViewModel replaceSectionWithCellViewModels:cellViewModels];
  }else{
    [self.collectionViewModel removeAllSections];
  }
}

#pragma mark - operations

- (void)addCell {
  LPDPhotoModel *model = [[LPDPhotoModel alloc]init];
  model.albumId = 111;
  model.identifier = 131;
  model.title = @"officia porro iure quia iusto qui ipsa ut modi";
  model.thumbnailUrl = @"http://placehold.it/150/1941e9";
  model.url = @"http://placehold.it/600/24f355";
  
  LPDCollectionPhotoCellViewModel *cellViewModel =
  [[LPDCollectionPhotoCellViewModel alloc] initWithViewModel:self.collectionViewModel];
  cellViewModel.model = model;
  [self.collectionViewModel addCellViewModel:cellViewModel];
}

- (void)addCells {
  NSMutableArray *cellViewModels = [NSMutableArray array];
  for (NSInteger i = 0; i < 3; i++) {
    LPDPhotoModel *model = [[LPDPhotoModel alloc]init];
    model.albumId = 111111;
    model.identifier = 1003131;
    model.title = @"officia porro iure quia iusto qui ipsa ut modi";
    model.thumbnailUrl = @"http://placehold.it/150/1941e9";
    model.url = @"http://placehold.it/600/24f355";
    
    LPDCollectionPhotoCellViewModel *cellViewModel =
    [[LPDCollectionPhotoCellViewModel alloc] initWithViewModel:self.collectionViewModel];
    cellViewModel.model = model;
    [cellViewModels addObject:cellViewModel];
  }
  [self.collectionViewModel addCellViewModels:cellViewModels];
}

- (void)insertCell {
  LPDPhotoModel *model = [[LPDPhotoModel alloc]init];
  model.albumId = 111;
  model.identifier = 131;
  model.title = @"officia porro iure quia iusto qui ipsa ut modi";
  model.thumbnailUrl = @"http://placehold.it/150/1941e9";
  model.url = @"http://placehold.it/600/24f355";
  
  LPDCollectionPhotoCellViewModel *cellViewModel =
  [[LPDCollectionPhotoCellViewModel alloc] initWithViewModel:self.collectionViewModel];
  cellViewModel.model = model;
  [self.collectionViewModel insertCellViewModel:cellViewModel atIndex:0];
}

- (void)insertCells {
  NSMutableArray *cellViewModels = [NSMutableArray array];
  for (NSInteger i = 0; i < 3; i++) {
    LPDPhotoModel *model = [[LPDPhotoModel alloc]init];
    model.albumId = 111111;
    model.identifier = 1003131;
    model.title = @"officia porro iure quia iusto qui ipsa ut modi";
    model.thumbnailUrl = @"http://placehold.it/150/1941e9";
    model.url = @"http://placehold.it/600/24f355";
    
    LPDCollectionPhotoCellViewModel *cellViewModel =
    [[LPDCollectionPhotoCellViewModel alloc] initWithViewModel:self.collectionViewModel];
    cellViewModel.model = model;
    [cellViewModels addObject:cellViewModel];
  }
  [self.collectionViewModel insertCellViewModels:cellViewModels atIndex:0];
}

- (void)removeCell {
  [self.collectionViewModel removeLastCellViewModel];
}

- (void)removeCells {
  [self.collectionViewModel removeSectionAtIndex:0];
}

- (void)replaceCells {
  NSMutableArray *cellViewModels = [NSMutableArray array];
  for (NSInteger i = 0; i < 3; i++) {
    LPDPhotoModel *model = [[LPDPhotoModel alloc]init];
    model.albumId = 111111;
    model.identifier = 1003131;
    model.title = @"officia porro iure quia iusto qui ipsa ut modi";
    model.thumbnailUrl = @"http://placehold.it/150/1941e9";
    model.url = @"http://placehold.it/600/24f355";
    
    LPDCollectionPhotoCellViewModel *cellViewModel =
    [[LPDCollectionPhotoCellViewModel alloc] initWithViewModel:self.collectionViewModel];
    cellViewModel.model = model;
    [cellViewModels addObject:cellViewModel];
  }
  [self.collectionViewModel replaceCellViewModels:cellViewModels fromIndex:1];
}

- (void)insertSection {
  LPDCollectionSectionWithHeadTitleViewModel *sectionViewModel = [LPDCollectionSectionWithHeadTitleViewModel section];
  
  sectionViewModel.headerTitle = @"逗你玩";
  [self.collectionViewModel addSectionViewModel:sectionViewModel];
}

@end
