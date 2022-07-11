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

-- get data
local m_data = M.get_args()
local j_data = m_data[1][1]
local data = lunajson.decode(j_data)

-- csum check
if data.params.csum == nil or data.params.csum == "" then
    return nil
end

-- create new descriptor
local tmp_f = os.tmpname()
-- get id
local id = tmp_f:gsub(".*_(.*)", "%1")

-- add csum and byte counter
local h = io.open(tmp_f, "w")
h:write(data.params.csum .. ";" .. 0 .. "\n")
h:close()

-- return firmware id
return '{ "firmware_id": "' .. id .. '" }'
