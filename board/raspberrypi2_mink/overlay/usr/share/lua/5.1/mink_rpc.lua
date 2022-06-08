-- mink module
local M = require("mink")(...)
local lunajson = require("lunajson")

-- get input args
local data = M.get_args()

-- process input
local t = lunajson.decode(data[1][1])

-- unknown command
local res = {
    code = -1,
    message = "Unknown command"
}
-- set result
M.set_result(lunajson.encode(res))
