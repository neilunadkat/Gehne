//
//  APObject.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APObject.h"
#import "APError.h"
#import "APHelperMethods.h"
#import "NSString+APString.h"
#import "APNetworking.h"
#import "Appacitive.h"

@implementation APObject

NSString *const OBJECT_PATH = @"v1.0/object/";
#define SEARCH_PATH @"search/"

#pragma mark - Initialization methods

- (instancetype) initWithTypeName:(NSString*)typeName objectId:(NSString*)objectId {
    if ([[self class] conformsToProtocol:@protocol(APObjectPropertyMapping)]) {
        self = [super init];
        if (self) {
            self.type = typeName;
            if(objectId != nil) {
                _objectId = objectId;
            }
            
            NSMutableDictionary *typeMapping;
            NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            filePath = [filePath stringByAppendingPathComponent:@"typeMapping.plist"];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                typeMapping = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
            else
                typeMapping = [@{ @"object":@"APObject", @"user":@"APUser", @"device":@"APDevice", @"connection":@"APConnection" } mutableCopy];
            
            [typeMapping setObject:NSStringFromClass([self class]) forKey:typeName];
            [typeMapping writeToFile:filePath atomically:YES];
            
        }
        return self;
    } else {
        NSException* myException = [NSException
                                    exceptionWithName:[NSString stringWithFormat:@"%@ Subclass does not conform to the APObjectPropertyMapping protocol.",[self class]]
                                    reason:@"In order to be able to subclass APObject, the subclass must conform to the APObjectPropertyMapping protocol and must implement all the methods marked as required."
                                    userInfo:nil];
        @throw myException;
    }

}

- (instancetype) initWithTypeName:(NSString*)typeName {
    return [self initWithTypeName:typeName objectId:nil];
}

+ (APObject*) objectWithTypeName:(NSString*)typeName {
    APObject *object = [[APObject alloc] initWithTypeName:typeName];
    return object;
}

+ (APObject*) objectWithTypeName:(NSString*)typeName objectId:(NSString*)objectId {
    APObject *object = [[APObject alloc] initWithTypeName:typeName objectId:objectId];
    return object;
}

#pragma mark - Delete methods

- (void) deleteObject {
    [self deleteObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) deleteObjectWithFailureHandler:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) deleteObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:successBlock failureHandler:failureBlock deleteConnectingConnections:NO];
}

- (void) deleteObjectWithConnectingConnections {
    [self deleteObjectWithSuccessHandler:nil failureHandler:nil deleteConnectingConnections:YES];
}

- (void) deleteObjectWithConnectingConnections:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:nil failureHandler:failureBlock deleteConnectingConnections:YES];
}

- (void) deleteObjectWithConnectingConnectionsSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:successBlock failureHandler:failureBlock deleteConnectingConnections:YES];
}

- (void) deleteObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock deleteConnectingConnections:(BOOL)deleteConnections {
    
    NSString *path = [[NSString alloc] init];
    
    path = [OBJECT_PATH stringByAppendingFormat:@"%@/%@", self.type, self.objectId];
    
    NSDictionary *queryParams = @{@"deleteconnections":deleteConnections?@"true":@"false"};
    path = [path stringByAppendingQueryParameters:queryParams];
    
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"DELETE"];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if(successBlock != nil) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Fetch methods

- (void) fetch {
    [self fetchWithQueryString:nil successHandler:nil failureHandler:nil];
}

- (void) fetchWithFailureHandler:(APFailureBlock)failureBlock {
    [self fetchWithQueryString:nil successHandler:nil failureHandler:failureBlock];
}

- (void) fetchWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self fetchWithQueryString:nil successHandler:successBlock failureHandler:failureBlock];
}

- (void) fetchWithQueryString:(NSString*)queryString successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [OBJECT_PATH stringByAppendingFormat:@"%@/%@", self.type, self.objectId];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    if (queryString) {
        NSDictionary *queryStringParams = [queryString queryParameters];
        [queryStringParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [queryParams setObject:obj forKey:key];
        }];
    }
    
    path = [path stringByAppendingQueryParameters:queryParams];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [self updateSnapshot];
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if (successBlock != nil) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

