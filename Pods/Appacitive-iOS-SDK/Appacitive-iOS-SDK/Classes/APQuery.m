//
//  APQuery.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 05/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APQuery.h"

#pragma mark - SimpleQuery

@implementation APSimpleQuery

- (NSString*) stringForm {
    if(self.fieldName != nil && self.fieldType != nil && self.operation != nil && self.value != nil)
        return [NSString stringWithFormat:@"%@ %@ %@",
                [self getFormattedFieldNameFor:self.fieldName  WithFieldType:self.fieldType],
                self.operation,
                self.value];
    return nil;
}

- (NSString*) getFormattedFieldNameFor:(NSString*)name WithFieldType:(NSString*)type {
    if ([type isEqualToString:@"attribute"])
        return [NSString stringWithFormat:@"@%@",name];
    else if ([type isEqualToString:@"aggregate"])
        return [NSString stringWithFormat:@"$%@",name];
    else
        return [NSString stringWithFormat:@"*%@",name];
}

@end

#pragma mark - CompundQuery

@implementation APCompoundQuery

- (instancetype) init {
    _innerQueries = [[NSMutableArray alloc] init];
    return self;
}

- (NSString*) stringForm {
    NSString *query = [[NSString alloc] init];
    query = @"(";
    for(int i =0; i<self.innerQueries.count-1; i++)
        if(self.boolOperator == kAnd)
            query = [query stringByAppendingString:[NSString stringWithFormat:@"%@ AND ",[self.innerQueries[i] stringForm]]];
        else {
            query = [query stringByAppendingString:[NSString stringWithFormat:@"%@ OR ",[self.innerQueries[i] stringForm]]];
        }
    query = [query stringByAppendingString:[NSString stringWithFormat:@"%@)",[[self.innerQueries lastObject] stringForm]]];
    return query;
}

@end

#pragma mark - QueryExpression

@implementation APQueryExpression

- (instancetype) initWithProperty:(NSString*)name ofType:(NSString*)type {
    _type = type;
    _name = name;
    return self;
}

- (APSimpleQuery *) isEqualTo:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"==";
        query.value = [NSString stringWithFormat:@"'%@'",value];
        return query;
    }
    return nil;
}


