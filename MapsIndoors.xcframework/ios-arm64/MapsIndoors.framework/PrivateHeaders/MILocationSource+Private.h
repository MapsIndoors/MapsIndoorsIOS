// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from LocationInterface.djinni

#include "../cpp/LocationSource.hpp"
#include <memory>

static_assert(__has_feature(objc_arc), "Djinni requires ARC to be enabled for this file");

@protocol MILocationSource;

namespace djinni_generated {

class LocationSource
{
public:
    using CppType = std::shared_ptr<::MICommon::LocationSource>;
    using CppOptType = std::shared_ptr<::MICommon::LocationSource>;
    using ObjcType = id<MILocationSource>;

    using Boxed = LocationSource;

    static CppType toCpp(ObjcType objc);
    static ObjcType fromCppOpt(const CppOptType& cpp);
    static ObjcType fromCpp(const CppType& cpp) { return fromCppOpt(cpp); }

private:
    class ObjcProxy;
};

}  // namespace djinni_generated
