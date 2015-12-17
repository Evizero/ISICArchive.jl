@defstruct ImageList (
    (limit::Int = 50, limit > 0),
    (offset::Int = 0, offset >= 0),
    sort::Symbol = :lowerName,
    (sortdir::Int = 1, sortdir == 1 || sortdir == -1),
    datasetId::ASCIIString
)

ImageList(ds::Union{ListEntry,DatasetInfo}; kw...) = ImageList(datasetId = ds.id; kw...)

function Base.get(req::ImageList)
    query = "https://isic-archive.com:443/api/v1/image?limit=$(req.limit)&offset=$(req.offset)&sort=$(req.sort)&sortdir=$(req.sortdir)&datasetId=$(req.datasetId)"
    [ListEntry(o) for o in clean_json(get(query))]
end

# ==========================================================================

type ImageInfo
    id::ASCIIString
    modelType::ASCIIString
    created::DateTime
    creatorId::ASCIIString
    description::UTF8String
    name::ASCIIString
    updated::DateTime
    class::Symbol
    meta
end

function ImageInfo(o::Dict)
    ImageInfo(
        o["_id"],
        o["_modelType"],
        parse_datetime(o["created"]),
        o["creatorId"],
        o["description"],
        o["name"],
        parse_datetime(o["updated"]),
        extract_class(o["meta"]),
        o["meta"])
end

function extract_class(o::Dict)
    if haskey(o, "clinical")
        c = o["clinical"]
        if haskey(c, "benign_malignant")
            return symbol(c["benign_malignant"])
        elseif haskey(c, "ben_mal")
            return symbol(c["ben_mal"])
        end
    end
    :none
end

function Base.show(io::IO, o::ImageInfo)
    print_with_color(:white, io, string(typeof(o)), "\n")
    print(io,   "  .name: ")
    print_with_color(:blue, io, o.name, "\n")
    println(io, "  .id: ", o.id)
    println(io, "  .modelType: ", o.modelType)
    println(io, "  .creatorId: ", o.creatorId)
    println(io, "  .created: ", o.created)
    println(io, "  .updated: ", o.updated)
    println(io, "  .class: ", o.class)
    println(io, "  .description: ", o.description)
    println(io, "")
    print(io,   "  .meta: parsed JSON as ")
    Base.showdict(io, o.meta)
end

# ==========================================================================

@defstruct ImageMetadata (
    id::ASCIIString
)

ImageMetadata(le::Union{ListEntry,ImageInfo}) = ImageMetadata(id = le.id)

function Base.get(req::ImageMetadata)
    query = "https://isic-archive.com:443/api/v1/image/$(req.id)"
    ImageInfo(clean_json(get(query)))
end

# ==========================================================================

@defstruct ImageDownload (
    id::ASCIIString
)

ImageDownload(le::Union{ListEntry,ImageInfo}) = ImageDownload(id = le.id)

function Base.get(req::ImageDownload)
    query = "https://isic-archive.com:443/api/v1/image/$(req.id)/download"
    ImageMagick.readblob(readbytes(get(query)))
end

# ==========================================================================

@defstruct ImageThumbnail (
    id::ASCIIString
)

ImageThumbnail(le::Union{ListEntry,ImageInfo}) = ImageThumbnail(id = le.id)

function Base.get(req::ImageThumbnail)
    query = "https://isic-archive.com:443/api/v1/image/$(req.id)/thumbnail"
    ImageMagick.readblob(readbytes(get(query)))
end
