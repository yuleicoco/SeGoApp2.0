//
//  RepositPictureViewController.m
//  sego2.0
//
//  Created by czx on 16/12/2.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "RepositPictureViewController.h"
#import "UIImage-Extensions.h"
#import "MyVideoCollectionViewCell.h"
#import "AFHttpClient+Reposit.h"
//#import "RecordModel.h"
#import "PhotoGrapgModel.h"
#import "IssueViewController.h"


static NSString *kfooterIdentifier = @"footerIdentifier";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kRecordheaderIdentifier = @"RecordHeaderIdentifier";
@interface RepositPictureViewController ()
{
    NSMutableArray * deleteOrUpdateArr;
}
@property (nonatomic,strong)UIButton * numBtn;
@property (nonatomic,strong)UIButton * rightBtn;

@end

@implementation RepositPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_COLOR;
}
-(void)setupData{
    [super setupData];
    deleteOrUpdateArr =[[NSMutableArray alloc]init];
    [self.dataSource addObject:[[PhotoGrapgModel alloc] init]];
}


-(void)setupView{
    [super setupView];
    UIView * bottomview = [[UIView alloc]init];
    bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomview];
    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomview.superview);
        make.right.equalTo(bottomview.superview);
        make.bottom.equalTo(bottomview.superview);
        make.height.mas_equalTo(50);
    
    }];
    
    UIButton * dancelbtn = [[UIButton alloc]init];
    [dancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [dancelbtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    dancelbtn.titleLabel.font = [UIFont systemFontOfSize:18];
     [dancelbtn addTarget:self action:@selector(dancelBtnToucch) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:dancelbtn];
    [dancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dancelbtn.superview).offset(79);
        make.centerY.equalTo(dancelbtn.superview.mas_centerY);
        
        
    }];
    
    _rightBtn = [[UIButton alloc]init];
    [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:RGB(220, 220, 220) forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_rightBtn.layer setMasksToBounds:YES];
       [_rightBtn addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightBtn.superview).offset(-79);
        make.centerY.equalTo(_rightBtn.superview.mas_centerY);
        
    }];
    
    
    _numBtn = [[UIButton alloc]init];
    _numBtn.backgroundColor = GREEN_COLOR;
    _numBtn.layer.cornerRadius =9;
    [_numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _numBtn.hidden = YES;
    [bottomview addSubview:_numBtn];
    [_numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightBtn.mas_right).offset(6);
        make.centerY.equalTo(_numBtn.superview.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    
    }];
    
    
    
    
    
    //    self.collectionView.frame = CGRectMake(0, 50, self.view.width , self.view.height-50);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionView.superview);
        make.right.equalTo(self.collectionView.superview);
        make.top.equalTo(self.collectionView.superview.mas_top);
        make.bottom.equalTo(bottomview.mas_bottom).offset(-60);
        
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator   = NO;
    
    [self.collectionView registerClass:[MyVideoCollectionViewCell class] forCellWithReuseIdentifier:@"imageId"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SQSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderViewCollection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecordHeaderViewCollection" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRecordheaderIdentifier];
    
    self.collectionView.backgroundColor =[UIColor whiteColor];
    
    [self initRefreshView];
    
    //self.headPortra

}
-(void)loadDataSourceWithPage:(int)page{
      _numBtn.hidden = YES;
    [_rightBtn setTitleColor:RGB(220, 220, 220) forState:UIControlStateNormal];
    [deleteOrUpdateArr removeAllObjects];
    [[AFHttpClient sharedAFHttpClient]getPhotoGraphWithMid:[AccountManager sharedAccountManager].loginModel.mid page:page complete:^(BaseModel *model) {
        if (model) {
            if (page == START_PAGE_INDEX) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObject:[[PhotoGrapgModel alloc] init]];
            }
            
            for (PhotoGrapgModel * photoModel in model.list) {
                photoModel.networkaddressArray = [photoModel.networkaddress componentsSeparatedByString:@","];
                photoModel.imagenameArray = [photoModel.imagename componentsSeparatedByString:@","];
             //   recordModel.typeArray = [recordModel.type componentsSeparatedByString:@","];
            }
            
            //if (model.list.count == 0) {
                self.collectionView.mj_footer.hidden = YES;
            //}else{
            //    self.collectionView.mj_footer.hidden = NO;
          //  }
            
            
            [self.dataSource addObjectsFromArray:model.list];
            
        }
        
        [self handleEndRefresh];
          [self.collectionView reloadData];
        
        
        
    }];
    
    
    
}

#pragma Mark  --- collectionDelegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    
    PhotoGrapgModel *model = self.dataSource[section];
    
    return model.imagenameArray.count;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 //   return CGSizeMake((collectionView.width - 4 * 10 ) / 4 , (collectionView.width - 4 * 10 ) / 4);
    //  return CGSizeMake(88.5 * W_Wide_Zoom, 85.5 * W_Hight_Zoom);
    //  return CGSizeMake(110 * W_Wide_Zoom, 110 * W_Hight_Zoom);
  //  return CGSizeMake(MainScreen.width/5+5, MainScreen.width/5+5);
    return CGSizeMake((collectionView.width - 4 * 10 ) / 4 , (collectionView.width - 4 * 10 ) / 4);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5,5);
    //return UIEdgeInsetsMake(13, 11 , 0, 11);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return nil;
    }
    
    PhotoGrapgModel *model = self.dataSource[indexPath.section];
    
    MyVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageId" forIndexPath:indexPath];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.networkaddressArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    
    cell.imageV.backgroundColor = [UIColor blackColor];
    cell.imageV.tag = 1000*(indexPath.section+1) +indexPath.row;
    cell.imageV.userInteractionEnabled = YES;
    
