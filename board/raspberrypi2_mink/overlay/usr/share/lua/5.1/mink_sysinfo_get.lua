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
local lunajson = require("lunajson")
-- sdbus call
local h = io.popen("busctl call --json=short org.freedesktop.hostname1 /org/freedesktop/hostname1 org.freedesktop.hostname1 Describe")
local j_bdata = h:read("*a")
h:close()
-- extract data part
local t_bdata = lunajson.decode(j_bdata)
-- return data part as json string
local t_out = lunajson.decode(t_bdata.data[1])
return lunajson.encode(t_out)
