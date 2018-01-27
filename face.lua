Face = {};

Face.metaTable = {};
Face.metaTable.__index = Face;

Face.graphic = love.graphics.newImage("assets/face_normal.png");

function Face:new()
    local instance = {};

    setmetatable(instance, self.metaTable);

    instance.states = {
        ["great"] = function()
            instance.graphic = love.graphics.newImage("assets/face_amazing.png");
        end,
        ["good"] = function()
            instance.graphic = love.graphics.newImage("assets/face_happy.png");
        end,
        ["ok"] = function()
            instance.graphic = love.graphics.newImage("assets/face_okay.png");
        end,
        ["default"] = function()
            instance.graphic = love.graphics.newImage("assets/face_normal.png");
        end,
        ["meh"] = function()
            instance.graphic = love.graphics.newImage("assets/face_meh.png");
        end,
        ["bad"] = function()
            instance.graphic = love.graphics.newImage("assets/face_sad.png");
        end,
        ["crap"] = function()
            instance.graphic = love.graphics.newImage("assets/face_horrible.png");
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