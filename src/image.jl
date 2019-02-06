@with_kw struct ImageListRequest
    limit::Int = 50; @assert limit > 0
    offset::Int = 0; @assert offset >= 0
    sort::Symbol = :lowerName
    sortdir::Int = 1; @assert sortdir == 1 || sortdir == -1
    datasetId::String
end

ImageListRequest(ds::Union{ListEntry,DatasetMetadata}; kw...) = ImageListRequest(datasetId = ds.id; kw...)

function Base.get(req::ImageListRequest)
    query = "https://isic-archive.com:443/api/v1/image?limit=$(req.limit)&offset=$(req.offset)&sort=$(req.sort)&sortdir=$(req.sortdir)&datasetId=$(req.datasetId)"
    [ListEntry(o) for o in clean_json(get(query))]
end

# ====================================================================

mutable struct ImageMetadata
    id::String
    modelType::String
    created::DateTime
    #creatorId::String
    #description::String
    name::String
    updated::DateTime
    class::Symbol
    meta::Dict{String,Any}
end

function ImageMetadata(o::Dict)
    ImageMetadata(
        o["_id"],
        o["_modelType"],
        parse_datetime(o["created"]),
        #o["creatorId"],
        #o["description"],
        o["name"],
        parse_datetime(o["updated"]),
        extract_class(o["meta"]),
        o["meta"])
end

function JSON.json(o::ImageMetadata)
    dict = Dict{String, Any}()
    dict["_id"] = o.id
    dict["_modelType"] = o.modelType
    dict["created"] = tostring(o.created)
    #dict["creatorId"] = o.creatorId
    #dict["description"] = o.description
    dict["name"] = o.name
    dict["updated"] = tostring(o.updated)
    dict["meta"] = o.meta
    json(dict)
end

save(file, o::ImageMetadata) = writeall(file, json(o))
load_imagemeta(file) = ImageMetadata(JSON.parse(readall(file)))

for op = (:<, :>, :(==), :(!=), :(<=), :(>=))
  @eval function Base.$op(i1::ImageMetadata, i2::ImageMetadata)
      Base.$op(i1.updated, i2.updated)
  end
end

function extract_class(o::Dict)
    if haskey(o, "clinical")
        c = o["clinical"]
        if haskey(c, "benign_malignant")
            return Symbol(c["benign_malignant"])
        elseif haskey(c, "ben_mal")
            return Symbol(c["ben_mal"])
        end
    end
    :none
end

function Base.show(io::IO, o::ImageMetadata)
    printstyled(io, string(typeof(o)), "\n", :white)
    print(io,   "  .name: ")
    printstyled(io, o.name, "\n", :blue)
    println(io, "  .id: ", o.id)
    println(io, "  .modelType: ", o.modelType)
    #println(io, "  .creatorId: ", o.creatorId)
    println(io, "  .created: ", o.created)
    println(io, "  .updated: ", o.updated)
    println(io, "  .class: ", o.class)
    #println(io, "  .description: ", o.description)
    println(io, "")
    print(io,   "  .meta: parsed JSON as ")
    show(io, o.meta)
end

# ====================================================================

@with_kw struct ImageMetadataRequest
    id::String
end

ImageMetadataRequest(le::Union{ListEntry,ImageMetadata}) = ImageMetadataRequest(id = le.id)

function Base.get(req::ImageMetadataRequest)
    query = "https://isic-archive.com:443/api/v1/image/$(req.id)"
    ImageMetadata(clean_json(get(query)))
end

# ====================================================================

@with_kw struct ImageDownloadRequest
    id::String
end

ImageDownloadRequest(le::Union{ListEntry,ImageMetadata}) = ImageDownloadRequest(id = le.id)

function Base.get(req::ImageDownloadRequest)
    query = "https://isic-archive.com:443/api/v1/image/$(req.id)/download"
    ImageMagick.readblob(get(query).body)
end

# ====================================================================

@with_kw struct ImageThumbnailRequest
    id::String
end

ImageThumbnailRequest(le::Union{ListEntry,ImageMetadata}) = ImageThumbnailRequest(id = le.id)

function Base.get(req::ImageThumbnailRequest)
    query = "https://isic-archive.com:443/api/v1/image/$(req.id)/thumbnail"
    ImageMagick.readblob(get(query).body)
end
