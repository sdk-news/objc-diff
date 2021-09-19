#import "OCDLinkMap.h"
#import "OCDReportGenerator.h"

@interface OCDHTMLReportGenerator : NSObject <OCDReportGenerator>

- (instancetype)initWithOutputDirectory:(NSString *)directory linkMap:(OCDLinkMap *)linkMap renderFullPage:(BOOL)renderFullPage;

@end
