Face = {};
Face.metaTable = {};
Face.metaTable.__index = Face;
Face.mood = 5
Face.time = 0
Face.frame = 0
Face.frameDuration = 0.33 -- In seconds.

Face.graphics = {}
Face.graphics.great = { 
    love.graphics.newImage("assets/5c.jpg"), 
    love.graphics.newImage("assets/5d.jpg"), 
    love.graphics.newImage("assets/5e.jpg"), 
    love.graphics.newImage("assets/5f.jpg"), 
    
}
Face.graphics.good = {
    love.graphics.newImage("assets/4a.jpg"),
    love.graphics.newImage("assets/4b.jpg")
}
Face.graphics.ok = { 
    love.graphics.newImage("assets/3a.jpg"),
    love.graphics.newImage("assets/3b.jpg"),
    love.graphics.newImage("assets/3c.jpg") 
    
}
Face.graphics.default = { 
    love.graphics.newImage("assets/2a.jpg"),
    love.graphics.newImage("assets/2b.jpg"), 
    love.graphics.newImage("assets/2c.jpg")     
}
Face.graphics.meh = { 
    love.graphics.newImage("assets/1b.jpg"),
    love.graphics.newImage("assets/1c.jpg"),
    love.graphics.newImage("assets/1d.jpg"), 
    love.graphics.newImage("assets/1e.jpg") 
}
Face.graphics.bad = { love.graphics.newImage("assets/images/face_sad.png") }
Face.graphics.crap = { love.graphics.newImage("assets/images/face_horrible.png") }

function Face:new()
    local instance = {};
    setmetatable(instance, self.metaTable);
    table.insert(objects.drawable, instance);
    instance:updateFace()
    return instance;
end

function Face:draw()
    local graphic = self.graphic[self.frame + 1]
    local screenCenter = {world.screen.width/2, world.screen.height/2};
    local imageCenter  = {graphic:getWidth()/2, graphic:getHeight()/2};

    love.graphics.draw(graphic, screenCenter[1] - imageCenter[1], screenCenter[2] - imageCenter[2]);
end

function Face:decreaseMood()
    self.mood = self.mood - 1
    if self.mood == 1 then
        currentState = state.gameOver
    end
    self:updateFace()
end

function Face:increaseMood()
    if self.mood < 7 then
        self.mood = self.mood + 1
        self:updateFace()
    end
end

function Face:updateFace(dt)
    if self.mood == 7 then
      self.graphic = self.graphics.great
    end
    if self.mood == 6 then
      self.graphic = self.graphics.good
    end
    if self.mood == 5 then
      self.graphic = self.graphics.ok
    end
    if self.mood == 4 then
      self.graphic = self.graphics.default
    end
    if self.mood == 3 then
      self.graphic = self.graphics.meh
    end
    if self.mood == 2 then
      self.graphic = self.graphics.bad
    end
    if self.mood == 1 then
      self.graphic = self.graphics.crap
    end
    self.frame = 0
end

function Face:update(dt)
    self.time = self.time + dt / self.frameDuration
    self.frame = math.floor(self.time) % #self.graphic
end