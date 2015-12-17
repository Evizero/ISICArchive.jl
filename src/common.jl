parse_datetime(str) = DateTime(str, "yyyy-mm-ddHH:MM:SS.")
tostring(dt::DateTime) = Dates.format(dt, "yyyy-mm-ddHH:MM:SS.")
clean_json(response) = JSON.parse(replace(readall(response), r"<\/?[^>]+>|(&nbsp;)"," "))
