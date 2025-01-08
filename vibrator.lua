function update_vibrator(strength)
    if not G.VIBRATION_MANAGER then
        -- We perform the requests on a separate thread to avoid causing UI lag
        local vibrationThread = love.thread.newThread([[
            local https = require('https')

            function get_lovense_host()
                local code, body = https.request('https://api.lovense.com/api/lan/getToys')
                -- weirdly, the response seems to not be valid JSON, so we do janky string search
                local i, j = string.find(body, '".-[.]lovense[.]club')
                if (i) then
                    local host = body.sub(body, i + 1, j)
                    return host
                end
            end

            CHANNEL_IN = love.thread.getChannel("vibration_channel_in")
            CHANNEL_OUT = love.thread.getChannel("vibration_channel_out")

            local host = get_lovense_host() or "{{lovely:vibrate_host}}"
            local command_url = "http://"..host..":".."{{lovely:vibrate_port}}".."/command"

            CHANNEL_OUT:push(command_url)

            while true do
                --Monitor the channel for any new requests
                local data = CHANNEL_IN:demand()
                if data then
                    https.request(command_url, { headers = {["Content-Type"] = "application/json"}, data = data, method = "POST" })
                end
            end
        ]])
        G.VIBRATION_MANAGER = {
            thread = vibrationThread,
            in_channel = love.thread.getChannel('vibration_channel_in'),
            out_channel = love.thread.getChannel("vibration_channel_out"),
        }
        vibrationThread:start()
    end

    G.LAST_VIBRATE = G.LAST_VIBRATE or 0
    if strength > 0.05 and (love.timer.getTime() - G.LAST_VIBRATE) > 1 then
        local scaledStrength = strength * {{lovely:intensity_scaling}}
        local roundingFunc = "{{lovely:intensity_rounding}}"
        if roundingFunc == "floor" then
            scaledStrength = math.floor(scaledStrength)
        elseif roundingFunc == "ceil" then
            scaledStrength = math.ceil(scaledStrength)
        elseif roundingFunc == "round" then
            scaledStrength = math.floor(scaledStrength + 0.5)
        end
        local data = [[{{lovely:vibrate_payload}}]]
        data = data:gsub('$intensity', scaledStrength)

        G.VIBRATION_MANAGER.in_channel:push(data)
        G.LAST_VIBRATE = love.timer.getTime()
    end
end
