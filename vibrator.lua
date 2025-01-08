function update_vibrator(strength)
    if not G.VIBRATION_MANAGER then
        -- We perform the requests on a separate thread to avoid causing UI lag
        local vibrationThread = love.thread.newThread("/Mods/BalatroBuzz/vibrationThread.lua")
        G.VIBRATION_MANAGER = {
            thread = vibrationThread,
            in_channel = love.thread.getChannel('vibration_channel_in'),
            out_channel = love.thread.getChannel("vibration_channel_out"),
        }
        vibrationThread:start()
    end

    G.LAST_VIBRATE = G.LAST_VIBRATE or 0
    if (love.timer.getTime() - G.LAST_VIBRATE) > 1 then
        local out = G.VIBRATION_MANAGER.out_channel:pop()
        if out then print(out) end

        if strength < 0.01 then strength = 0 end

        G.VIBRATION_MANAGER.in_channel:push(strength)
        G.LAST_VIBRATE = love.timer.getTime()
    end
end
