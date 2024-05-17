local utils = require('spectre.utils')

---@class RegexEngine
local vim_regex = {}

vim_regex.change_options = function(_) end

vim_regex.matchstr = function(search_text, search_query)
    local results = {}
    local start_pos = 0
    local escaped_query = '\\v' .. utils.escape_vim_magic(search_query)
    while true do
        local ok, result = pcall(vim.fn.matchstrpos, search_text, escaped_query, start_pos)
        if not ok or result[1] == '' then
            break
        end
        local match_start = result[2]
        local match_end = result[3]
        if match_start == -1 then
            break
        end
        table.insert(results, { match_start, match_end, search_text:sub(match_start + 1, match_end) })
        start_pos = match_end + 1
    end
    return results
end

vim_regex.replace_all = function(search_query, replace_query, text)
    local result = vim.fn.substitute(text, '\\v' .. utils.escape_vim_magic(search_query), replace_query, 'g')
    return result
end

--- get all position of text match in string
---@return table col{{start1, end1},{start2, end2}} math in line
vim_regex.match_text_line = function(match, str, padding)
    if match == nil or str == nil then
        return {}
    end
    if match == '' or str == '' then
        return {}
    end
    padding = padding or 0
    local index = 0
    local len = string.len(str)
    local match_len = string.len(match)
    local col_tbl = {}
    while index < len do
        local txt = string.sub(str, index, index + match_len - 1)
        if txt == match then
            table.insert(col_tbl, { index - 1 + padding, index + match_len - 1 + padding })
            index = index + match_len
        else
            index = index + 1
        end
    end
    return col_tbl
end

vim_regex.replace_file = function(filepath, lnum, search_query, replace_query) end

return vim_regex
