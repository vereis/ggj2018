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
