type DatasetListEntry
    id::ASCIIString
    name::ASCIIString
    updated::DateTime
end

function DatasetListEntry(entry::Dict)
    DatasetListEntry(entry["_id"], entry["name"], parse_datetime(entry["updated"]))
end

function Base.show(io::IO, entry::DatasetListEntry)
    print_with_color(:blue, io, entry.name)
    print(io, ": id = $(entry.id), updated = $(entry.updated)")
end

# ==========================================================================

@defstruct DatasetList (
    (limit::Int = 50, limit > 0),
    (offset::Int = 0, offset >= 0),
    sort::Symbol = :lowerName,
    (sortdir::Int = 1, sortdir == 1 || sortdir == -1)
)

function Base.get(req::DatasetList)
    query = "https://isic-archive.com:443/api/v1/dataset?limit=$(req.limit)&offset=$(req.offset)&sort=$(req.sort)&sortdir=$(req.sortdir)"
    [DatasetListEntry(entry) for entry in clean_json(get(query))]
end

# ==========================================================================

type DatasetInfo
    accessLevel::Int
    id::ASCIIString
    modelType::ASCIIString
    created::DateTime
    creatorId::ASCIIString
    description::UTF8String
    name::ASCIIString
    updated::DateTime
end

function DatasetInfo(entry::Dict)
    DatasetInfo(
        entry["_accessLevel"],
        entry["_id"],
        entry["_modelType"],
        parse_datetime(entry["created"]),
        entry["creatorId"],
        entry["description"],
        entry["name"],
        parse_datetime(entry["updated"]))
end

function Base.show(io::IO, entry::DatasetInfo)
    print_with_color(:white, io, string(typeof(entry)), "\n")
    print(io,   "  .name: ")
    print_with_color(:blue, io, entry.name, "\n")
    println(io, "  .id: ", entry.id)
    println(io, "  .modelType: ", entry.modelType)
    println(io, "  .created: ", entry.created)
    println(io, "  .creatorId: ", entry.creatorId)
    println(io, "  .updated: ", entry.updated)
    println(io, "")
    print(io, entry.description)
end

# ==========================================================================

@defstruct Dataset (
    id::ASCIIString
)

Dataset(le::DatasetListEntry) = Dataset(id = le.id)

function Base.get(req::Dataset)
    query = "https://isic-archive.com:443/api/v1/dataset/$(req.id)"
    DatasetInfo(clean_json(get(query)))
end
