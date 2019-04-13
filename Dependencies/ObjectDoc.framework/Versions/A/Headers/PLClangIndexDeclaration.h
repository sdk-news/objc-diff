//
//  PLClangIndexDeclaration.h
//  ObjectDoc
//
//  Created by lizhuoli on 2019/4/13.
//  Copyright © 2019 Landon Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLClangIndexAttribute.h"

@interface PLClangIndexDeclaration : NSObject

@property(nonatomic, readonly) BOOL isRedeclaration;
@property(nonatomic, readonly) BOOL isDefinition;
@property(nonatomic, readonly) BOOL isContainer;
@property(nonatomic, readonly) BOOL isImplicit;

/**
 The attributes applied for indexed declaration.
 */
@property(nonatomic, readonly) NSArray<PLClangIndexAttribute *> *attributes;

@end
