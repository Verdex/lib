
function print_list( l ) 
    io.stdout:write "[ "
    for _,v in ipairs( l ) do
        io.stdout:write( v .. " " )
    end
    print("]")
end
   
local unique = 0
function splice( str, env )
    local gensym = {}
    local env = env or {}
    for sym in string.gmatch( str, "&(%w+)" ) do
        if not gensym[sym] then
            gensym[sym] = unique
            unique = unique + 1
        end
    end

    str = string.gsub( str, "&(%w+)", function (s)
        return s .. gensym[s]
    end )

    str = string.gsub( str, "@(%w+)", env )

    return str
end

outer = [[
return function ( array )
    @body
end
]]

recur = [[ 
for &k = @start, #array do 
    local &n = table.remove( array, &k )
    table.insert( array, @start, &n )

    @body

    &n = table.remove( array, @start )
    table.insert( array, &k, &n )
end
]]

base = [[
print_list( array )
local &temp = table.remove( array )
table.insert( array, #array, &temp )
print_list( array )
&temp = table.remove( array )
table.insert( array, #array, &temp )
]]

function recursive_part( tot, s )
    local s = s or 1
    if tot == 2 then
        return splice( base )
    end

    return splice( recur, { start = s, body = recursive_part( tot - 1, s + 1 ) } )
end

function perm( array )
    local str = splice( outer, { body = recursive_part( #array ) } )
    local f = loadstring( str )()
    f( array ) 
end

