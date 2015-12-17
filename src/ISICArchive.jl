module ISICArchive

using Requests
using JSON
using SimpleStructs

export

    DatasetList,
    Dataset,
    ImageList

include("common.jl")
include("dataset.jl")
include("image.jl")

end # module
