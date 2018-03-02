//
//  AYAliyunOSSFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 28/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYFacade.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import <AliyunOSSiOS/AliyunOSSiOS.h>


//lC2a3NXist8peEDm WP59s7IZkHBqIWWs57Ho0yx9B28S9m
#define AYOSSAccessID  @"LTAINO7wSDoWJRfN"
#define AYOSSAccessKey  @"PcDzLSOE86DsnjQn8IEgbaIQmyBzt6"
//http://blackmirror.
#define AYOSSEndPoint  @"oss-cn-beijing.aliyuncs.com/upload"

#define AYOSSSTSId  @"STS.EbLxyWo5NHg4i9ZvizKKSLqzS"
#define AYOSSSTSSecretKey  @"Gobvf6rQB4W4K9ebJJo9jj1fgxqyQ43wtrtTkt5iwzJR"

#define AYOSSSTSSecurityToken  @"CAIShQJ1q6Ft5B2yfSjIpKH5M8Pjgupv/6Xfax/rkmkvR8R/o7TRsTz2IHlMfnVhAe0asv03lGtR6PgflqJ5T5ZORknFd9F39My9P6tmlc6T1fau5Jko1beHewHKeTOZsebWZ+LmNqC/Ht6md1HDkAJq3LL+bk/Mdle5MJqP+/UFB5ZtKWveVzddA8pMLQZPsdITMWCrVcygKRn3mGHdfiEK00he8TohuPrimJDDsEWG0Aahk7Yvyt6vcsT+Xa5FJ4xiVtq55utye5fa3TRYgxowr/4u1vAVoWqb4ojFUwIIvUvbKZnd9tx+MQl+fbMmHK1Jqvfxk/Bis/DUjZ7wzxtduhT90f5oresagAGenBelPg6xQA6sdlXU1K3yozxy9tkxMMEovapX4gQ9QiIENHCtioTDb1rWhBhWpSrR8N+BA2B5Z98ERXWumUGC4tD7ij3xqO/0m06UIBNCOVTwuOGiezj/4ClISuQZGHV/0DUE/Zjy+Wb8cHKJW4C2MFb5fVBbPP/W2InUMDVxmw=="

#define OSSFilePathPrefix  @"upload/"

@interface AYAliyunOSSFacade : AYFacade

@property (nonatomic, strong) OSSClient *client;

//- (OSSClient*)OSSClient;

@end
