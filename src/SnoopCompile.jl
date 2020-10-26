module SnoopCompile

using SnoopCompileCore
export @snoopc
isdefined(SnoopCompileCore, Symbol("@snoopi")) && export @snoopi
if isdefined(SnoopCompileCore, Symbol("@snoopr"))
    export @snoopr, uinvalidated, invalidation_trees, filtermod, findcaller, ascend
end

using Core: MethodInstance, CodeInfo
using Serialization, OrderedCollections
import YAML,CSV  # For @snoopl

# Parcel Regex
const anonrex = r"#{1,2}\d+#{1,2}\d+"         # detect anonymous functions
const kwrex = r"^#kw##(.*)$|^#([^#]*)##kw$"   # detect keyword-supplying functions
const kwbodyrex = r"^##(\w[^#]*)#\d+"         # detect keyword body methods
const genrex = r"^##s\d+#\d+$"                # detect generators for @generated functions
const innerrex = r"^#[^#]+#\d+"               # detect inner functions

# Parcel
include("parcel_snoopc.jl")

if VERSION >= v"1.2.0-DEV.573"
    include("parcel_snoopi.jl")
end

if VERSION >= v"1.6.0-DEV.1192"  # https://github.com/JuliaLang/julia/pull/37136
    include("parcel_snoopl.jl")
end

if isdefined(SnoopCompileCore, Symbol("@snoopr"))
    include("invalidations.jl")
end

# Write
include("write.jl")

end # module