+ (void) fetchObjectWithObjectId:(NSString*)objectId typeName:(NSString*)typeName successHandler:(APObjectsSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self fetchObjectsWithObjectIds:@[objectId] typeName:typeName successHandler:successBlock failureHandler:failureBlock];
}

+ (void) fetchObjectsWithObjectIds:(NSArray*)objectIds typeName:(NSString *)typeName successHandler:(APObjectsSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    __block NSString *path = [OBJECT_PATH stringByAppendingFormat:@"%@/multiget/", typeName];
    
    [objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *string= (NSString*) obj;
        path = [path stringByAppendingFormat:@"%@", string];
        if (idx != objectIds.count - 1) {
            path = [path stringByAppendingString:@","];
        }
    }];
    
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if(successBlock != nil) {
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            for (int i=0; i<[[result objectForKey:@"objects"] count]; i++)
            {
                APObject *tempObject = [[APObject alloc] init];
                [tempObject setPropertyValuesFromDictionary:[[result objectForKey:@"objects"] objectAtIndex:i]];
                [objects addObject:tempObject];
            }
            successBlock(objects);
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Save methods
- (void) saveObject {
    [self saveObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) saveObjectWithFailureHandler:(APFailureBlock)failureBlock {
    [self saveObjectWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) saveObjectWithSuccessHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    NSString *path = [OBJECT_PATH stringByAppendingFormat:@"%@", self.type];
    
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"PUT"];
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:[self postParameters] options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    [urlRequest setHTTPBody:requestBody];
    [self updateSnapshot];
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if(successBlock != nil) {
            successBlock(result);
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Update methods

- (void) updateObject {
    [self updateObjectWithRevisionNumber:nil successHandler:nil failureHandler:nil];
}

- (void) updateObjectWithFailureHandler:(APFailureBlock)failureBlock {
    [self updateObjectWithRevisionNumber:nil successHandler:nil failureHandler:failureBlock];
}

- (void) updateObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self updateObjectWithRevisionNumber:nil successHandler:successBlock failureHandler:failureBlock];
}

- (void) updateObjectWithRevisionNumber:(NSNumber*)revision successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [[NSString alloc] init];
    
    if(revision != nil)
        path = [OBJECT_PATH stringByAppendingFormat:@"%@/%@?revision=%@", self.type, self.objectId.description,revision];
    else
        path = [OBJECT_PATH stringByAppendingFormat:@"%@/%@", self.type, self.objectId.description];
    
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:[self postParametersUpdate] options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    [urlRequest setHTTPBody:requestBody];
    [self updateSnapshot];
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if(successBlock != nil) {
            successBlock(result);
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Search method

+ (void) searchAllObjectsWithTypeName:(NSString*)typeName successHandler:(APObjectsSuccessBlock)successBlock {
    [APObject searchAllObjectsWithTypeName:typeName successHandler:successBlock failureHandler:nil];
}

+ (void) searchAllObjectsWithTypeName:(NSString*)typeName successHandler:(APObjectsSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APObject searchAllObjectsWithTypeName:typeName withQueryString:nil successHandler:successBlock failureHandler:failureBlock];
}

+ (void) searchAllObjectsWithTypeName:(NSString*)typeName withQueryString:(NSString*)queryString successHandler:(APObjectsSuccessBlock)successBlock {
    [APObject searchAllObjectsWithTypeName:typeName withQueryString:queryString successHandler:successBlock failureHandler:nil];
}

+ (void) searchAllObjectsWithTypeName:(NSString*)typeName withQueryString:(NSString*)queryString successHandler:(APObjectsSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    NSString *path = [OBJECT_PATH stringByAppendingFormat:@"%@/find/all", typeName];
//    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    if (queryString) {
//        NSDictionary *queryStringParams = [queryString queryParameters];
//        [queryStringParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
//            [queryParams setObject:obj forKey:key];
//        }];
        path = [path stringByAppendingFormat:@"?%@",[queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
//    path = [path stringByAppendingQueryParameters:queryParams];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if(successBlock != nil) {
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            for (int i=0; i<[[result objectForKey:@"objects"] count]; i++) {
                APObject *tempObject = [[APObject alloc] init];
                [tempObject setPropertyValuesFromDictionary:[[result objectForKey:@"objects"] objectAtIndex:i]];
                [objects addObject:tempObject];
            }
            successBlock(objects);
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Add properties method

- (void) addPropertyWithKey:(NSString*)keyName value:(id)object {
    if (!self.properties)
        _properties = [NSMutableArray array];
    [_properties addObject:@{keyName: object}.mutableCopy];
}

#pragma mark - Update properties method

- (void) updatePropertyWithKey:(NSString*) keyName value:(id) object {
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = (NSMutableDictionary *)obj;
        if ([dict objectForKey:keyName] != nil) {
            [dict setObject:object forKey:keyName];
            *stop = YES;
        }
    }];
}

#pragma mark - Delete property

- (void) removePropertyWithKey:(NSString*) keyName {
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = (NSMutableDictionary *)obj;
        if ([dict objectForKey:keyName] != nil) {
            [dict setObject:[NSNull null] forKey:keyName];
            *stop = YES;
        }
    }];
}

