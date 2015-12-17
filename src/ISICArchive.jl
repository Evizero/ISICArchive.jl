module ISICArchive

using Requests
using JSON
using SimpleStructs

export

    DatasetList,
    Dataset

include("common.jl")
include("dataset.jl")

end # module
