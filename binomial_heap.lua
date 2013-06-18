local binomial_heap = {}

function binomial_heap:new(x)
    x = x or {}
    x.__index = self
    x.__call = function(...) return x.new(...) end
    setmetatable(x,x)
    return x
end

function binomial_heap:push(d,p)
end

function binomial_heap:pop()
end
