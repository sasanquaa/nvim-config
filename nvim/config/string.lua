function string.starts(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

function string.replace_char(str, pos, r)
    return table.concat { str:sub(1, pos - 1), r, str:sub(pos + 1) }
end

-- https://gist.github.com/jaredallard/ddb152179831dd23b230
function string.split(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end
