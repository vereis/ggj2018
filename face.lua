Face = {};
Face.metaTable = {};
Face.metaTable.__index = Face;
Face.mood = 5
Face.time = 0
Face.frame = 0
Face.frameDuration = 0.33 -- In seconds.

Face.graphics = {}
Face.graphics.great = {
   love.graphics.newImage("assets/images/face_amazing.png")
    --love.graphics.newImage("assets/5a.png"),
    --love.graphics.newImage("assets/5b.png")
}
Face.graphics.good = {
   love.graphics.newImage("assets/images/face_happy.png")
     --love.graphics.newImage("assets/4a.png"),
     --love.graphics.newImage("assets/4b.png")
}
Face.graphics.ok = {
   love.graphics.newImage("assets/images/face_okay.png")
    --love.graphics.newImage("assets/3a.png"),
    --love.graphics.newImage("assets/3b.png")
}
Face.graphics.default = { love.graphics.newImage("assets/images/face_normal.png") }
Face.graphics.meh = { love.graphics.newImage("assets/images/face_meh.png") }
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
