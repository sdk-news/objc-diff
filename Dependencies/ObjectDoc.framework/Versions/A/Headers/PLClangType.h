/*
 * Copyright (c) 2013 Plausible Labs Cooperative, Inc.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
@class PLClangCursor;
@class PLClangType;

/**
 * The kind of a PLClangType.
 */
typedef NS_ENUM(NSUInteger, PLClangTypeKind) {
    /** A type whose specific kind is not exposed via this interface. */
    PLClangTypeKindUnexposed = 1,

    /** void */
    PLClangTypeKindVoid = 2,

    /** bool in C++ or _Bool in C99 */
    PLClangTypeKindBool = 3,

    /** char for targets where it's unsigned */
    PLClangTypeKindCharUnsignedTarget = 4,

    /** unsigned char, explicitly qualified */
    PLClangTypeKindUnsignedChar = 5,

    /** char16_t in C++ */
    PLClangTypeKindChar16 = 6,

    /** char32_t in C++ */
    PLClangTypeKindChar32 = 7,

    /** unsigned short */
    PLClangTypeKindUnsignedShort = 8,

    /** unsigned int */
    PLClangTypeKindUnsignedInt = 9,

    /** unsigned long */
    PLClangTypeKindUnsignedLong = 10,

    /** unsigned long long */
    PLClangTypeKindUnsignedLongLong = 11,

    /** __uint128_t */
    PLClangTypeKindUInt128 = 12,

    /** char for targets where it's signed */
    PLClangTypeKindCharSignedTarget = 13,

    /** signed char, explicitly qualified */
    PLClangTypeKindSignedChar = 14,

    /** wchar_t */
    PLClangTypeKindWChar = 15,

    /** short or signed short */
    PLClangTypeKindShort = 16,

    /** int or signed int */
    PLClangTypeKindInt = 17,

    /** long or signed long */
    PLClangTypeKindLong = 18,

    /** long long or signed long long */
    PLClangTypeKindLongLong = 19,

    /** __int128_t */
    PLClangTypeKindInt128 = 20,

    /** float */
    PLClangTypeKindFloat = 21,

    /** double */
    PLClangTypeKindDouble = 22,

    /** long double */
    PLClangTypeKindLongDouble = 23,

    /** nullptr */
    PLClangTypeKindNullPtr = 24,

    /** A type of an unresolved overload set. */
    PLClangTypeKindOverload = 25,

    /**
     * A type of an expression whose type is unknown, such as "T::foo".
     *
     * It is permitted for this to appear in situations where the structure of the type
     * is theoretically deducible.
     */
    PLClangTypeKindDependent = 26,

    /** id in Objective-C */
    PLClangTypeKindObjCId = 27,

    /** Class in Objective-C */
    PLClangTypeKindObjCClass = 28,

    /** SEL in Objective-C */
    PLClangTypeKindObjCSel = 29,

    /** __float128 */
    PLClangTypeKindFloat128 = 30,
    
    PLClangTypeKindHalf = 31,
    PLClangTypeKindFloat16 = 32,
    PLClangTypeKindShortAccum = 33,
    PLClangTypeKindAccum = 34,
    PLClangTypeKindLongAccum = 35,
    PLClangTypeKindUShortAccum = 36,
    PLClangTypeKindUAccum = 37,
    PLClangTypeKindULongAccum = 38,
    PLClangTypeKindFirstBuiltin = PLClangTypeKindVoid,
    PLClangTypeKindLastBuiltin = PLClangTypeKindULongAccum,

    /** A complex type. */
    PLClangTypeKindComplex = 100,

    /** A pointer. */
    PLClangTypeKindPointer = 101,

    /** A pointer to a block. */
    PLClangTypeKindBlockPointer = 102,

    /** An lvalue reference. */
    PLClangTypeKindLValueReference = 103,

    /** An rvalue reference. */
    PLClangTypeKindRValueReference = 104,

    /** A record. */
    PLClangTypeKindRecord = 105,

    /** An enum. */
    PLClangTypeKindEnum = 106,

    /** A typedef. */
    PLClangTypeKindTypedef = 107,

    /** An Objective-C interface. */
    PLClangTypeKindObjCInterface = 108,

    /** A pointer to an Objective-C object. */
    PLClangTypeKindObjCObjectPointer = 109,

    /** A function that has no argument information, such as "int foo()". */
    PLClangTypeKindFunctionNoPrototype = 110,

    /** A function prototype that has argument information, such as "int foo(int) or "int foo(void)". */
    PLClangTypeKindFunctionPrototype = 111,

    /** A C array with a specified constant size. */
    PLClangTypeKindConstantArray = 112,

    /** A generic vector. */
    PLClangTypeKindVector = 113,

    /** A C array with an unspecified size, such as "int a[]". */
    PLClangTypeKindIncompleteArray = 114,

    /** A C array with a non-constant size, such as "int a[x+foo()]". */
    PLClangTypeKindVariableArray = 115,

    /**
     * A C++ array type whose size is a value-dependent expression.
     *
     * For example:
     *
     * @code
     * template<typename T, int Size>
     * class array {
     *   T data[Size];
     * }
     * @endcode
     */
    PLClangTypeKindDependentSizedArray = 116,

    /** A C++ member pointer. */
    PLClangTypeKindMemberPointer = 117,

    /** A C++11 auto or C++14 decltype(auto) type. */
    PLClangTypeKindAuto = 118,

    /**
     * A type that was referred to using an elaborated type keyword.
     *
     * E.g., struct S, or via a qualified name, e.g., N::M::type, or both.
     */
    PLClangTypeKindElaborated = 119,
    
    /* OpenCL PipeType. */
    PLClangTypeKindPipe = 120,
    
    /* OpenCL builtin types. */
    PLClangTypeKindOCLImage1dRO = 121,
    PLClangTypeKindOCLImage1dArrayRO = 122,
    PLClangTypeKindOCLImage1dBufferRO = 123,
    PLClangTypeKindOCLImage2dRO = 124,
    PLClangTypeKindOCLImage2dArrayRO = 125,
    PLClangTypeKindOCLImage2dDepthRO = 126,
    PLClangTypeKindOCLImage2dArrayDepthRO = 127,
    PLClangTypeKindOCLImage2dMSAARO = 128,
    PLClangTypeKindOCLImage2dArrayMSAARO = 129,
    PLClangTypeKindOCLImage2dMSAADepthRO = 130,
    PLClangTypeKindOCLImage2dArrayMSAADepthRO = 131,
    PLClangTypeKindOCLImage3dRO = 132,
    PLClangTypeKindOCLImage1dWO = 133,
    PLClangTypeKindOCLImage1dArrayWO = 134,
    PLClangTypeKindOCLImage1dBufferWO = 135,
    PLClangTypeKindOCLImage2dWO = 136,
    PLClangTypeKindOCLImage2dArrayWO = 137,
    PLClangTypeKindOCLImage2dDepthWO = 138,
    PLClangTypeKindOCLImage2dArrayDepthWO = 139,
    PLClangTypeKindOCLImage2dMSAAWO = 140,
    PLClangTypeKindOCLImage2dArrayMSAAWO = 141,
    PLClangTypeKindOCLImage2dMSAADepthWO = 142,
    PLClangTypeKindOCLImage2dArrayMSAADepthWO = 143,
    PLClangTypeKindOCLImage3dWO = 144,
    PLClangTypeKindOCLImage1dRW = 145,
    PLClangTypeKindOCLImage1dArrayRW = 146,
    PLClangTypeKindOCLImage1dBufferRW = 147,
    PLClangTypeKindOCLImage2dRW = 148,
    PLClangTypeKindOCLImage2dArrayRW = 149,
    PLClangTypeKindOCLImage2dDepthRW = 150,
    PLClangTypeKindOCLImage2dArrayDepthRW = 151,
    PLClangTypeKindOCLImage2dMSAARW = 152,
    PLClangTypeKindOCLImage2dArrayMSAARW = 153,
    PLClangTypeKindOCLImage2dMSAADepthRW = 154,
    PLClangTypeKindOCLImage2dArrayMSAADepthRW = 155,
    PLClangTypeKindOCLImage3dRW = 156,
    PLClangTypeKindOCLSampler = 157,
    PLClangTypeKindOCLEvent = 158,
    PLClangTypeKindOCLQueue = 159,
    PLClangTypeKindOCLReserveID = 160,
    
    PLClangTypeKindObjCObject = 161,
    PLClangTypeKindObjCTypeParam = 162,
    PLClangTypeKindAttributed = 163,
    
    PLClangTypeKindOCLIntelSubgroupAVCMcePayload = 164,
    PLClangTypeKindOCLIntelSubgroupAVCImePayload = 165,
    PLClangTypeKindOCLIntelSubgroupAVCRefPayload = 166,
    PLClangTypeKindOCLIntelSubgroupAVCSicPayload = 167,
    PLClangTypeKindOCLIntelSubgroupAVCMceResult = 168,
    PLClangTypeKindOCLIntelSubgroupAVCImeResult = 169,
    PLClangTypeKindOCLIntelSubgroupAVCRefResult = 170,
    PLClangTypeKindOCLIntelSubgroupAVCSicResult = 171,
    PLClangTypeKindOCLIntelSubgroupAVCImeResultSingleRefStreamout = 172,
    PLClangTypeKindOCLIntelSubgroupAVCImeResultDualRefStreamout = 173,
    PLClangTypeKindOCLIntelSubgroupAVCImeSingleRefStreamin = 174,
    
    PLClangTypeKindOCLIntelSubgroupAVCImeDualRefStreamin = 175,
};

