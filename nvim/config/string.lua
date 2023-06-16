function string.starts(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

function string.replace_char(str, pos, r)
    return table.concat {str:sub(1, pos - 1), r, str:sub(pos + 1)}
end
