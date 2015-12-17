module ISICArchive

import Requests: get
using JSON
using SimpleStructs
using Images
using ImageMagick

export

    DatasetList,
    Dataset,

    ImageList,
    ImageMetadata,
    ImageDownload,
    ImageThumbnail

include("common.jl")
include("dataset.jl")
include("image.jl")

end # module
