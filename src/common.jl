parse_datetime(str) = DateTime(split(str, ".")[1], "yyyy-mm-ddTHH:MM:SS.")
tostring(dt::DateTime) = Dates.format(dt, "yyyy-mm-ddTHH:MM:SS.")
clean_json(response) = JSON.parse(replace(readstring(response), r"<\/?[^>]+>|(&nbsp;)"," "))
function writeall(file, str)
    open(file, "w") do io
        write(io, str)
    end
end
