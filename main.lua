require("coin")

function linearInterpolation(a, b, amount)
    local result = a + amount * (b - a)
    return result
end

function interpolate(a, b, amount)
    return linearInterpolation(a, b, amount)
end

function init(windowWidth, windowHeight)

    callbacks = {}
    function callbacks.beginContact(a, b, collision)
      local au = a:getUserData()
      local bu = b:getUserData()
      if au and au.beginContact then au:beginContact(bu) end
      if bu and bu.beginContact then bu:beginContact(au) end
    end

    function callbacks.endContact(a, b, collision)
      local au = a:getUserData()
      local bu = b:getUserData()
      if au and au.endContact then au:endContact(bu) end
      if bu and bu.endContact then bu:endContact(au) end
    end

    function callbacks.preSolve(a, b, collision)
      local au = a:getUserData()
      local bu = b:getUserData()
      if au and au.preSolve then au:preSolve(bu) end
      if bu and bu.preSolve then bu:preSolve(au) end
    end

    function callbacks.postSolve(a, b, collision, normalImpulse, tangentImpulse)

    end

    -- init main stuff
    world = {};

    world.meter = 64;
    world.gravity = 9;
    world.world = love.physics.newWorld(0, world.gravity * world.meter, true);
                  love.physics.setMeter(world.meter);

    world.world:setCallbacks(callbacks.beginContact, callbacks.endContact, callbacks.preSolve, callbacks.postSolve)

    world.screen = {};
    world.screen.width  = windowWidth or 320;
    world.screen.height = windowHeight or 320;
    world.screen.x1     = 0;
    world.screen.x2     = world.screen.width;
    world.screen.y1     = 0;
    world.screen.y2     = world.screen.height;

    -- init object pool
    objects = {};
    objects.blocks  = {};
    objects.hazards = {};
    objects.points  = {};
    objects.player  = {};
    objects.drawable = {}

    Coin:new(world.screen.width, world.screen.height / 2)

    --preliminary height code (hh)
    local rawHeights = {}
    for i=1,14 do
        table.insert(rawHeights, math.random(0, world.screen.height))
    end
    wave = {}
    for i=1,13 do
        local a = rawHeights[i + 0]
        local b = rawHeights[i + 1]
        for j=0,9 do
          table.insert(wave, linearInterpolation(a, b, j/10))
        end
    end

    --initial graphics setup
    love.window.setMode(world.screen.width, world.screen.height);

    nextCoin = 0
end

function newBlock(x1, y1, x2, y2, color, type)
    color   = color or {255, 255, 255};
    type = type or "static"

    local block   = {};
    local width   = math.abs(x1 - x2);
    local height  = math.abs(y1 - y2);
    local midX = (x1 + x2) / 2;
    local midY = (y1 + y2) / 2;

    block.body    = love.physics.newBody(world.world, midX, midY, type);
    block.shape   = love.physics.newRectangleShape(width, height);
    block.fixture = love.physics.newFixture(block.body, block.shape);

    block.color   = {};
    block.color.r = color[1];
    block.color.g = color[2];
    block.color.b = color[3];

    return block;
end

function drawBlocks()
    table.foreach(objects.blocks, function(k, v)
        local block = v;
        love.graphics.setColor(block.color.r, block.color.g, block.color.b);
        love.graphics.polygon("fill", block.body:getWorldPoints(block.shape:getPoints()));
    end);
end

function spawnPlayer(x, y, r, state)
    x = x or 0;
    y = y or 0;
    r = r or 14;
    state = state or "idle";

    objects.player = {};
    objects.player.body    = love.physics.newBody(world.world, x + r, y - r, "dynamic");
    objects.player.shape   = love.physics.newCircleShape(r);
    objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1);
    objects.player.fixture:setRestitution(0.25);
    objects.player.fixture:setUserData(objects.player);

    objects.player.state   = state;
    objects.player.states  = {
        ["idle"] = function()
            if love.keyboard.isDown("space") then
                objects.player.state = "jetpack";
            end
        end,
        ["jetpack"] = function()
            objects.player.body:applyForce(0, -350);
            if not love.keyboard.isDown("space") then
                objects.player.state = "idle";
            end
        end
    };

    objects.player.update  = function()
        objects.player.states[objects.player.state]();
    end
end

function drawPlayer()
    love.graphics.setColor(193, 47, 14)
    love.graphics.circle("fill",
        objects.player.body:getX(),
        objects.player.body:getY(),
        objects.player.shape:getRadius());
end

function drawWave(obj)
    local gap = 15
    local xOffset = gap
    for i,v in ipairs(obj) do
        love.graphics.circle((i-1) % 10 == 0 and "fill" or "line", xOffset, v, 5)
        xOffset = xOffset + gap
    end
    xOffset = gap
    for i=1,#obj-1 do
        local curr=obj[i+0]
        local next=obj[i+1]
        love.graphics.line(xOffset, curr, xOffset+gap, next)
        xOffset = xOffset + gap
    end
end

function love.load()
    init(800, 600);
    spawnPlayer(world.screen.x1 + 32, world.screen.y2 - 40);

    table.insert(objects.blocks, newBlock(world.screen.x1,
                                          world.screen.y1,
                                          world.screen.x2,
                                          world.screen.y1 + 16,
                                          {0, 255, 0}));
    table.insert(objects.blocks, newBlock(world.screen.x1,
                                          world.screen.y2,
                                          world.screen.x2,
                                          world.screen.y2 - 16,
                                          {0, 255, 0}));
end

time=0
function love.update(dt)
    time = time + dt
    nextCoin = nextCoin + dt
    if nextCoin > 0.35 then
      Coin:new(800, 300 + math.sin(time) * 150)
      nextCoin = 0
    end
    world.world:update(dt)
    objects.player.update();
end

function love.draw()
    drawBlocks()
    drawPlayer()
    love.graphics.setColor(0, 255, 0, 255)
    drawWave(wave)
    love.graphics.setColor(255, 255, 255, 255)

    for i,v in ipairs(objects.drawable) do
      v:draw()
    end
end
