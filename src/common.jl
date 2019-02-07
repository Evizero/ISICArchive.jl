parse_datetime(str) = DateTime(split(str, ".")[1], "yyyy-mm-ddTHH:MM:SS.")

tostring(dt::DateTime) = Dates.format(dt, "yyyy-mm-ddTHH:MM:SS.")

function clean_json(response)
    json = JSON.parse(String(response.body))
    replace(json, r"<\/?[^>]+>|(&nbsp;)" => " ")
end

function writeall(file, str)
    open(file, "w") do io
        write(io, str)
    end
end
