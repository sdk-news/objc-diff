//
//  PLClangFile.h
//  ObjectDoc
//
//  Created by lizhuoli on 2019/4/16.
//  Copyright © 2019 Landon Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLClangFile : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) time_t time;

@end

NS_ASSUME_NONNULL_END
