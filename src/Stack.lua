EffusionRaidAssistStack = CreateClass()

function EffusionRaidAssistStack.new(list)
    local self = setmetatable({}, EffusionRaidAssistStack)
    self.stack = list or {}
    return self
end

function EffusionRaidAssistStack:Push(item)
    self.stack[#self.stack + 1] = item
end

function EffusionRaidAssistStack:Pop()
    if #self.stack > 0 then
        return table.remove(self.stack, #self.stack)
    end
end

function EffusionRaidAssistStack:GetSize()
    return #self.stack
end