//    if ([model.typeArray[indexPath.row] isEqualToString:@"video"]) {
      //  cell.startImageV.hidden = NO;
//    }else{
//        cell.startImageV.hidden = YES;
//    }
    UITapGestureRecognizer *tapMYP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onVideo:)];
    [cell.imageV addGestureRecognizer:tapMYP];
    cell.rightBtn.hidden = YES;
    
    
    return cell;
}


//头部
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size;
    
    if (section == 0) {
        size = CGSizeMake(self.collectionView.width, 0 * W_Hight_Zoom);
    }else {
        size = CGSizeMake(self.collectionView.width, 20);
    }
    
    return size;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size ;
    
    if (section == 0) {
        size = CGSizeZero;
    }else{
        size = CGSizeMake(self.collectionView.width, 0);
    }
    
    return size;
}

// heder和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    UICollectionReusableView *view;
    
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = kfooterIdentifier;
        view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        //        UILabel *label = (UILabel *)[view viewWithTag:1111];
        view.backgroundColor =[UIColor whiteColor];
        //  label.backgroundColor =[UIColor redColor];
    }else{
        reuseIdentifier = kheaderIdentifier;
        view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
        UILabel *label = (UILabel *)[view viewWithTag:2222];
        
        view.backgroundColor =[UIColor whiteColor];
        
        PhotoGrapgModel *model = self.dataSource[indexPath.section];
        
        label.text = model.pgtime;
    }
    
    return view;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    MyVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageId" forIndexPath:indexPath];
//   // cell.imageV.hidden = YES;
//    cell.startImageV.hidden = YES;
//    //[self.collectionView reloadData];
////    FuckLog(indexPath);
//    NSLog(@"%@",indexPath);
//
//
//
//}



- (void)onVideo:(UITapGestureRecognizer *)imageSender
{
    NSUserDefaults * userdefautls = [NSUserDefaults standardUserDefaults];
    NSMutableArray * videoArrray = [userdefautls objectForKey:@"respositVideo"];
    if (videoArrray.count >0) {
        [[AppUtil appTopViewController] showHint:@"只能单独选择视频或图片发布"];
        return;
    }
    
    
    
    NSInteger i = imageSender.view.tag/1000;//分区
    int j = imageSender.view.tag%1000;//每个分区的分组
    
    PhotoGrapgModel *model = self.dataSource[i - 1];
    NSArray *imageA  = model.networkaddressArray;
     MyVideoCollectionViewCell *cell = (MyVideoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i-1]];
    
    if (deleteOrUpdateArr.count>=4) {
        if (cell.rightBtn.hidden == NO) {
            cell.rightBtn.hidden = YES;
            cell.rightBtn.selected = NO;
            [deleteOrUpdateArr removeObject:imageA[j]];//把要删除的图片从删除数组中删除
        }else{
            [[AppUtil appTopViewController] showHint:@"您只能选择最多四张图片"];
            return;
        }
    }else{
        if (cell.rightBtn.hidden == YES) {
            cell.rightBtn.hidden = NO;
            cell.rightBtn.selected = YES;
            [deleteOrUpdateArr addObject:imageA[j]];//把要删除的图片加入删除数组
            
        }else{
            cell.rightBtn.hidden = YES;
            cell.rightBtn.selected = NO;
            [deleteOrUpdateArr removeObject:imageA[j]];//把要删除的图片从删除数组中删除
        }
    }
    
    if (deleteOrUpdateArr.count>0) {
        _numBtn.hidden = NO;
        [_numBtn setTitle:[NSString stringWithFormat:@"%ld",deleteOrUpdateArr.count] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        _rightBtn.selected = NO;
    }else{
        _numBtn.hidden = YES;
       // _numBtn.backgroundColor = [UIColor redColor];
        [_rightBtn setTitleColor:RGB(220, 220, 220) forState:UIControlStateNormal];
        //_rightBtn.selected = YES;
    }
    
    NSUserDefaults * userdefautls2 = [NSUserDefaults standardUserDefaults];
    [userdefautls2 setObject:deleteOrUpdateArr forKey:@"repositImage"];
    [userdefautls2 synchronize];
    
}


-(void)rightButtonTouch{
    NSLog(@"%@",deleteOrUpdateArr);
    if (deleteOrUpdateArr.count > 0) {
        IssueViewController * issVc = [[IssueViewController alloc]init];
        //issVc.ImageArray = thunmArray;
        issVc.ImageArray = deleteOrUpdateArr;
        issVc.porv = @"p";
        [self.navigationController pushViewController:issVc animated:NO];
    }else{
    
    }
   
    
}
-(void)dancelBtnToucch{
    [self.navigationController popViewControllerAnimated:NO];
    
}

@end