#pragma mark - Retrieve property

- (id) getPropertyWithKey:(NSString*) keyName {
    __block id property;
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = (NSMutableDictionary *)obj;
        if ([dict objectForKey:keyName] != nil) {
            property = [dict objectForKey:keyName];
            *stop = YES;
        }
    }];
    return property;
}

#pragma mark - Add attributes method

- (void) addAttributeWithKey:(NSString*) keyName value:(id) object {
    if (!self.attributes) {
        _attributes = [NSMutableDictionary dictionary];
    }
    [_attributes setObject:object forKey:keyName];
}

- (void) updateAttributeWithKey:(NSString*) keyName value:(id) object {
    [_attributes setObject:object forKey:keyName];
}

- (void) removeAttributeWithKey:(NSString*) keyName {
    [_attributes setObject:[NSNull null] forKey:keyName];
}

- (NSString*) description {
    NSString *description = [NSString stringWithFormat:@"Object Id:%@, Created by:%@, Last modified by:%@, UTC date created:%@, UTC date updated:%@, Revision:%d, Properties:%@, Attributes:%@, TypeId:%d, type:%@, Tag:%@", self.objectId, self.createdBy, self.lastModifiedBy, self.utcDateCreated, self.utcLastUpdatedDate, [self.revision intValue], self.properties, self.attributes, [self.typeId intValue], self.type, self.tags];
    return description;
}

- (void) addTag:(NSString*)tag
{
    if(_tagsToAdd == nil)
        _tagsToAdd = [[NSMutableSet alloc] init];
    if(tag != nil) {
        [_tagsToAdd addObject:[tag lowercaseString]];
    }
}

- (void) removeTag:(NSString*)tag
{
    if(_tagsToRemove == nil)
        _tagsToRemove = [[NSMutableSet alloc] init];
    if(tag != nil) {
        [_tagsToRemove addObject:[tag lowercaseString]];
        [_tagsToAdd minusSet:self.tagsToRemove];
    }
}

#pragma mark - Private methods


