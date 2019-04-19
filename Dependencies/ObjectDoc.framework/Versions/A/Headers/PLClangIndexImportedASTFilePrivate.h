//
//  PLClangIndexImportedASTFilePrivate.h
//  ObjectDoc
//
//  Created by lizhuoli on 2019/4/18.
//  Copyright © 2019 Landon Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLClangIndexImportedASTFile.h"

#import <clang-c/Index.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLClangIndexImportedASTFile (PackagePrivate)

- (instancetype)initWithCXIdxImportedASTFileInfo:(CXIdxImportedASTFileInfo)info;

@end

NS_ASSUME_NONNULL_END
