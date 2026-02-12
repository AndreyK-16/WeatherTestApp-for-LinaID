//
//  WeatherJSONParser.m
//  WeatherTestApp
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

#import "WeatherJSONParser.h"
#import <Foundation/Foundation.h>

#include <string>
#include <tao/json.hpp>

static NSNumber *numberFromValue(const tao::json::value *v) {
    if (!v || !v->is_number()) return nil;
    if (v->is_double()) return @(v->get_double());
    if (v->is_signed()) return @(static_cast<double>(v->get_signed()));
    if (v->is_unsigned()) return @(static_cast<double>(v->get_unsigned()));
    return nil;
}

static NSString *stringFromValue(const tao::json::value *v) {
    if (!v || !v->is_string_type()) return nil;
    return [NSString stringWithUTF8String:std::string(v->get_string_type()).c_str()];
}

static NSDictionary *dictFromCurrent(const tao::json::value &root) {
    const auto *cur = root.find("current");
    if (!cur || !cur->is_object()) return nil;
    
    NSMutableDictionary *out = [NSMutableDictionary dictionary];
    
    if (const auto *p = cur->find("temp")) { out[@"temp"] = numberFromValue(p); }
    if (const auto *p = cur->find("pressure")) { out[@"pressure"] = numberFromValue(p); }
    if (const auto *p = cur->find("humidity")) { out[@"humidity"] = numberFromValue(p); }
    if (const auto *p = cur->find("visibility")) { out[@"visibility"] = numberFromValue(p); }
    if (const auto *p = cur->find("clouds")) { out[@"clouds"] = numberFromValue(p); }
    
    const auto *weather = cur->find("weather");
    if (weather && weather->is_array() && !weather->get_array().empty()) {
        const auto &w0 = weather->get_array()[0];
        if (const auto *d = w0.find("description")) {
            out[@"description"] = stringFromValue(d);
        }
    }
    
    return [out copy];
}

static NSDictionary *dictFromDailyItem(const tao::json::value &day) {
    NSMutableDictionary *out = [NSMutableDictionary dictionary];
    
    if (const auto *p = day.find("dt")) { out[@"dt"] = numberFromValue(p); }
    
    const auto *temp = day.find("temp");
    if (temp && temp->is_object()) {
        if (const auto *d = temp->find("day")) { out[@"temp_day"] = numberFromValue(d); }
    }
    
    if (const auto *p = day.find("pressure")) { out[@"pressure"] = numberFromValue(p); }
    if (const auto *p = day.find("humidity")) { out[@"humidity"] = numberFromValue(p); }
    if (const auto *p = day.find("visibility")) { out[@"visibility"] = numberFromValue(p); }
    if (const auto *p = day.find("clouds")) { out[@"clouds"] = numberFromValue(p); }
    
    const auto *weather = day.find("weather");
    if (weather && weather->is_array() && !weather->get_array().empty()) {
        const auto &w0 = weather->get_array()[0];
        if (const auto *d = w0.find("description")) {
            out[@"description"] = stringFromValue(d);
        }
    }
    
    return [out copy];
}

static NSArray *dailyArrayFromRoot(const tao::json::value &root) {
    const auto *daily = root.find("daily");
    if (!daily || !daily->is_array()) return @[];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (const auto &day : daily->get_array()) {
        NSDictionary *d = dictFromDailyItem(day);
        if (d.count > 0) [arr addObject:d];
    }
    return [arr copy];
}

@implementation WeatherJSONParser

+ (NSDictionary *)parseOneCallResponseWithJSONString:(NSString *)jsonString error:(NSError **)error {
    if (!jsonString.length) {
        if (error) *error = [NSError errorWithDomain:@"WeatherJSONParser" code:1 userInfo:@{ NSLocalizedDescriptionKey: @"Empty JSON string" }];
        return nil;
    }
    
    std::string utf8([jsonString UTF8String]);
    
    try {
        tao::json::value v = tao::json::from_string(utf8);
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSDictionary *current = dictFromCurrent(v);
        if (current) result[@"current"] = current;
        result[@"daily"] = dailyArrayFromRoot(v);
        if (const auto *tz = v.find("timezone")) {
            if (tz->is_string_type()) {
                result[@"timezone"] = stringFromValue(tz);
            }
        }
        return [result copy];
    } catch (const std::exception &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"WeatherJSONParser" code:2
                                      userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithUTF8String:e.what()] }];
        }
        return nil;
    }
}

@end
