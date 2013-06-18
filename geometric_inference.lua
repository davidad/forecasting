local Z = require("zdd")
local H = require("binary_heap")

local finite
local partition_strategies
local solve, midpoint, incr_decr
local subregion, subregion_not

local function measure(t)
    local A,P,Om = unpack(t)
    local precision = t.precision or 0.0005
    local h = H:new():push({r=Om:entire(),z=A},1.0)
    local unk_mass, true_mass = 1.0, 0.0
    local function push(x)
        h:push(x,P(x.r))
    end
    while(unk_mass>precision) do
        local i, mass = h:pop()
        local z,r = i.z,i.r
        z = z:evaluate(r)
        local in_A, n = z:truth(), z.root
        if(in_A==nil) then
            local partition = partition_strategies {
                c = n.c;
                function(v) return solve(n,v,r) end;
                function(v) return midpoint(r,v) end;
                function(v) return incr_decr(r,v) end;
                function(v) return r:any_partition(v) end;
            }
            if(partition._solved) then
                push{r=subregion(r,partition),z=partition._solved_zdd}
            else
                push{r=subregion(r,partition),z=z}
            end
            push{r=subregion_not(r,partition),z=z}
        else
            unk_mass = unk_mass - mass
            if(in_A) then
                true_mass = true_mass + mass
            end
        end
    end
end

local function partition_strategies(l)
    local partition=nil
    local function partition_strategies_(l,i)
        partition = choose_random_variables(l.c,l[i])
        if(partition) then
            return partition
        else
            return partition_strategies_(l,i+1)
        end
    end
    partition_strategies_(l,1)
    return partition
end

local function solve(n,v,r)
    local partition, result = n.c:solve(v,r)
    if(result==nil) then
        return nil
    else
        partition._solved=true
        if(result==true) then
            partition._solved_zdd = n[true]
        else
            partition._solved_zdd = n[false]
        end
        return partition
    end
end

local function midpoint(r)
    local x = r[v]
    local a,b=x.a,x.b
    if(a and finite(a) and b and finite(b)) then
        return {v,greater=(a+b)/2}
    end
    return nil
end

local function incr_decr(r,v)
    local x = r[v]
    local a,b=x.a,x.b
    if(a and b) then
        if(finite(a)) then
            return {v,lesser=a+1}
        elseif(finite(b)) then
            return {v,greater=b-1}
        end
    end
    return nil
end

local function subregion(r,p) return r:copy():intersect{p} end
local function subregion_not(r,p) return r:copy():intersect{p,invert=true} end

local function finite(z) return z > -math.huge and z < math.huge end
