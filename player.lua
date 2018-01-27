Player = {};

Player.metaTable = {};
Player.metaTable.__index = Player;

Player.radius = 30;

Player.states = {};
Player.state = "idle";

function Player:new(x, y)
    local instance = {};

    setmetatable(instance, self.metaTable);

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
            instance.body:applyForce(0, -1000);
            if not love.keyboard.isDown("space") then
                instance.state = "idle";
            end
        end
    };

    table.insert(objects.drawable, instance);
    objects.player = instance;

    return instance;
end

function Player:draw()
    local x, y = self.body:getPosition();
    love.graphics.setColor(193, 47, 14);
    love.graphics.circle("fill", x, y, self.radius);
end

function Player:update()
    self.states[self.state]();
end