require("coin")

function lerp(a, b, amount)
    local result = a + amount * (b - a)
    return result
end

function slerp(a, b, amount)
    local factor = (0.5 - math.cos(math.pi * amount) * 0.5);
    return a * (1.0 - factor) + b * factor
end

Wave = {}

  Wave.metaTable = {}
  Wave.metaTable.__index = Wave

  Wave.heights = {}
  Wave.smoothness = 5
  Wave.min = 0
  Wave.max = 0
  Wave.timer = {}
  Wave.timer.interval = 0.5
  Wave.timer.progress = 0
  Wave.timer.count = 0

function Wave:new(min, max)
    local instance = {}
      setmetatable(instance, self.metaTable)

    instance.min = min
    instance.max = max

    table.insert(instance.heights, min + (max - min) / 2)

    return instance
end

function Wave:generate(current)
    local next = math.random(self.min, self.max)
    for i = 1, self.smoothness do
      table.insert(self.heights, slerp(current, next, i/self.smoothness))
    end
end

function Wave:pop()
    local current = table.remove(self.heights, 1)
    if #self.heights == 0 then
        self:generate(current)
    end
    return current
end

function Wave:addPoint()
    local point = {}
    point.x = world.screen.width + 100
    point.y = self:pop()

    if currentState == state.inProgress then
        Coin:new(point.x, point.y)
    end
end

function Wave:update(dt)
    self.timer.progress = self.timer.progress + dt * timeMultiplier()
    while self.timer.progress > self.timer.interval do
        self.timer.progress = self.timer.progress - self.timer.interval
        self.timer.count = self.timer.count + 1
        self:addPoint()
    end
end
