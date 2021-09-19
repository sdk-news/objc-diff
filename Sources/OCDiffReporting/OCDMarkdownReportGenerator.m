#import "OCDMarkdownReportGenerator.h"

@implementation OCDMarkdownReportGenerator {
    NSString *_outputDirectory;
}

- (instancetype)initWithOutputDirectory:(NSString *)directory {
    if (!(self = [super init]))
        return nil;

    _outputDirectory = [directory copy];

    return self;
}

- (void)generateReportForDifferences:(OCDAPIDifferences *)differences title:(NSString *)title {
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:_outputDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
        fprintf(stderr, "Error creating directory at path %s: %s\n", [_outputDirectory UTF8String], [[error description] UTF8String]);
        exit(1);
    }

    if (differences.modules.count == 1) {
        NSString *outputFile = [[_outputDirectory stringByAppendingPathComponent:differences.modules[0].name] stringByAppendingPathExtension:@"md"];
        [self generateFileForDifferences:differences.modules.firstObject.differences title:title path:outputFile];
    } else {
        BOOL hasDifferences = NO;
        NSMutableString *markdown = [[NSMutableString alloc] init];

        if (title != nil) {
            [markdown appendFormat:@"# %@\n\n", title];
        }

        for (OCDModule *module in differences.modules) {
            if (module.differenceType == OCDifferenceTypeRemoval) {
                [markdown appendFormat:@"- %@ *(Removed)*\n", module.name];
                continue;
            } else if (module.differences.count < 1) {
                continue;
            } else {
                if (module.differenceType == OCDifferenceTypeAddition) {
                    [markdown appendFormat:@"- [%@](%@) *(Added)*\n", module.name, module.name];
                } else {
                    [markdown appendFormat:@"- [%@](%@)\n", module.name, module.name];
                }
            }

            hasDifferences = YES;

            NSString *moduleTitle;
            if (title != nil) {
                moduleTitle = [NSString stringWithFormat:@"%@ %@", module.name, title ?: @""];
            } else {
                moduleTitle = module.name;
            }

            NSString *fileName = [module.name stringByAppendingPathExtension:@"md"];
            NSString *outputFile = [_outputDirectory stringByAppendingPathComponent:fileName];
            [self generateFileForDifferences:module.differences title:moduleTitle path:outputFile];
        }

        if (hasDifferences == NO) {
            [markdown appendString:@"No differences\n\n"];
        }

        NSString *outputFile = [_outputDirectory stringByAppendingPathComponent:@"index.md"];
        if (![markdown writeToFile:outputFile atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
            fprintf(stderr, "Error writing HTML report to %s: %s\n", [outputFile UTF8String], [[error description] UTF8String]);
            exit(1);
        }
    }
}

- (void)generateFileForDifferences:(NSArray<OCDifference *> *)differences title:(NSString *)title path:(NSString *)outputFile {
    NSMutableString *markdown = [[NSMutableString alloc] init];

    NSString *lastFile = @"";

    for (OCDifference *difference in differences) {
        NSString *file = difference.path;
        if ([file isEqualToString:lastFile] == NO) {
            lastFile = file;
            [markdown appendFormat:@"## %@\n\n", file];
        }

        [markdown appendFormat:@"*%@* `%@`\n\n", [self stringForDifferenceType:difference.type], difference.name];

        if ([difference.modifications count] > 0) {
            if ([difference.modifications count] == 1 && difference.modifications[0].type == OCDModificationTypeReplacement) {
                OCDModification *modification = difference.modifications[0];

                [markdown appendFormat:@"<table><tr><th>From</th><td><pre>%@</pre></td></tr><tr><th>To</th><td><pre>%@</pre></td></tr></table>\n\n",
                    modification.previousValue.length ? modification.previousValue : @"(none)",
                    modification.currentValue.length ? modification.currentValue : @"(none)"
                ];
            } else if ([difference.modifications count] > 0) {
                [markdown appendString:@"|  | From | To |\n"];
                [markdown appendString:@"|--|------|----|\n"];

                for (OCDModification *modification in difference.modifications) {
                    [markdown appendFormat:@"| %@ | %@ | %@ |\n",
                        [OCDModification stringForModificationType:modification.type],
                        modification.previousValue.length ? modification.previousValue : @"(none)",
                        modification.currentValue.length ? modification.currentValue : @"(none)"
                    ];
                }

                [markdown appendString:@"\n"];
            }
        }
    }

    NSError *error;
    if (![markdown writeToFile:outputFile atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
        fprintf(stderr, "Error writing markdown report to %s: %s\n", [outputFile UTF8String], [[error description] UTF8String]);
        exit(1);
    }
}

- (NSString *)stringForDifferenceType:(OCDifferenceType)type {
    switch (type) {
        case OCDifferenceTypeAddition:
            return @"Added";

        case OCDifferenceTypeRemoval:
            return @"Removed";

        case OCDifferenceTypeModification:
            return @"Modified";
    }

    abort();
}

@end
