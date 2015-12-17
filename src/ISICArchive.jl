module ISICArchive

using Requests
using JSON
using SimpleStructs

parse_datetime(str) = DateTime(str, "yyyy-mm-ddHH:MM:SS.")
clean_json(response) = JSON.parse(replace(readall(response), r"<\/?[^>]+>|(&nbsp;)"," "))

include("dataset.jl")

end # module
