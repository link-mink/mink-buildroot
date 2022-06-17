--            _       _
--  _ __ ___ (_)_ __ | | __
-- | '_ ` _ \| | '_ \| |/ /
-- | | | | | | | | | |   <
-- |_| |_| |_|_|_| |_|_|\_\
--
-- SPDX-License-Identifier: MIT
--
--

--imports
local M = require("mink")(...)
local device = require("device")
local lunajson = require("lunajson")

-- device id
local ID = device.id
-- args
local data = M.get_args()
-- topic
local T = data[1].mqtt_topic
-- payload
local P = data[1].mqtt_payload

-- json decode error handler
local function json_decode(d)
    local s, j = pcall(lunajson.decode, d)
    if not s then
        return false, {
            code = -1,
            message = "malformed data"
        }
    else
        return true, j
    end
end

-- verify topic
if T == "mink/" .. ID .. "/cmd" then
    -- setup mqtt result header
    local res = {
        jsonrpc = "2.0"
    }
    -- decode json rpc
    local s, j = json_decode(P)
    if not s then
        res.error = j
        res.id = -1
    else
        res.id = j.id
         -- process method
        local s_res = M.signal(j.method, P)
        -- err check
        if s_res ~= nil and s_res ~= "" then
            s, j = json_decode(s_res)
            if not s then
                res.error = j
            else
                res.result = j
            end
        else
            res.error = {
                code = -1,
                message = "unknown error"
            }
        end
    end
    -- MQTT PUBLISH result/error
    cmd = {
        "CMD_MQTT_PUBLISH",
        "mqtt_local",
        "mink/" .. ID .. "/res",
        lunajson.encode(res)
    }
    M.cmd_call(cmd)
end
