
require("face");
require("player")
require("callbacks")
require("coin")

function lerp(a, b, amount)
    local result = a + amount * (b - a)
    return result
end

function init(windowWidth, windowHeight)

    state = {}
      state.begin = 0x01
      state.inProgress = 0x02
      state.gameOver = 0x03

    currentState = state.begin

    -- init main stuff
    world = {};

    world.meter = 64;
    world.gravity = 11;
    world.world = love.physics.newWorld(0, world.gravity * world.meter, true);
                  love.physics.setMeter(world.meter);

    world.world:setCallbacks(
        callbacks.beginContact,
        callbacks.endContact,
        callbacks.preSolve,
        callbacks.postSolve)

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

    wave = {}
    table.insert(wave, world.screen.height / 2)

    Coin:new(world.screen.width, world.screen.height / 2)

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

function nextCoinHeight()
    if #wave == 1 then
        local amplitude = world.screen.height * 0.4
        local next = world.screen.height/2 + math.random(-amplitude, amplitude)
        for i=1,10 do
          table.insert(wave, lerp(wave[1], next, i/10))
        end
    end
    return table.remove(wave, 1)
end

function love.load()
    init(800, 600);

    Player:new();

    Face:new();

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


function love.update(dt)
    --if nextCoin > 0.35 then
    --  Coin:new(800, nextCoinHeight())
    --  nextCoin = 0
    --end

    if currentState == state.begin then
        if love.keyboard.isDown("space") then
            currentState = state.inProgress
        end
    end

    if currentState == state.inProgress then
        world.world:update(dt)
        objects.player:update();
    end

    if currentState == state.gameOver then
        -- Do nothing; player is stuck.
    end
end

function love.draw()
    drawBlocks()
    -- love.graphics.setColor(0x00, 0xff, 0x00, 0xff)
    -- drawWave(wave)

    love.graphics.setColor(0xff, 0xff, 0xff, 0xff)
    for i,v in ipairs(objects.drawable) do
        v:draw()
    end

    love.graphics.setColor(0xff, 0xff, 0xff, 0xff)

    if currentState == state.begin then
        love.graphics.print("Press space to start.")
    end
    if currentState == state.gameOver then
        love.graphics.print("Game over! You lose.")
    end
end
