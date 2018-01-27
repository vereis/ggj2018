function init(windowWidth, windowHeight)
    -- init main stuff
    world = {};

    world.meter = 64;
    world.gravity = 9;
    world.world = love.physics.newWorld(0, world.gravity * world.meter, true);
                  love.physics.setMeter(world.meter);

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

    --initial graphics setup
    love.window.setMode(world.screen.width, world.screen.height);
end

function newBlock(x1, y1, x2, y2, color, canMove)
    canMove = canMove == false or "dynamic";
    color   = color or {255, 255, 255};

    local block   = {};
    local width   = math.abs(x1 - x2);
    local height  = math.abs(y1 - y2);
    local midX = (x1 + x2) / 2;
    local midY = (y1 + y2) / 2;

    block.body    = love.physics.newBody(world.world, midX, midY, canMove);
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

function love.load()
    init(480, 270);
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
      
function love.update(dt)
    world.world:update(dt)
    objects.player.update();
end

function love.draw()
    drawBlocks();
    drawPlayer();
end