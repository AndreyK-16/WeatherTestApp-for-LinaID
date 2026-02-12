//
//  WeatherJSONParser.h
//  WeatherTestApp
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherJSONParser : NSObject

/// Parses One Call API 3.0 response JSON string into a dictionary usable by Swift.
/// Returns nil and sets error on parse failure.
/// Result structure: current (temp, pressure, humidity, visibility, clouds, weather[0].description),
///                   daily (array of day objects with dt, temp_day, pressure, humidity, visibility, clouds, weather[0].description).
+ (nullable NSDictionary *)parseOneCallResponseWithJSONString:(NSString *)jsonString
                                                        error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
