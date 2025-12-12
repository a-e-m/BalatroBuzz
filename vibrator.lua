function update_vibrator()
    if not G.VIBRATION_MANAGER then
        -- We perform the requests on a separate thread to avoid causing UI lag
        local vibrationThread = love.thread.newThread("/Mods/BalatroBuzz/vibrationThread.lua")
        G.VIBRATION_MANAGER = {
            thread = vibrationThread,
            in_channel = love.thread.getChannel('vibration_channel_in'),
            out_channel = love.thread.getChannel("vibration_channel_out"),
        }
        vibrationThread:start()
        
        -- Send Intiface connection info to vibration thread
        G.VIBRATION_MANAGER.in_channel:push('{{lovely:intiface_host}}')
        G.VIBRATION_MANAGER.in_channel:push({{lovely:intiface_port}})
    end

    G.LAST_VIBRATE = G.LAST_VIBRATE or 0
    if (love.timer.getTime() - G.LAST_VIBRATE) > 1 then
        local should_buzz = G.ARGS.score_intensity.earned_score >= G.ARGS.score_intensity.required_score and G.ARGS.score_intensity.required_score > 0;
        local strength = math.min(math.log(G.ARGS.score_intensity.earned_score / G.ARGS.score_intensity.required_score) + 0.1, 1.0)
        local out = G.VIBRATION_MANAGER.out_channel:pop()
        if out then print(out) end

        if strength < {{lovely:zero_threshold}} then strength = 0 end

        if should_buzz then
            G.VIBRATION_MANAGER.in_channel:push(strength)
        else
            G.VIBRATION_MANAGER.in_channel:push(0.0)
        end
        G.LAST_VIBRATE = love.timer.getTime()
    end
end
