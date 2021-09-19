#import "OCDReportGenerator.h"

@interface OCDMarkdownReportGenerator : NSObject <OCDReportGenerator>

- (instancetype)initWithOutputDirectory:(NSString *)directory;

@end