/**
 * The nullability of a PLClangType.
 */
typedef NS_ENUM(NSUInteger, PLClangNullability) {
    /** Values of this type can never be null. */
    PLClangNullabilityNonnull = 0,

    /** Values of this type can be null. */
    PLClangNullabilityNullable = 1,

    /** Whether values of this type can be null is explicitly unspecified. */
    PLClangNullabilityExplicitlyUnspecified = 2,
    
    /** No nullability information is available for the type. */
    PLClangNullabilityInvalid = 3
};

@interface PLClangType : NSObject

@property(nonatomic, readonly) PLClangTypeKind kind;

/**
 * A string representation of the type.
 */
@property(nonatomic, readonly) NSString *spelling;
@property(nonatomic, readonly) PLClangCursor *declaration;

@property(nonatomic, readonly) BOOL isConstQualified;
@property(nonatomic, readonly) BOOL isRestrictQualified;
@property(nonatomic, readonly) BOOL isVolatileQualified;
@property(nonatomic, readonly) BOOL isPOD;
@property(nonatomic, readonly) BOOL isVariadic;

@property(nonatomic, readonly) PLClangType *canonicalType;
@property(nonatomic, readonly) PLClangType *resultType;
@property(nonatomic, readonly) PLClangType *pointeeType;
@property(nonatomic, readonly) PLClangType *elementType;
@property(nonatomic, readonly) long long numberOfElements;
@property(nonatomic, readonly) NSArray *argumentTypes;

@property(nonatomic, readonly) PLClangNullability nullability;

@end
