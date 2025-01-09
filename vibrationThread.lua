require "love"
require "love.filesystem"

CHANNEL_IN = love.thread.getChannel("vibration_channel_in")
CHANNEL_OUT = love.thread.getChannel("vibration_channel_out")

require('engine.object')
local json = require('Mods.BalatroBuzz.json')
local websocket = require("Mods.BalatroBuzz.websocket")

local intiface_host = CHANNEL_IN:demand()
local intiface_port = CHANNEL_IN:demand()
local device_index = CHANNEL_IN:demand()

CHANNEL_OUT:push('using Intiface host '..intiface_host..':'..intiface_port)
CHANNEL_OUT:push('using device index '..device_index)

local client = websocket.new(intiface_host, intiface_port, "/")

local Intiface = Object:extend()

function Intiface:init()
    self.message_id = 1
    self.ready = false
    self.callback_table = {}
end

function Intiface:send_json(data, callback)
    local payload = json.encode({data})
    CHANNEL_OUT:push('sent: '..payload)
    self.callback_table[self.message_id] = callback
    client:send(payload)
    self.message_id = self.message_id + 1
end

function Intiface:connect(callback)
    self:send_json({
        RequestServerInfo = {
            Id = self.message_id,
            ClientName = "BalatroBuzz",
            MessageVersion = 2
        }
    }, callback)
end

function Intiface:get_device_list(callback)
    -- [{"RequestDeviceList":{"Id":2}}]
    self:send_json({
        RequestDeviceList = {
            Id = self.message_id
        }
    }, callback)
end

function Intiface:scan(callback)
    -- [{"StartScanning":{"Id":3}}]
    self:send_json({
        StartScanning = {
            Id = self.message_id
        }
    }, callback)
end

function Intiface:vibrate(intensity)
    -- v3 version - for some reason the v3 handshake is having issues
    --
    -- self:send_json({
    --    ScalarCmd = {
    --        Id = self.message_id,
    --        DeviceIndex = 0,
    --        Scalars = {{ Index = 0, Scalar = intensity, ActuatorType = "Vibrate" }}
    --    }
    --})
    self:send_json({
        VibrateCmd = {
            Id = self.message_id,
            DeviceIndex = device_index,
            Speeds = {{ Index = 0, Speed = intensity }}
        }
    })
end

function Intiface:callback(message_type, message_id, message)
    CHANNEL_OUT:push(message_type.." message: "..json.encode(message))
    local callback = self.callback_table[message_id]
    if callback then callback(message) end
end

local buttplugClient = Intiface()

function client:onmessage(data)
    local json_data = json.decode(data)

    for _, message in ipairs(json_data) do
        for message_type, message_value in pairs(message) do
            local message_id = message_value.Id
            buttplugClient:callback(message_type, message_id, message_value)
        end
    end
end

function client:onopen()
    buttplugClient:connect(function ()
        buttplugClient:scan(function ()
            buttplugClient:get_device_list(function()
                buttplugClient.ready = true
                CHANNEL_OUT:push("Intiface ready!")
            end)
        end)
    end)
end

function client:onclose(code, reason)
    CHANNEL_OUT:push("closecode: "..code..", reason: "..reason)
end

while true do
    client:update()
    --Monitor the channel for any new requests
    if buttplugClient.ready then
        local data = CHANNEL_IN:pop()
        if data then
            buttplugClient:vibrate(data)
        end
    end
end