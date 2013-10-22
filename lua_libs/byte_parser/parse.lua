
--[[
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

otherwise = app <case> -> true
<case> : ?? 
<name> : string
<parser> : byte array -> (bool, value)

frame probably has to be a parser
dont need a lookup table of parser names if 
the frame function just returns a parser function

parse : main frame -> bytes -> (bool, data model)
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
    return function ( env )
        return function ( byte_array )
            return parser( byte_array )
        end
    end
end

function capture( name, parser )
    return function ( env )
        return function ( byte_array )
            local status, value = parser( byte_array )
            if status then
                env[name] = value
            end
            return status
        end
    end
end

-- capture meaning the output of the capture function
-- predicate meaning function of env -> bool
function case( predicate, capture )

end

function otherwise( capture ) -- this is just a special case

end

function choice( ... ) -- takes a list of cases

end

function frame( name, ... )
    local fieldStuff = {...}  -- seriously, whats a good name for this?
    local env = {}
    return function ( byte_array )
        for _, fs in ipairs( fieldStuff ) do
            -- at first I thought i was going overboard with the FP stuff
            -- but at second glance, I'm not sure that my env_var and val 
            -- functions will work the way I want to without the currying 
            -- stuff going on ... investigate further and refactor
            local successful = fs( env )( byte_array ) 
            if not successful then 
                return false, nil
            end
        end
        return true, env
    end 
end

function parse( frame, byteString )

end