- (APSimpleQuery *) isEqualToDate:(NSDate*)date {
    if(date != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"==";
        query.value = [NSString stringWithFormat:@"date('%@')",date];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isNotEqualTo:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"<>";
        query.value = [NSString stringWithFormat:@"'%@'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isNotEqualToDate:(NSDate*)date {
    if(date != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"<>";
        query.value = [NSString stringWithFormat:@"date('%@')",date];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isLike:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"like";
        query.value = [NSString stringWithFormat:@"'%@'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) startsWith:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"like";
        query.value = [NSString stringWithFormat:@"'%@*'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) endsWith:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"like";
        query.value = [NSString stringWithFormat:@"'*%@'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) matches:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"match";
        query.value = [NSString stringWithFormat:@"'%@'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isGreaterThan:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @">";
        query.value = [NSString stringWithFormat:@"'%@'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isLessThan:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"<";
        query.value = [NSString stringWithFormat:@"'%@'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isGreaterThanOrEqualTo:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @">=";
        query.value = [NSString stringWithFormat:@"'%@'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isLessThanOrEqualTo:(NSString*)value {
    if (value != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"<=";
        query.value = [NSString stringWithFormat:@"'%@'",value];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isBetween:(NSString*)value1 and:(NSString*)value2 {
    if (value1 != nil && value2 != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"between";
        query.value = [NSString stringWithFormat:@"('%@','%@')",value1,value2];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isGreaterThanDate:(NSDate*)date {
    if (date != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @">";
        query.value = [NSString stringWithFormat:@"date('%@')",date];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isLessThanDate:(NSDate*)date {
    if (date != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"<";
        query.value = [NSString stringWithFormat:@"date('%@')",date];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isGreaterThanOrEqualToDate:(NSDate*)date {
    if (date != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @">=";
        query.value = [NSString stringWithFormat:@"date('%@')",date];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isLessThanOrEqualToDate:(NSDate*)date {
    if (date != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"<=";
        query.value = [NSString stringWithFormat:@"date('%@')",date];
        return query;
    }
    return nil;
}

- (APSimpleQuery *) isBetweenDates:(NSDate*)date1 and:(NSDate*)date2 {
    if (date1 != nil && date2 != nil) {
        APSimpleQuery *query = [[APSimpleQuery alloc] init];
        query.fieldName = _name;
        query.fieldType = _type;
        query.operation = @"between";
        query.value = [NSString stringWithFormat:@"(date('%@'),date('%@'))",date1,date2];
        return query;
    }
    return nil;
}


@end

#pragma mark - Query

@implementation APQuery

+ (APQueryExpression*) queryExpressionWithProperty:(NSString*)propertyName {
    return [[APQueryExpression alloc] initWithProperty:propertyName ofType:@"property"];
}

+ (APQueryExpression*) queryExpressionWithAttribute:(NSString*)attributeName {
    return [[APQueryExpression alloc] initWithProperty:attributeName ofType:@"attribute"];
}

+ (APQueryExpression*) queryExpressionWithAggregate:(NSString*)aggregateName {
    return [[APQueryExpression alloc] initWithProperty:aggregateName ofType:@"aggergate"];
}

+ (APCompoundQuery *) booleanAnd:(NSArray*)queries {
    APCompoundQuery* compoundQuery = [[APCompoundQuery alloc] init];
    compoundQuery.boolOperator = kAnd;
    [[compoundQuery innerQueries] addObjectsFromArray:queries];
    return compoundQuery;
}

+ (APCompoundQuery *) booleanOr:(NSArray*)queries {
    APCompoundQuery* compoundQuery = [[APCompoundQuery alloc] init];
    compoundQuery.boolOperator = kOr;
    [[compoundQuery innerQueries] addObjectsFromArray:queries];
    return compoundQuery;
}

+ (NSString *) queryWithRadialSearchForProperty:(NSString*)propertyName nearLocation:(CLLocation*)location withinRadius:(NSNumber*)radius usingDistanceMetric:(DistanceMetric)distanceMetric {
    if(location != nil && radius != nil) {
        NSString *queryString = [NSString stringWithFormat:@"*%@ within_circle ", propertyName];
        queryString = [queryString stringByAppendingFormat:@"%lf, %lf, %lf", location.coordinate.latitude, location.coordinate.longitude, radius.doubleValue];
        if (distanceMetric == kKilometers) {
            queryString = [queryString stringByAppendingFormat:@" km"];
        } else {
            queryString = [queryString stringByAppendingFormat:@" m"];
        }
        return queryString;
    }
    return nil;
}

+ (NSString *) queryWithPolygonSearchForProperty:(NSString*)propertyName withPolygonCoordinates:(NSArray*)coordinates {
    if (coordinates != nil && coordinates.count >= 3) {
        __block NSString *query = [NSString stringWithFormat:@"*%@ within_polygon ", propertyName];
        [coordinates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[CLLocation class]]) {
                CLLocation *location = (CLLocation*)obj;
                query = [query stringByAppendingFormat:@"%lf,%lf", location.coordinate.latitude, location.coordinate.longitude];
                if (idx != coordinates.count - 1) {
                    query = [query stringByAppendingString:@"|"];
                }
            }
        }];
        return query;
    }
    return nil;
}

+ (NSString *) queryWithSearchUsingOneOrMoreTags:(NSArray*)tags {
    if (tags != nil) {
        __block NSString *queryString = @"tagged_with_one_or_more ('";
        [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                queryString = [queryString stringByAppendingFormat:@"%@", obj];
                if (idx != tags.count - 1) {
                    queryString = [queryString stringByAppendingString:@","];
                } else {
                    queryString = [queryString stringByAppendingString:@"')"];
                }
            }
        }];
        return queryString;
    }
    return nil;
}

+ (NSString *) queryWithSearchUsingAllTags:(NSArray*)tags {
    if (tags != nil) {
        __block NSString *queryString = @"tagged_with_all ('";
        [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                queryString = [queryString stringByAppendingFormat:@"%@", obj];
                if (idx != tags.count - 1) {
                    queryString = [queryString stringByAppendingString:@","];
                } else {
                    queryString = [queryString stringByAppendingString:@"')"];
                }
            }
        }];
        return queryString;
    }
    return nil;
}

+ (NSString *) queryWithPageSize:(NSUInteger)pageSize {
    return [NSString stringWithFormat:@"psize=%lu", (unsigned long)pageSize];
}

+ (NSString *) queryWithPageNumber:(NSUInteger)pageNumber {
    return [NSString stringWithFormat:@"pnum=%lu", (unsigned long)pageNumber];
}

+ (NSString *) queryWithOrderBy:(NSString*)property isAscending:(BOOL)isAscending {
    if(property != nil) {
    if(isAscending == YES)
        return [NSString stringWithFormat:@"orderBy=%@&isAsc=true",property];
    else
        return [NSString stringWithFormat:@"orderBy=%@&isAsc=false",property];
    }
    else return nil;
}

+ (NSString *) queryWithFields:(NSArray*)fields {
    NSString *queryString = [NSString stringWithFormat:@"fields="];
    if(fields != nil) {
        for(int i = 0; i < fields.count; i++) {
            queryString = [queryString stringByAppendingFormat:@"%@,",fields[i]];
        }
    }
    return queryString;
}

+ (NSString *) queryWithSearchUsingFreeText:(NSArray*)freeTextTokens {
    if (freeTextTokens != nil && freeTextTokens.count > 0) {
        __block NSString *queryString = @"freeText=";
        [freeTextTokens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                queryString = [queryString stringByAppendingString:obj];
                if(idx != freeTextTokens.count - 1) {
                    queryString = [queryString stringByAppendingString:@" "];
                }
            }
        }];
        return queryString;
    }
    return nil;
}

@end

