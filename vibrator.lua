function update_vibrator(strength)
    if not G.VIBRATION_THREAD then
        -- We perform the requests on a separate thread to avoid causing UI lag
        G.VIBRATION_THREAD = love.thread.newThread([[
            local https = require('https')
            CHANNEL = love.thread.getChannel("vibration_channel")

            while true do
                --Monitor the channel for any new requests
                local data = CHANNEL:demand()
                if data then
                    https.request('{{lovely:vibrate_url}}', { headers = {["Content-Type"] = "application/json"}, data = data, method = "POST" })
                end
            end
        ]])
        G.VIBRATION_THREAD:start()
        G.VIBRATION_CHANNEL = love.thread.getChannel('vibration_channel')
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

        G.VIBRATION_CHANNEL:push(data)
        G.LAST_VIBRATE = love.timer.getTime()
    end
end
