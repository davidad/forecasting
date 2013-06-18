local binary_heap = {}
local floor = require("math").floor

function binary_heap:new(x)
    x = x or {}
    x.__index = self
    x.__call = function(...) return x.new(...) end
    setmetatable(x,x)
    x.data = nil
    x.score = nil
    x.parent = nil
    x.fill = x
    return x
end

function binary_heap:push(data,score)
    local function swap(i,x)
        if(i>1) then
            local ip = math.floor(i/2)
            local xp = self[ip]
            if(xp.score < x.score) then
                self[i] = xp
                swap(ip,x)
                return
            end
        end
        self[i] = x
    end
    swap(#self+1,{data=data,score=score})
    return self
end

function binary_heap:pop()
    local function swap(i)
        local i1, i2 = 2*i, 2*i+1
        local largest = i
        if(i1 <= #self and self[i1].score > self[largest].score) then
            largest = i1
        end
        if(i2 <= #self and self[i2].score > self[largest].score) then
            largest = i2
        end
        if(largest ~= i) then
            local swp = self[i]
            self[i] = self[largest]
            self[largest] = swp
            swap(largest)
        end
    end
    local res = self[1]
    self[1] = self[#self]
    self[#self] = nil
    swap(1)
    if(res) then
        return res.data, res.score
    else
        return nil, nil
    end
end

return binary_heap
