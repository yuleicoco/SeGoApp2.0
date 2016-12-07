//
//  PhotoGrapgModel.h
//  sego2.0
//
//  Created by czx on 16/12/5.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface PhotoGrapgModel : JSONModel
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *imagename;
@property (nonatomic, copy) NSString *networkaddress;
@property (nonatomic, copy) NSString *pgid;
@property (nonatomic, copy) NSString *pgtime;


@property (nonatomic, copy) NSArray *networkaddressArray;
@property (nonatomic, copy) NSArray *imagenameArray;

@end
