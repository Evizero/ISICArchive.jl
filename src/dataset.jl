mutable struct ListEntry
    id::String
    name::String
    updated::DateTime
end

function ListEntry(o::Dict)
    ListEntry(o["_id"], o["name"], parse_datetime(o["updated"]))
end

convert(::Type{<:AbstractString}, ls::ListEntry) = ls.id

function show(io::IO, o::ListEntry)
    printstyled(io, o.name, color=:blue)
    print(io, ": id = $(o.id), updated = $(o.updated)")
end

# ====================================================================

@with_kw_noshow struct DatasetListRequest
    limit::Int = 50; @assert limit > 0
    offset::Int = 0; @assert offset >= 0
    sort::Symbol = :lowerName
    sortdir::Int = 1; @assert sortdir == 1 || sortdir == -1
end

function Base.get(req::DatasetListRequest)
    query = "https://isic-archive.com/api/v1/dataset?limit=$(req.limit)&offset=$(req.offset)&sort=$(req.sort)&sortdir=$(req.sortdir)"
    [ListEntry(o) for o in clean_json(get(query))]
end

show(io::IO, req::DatasetListRequest) =
    print(io, "$(typeof(req))\nlimit:   $(req.limit)\noffset:  $(req.offset)\nsort:    $(req.sort)\nsortdir: $(req.sortdir)\n")


# ====================================================================

mutable struct DatasetMetadata
    id::String
    modelType::String
    created::DateTime
    #creatorId::String
    description::String
    name::String
    updated::DateTime
end

function DatasetMetadata(o::Dict)
    DatasetMetadata(
        o["_id"],
        o["_modelType"],
        parse_datetime(o["created"]),
        #o["creator"]["_id"],
        o["description"],
        o["name"],
        parse_datetime(o["updated"]))
end

function JSON.json(o::DatasetMetadata)
    dict = Dict{String, Any}()
    dict["_id"] = o.id
    dict["_modelType"] = o.modelType
    dict["created"] = tostring(o.created)
    #dict["creatorId"] = o.creatorId
    dict["description"] = o.description
    dict["name"] = o.name
    dict["updated"] = tostring(o.updated)
    json(dict)
end

save(file, o::DatasetMetadata) = writeall(file, json(o))
load_datasetmeta(file) = DatasetMetadata(JSON.parse(readall(file)))

for op = (:<, :>, :(==), :(!=), :(<=), :(>=))
  @eval function Base.$op(d1::DatasetMetadata, d2::DatasetMetadata)
      Base.$op(d1.updated, d2.updated)
  end
end

function Base.show(io::IO, o::DatasetMetadata)
    printstyled(io, string(typeof(o)), "\n", color=:white)
    print(io,   "  .name: ")
    printstyled(io, o.name, "\n", color = :blue)
    println(io, "  .id: ", o.id)
    println(io, "  .modelType: ", o.modelType)
    #println(io, "  .creatorId: ", o.creatorId)
    println(io, "  .created: ", o.created)
    println(io, "  .updated: ", o.updated)
    println(io, "")
    print(io, o.description)
end

# ====================================================================

@with_kw_noshow struct DatasetMetadataRequest
    id::String
end

DatasetMetadataRequest(le::ListEntry) = DatasetMetadataRequest(id = le.id)

function Base.get(req::DatasetMetadataRequest)
    query = "https://isic-archive.com/api/v1/dataset/$(req.id)"
    DatasetMetadata(clean_json(get(query)))
end

show(io::IO, req::DatasetMetadataRequest) = print(io, "$(typeof(req))\nid:    $(req.id)")
