// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from LocationInterface.djinni

#import "MIFloatRange.h"
#include "../cpp/FloatRange.hpp"

static_assert(__has_feature(objc_arc), "Djinni requires ARC to be enabled for this file");

@class MIFloatRange;

namespace djinni_generated {

struct FloatRange
{
    using CppType = ::MICommon::FloatRange;
    using ObjcType = MIFloatRange*;

    using Boxed = FloatRange;

    static CppType toCpp(ObjcType objc);
    static ObjcType fromCpp(const CppType& cpp);
};

}  // namespace djinni_generated