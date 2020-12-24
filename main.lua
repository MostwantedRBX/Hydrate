Hydrate = LibStub("AceAddon-3.0"):NewAddon("Hydrate!", "AceConsole-3.0", "AceEvent-3.0")

reminderDelay = 45
drank = false
UpdateInterval = 1
waitingForAnimation = false
defaultOptions = {
    -- nothing yet, working on AceDB stuff
}

local options = {
    name = "Hydrate!",
    handler = Hydrate,
    type = 'group',
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "Waht to change it to.",
            usage = "<Your message>",
            get = "GetMessage",
            set = "SetMessage",
        },
        showInChat = {
            type = "toggle",
            name = "Show in Chat",
            desc = "Toggles the display of the message in the chat window.",
            get = "IsShowInChat",
            set = "ToggleShowInChat",
        },
        showOnScreen = {
            type = "toggle",
            name = "Show on Screen",
            desc = "Toggles the display of the message on the screen.",
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen",
        },
    },
}

function Hydrate_printMSG(msg,color)
    local c = color
    if not c then --if no color is provided, then default to this one... it may be useful later.
        c = "cff00ccff"
    end
    DEFAULT_CHAT_FRAME:AddMessage("|"..c.."Hydrate: " .. msg.."|r", 1, 1, 1);
end

local waitTable = {};
local waitFrame = nil;
function Hydrate_Wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
end

local debounce = false; -- Debounce to prevent multiple clicks; I can't supply a temp function to the wait command or I would.
function DebounceHandler(bool)
    debounce = bool
end
function NoLongerWaiting()
    waitingForAnimation = false
end

function ShakeThisWay(f,way)
    -- Interestingly, this bugs out if you try and move the icon too far up on your screen or too far to the side... 
    -- "Hydrate\main.lua:84: Action[SetPoint] failed because[SetPoint would result in anchor family connection]: attempted from: <unnamed>:SetPoint."
    local p,rT,rP,xOf,yOf = f:GetPoint()
    if way == "up" and f then
        f:SetParent(UIParent)
        f:SetPoint("CENTER",xOf,yOf+1)
    elseif f and way == "down" then
        f:SetParent(UIParent)
        f:SetPoint("CENTER",xOf,yOf-1)
    end
end

local function ShakeAnimation(f)
    if waitingForAnimation == false then
        waitingForAnimation = true
        for i=0,.5,.05 do
            Hydrate_Wait(i, ShakeThisWay,f,"up")
        end
        for i=.5,1.05,.05 do
            Hydrate_Wait(i, ShakeThisWay,f,"down")
        end
        Hydrate_Wait(1.05, SetDelay, "waitingForAnimation")
        --[[for i=1,1.15,.05 do
            Hydrate_Wait(i, ShakeThisWay,f,"up")
        end]]
    end
end

function SetDelay(x)
    if x == "waitingForAnimation" then
        waitingForAnimation = false
    elseif x == "drank" then
        drank = false
    end
end

function Hydrate:OnInitialize()
    self:RegisterChatCommand("hy","ChatCommand")
    self:RegisterChatCommand("hydrate","ChatCommand")
    self:RegisterChatCommand("hy!","ChatCommand") -- Need to dicide whether or not to use Ace's options table with these.

    LibStub("AceConfig-3.0"):RegisterOptionsTable("Hydrate!", options, {"hydrate","hy"})
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Hydrate!","Hydrate!")


    -- Hydrate.showInChat = false
    -- Hydrate.showOnScreen = true
    Hydrate.message = "Make sure to Hydrate!"
end

function Hydrate:OnEnable()
    local WaterBottle = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
    WaterBottle:SetPoint("CENTER")
    WaterBottle:SetMovable(true)
    WaterBottle:EnableMouse(true)
    WaterBottle:RegisterForDrag("LeftButton")
    WaterBottle:SetScript("OnDragStart", WaterBottle.StartMoving)
    WaterBottle:SetScript("OnDragStop", WaterBottle.StopMovingOrSizing) 
    WaterBottle:SetSize(64, 64)
    WaterBottle:SetText("")
    local tex = WaterBottle:CreateTexture()
    tex:SetAllPoints(WaterBottle)
    tex:SetTexture("Interface\\ICONS\\INV_Drink_20") -- Todo: Add my own water bottle texture
    WaterBottle:SetScript("OnClick", function(self, button)
        if not debounce then
            debounce = true
            drank = true
            -- this delay will be changeable in settings, but will default to once every 45m going off as thats the reccomended delay between drinking.
            Hydrate_Wait(reminderDelay,Hydrate_printMSG,"Hydrate yo self!")
            Hydrate_Wait(5,DebounceHandler, false)
            
        end
    end)
    TimeSinceLastUpdate = 0
    WaterBottle:SetScript("OnUpdate", function(self, elapsed)
        TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed; 	
        if (TimeSinceLastUpdate > UpdateInterval) then
            if not drank and not waitingForAnimation then
                Hydrate_Wait(1.05,ShakeAnimation,WaterBottle)
                Hydrate_Wait(reminderDelay,SetDelay,"drank")
            end
          TimeSinceLastUpdate = 0;
        end

    end)
    --ani = AnimationGroup:CreateAnimation("Rotation",nil) -- ahhhhhhhhhhhhhhhhh
end

function Hydrate:OnDisable()

end

function Hydrate:ChatCommand(input)
    self:Print("Opening options...")
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
end
-- Don't need these yet.
-- function Hydrate:IsShowInChat(info)
--     return self.showInChat
-- end

-- function Hydrate:ToggleShowInChat(info, value)
--     self.showInChat = value
-- end

-- function Hydrate:IsShowOnScreen(info)
--     return self.showOnScreen
-- end

-- function Hydrate:ToggleShowOnScreen(info, value)
--     self.showOnScreen = value
-- end

function Hydrate:GetMessage(info)
    return self.message
end

function Hydrate:SetMessage(info,newValue)
    self.message = newValue
end

--[[
    Psudo Code for triggering WaterBottle Animation to help my brain

    If user hasn't drank within the delay timer then
        send signal to function that handles animation triggering
            check if the function is already triggered by using variable
                if not then trigger animation until bottle is clicked and set the variable regulating trigger-age
                    reset the cooldown on the bottle shaking animation
                        repeat
    

]]