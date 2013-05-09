
module( ..., package.seeall )


local _cataMeta = {}
local _anaMeta = {}
local _combinedMeta = {}
local _realKey = {}

local function nilIndex( table, key )
    return nil
end

local function nilNexIndex( table, key, value )
    -- do nothing
end

-- my morphisms will be tables that pretend to be functions
-- this is sealing off the table like behavior
_cataMeta.__newIndex = nilNexIndex
_cataMeta.__index = nilIndex

_anaMeta.__newIndex = nilNewIndex
_anaMeta.__index = nilIndex

_combinedMeta.__newIndex = nilNewIndex
_combinedMeta.__index = nilIndex


function _cataMeta.__call( proxy, ... )
    -- should only have a single arg (list to be reduced)
    local args = {...}
    local list = args[1]

    -- TODO pull appropriate items out of the real table and do computation
    return nil
end

function compose( a, b )
    -- Dont bother with a case for normal lua functions because
    -- with a normal lua function I have no idea what the arity is
end
