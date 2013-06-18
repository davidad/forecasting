local serpent = require("serpent")
local M = {}
local Tech = {Tech = true}
M.Tech = Tech

function Tech:new(x)
    local x = x or {}
    x.__index = self
    x.__call = function(...) return x.new(...) end
    setmetatable(x,x)
    return x
end

local function flattening_combinator(Tech,name)
    M[Tech][name:gsub("_","",1):lower()] = function (self,x,k)
        local o = rawget(self,name) or {}
        o.__index=self
        local function comb_(x,k)
            if(type(x)=="boolean" or type(x)=="string") then
                o[#o+1]=x
            elseif(rawget(x,name)) then
                for i,v in ipairs(x[name]) do
                    o[#o+1]=v
                end
            elseif(x[Tech]==true) then
                o[#o+1]=x
            else
                for k,v in pairs(x) do
                    comb_(v,k)
                end
            end
        end
        comb_(x,k)
        self[name] = o
        return self
    end
end
flattening_combinator("Tech","_Any")
flattening_combinator("Tech","_All")

local function flattening_shorthand(Tech,comb,name)
    M[Tech][name] = function (self,x)
        local ret
        if(type(x)=="string" or type(x)=="boolean") then
            return x
        elseif(x[Tech]==true) then
            x.__index = self
            ret = x
        else
            local o
            o = self:new()
            for k,v in pairs(x) do
                if(v=="inherit") then
                    x[k]="_inherit_"..k
                end
            end
            for k,v in pairs(x) do
                if(type(k)=="string" and k:find("_def_")==1) then
                    o[k:sub(6)] = o[name](o,v)
                else
                    o[k] = o[name](o,v)
                    o[comb](o,o[k],k)
                end
            end
            ret = o
        end
        return ret:inherit()
    end
end
flattening_shorthand("Tech","any","taxonomy")
flattening_shorthand("Tech","all","process")

function Tech:inherit()
    local visited = {}
    local function _inherit(x)
        if(not visited[x]) then
            visited[x]=true
            for k,v in pairs(x) do
                if(type(v)=="string" and v:find("_inherit_")==1) then
                    x[k]=x.__index and x.__index[v:sub(10)] or v
                elseif(type(k)=="string" and k:find("_inherit_")==1) then
                    x[k:sub(10)]=x[k:sub(10)]
                end
            end
            for k,v in pairs(x) do
                if(type(x[k])=="table") then
                    _inherit(x[k])
                end
            end
        end
    end
    _inherit(self)
    return self
end

return M
