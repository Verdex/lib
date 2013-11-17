
--[[

the thought does occur that i could add some sort of post processing step to
the frame function (an optional parameter), but I suspect that it will be 
better to just wrap the frame's output parsing function with another
function which performs that operation (that way things will be more modular
and you could reuse a frame without the processing that another module
would otherwise force on you)

frame <name>
    capture( <name> <parser>  )
    ditch( <parser> )
    constant -- ??  (also will need the same sig as ditch and capture)
    choice ( -- this guy is going to need the same sig as ditch and capture ...
        case( <predicate> capture( <name> <parser> ) )
        case( <predicate> ditch( <parser> ) )
        case( <predicate> empty )
        otherwise( capture( <name> <parser> )
        otherwise( ditch( <parser> ) )
        otherwise( empty )

maybe a = bool, a
parser a = byte_array -> maybe a
capture = (str, parser a) -> (env, byte_array) -> maybe a 
capture_array = ((env->int), str, parser a) -> (env, byte_array) -> maybe a

choice( ... ) = (env, byte_array) -> maybe a 
case pred (cap|dit) = (env, byte_array) -> maybe a 
pred = val|var, val|var, (?->?->bool) -> env -> bool
val|var = (env -> ?)


--]]

function cons_byte_array( byte_string )
    return { byte_string = byte_string; index = 1 }
end

--[[
    I want parser that will take a parameter
    this way I can just have like byte( val( 10 ) )
    instead of making a special parse 10 bytes parser
    !!! Additionally, I might want to make the size of the
    bytes *dynamic* based off of a previous value in the frame
    in order to do this the idea would be like byte( env_var( "a" ) )
--]]
function val( val )
    return function( env )
        return val
    end
end
function env_var( var ) 
    return function( env )
        return env[var]
    end
end

function empty( byte_array ) 
    return true
end

function constant(  ) -- this seems a lot like a special case of choice but with one item and otherwise fail

end

-- capture, but do not store value in an environment name
function ditch( parser )
    return function ( env, byte_array )
        return parser( byte_array )
    end
end

function capture( name, parser )
    return function ( env, byte_array )
        local status, value = parser( byte_array )
        if status then
            env[name] = value
        end
        return status
    end
end

function ditch_array( count, parser )
    return function ( env, byte_array )
        local c = count( env )  
        for i = 1, c do
            local status, value = parser( byte_array )
            if not( status ) then
                return false
            end
        end
        return true
    end
end

function capture_array( count, name, parser )
    return function ( env, byte_array )
        local c = count( env )  
        local a = {}
        for i = 1, c do
            local status, value = parser( byte_array )
            if status then
                a[i] = value
            else
                return false;
            end
        end
        env[name] = a
        return true
    end
end

function case( pred, capture )
    return function ( env, byte_array )
        if pred( env ) then

        else

        end
    end
end

function otherwise( capture ) -- this is just a special case

end

function choice( ... ) -- takes a list of cases

end

function frame( ... ) 
    local fieldStuff = {...}  -- seriously, whats a good name for this?
    local env = {}
    return function ( byte_array )
        for _, fs in ipairs( fieldStuff ) do
            local successful = fs( env, byte_array ) 
            if not successful then 
                return false, nil
            end
        end
        return true, env
    end 
end

function parse_byte( byte_array )
    -- can this operation fail?
    local val = string.byte( byte_array.byte_string, byte_array.index )
    byte_array.index = byte_array.index + 1
    return true, tonumber( val )
end

function parse( frame, byteString ) -- decide if byte_string or byte_array is better 

end

input = string.char( 3 ) .. string.char( 4 ) .. string.char( 5 ) .. string.char( 6 )


parser = frame( 
    capture( "zero", parse_byte ),
    capture( "one", parse_byte ),
    capture( "two", parse_byte ),
    capture( "three", parse_byte ) )

suc, env = parser( cons_byte_array( input ) )

assert( suc )
assert( env.zero == 3 )
assert( env.one == 4 )
assert( env.two == 5 )
assert( env.three == 6 )


input = string.char( 3 ) .. string.char( 4 ) .. string.char( 5 ) .. string.char( 6 )

blah = frame( 
    capture_array( val( 4 ), "ikky", parse_byte ) )

suc, env = blah( cons_byte_array( input ) )
assert( suc )
assert( env.ikky[1] == 3 )
assert( env.ikky[2] == 4 )
assert( env.ikky[3] == 5 )
assert( env.ikky[4] == 6 )

input = string.char( 4 ) .. string.char( 4 ) .. string.char( 5 ) .. string.char( 6 ) .. string.char( 7 )

blah = frame( 
    capture( "length", parse_byte ),
    capture_array( env_var( "length" ), "ikky", parse_byte ) )

suc, env = blah( cons_byte_array( input ) )
assert( suc )
assert( env.length == 4 )
assert( env.ikky[1] == 4 )
assert( env.ikky[2] == 5 )
assert( env.ikky[3] == 6 )
assert( env.ikky[4] == 7 )
