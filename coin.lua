Coin = {}

  Coin.metaTable = {}
    Coin.metaTable.__index = Coin

  Coin.radius = 15
  Coin.speed = 200

  Coin.colour = {0xff, 0x00, 0x00}

  function Coin:new(x, y)

    local instance = {}
      setmetatable(instance, self.metaTable)

      instance.body = love.physics.newBody(world.world, x, y, "kinematic")
      instance.shape = love.physics.newCircleShape(instance.radius)
      instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
      instance.fixture:setSensor(true)
      instance.fixture:setUserData(instance)

      instance.body:setLinearVelocity(-instance.speed, 0)

      table.insert(objects.drawable, instance)

    return instance;
  end

  function Coin:draw()
      local x, y = self.body:getPosition()
      love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], 0xff)
      love.graphics.circle("fill", x, y, self.radius)
  end

  function Coin:beginContact(other)
      if other == objects.goal then
          objects.face:decreaseMood()
      end
      if other == objects.player then
          objects.face:increaseMood()
      end
      if other == objects.player or other == objects.goal then
        self.body:destroy()
        for key, value in pairs(objects.drawable) do
          if value == self then
              table.remove(objects.drawable, key)
              break
            end
        end
      end
  end
