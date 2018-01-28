Player = {};

Player.metaTable = {};
Player.metaTable.__index = Player;

Player.radius = 30;

Player.states = {};
Player.state = "idle";
Player.force = -2400
Player.offset = 140

function Player:new()
    local instance = {};
    setmetatable(instance, self.metaTable);

    local x = instance.offset
    local y = world.screen.height / 2

    instance.body = love.physics.newBody(world.world, x, y, "dynamic");
    instance.shape = love.physics.newCircleShape(instance.radius);
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1);
    instance.fixture:setRestitution(0.3);
    instance.fixture:setUserData(instance);

    instance.states = {
        ["idle"] = function()
            if love.keyboard.isDown("space") then
                instance.state = "jetpack";
            end
        end,
        ["jetpack"] = function()
            instance.body:applyForce(0, instance.force);
            if not love.keyboard.isDown("space") then
                instance.state = "idle";
            end
        end
    };

    table.insert(objects.drawable, instance);

    return instance;
end

function Player:draw()
    local x, y = self.body:getPosition();


    love.graphics.setColor(0x00, 0x00, 0x00)
    love.graphics.line(0, world.screen.height/2, x, y)
    love.graphics.setColor(193, 47, 14);
    love.graphics.circle("fill", x, y, self.radius);
    love.graphics.setColor(255, 255, 255);
end

function Player:update()
    local x, y = self.body:getPosition();
    local yPercentage = y / world.screen.height
    self.body:setX(math.sin(yPercentage * math.pi) * self.offset)

    self.states[self.state]();
end
