--            _       _
--  _ __ ___ (_)_ __ | | __
-- | '_ ` _ \| | '_ \| |/ /
-- | | | | | | | | | |   <
-- |_| |_| |_|_|_| |_|_|\_\
--
-- SPDX-License-Identifier: MIT
--
--

-- imports
local M = require("mink")(...)
local lunajson = require("lunajson")
local inspect = require("inspect")
local b64 = require("base64")

-- get data
local m_data = M.get_args()
local j_data = m_data[1][1]
local data = lunajson.decode(j_data)

-- id
local id = data.params.id

-- check meta
local h = io.open("/tmp/lua_" .. id, "r")
if h == nil then
    return nil
end

-- read meta
local md = h:read("*a")
h:close()

-- csum and byte count
local csum = md:gsub("(.*);.*", "%1")
local bc = md:gsub(".*;(%d)", "%1")

-- decode base64 data
local raw = b64.decode(data.params.data)
-- add to data
local h = io.open("/tmp/" .. id .. ".data", "a")
h:write(raw)
h:close()

-- update meta
h = io.open("/tmp/lua_" .. id, "w")
h:write(csum .. ";" .. bc + #raw)
h:close()

-- check if finished ("more_fragments" == false)
if not data.params.more_fragments then
    -- remove meta
    os.remove("/tmp/lua_" .. id)
    -- verify checksum
    local ch = io.popen("sha256sum /tmp/" .. id .. ".data")
    local csum2 = ch:read("*a"):gsub("([^ ]*).*", "%1")
    ch:close()
    -- csum verified
    if csum == csum2 then
        os.remove("/tmp/lua_" .. id)
    -- invalid csum
    else
        os.remove("/tmp/lua_" .. id)
        os.remove("/tmp/" .. id .. ".data")
        return nil
    end
end

-- return byte counts
local res = {
    bytes_written = #raw,
    bytes_total = bc + #raw
}
return lunajson.encode(res)
