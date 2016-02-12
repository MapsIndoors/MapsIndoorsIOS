HashBuilder
===========
[![Build Status](https://travis-ci.org/levigroker/HashBuilder.svg)](https://travis-ci.org/levigroker/HashBuilder)
[![Version](http://img.shields.io/cocoapods/v/HashBuilder.svg)](http://cocoapods.org/?q=HashBuilder)
[![Platform](http://img.shields.io/cocoapods/p/HashBuilder.svg)]()
[![License](http://img.shields.io/cocoapods/l/HashBuilder.svg)](https://github.com/levigroker/HashBuilder/blob/master/LICENSE.txt)

Used to build a hash result from contributed objects or hashes (presumably
properties on your object which should be considered in the isEqual: override).
The intention is for the hash result to be returned from an override to the
`NSObject` `- (NSUInteger)hash` method.

### Installing

If you're using [CocoPods](http://cocopods.org) it's as simple as adding this to your `Podfile`:

	pod 'HashBuilder', '~> 1.0'

otherwise, simply add the contents of the `HashBuilder` subdirectory to your
project.

### Documentation

To use, create a HashBuilder object, contribute to it, then query the 'builtHash'
property for the resulting hash.

	- (NSUInteger)hash
	{
		HashBuilder *builder = [HashBuilder builder];

		[builder contributeObject:self.objectID];
		[builder contributeObject:self.occurredDate];
		[builder contributeObject:self.type];
		[builder contributeObject:self.objectURL];
		[builder contributeObject:self.tags];
		[builder contributeObject:self.count];

		NSUInteger retVal = builder.builtHash;

		return retVal;
	}

It is prudent to consider the same properties when overriding your `- (BOOL)isEqual:(id)object`
method as well.

NOTE: The order of contribution _will_ change the resulting hash, even if all
the same values are contributed. For example:

    HashBuilder *builder1 = [HashBuilder builder];
    [builder1 contributeObject:@"a"];
    [builder1 contributeObject:[NSNumber numberWithInteger:12345]];
    NSUInteger hash1 = builder1.builtHash;

    HashBuilder *builder2 = [HashBuilder builder];
    [builder2 contributeObject:[NSNumber numberWithInteger:12345]];
    [builder2 contributeObject:@"a"];
    NSUInteger hash2 = builder2.builtHash;

`hash1 != hash2`

#### Disclaimer and Licence

* This work makes use of techniques and concepts presented by [Mike Ash](http://www.mikeash.com/)
  in his post entitled [Implementing Equality and Hashing](http://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html)
* This work is licensed under the [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/).
  Please see the included LICENSE.txt for complete details.

#### About

A professional iOS engineer by day, my name is Levi Brown. Authoring a technical
blog [grokin.gs](http://grokin.gs), I am reachable via:

Twitter [@levigroker](https://twitter.com/levigroker)  
EMail [levigroker@gmail.com](mailto:levigroker@gmail.com)  

Your constructive comments and feedback are always welcome.
