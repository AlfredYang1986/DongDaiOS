//
//  AYAlbumDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYAlbumDefines_h
#define AYAlbumDefines_h
typedef NS_ENUM(NSInteger, AlbumControllerType) {
    AlbumControllerTypePhoto,
    AlbumControllerTypeMovie,
    AlbumControllerTypeCompire,
};

static NSString* const kAYAlbumTableCellName = @"AlbumTableCell";

//@protocol AlbumActionDelegate <NSObject>
//- (void)didCameraBtn: (UIViewController*)pv;
//- (void)didMovieBtn: (UIViewController*)pv;
//- (void)didCompareBtn: (UIViewController*)pv;
//- (void)postViewController:(UIViewController*)pv didPostSueecss:(BOOL)success;
//@end

#endif /* AYAlbumDefines_h */
