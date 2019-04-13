//
//  PLClangIndexAttribute.h
//  ObjectDoc
//
//  Created by lizhuoli on 2019/4/13.
//  Copyright © 2019 Landon Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PLClangCursor;
@class PLClangSourceLocation;

/**
 * The kind of a PLClangIndexAttribute. Typically the @IBOutlet attribute.
 */
typedef NS_ENUM(NSUInteger, PLClangIndexAttributeKind) {
    /** Unexposed */
    PLClangIndexAttributeKindUnexposed     = 0,
    /** @IBAction */
    PLClangIndexAttributeKindIBAction      = 1,
    /** @IBOutlet */
    PLClangIndexAttributeKindIBOutlet      = 2,
    /** @IBOutletCollection */
    PLClangIndexAttributeKindIBOutletCollection = 3
};

@interface PLClangIndexAttribute : NSObject

@property(nonatomic, readonly) PLClangIndexAttributeKind kind;
@property(nonatomic, readonly) PLClangCursor *cursor;
@property(nonatomic, readonly) PLClangSourceLocation *location;

@end
