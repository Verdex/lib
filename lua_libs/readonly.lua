
module( ..., package.seeall )

local readonlyMeta = {}
local realKey = {}

function readonlyMeta.__newindex( table, key, value )
    error 'attempt to set field in readonly table'
end

function readonlyMeta.__index( proxy, key )
    local table = proxy[realKey] 
    return table[key]
end

local function inext( table, i )
    i = i + 1
    local t = table[i]
    if t then
        return i, t
    end
end

local function ipairs( proxy )
    return inext, proxy[realKey], 0
end

local function pairs( proxy )
    return next, proxy[realKey], nil
end

-- I would rather do this as a metamethod, but
-- it seems this fails in lua 5.1
local function length( proxy )
    return #proxy[realKey]
end

function shallowReadonly( table )
    local proxy = { 
        [realKey] = table,
        ipairs = ipairs, 
        pairs = pairs,
        length = length, }
    setmetatable( proxy, readonlyMeta )
    return proxy 
end

