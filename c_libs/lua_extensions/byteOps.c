

#include "lua.h"
#include "lauxlib.h"

#include<stdlib.h>

static int xor( lua_State* L ) {
    int a = luaL_checkint( L, -2 );
    int b = luaL_checkint( L, -1 );
    lua_pushnumber( L, a ^ b );
    return 1;
}

static int and( lua_State* L ) {
    int a = luaL_checkint( L, -2 );
    int b = luaL_checkint( L, -1 );
    lua_pushnumber( L, a & b );
    return 1;
}

static int or( lua_State* L ) {
    int a = luaL_checkint( L, -2 );
    int b = luaL_checkint( L, -1 );
    lua_pushnumber( L, a | b );
    return 1;
}

static int rightShift( lua_State* L ) {
    int a = luaL_checkint( L, -2 );
    int b = luaL_checkint( L, -1 );
    lua_pushnumber( L, a >> b );
    return 1;
}

static int leftShift( lua_State* L ) { 
    int a = luaL_checkint( L, -2 );
    int b = luaL_checkint( L, -1 );
    lua_pushnumber( L, a << b );
    return 1;
}

static const struct luaL_Reg byteOps [] = {
    { "xor", xor },
    { "bitAnd", and },
    { "bitOr", or },
    { "rightShift", rightShift },
    { "leftShift", leftShift },
    { NULL, NULL }
};

int luaopen_byteOps( lua_State* L ) {
    luaL_newlib( L, byteOps );
    return 1; 
}