- (void) setPropertyValuesFromDictionary:(NSDictionary*) dictionary {
    NSDictionary *object = [[NSDictionary alloc] init];
    if([[dictionary allKeys] containsObject:@"object"])
        object = dictionary[@"object"];
    else
        object = dictionary;
    _createdBy = (NSString*) object[@"__createdby"];
    _objectId = object[@"__id"];
    _lastModifiedBy = (NSString*) object[@"__lastmodifiedby"];
    _revision = (NSNumber*) object[@"__revision"];
    _typeId = object[@"__typeid"];
    _utcDateCreated = [APHelperMethods deserializeJsonDateString:object[@"__utcdatecreated"]];
    _utcLastUpdatedDate = [APHelperMethods deserializeJsonDateString:object[@"__utclastupdateddate"]];
    _attributes = [object[@"__attributes"] mutableCopy];
    _tags = object[@"__tags"];
    _type = object[@"__type"];
    _properties = [APHelperMethods arrayOfPropertiesFromJSONResponse:object].mutableCopy;
    
    [self updateSnapshot];
}


- (NSMutableDictionary*) postParameters {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    if (_objectId != nil)
        postParams[@"__id"] = self.objectId;
    if (_attributes)
        postParams[@"__attributes"] = _attributes;
    if (_createdBy)
        postParams[@"__createdby"] = _createdBy;
    if (_revision)
        postParams[@"__revision"] = _revision;
    for(NSDictionary *prop in _properties) {
        [prop enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [postParams setObject:obj forKey:key];
            *stop = YES;
        }];
    }
    if (self.type)
        postParams[@"__type"] = self.type;
    if (self.tags)
        postParams[@"__tags"] = self.tags;
    return postParams;
}

- (NSMutableDictionary*) postParametersUpdate {
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    
    if (_attributes && [_attributes count] > 0)
        for(id key in _attributes) {
            if(![[[_snapShot objectForKey:@"__attributes"] allKeys] containsObject:key])
                [postParams[@"__attributes"] setObject:[self.attributes objectForKey:key] forKey:key];
            else if([[_snapShot objectForKey:@"__attributes"] objectForKey:key] != [_attributes objectForKey:key])
                [postParams[@"__attributes"] setObject:[_attributes objectForKey:key] forKey:key];
        }
    
    for(NSDictionary *prop in _properties) {
        [prop enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            if(![[_snapShot allKeys] containsObject:key])
                [postParams setObject:obj forKey:key];
            else if([_snapShot objectForKey:key] != [prop objectForKey:key])
                [postParams setObject:obj forKey:key];
            *stop = YES;
        }];
    }
//    
//    if (self.attributes && [self.attributes count] > 0)
//        postParams[@"__attributes"] = self.attributes;
//    
//    for(NSDictionary *prop in self.properties) {
//        [prop enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
//            [postParams setObject:obj forKey:key];
//            *stop = YES;
//        }];
//    }
    if(_tagsToAdd && [_tagsToAdd count] > 0)
        postParams[@"__addtags"] = [_tagsToAdd allObjects];
    if(_tagsToRemove && [_tagsToRemove count] > 0)
        postParams[@"__removetags"] = [_tagsToRemove allObjects];
    return postParams;
}

- (void) updateSnapshot {
    if(_snapShot == nil)
        _snapShot = [[NSMutableDictionary alloc] init];
    
    if(_attributes)
        _snapShot[@"__attributes"] = [self.attributes mutableCopy];
    if(_tags)
        _snapShot[@"__tags"] = [self.tags mutableCopy];
    if(_properties)
        _snapShot[@"__properties"] = [self.properties mutableCopy];
}

@end

# pragma mark - APObjects Class Implementation

@implementation APObjects

#pragma mark - Delete methods

+ (void) deleteObjectsWithIds:(NSArray*)objectIds typeName:(NSString*)typeName failureHandler:(APFailureBlock)failureBlock {
    [APObjects deleteObjectsWithIds:objectIds typeName:typeName successHandler:nil failureHandler:failureBlock];
}

+ (void) deleteObjectsWithIds:(NSArray*)objectIds typeName:(NSString*)typeName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    NSString *path = [OBJECT_PATH stringByAppendingFormat:@"%@/bulkdelete", typeName];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:objectIds forKey:@"idlist"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    [urlRequest setHTTPBody:requestBody];
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if(successBlock != nil) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

@end

