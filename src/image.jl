
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
    metadata
end

function ImageInfo(o::Dict)
    ImageInfo(
        o["_id"],
        o["_modelType"],
        parse_datetime(o["created"]),
        o["creatorId"],
        o["description"],
        o["name"],
        parse_datetime(o["updated"]))
end

function Base.show(io::IO, o::DatasetInfo)
    print_with_color(:white, io, string(typeof(o)), "\n")
    print(io,   "  .name: ")
    print_with_color(:blue, io, o.name, "\n")
    println(io, "  .id: ", o.id)
    println(io, "  .modelType: ", o.modelType)
    println(io, "  .creatorId: ", o.creatorId)
    println(io, "  .created: ", o.created)
    println(io, "  .updated: ", o.updated)
    println(io, "")
    print(io, o.description)
end
