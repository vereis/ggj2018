Coin = {}

  Coin.metaTable = {}
    Coin.metaTable.__index = Coin

  Coin.radius = 30
  Coin.speed = 200

  Coin.colour = {0xff, 0x00, 0x00}

  Coin.apperances = {}
  Coin.apperances[1] = love.graphics.newImage("assets/button1.png")
  Coin.apperances[2] = love.graphics.newImage("assets/button2.png")

  function Coin:new(x, y)

    local instance = {}
      setmetatable(instance, self.metaTable)

      instance.body = love.physics.newBody(world.world, x, y, "kinematic")
      instance.shape = love.physics.newCircleShape(instance.radius)
      instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
      instance.fixture:setSensor(true)
      instance.fixture:setUserData(instance)
      instance.apperance = instance.apperances[love.math.random(1, #instance.apperances)]

      instance.body:setLinearVelocity(-instance.speed * speedMultiplier(timeStep.total), 0)

      table.insert(objects.drawable, instance)

    return instance;
  end

  function Coin:draw()
      local x, y = self.body:getPosition()
      love.graphics.draw(self.apperance, x - self.radius, y - self.radius)
  end

  function Coin:beginContact(other)
      if other == objects.goal then
          objects.face:decreaseMood()
          self:playSound(coin.miss)
      end
      if other == objects.player then
          objects.face:increaseMood()
          self:playSound(coin.pickup)
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

  function Coin:playSound(sound)
	local index = love.math.random(1, #sound)
	local i
	for key, value in ipairs(sound[index]) do
		if not value:isPlaying() then
			i = value	
			break	
		end
	end
	if not i then
		i = sound[index][1]:clone()
		table.insert(sound[index], i)
	end
	i:setVolume(0.5)
	i:play()
  end
