
function string:endswith(ending)
    return ending == "" or self:sub(-#ending) == ending
end

function fileExtension(path)
    local lastdotpos = (path:reverse()):find("%.")
    return (lastdotpos)
end

function love.load()
    push = require "./libs/push"
    fullscreentypevar = "desktop"
    love.window.setMode(320, 240, {resizable = true, fullscreen = true, fullscreentype = fullscreentypevar})
    push.setupScreen(320, 240, {upscale = "pixel-perfect"})
    love.graphics.setDefaultFilter("linear", "nearest")
    font = love.graphics.newImageFont("assets/font/Damienne8.png", " AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!?.,:;\"\'()[]<>/\\|~`@#$%^&*-_+=↑→↓←", 1)
    font:setLineHeight(1.25)
    love.graphics.setFont(font)
    bg = love.graphics.newImage("assets/UI/Background.png")
    art = love.graphics.newImage("assets/UI/MusicArt.png")
    nav = love.graphics.newImage("assets/UI/playbackButtons.png")
    delete = love.graphics.newImage("assets/UI/delete.png")
    --navlight = love.graphics.newImage("assets/UI/playbackButtonsHighlighted.png") unused
    rewind = love.graphics.newQuad(0,0,62,18,143,36)
    pause = love.graphics.newQuad(62,0,19,18,143,36)
    fastforward = love.graphics.newQuad(81,0,62,18,143,36)
    restart = love.graphics.newQuad(0,18,62,18,143,36)
    stop = love.graphics.newQuad(62,18,19,18,143,36)
    skip = love.graphics.newQuad(81,18,62,18,143,36)
    if not love.filesystem.getInfo("music", "directory") then
        print("No music directory found, creating..")
        love.filesystem.createDirectory("music")
    end
    files = love.filesystem.getDirectoryItems("music")
    formats = {".wav", ".mp3", ".ogg", ".oga", ".ogv", ".699", ".amf", ".ams", ".dbm", ".dmf", ".dsm", ".far", ".it", ".j2b", ".mdl", ".med", ".mod", ".mt2", ".mtm", ".okt", ".psm", ".s3m", ".stm", ".ult", ".umx", ".xm", ".abc", ".mid", ".pat", ".flac"}
    music = {}
    for k, file in ipairs(files) do
        print(k .. ". " .. file) --outputs something like "1. main.lua"
        infoTable = love.filesystem.getInfo("music/"..file)
        print(infoTable.type)
        if infoTable.type == "directory" then
            music[#music+1] = file
        end
        for i, format in ipairs(formats) do
            if file:endswith(format) then
                music[#music+1] = file
            end
        end
    end
    files = nil
    if #music == 0 then
        print("empty ahh")
        IsEmptyFolder = true
    end
    highlightedfile = 1
    highlightedopt = 1
    IsPlaying = false
    appendDir = ""
    queue = {}
    queueMode = false
    navigation = {1,1}
    isPaused = false
end

function bool2int(bool)
    if bool then
    return 1
    else
    return 0
    end
end

function math.whole(n)
    return (math.abs(n)+n) / 2
end

function love.keypressed(key, code, isrepeat)
    if not (IsEmptyFolder or IsPlaying) then
        if key == "up" and not isrepeat and highlightedfile-1>=0 then
            highlightedfile = highlightedfile-1
        elseif key == "down" and not isrepeat then --and highlightedfile+1 <= #music then
            if queueMode and highlightedfile+1 <= #queue then
                highlightedfile = highlightedfile+1
            elseif not queueMode and highlightedfile+1 <= #music then
                highlightedfile = highlightedfile+1
            end
        elseif key == "left" and not isrepeat and highlightedopt-1 >= 1 then
            highlightedopt = highlightedopt - 1
        elseif key == "right" and not isrepeat and highlightedopt+1 <= 2 then
            highlightedopt = highlightedopt + 1
        end
        if key == "return" and not isrepeat then
            if queueMode and highlightedfile~=0 then
                table.remove(queue, highlightedfile)
                if highlightedfile > #queue then
                        highlightedfile = #queue
                end
                return
            end
            if highlightedfile == 0 then
                if highlightedopt == 2 then
                    love.event.quit()
                else
                    queueMode = not queueMode
                end
            else
                if highlightedopt == 2 and love.filesystem.getInfo("music/"..appendDir..music[highlightedfile]).type ~= "directory" then
                    queue[#queue+1] = appendDir..music[highlightedfile]
                else
                    if music[highlightedfile] == ".." then
                        riDdneppa = appendDir:reverse()
                        print(riDdneppa)
                        hey_wheres_the_parent = string.find(riDdneppa, "/", 2)
                        print(hey_wheres_the_parent)
                        if hey_wheres_the_parent == nil then
                            appendDir = ""
                        else
                            appendDir = string.sub(riDdneppa, hey_wheres_the_parent):reverse()
                            print(appendDir)
                        end
                        print(appendDir)
                        files = love.filesystem.getDirectoryItems("music/"..appendDir)
                        formats = {".wav", ".mp3", ".ogg", ".oga", ".ogv", ".699", ".amf", ".ams", ".dbm", ".dmf", ".dsm", ".far", ".it", ".j2b", ".mdl", ".med", ".mod", ".mt2", ".mtm", ".okt", ".psm", ".s3m", ".stm", ".ult", ".umx", ".xm", ".abc", ".mid", ".pat", ".flac"}
                        music = {}
                        if appendDir ~= "" then
                            music[#music+1] = ".."
                        end
                        for k, file in ipairs(files) do
                            print(k .. ". " .. file) --outputs something like "1. main.lua"
                            infoTable = love.filesystem.getInfo("music/"..appendDir..file)
                            print(infoTable.type)
                            if infoTable.type == "directory" then
                                music[#music+1] = file
                            end
                            for i, format in ipairs(formats) do
                                if file:endswith(format) then
                                    music[#music+1] = file
                                end
                            end
                        end
                        highlightedfile = 1
                        files = nil
                    elseif love.filesystem.getInfo("music/"..appendDir..music[highlightedfile]).type == "directory" then
                        if appendDir ~= "" then
                            appendDir = appendDir..music[highlightedfile].."/"
                        else
                            appendDir = music[highlightedfile].."/"
                        end
                        files = love.filesystem.getDirectoryItems("music/"..appendDir)
                        formats = {".wav", ".mp3", ".ogg", ".oga", ".ogv", ".699", ".amf", ".ams", ".dbm", ".dmf", ".dsm", ".far", ".it", ".j2b", ".mdl", ".med", ".mod", ".mt2", ".mtm", ".okt", ".psm", ".s3m", ".stm", ".ult", ".umx", ".xm", ".abc", ".mid", ".pat", ".flac"}
                        music = {}
                        if appendDir ~= "" then
                            music[#music+1] = ".."
                        end
                        for k, file in ipairs(files) do
                            print(k .. ". queue[#queue] = nil" .. file) --outputs something like "1. main.lua"
                            infoTable = love.filesystem.getInfo("music/"..appendDir..file)
                            print(infoTable.type)
                            if infoTable.type == "directory" then
                                music[#music+1] = file
                            end
                            for i, format in ipairs(formats) do
                                if file:endswith(format) then
                                    music[#music+1] = file
                                end
                            end
                        end
                        highlightedfile = 1
                        files = nil
                    else
                        queue[#queue+1] = appendDir..music[highlightedfile]
                        if love.filesystem.getInfo("music/"..queue[#queue]..".png") then
                            musicArt = love.graphics.newImage("music/"..queue[#queue]..".png")
                        else
                            musicArt = art
                        end
                        -- data, err = love.filesystem.newFileData("music/"..appendDir..music[highlightedfile])) old method of getting data.
                        print(err)
                        audioSource = love.audio.newSource(love.sound.newSoundData("music/"..queue[#queue]), "stream")
                        audioSource:play()
                        IsPlaying = true
                    end
                end
            end
        end
    elseif not IsEmptyFolder then
        if key == "up" and not isrepeat and navigation[1]-1~=0 then
            navigation[1] = navigation[1] - 1
        elseif key == "down" and not isrepeat and navigation[1]+1 <= 2 then
            navigation[1] = navigation[1] + 1
        elseif key == "left" and not isrepeat and navigation[2]-1 >= 1 then
            navigation[2] = navigation[2] - 1
        elseif key == "right" and not isrepeat and navigation[2]+1 <= 3 then
            navigation[2] = navigation[2] + 1
        end
        if key == "return" and not isrepeat then
            if navigation[1]==1 then
                if navigation[2]==1 then
                    audioSource:seek(math.whole(audioSource:tell("seconds")-10))
                elseif navigation[2]==2 then
                    if isPaused then
                        audioSource:play()
                        isPaused = false
                    else
                        isPaused = true
                        audioSource:pause()
                    end
                elseif navigation[2]==3 then
                    audioSource:seek(math.whole(audioSource:tell("seconds")+10))
                end
            end
            if navigation[1]==2 then
                if navigation[2]==1 then
                    audioSource:seek(0)
                elseif navigation[2]==2 then
                    IsPlaying = false
                    audioSource:stop()
                elseif navigation[2]==3 then
                    audioSource:stop()
                end
            end
        end
    end
    if not isrepeat and key == "f11" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
    if not isrepeat and key == "f4" then
        if love.keyboard.isDown("lalt") then
            love.event.quit()
        end
    end
end

function love.resize(width, height)
	push.resize(width, height)
end

function love.update(dt)
    if IsPlaying and not audioSource:isPlaying() and not isPaused then
        audioSource:release()
        print(queue[#queue])
        if #queue > 0 then
                table.remove(queue, #queue)
                if #queue <= 0 then
                    IsPlaying = false
                else
                    if love.filesystem.getInfo("music/"..queue[#queue]..".png") then
                        musicArt = love.graphics.newImage("music/"..queue[#queue]..".png")
                    else
                        musicArt = art
                    end
                    -- data, err = love.filesystem.newFileData("music/"..appendDir..music[highlightedfile])) old method of getting data.
                    print(err)
                    audioSource = love.audio.newSource(love.sound.newSoundData("music/"..queue[#queue]), "stream")
                    audioSource:play()
                end
        else
        IsPlaying = false
        end
    end
end



function love.draw()
    push:start()
        love.graphics.setColor(1,1,1)
        love.graphics.draw(bg, 0,0)
        love.graphics.setColor(0,0,0)
        if IsEmptyFolder then
            love.graphics.printf("Hey there! Seems like you're missing music to play. Add some music to "..love.filesystem.getSaveDirectory().."/music and try again!", 0, 88, 160, "center", 0, 2)
        elseif not IsPlaying then
            if not queueMode then
                love.graphics.print("music/"..appendDir,0,1)
            else
                love.graphics.print("Queue ("..#queue..")",0,1)
            end
            if highlightedfile == 0 then
                love.graphics.setColor(0+(0.8*(bool2int(highlightedopt==1))),0+(0.8*(bool2int(highlightedopt==1))),1)
                love.graphics.rectangle("fill", 284,0,18,8)
                love.graphics.setColor(0.8-(0.8*(bool2int(highlightedopt==1))),0.8-(0.8*(bool2int(highlightedopt==1))),1)
                love.graphics.rectangle("fill", 287,1,12,1)
                love.graphics.rectangle("fill", 287,3,12,1)
                love.graphics.rectangle("fill", 287,5,12,1)
                love.graphics.setColor(0+(0.8*(bool2int(highlightedopt==2))),0+(0.8*(bool2int(highlightedopt==2))),1)
                love.graphics.rectangle("fill", 302,0,18,8)
                love.graphics.setColor(0.8-(0.8*(bool2int(highlightedopt==2))),0.8-(0.8*(bool2int(highlightedopt==2))),1)
                love.graphics.print("x", 309)
            else
                love.graphics.setColor(0,0,1)
                love.graphics.rectangle("fill", 284,0,18,8)
                love.graphics.setColor(0.8,0.8,1)
                love.graphics.rectangle("fill", 287,1,12,1)
                love.graphics.rectangle("fill", 287,3,12,1)
                love.graphics.rectangle("fill", 287,5,12,1)
                love.graphics.setColor(0,0,1)
                love.graphics.rectangle("fill", 302,0,18,8)
                love.graphics.setColor(0.8,0.8,1)
                love.graphics.print("x", 309)
            end
            if queueMode then
                for k, file in ipairs(queue) do
                    koffset = math.whole(highlightedfile-5)
                    if highlightedfile > 5 and highlightedfile >= k+5 then
                        goto skip_render_queuemode
                    else
                        if k == highlightedfile then
                            love.graphics.setColor(0,0,1)
                            love.graphics.rectangle("fill", 0,(((k-koffset)-1)*20)+10,320,18)
                            love.graphics.setColor(0.8,0.8,1)
                            love.graphics.rectangle("fill", 0,(((k-koffset)-1)*20)+10,18,18)
                            love.graphics.setColor(0,0,1)
                            love.graphics.draw(delete, 0, (((k-koffset)-1)*20)+11)
                            love.graphics.setColor(0.8,0.8,1)
                        else
                            love.graphics.setColor(0,0,0)
                        end
                        --print(k .. ". " .. file) --outputs something like "1. main.lua"
                        love.graphics.printf(file, -480, (((k-koffset)-1)*20)+12, 640, "center", 0, 2)
                    end
                    ::skip_render_queuemode::
                end

            else
                for k, file in ipairs(music) do
                    koffset = math.whole(highlightedfile-5)
                    if k == highlightedfile then
                    love.graphics.setColor(0,0,1)
                    love.graphics.rectangle("fill", 0,(((k-koffset)-1)*20)+10,320,18)
                        if love.filesystem.getInfo("music/"..appendDir..music[highlightedfile]).type ~= "directory" then
                            love.graphics.setColor(0+(0.8*(bool2int(highlightedopt==1))),0+(0.8*(bool2int(highlightedopt==1))),1)
                            love.graphics.rectangle("fill", 0,(((k-koffset)-1)*20)+10,18,18)
                            love.graphics.setColor(0.8-(0.8*(bool2int(highlightedopt==1))),0.8-(0.8*(bool2int(highlightedopt==1))),1)
                            love.graphics.polygon("fill",4,(((k-koffset)-1)*20)+14,4,(((k-koffset)-1)*20)+24,14,(((k-koffset)-1)*20)+19)
                            love.graphics.setColor(0+(0.8*(bool2int(highlightedopt==2))),0+(0.8*(bool2int(highlightedopt==2))),1)
                            love.graphics.rectangle("fill", 18,(((k-koffset)-1)*20)+10,18,18)
                            love.graphics.setColor(0.8-(0.8*(bool2int(highlightedopt==2))),0.8-(0.8*(bool2int(highlightedopt==2))),1)
                            love.graphics.rectangle("line", 20,(((k-koffset)-1)*20)+15,14,0)
                            love.graphics.rectangle("line", 20,(((k-koffset)-1)*20)+19,14,0)
                            love.graphics.rectangle("line", 20,(((k-koffset)-1)*20)+23,14,0)
                        end
                        love.graphics.setColor(0.8,0.8,1)
                        else
                        love.graphics.setColor(0,0,0)
                    end
                    --print(k .. ". " .. file) --outputs something like "1. main.lua"
                    love.graphics.printf(file, -480, (((k-koffset)-1)*20)+12, 640, "center", 0, 2)
                end
            end
        else
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", 14, 32, 132, 132)
            love.graphics.setColor(1,1,1)
            love.graphics.draw(musicArt, 16, 34, 0, 128/musicArt:getWidth(), 128/musicArt:getHeight())
            love.graphics.setColor(0,0,0)
            love.graphics.printf("Now Playing: ", 16, 8, 320, "left", 0, 2)
            if string.find(queue[#queue], "/") then
            love.graphics.printf(string.sub(queue[#queue],2+string.len(queue[#queue])-string.find(string.reverse(queue[#queue]), "/"),string.len(queue[#queue])-fileExtension(queue[#queue])), 152, 32, 68, "left", 0, 2)
            else
            love.graphics.printf(string.sub(queue[#queue],0,string.len(queue[#queue])-fileExtension(queue[#queue])), 152, 32, 68, "left", 0, 2)
            end
            love.graphics.printf(math.floor(audioSource:tell("seconds")/60)..":"..string.sub("00000000000",0,2-string.len(math.floor(audioSource:tell("seconds")%60)))..math.floor(audioSource:tell("seconds")%60).."/"..math.floor(audioSource:getDuration("seconds")/60)..":"..string.sub("00000000000",0,2-string.len(math.floor(audioSource:getDuration("seconds")%60)))..math.floor(audioSource:getDuration("seconds")%60), 152, 152, 64, "left", 0, 2)
            love.graphics.rectangle("fill",8,170,304,18)
            love.graphics.setColor(0,0,1)
            love.graphics.rectangle("fill",10,172,300*(audioSource:tell("seconds")/audioSource:getDuration("seconds")),14)
            love.graphics.setColor(1-(bool2int(navigation[1]==1 and navigation[2]==1)),1,1)
            love.graphics.draw(nav, rewind, 151, 138-28)
            love.graphics.setColor(1-(bool2int(navigation[1]==1 and navigation[2]==2)),1,1)
            love.graphics.draw(nav, pause, 218, 138-28)
            love.graphics.setColor(1-(bool2int(navigation[1]==1 and navigation[2]==3)),1,1)
            love.graphics.draw(nav, fastforward, 242, 138-28)
            love.graphics.setColor(1-(bool2int(navigation[1]==2 and navigation[2]==1)),1,1)
            love.graphics.draw(nav, restart, 151, 158-28)
            love.graphics.setColor(1-(bool2int(navigation[1]==2 and navigation[2]==2)),1,1)
            love.graphics.draw(nav, stop, 218, 158-28)
            love.graphics.setColor(1-(bool2int(navigation[1]==2 and navigation[2]==3)),1,1)
            love.graphics.draw(nav, skip, 242, 158-28)
            love.graphics.setColor(0,1,1)

            if queue[#queue-1] ~= nil then
                if string.find(queue[#queue-1], "/") then
                    love.graphics.printf("Up next:"..string.sub(queue[#queue-1],2+string.len(queue[#queue-1])-string.find(string.reverse(queue[#queue-1]), "/"),string.len(queue[#queue-1])-fileExtension(queue[#queue-1])), 16, 192, 152, "left", 0, 2)
                else
                    love.graphics.printf("Up next:"..string.sub(queue[#queue-1],0,string.len(queue[#queue-1])-fileExtension(queue[#queue-1])), 16, 192, 152, "left", 0, 2)
                end
            end
        end
    push:finish()
end
