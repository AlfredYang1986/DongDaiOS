//
//  AYAliyunOSSFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 28/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYFacade.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>


NSString * const AYOSSAccessID = @"lC2a3NXist8peEDm";
NSString * const AYOSSAccessKey = @"WP59s7IZkHBqIWWs57Ho0yx9B28S9m";
NSString * const AYOSSEndPoint = @"http://blackmirror.oss-cn-beijing.aliyuncs.com";

NSString * const AYOSSSTSId = @"STS.GjXbCB9c3N7rAkBmUVVHZUAmA";
NSString * const AYOSSSTSSecretKey = @"CmwYNbufxckoLUzaSX15UzPMLKqjCocp5qNWN7d9n11r";
NSString * const AYOSSSTSSecurityToken = @"CAISgAJ1q6Ft5B2yfSjIpqntKfn21LwS+fWZQ03ziVUDWsd2uoTGozz2IHlMfnVhAe0asv03lGtR6Pgflq96T5FfSECc+BaeWGETo22beIPkl5Gfz95t0e+IewW6Dxr8w7WhAYHQR8/cffGAck3NkjQJr5LxaTSlWS7OU/TL8+kFCO4aRQ6ldzFLKc5LLw950q8gOGDWKOymP2yB4AOSLjIx5Fsi1Dkitv7gmpHHsUOHtjCglL9J/baWC4O/csxhMK14V9qIx+FsfsLDqnUJs0IWpf8r0PAdoWec54/DXkMi6hGHIvfS9cZ0MAh6a641FqhJtvHgkudivejehwMCY5SXigg+GoABFwxQf+PL5PcaX0cxINlX2b5jgQHAW3GKFESuNv8Fo6Qi6wKe+Jfpb1Ejb6DH8ttoE47bjHyFCG+Z2FEcM8aOdP6/8AgY41ij8cm539DM7QkfHjcAUjO8Dj+/AjkaHwlHNO58z8hNlK0LVfvJ9iT78oY0XxUF45wq3rmKd2/lvnk=";

@interface AYAliyunOSSFacade : AYFacade

@property (nonatomic, strong) OSSClient *client;

@end
