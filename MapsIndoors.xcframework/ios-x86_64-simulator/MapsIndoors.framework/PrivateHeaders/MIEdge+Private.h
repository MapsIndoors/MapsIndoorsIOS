// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from DirectionsInterface.djinni

#import "MIEdge.h"
#include "../cpp/Edge.hpp"

static_assert(__has_feature(objc_arc), "Djinni requires ARC to be enabled for this file");

@class MIEdge;

namespace djinni_generated {

struct Edge
{
    using CppType = ::MICommon::Edge;
    using ObjcType = MIEdge*;

    using Boxed = Edge;

    static CppType toCpp(ObjcType objc);
    static ObjcType fromCpp(const CppType& cpp);
};

}  // namespace djinni_generated