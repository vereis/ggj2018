Face = {};

Face.metaTable = {};
Face.metaTable.__index = Face;

Face.graphic = love.graphics.newImage("assets/face_normal.png");

function Face:new()
    local instance = {};

    setmetatable(instance, self.metaTable);

    instance.graphics = {}
    instance.graphics.great = love.graphics.newImage("assets/face_amazing.png")
    instance.graphics.good = love.graphics.newImage("assets/face_happy.png")
    instance.graphics.ok = love.graphics.newImage("assets/face_okay.png")
    instance.graphics.default = love.graphics.newImage("assets/face_normal.png")
    instance.graphics.meh = love.graphics.newImage("assets/face_meh.png")
    instance.graphics.bad = love.graphics.newImage("assets/face_sad.png")
    instance.graphics.crap = love.graphics.newImage("assets/face_horrible.png")

    instance.states = {
        ["great"] = function()
            instance.graphic = instance.graphics.great
        end,
        ["good"] = function()
            instance.graphic = instance.graphics.good
        end,
        ["ok"] = function()
            instance.graphic = instance.graphics.ok
        end,
        ["default"] = function()
            instance.graphic = instance.graphics.default
        end,
        ["meh"] = function()
            instance.graphic = instance.graphics.meh
        end,
        ["bad"] = function()
            instance.graphic = instance.graphics.bad
        end,
        ["crap"] = function()
            instance.graphic = instance.graphics.crap
        end,
    };

    table.insert(objects.drawable, instance);
    objects.face = instance;

    return instance;
end

function Face:draw()
    local screenCenter = {world.screen.width/2, world.screen.height/2};
    local imageCenter  = {self.graphic:getWidth()/2, self.graphic:getHeight()/2};

    love.graphics.draw(self.graphic, screenCenter[1] - imageCenter[1], screenCenter[2] - imageCenter[2]);
end
