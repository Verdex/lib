
-- TODO ipairs does not appear to work on readonly tables

module( ..., package.seeall )

local readonlyMeta = {}
local realKey = {}

function readonlyMeta.__newindex( table, key, value )
    error 'attempt to set field in readonly table'
end

function readonlyMeta.__index( proxy, key )
   local table = rawget( proxy, realKey ) 
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
    return inext, rawget( proxy, realKey ), 0
end

local function pairs( proxy )
    return next, rawget( proxy, realKey ), nil
end

function shallowReadonly( table )
    local proxy = { 
        [realKey] = table,
        ipairs = ipairs, 
        pairs = pairs }
    setmetatable( proxy, readonlyMeta )
    return proxy 
end

