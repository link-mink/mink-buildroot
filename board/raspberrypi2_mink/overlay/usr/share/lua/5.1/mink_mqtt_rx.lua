-- modules
local M = require("mink")(...)
local device = require("device")
local inspect = require("inspect")
local lunajson = require("lunajson")

-- device id
local ID = device.id
-- args
local data = M.get_args()
-- topic
local T = data[1].mqtt_topic
-- payload
local P = data[1].mqtt_payload

-- debug
print("mqtt:RX: ", inspect(data))

-- verify topic
if T == "mink/" .. ID .. "/cmd" then
    -- decode json rpc
    local j = lunajson.decode(P)
    -- process method
    local s_res = M.signal(j.method, P)
    -- setup mqtt result header
    local res = {
        jsonrpc = "2.0",
        id = j.id
    }
    -- err check
    if s_res ~= nil and s_res ~= "" then
        res.result = lunajson.decode(s_res)
    else
        res.error = {
            code = -1,
            message = "unknown error"
        }
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

