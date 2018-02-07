Face = {};
Face.metaTable = {};
Face.metaTable.__index = Face;
Face.mood = 1.5
Face.moodStep = 0.1
Face.time = 0
Face.frame = 0
Face.frameDuration = 0.33 -- In seconds.

Face.graphics = {}
Face.graphics[5] = {
    love.graphics.newImage("assets/5c.jpg"),
    love.graphics.newImage("assets/5d.jpg"),
    love.graphics.newImage("assets/5e.jpg"),
    love.graphics.newImage("assets/5f.jpg"),

}
Face.graphics[4] = {
    love.graphics.newImage("assets/4a.jpg"),
    love.graphics.newImage("assets/4b.jpg")
}
Face.graphics[3] = {
    love.graphics.newImage("assets/3a.jpg"),
    love.graphics.newImage("assets/3b.jpg"),
    love.graphics.newImage("assets/3c.jpg")

}
Face.graphics[2] = {
    love.graphics.newImage("assets/2a.jpg"),
    love.graphics.newImage("assets/2b.jpg"),
    love.graphics.newImage("assets/2c.jpg")
}
Face.graphics[1] = {
    love.graphics.newImage("assets/1b.jpg"),
    love.graphics.newImage("assets/1c.jpg"),
    love.graphics.newImage("assets/1d.jpg"),
    love.graphics.newImage("assets/1e.jpg")
}

function Face:new()
    local instance = {};
    setmetatable(instance, self.metaTable);
    table.insert(objects.drawable, instance);
    instance:updateFace(math.floor(instance.mood))
    return instance;
end

function Face:draw()

    local graphic = self.graphic[self.frame + 1]
    local screenCenter = {world.screen.width/2, world.screen.height/2};
    local imageCenter  = {graphic:getWidth()/2, graphic:getHeight()/2};

    love.graphics.setColor(0xff, 0xff, 0xff, 0xff)
    love.graphics.draw(graphic, screenCenter[1] - imageCenter[1], screenCenter[2] - imageCenter[2]);
end

function Face:decreaseMood()
    local oldMood = math.floor(self.mood)
    self.mood = self.mood - self.moodStep
    local newMood = math.floor(self.mood)
    if oldMood ~= newMood then
        self:updateFace(newMood)
    end
    if self.mood < 1 then
        currentState = state.gameOver
    end
end

function Face:increaseMood()
    if self.mood < 5 then
        local oldMood = math.floor(self.mood)
        self.mood = self.mood + self.moodStep
        local newMood = math.floor(self.mood)
        if oldMood ~= newMood then
            self:updateFace(newMood)
        end
    end
end

function Face:updateFace(mood)
    self.graphic = self.graphics[mood] or self.graphics[1]
    self.frame = 0
    playSong(mood)
end

function Face:update(dt)
    self.time = self.time + dt / self.frameDuration
    self.frame = math.floor(self.time) % #self.graphic
end
