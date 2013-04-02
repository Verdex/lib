
module( ..., package.seeall )


local tests = {}
local meta = {}

function meta.__newindex( table, key, value )
    if type( value ) == 'function' and key:match( '^test_' ) then
        local success, errorMessage = pcall( value )
        if success then
            print( "Pass:  " .. key )
        else
            print( "Failure:  " .. key .. " - " .. errorMessage )
        end
    else
        rawset( table, key, value )
    end
end

meta.__index = _G

setmetatable( tests, meta )

function init() 
    setfenv( 2, tests )
end

local throwUnexpectedMsg = 
[[
Unexpected error message encountered.
Expected:  %s
Found:  %s
]]
function assertThrows( f, expectedMsg )
    local suc, observedMsg = pcall( f )
    if suc == false then
        if expectedMsg and observeMsg ~= expectedMsg then
            error( string.format( throwUnexpectedMsg, expectedMsg, observedMsg ) )
        end
    else
        error 'Expected function to throw error'
    end
end

                        
