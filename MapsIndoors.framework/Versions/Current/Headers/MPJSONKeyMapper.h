//
//  MPJSONKeyMapper.h
//
//  @version 1.4
//  @author Marin Todorov (http://www.underplot.com) and contributors
//

// Copyright (c) 2012-2015 Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import <Foundation/Foundation.h>
#import "MPDefines.h"


typedef NSString *(^MPJSONModelKeyMapBlock)(NSString *keyName);

/**
 * **You won't need to create or store instances of this class yourself.** If you want your model
 * to have different property names than the JSON feed keys, look below on how to
 * make your model use a key mapper.
 *
 * For example if you consume JSON from twitter
 * you get back underscore_case style key names. For example:
 *
 * <pre>"profile_sidebar_border_color": "0094C2",
 * "profile_background_tile": false,</pre>
 *
 * To comply with Obj-C accepted camelCase property naming for your classes,
 * you need to provide mapping between JSON keys and ObjC property names.
 *
 * In your model overwrite the + (MPJSONKeyMapper *)keyMapper method and provide a MPJSONKeyMapper
 * instance to convert the key names for your model.
 *
 * If you need custom mapping it's as easy as:
 * <pre>
 * + (MPJSONKeyMapper *)keyMapper {
 * &nbsp; return [[MPJSONKeyMapper&nbsp;alloc]&nbsp;initWithDictionary:@{@"crazy_JSON_name":@"myCamelCaseName"}];
 * }
 * </pre>
 * In case you want to handle underscore_case, **use the predefined key mapper**, like so:
 * <pre>
 * + (MPJSONKeyMapper *)keyMapper {
 * &nbsp; return [MPJSONKeyMapper&nbsp;mapperFromUnderscoreCaseToCamelCase];
 * }
 * </pre>
 */
@interface MPJSONKeyMapper : NSObject

// deprecated
@property (readonly, nonatomic) MPJSONModelKeyMapBlock JSONToModelKeyBlock MP_DEPRECATED_ATTRIBUTE;
- (NSString *)convertValue:(NSString *)value isImportingToModel:(BOOL)importing MP_DEPRECATED_MSG_ATTRIBUTE("use convertValue:");
- (instancetype)initWithDictionary:(NSDictionary *)map MP_DEPRECATED_MSG_ATTRIBUTE("use initWithModelToJSONDictionary:");
- (instancetype)initWithJSONToModelBlock:(MPJSONModelKeyMapBlock)toModel modelToJSONBlock:(MPJSONModelKeyMapBlock)toJSON MP_DEPRECATED_MSG_ATTRIBUTE("use initWithModelToJSONBlock:");
+ (instancetype)mapper:(MPJSONKeyMapper *)baseKeyMapper withExceptions:(NSDictionary *)exceptions MP_DEPRECATED_MSG_ATTRIBUTE("use baseMapper:withModelToJSONExceptions:");

/** @name Name converters */
/** Block, which takes in a property name and converts it to the corresponding JSON key name */
@property (readonly, nonatomic) MPJSONModelKeyMapBlock modelToJSONKeyBlock;

/** Combined converter method
 * @param value the source name
 * @return MPJSONKeyMapper instance
 */
- (NSString *)convertValue:(NSString *)value;

/** @name Creating a key mapper */

/**
 * Creates a MPJSONKeyMapper instance, based on the block you provide this initializer.
 * The parameter takes in a MPJSONModelKeyMapBlock block:
 * <pre>NSString *(^MPJSONModelKeyMapBlock)(NSString *keyName)</pre>
 * The block takes in a string and returns the transformed (if at all) string.
 * @param toJSON transforms your model property name to a JSON key
 */
- (instancetype)initWithModelToJSONBlock:(MPJSONModelKeyMapBlock)toJSON;

/**
 * Creates a MPJSONKeyMapper instance, based on the mapping you provide.
 * Use your MPJSONModel property names as keys, and the JSON key names as values.
 * @param toJSON map dictionary, in the format: <pre>@{@"myCamelCaseName":@"crazy_JSON_name"}</pre>
 * @return MPJSONKeyMapper instance
 */
- (instancetype)initWithModelToJSONDictionary:(NSDictionary *)toJSON;

/**
 * Creates a MPJSONKeyMapper, which converts underscore_case to camelCase and vice versa.
 */
+ (instancetype)mapperFromUnderscoreCaseToCamelCase;

+ (instancetype)mapperFromUpperCaseToLowerCase;

/**
 * Creates a MPJSONKeyMapper based on a built-in MPJSONKeyMapper, with specific exceptions.
 * Use your MPJSONModel property names as keys, and the JSON key names as values.
 */
+ (instancetype)baseMapper:(MPJSONKeyMapper *)baseKeyMapper withModelToJSONExceptions:(NSDictionary *)toJSON;

@end
