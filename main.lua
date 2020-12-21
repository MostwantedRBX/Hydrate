Hydrate = LibStub("AceAddon-3.0"):NewAddon("Hydrate!", "AceConsole-3.0", "AceEvent-3.0")

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
        open = {
            name = "Do It",
            type = "execute",
            func = function()InterfaceOptionsFrame_OpenToCategory("Hydrate!") InterfaceOptionsFrame_OpenToCategory("Hydrate!")end,
        },
    },
}



function Hydrate:OnInitialize()
    self.RegisterChatCommand("hy","ChatCommand")
    self.RegisterChatCommand("hydrate","ChatCommand")

    LibStub("AceConfig-3.0"):RegisterOptionsTable("Hydrate!", options, {"hydrate","hy"})
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Hydrate!","Hydrate!")


    -- Hydrate.showInChat = false
    -- Hydrate.showOnScreen = true
    Hydrate.message = "Make sure to Hydrate!"
end

function Hydrate:OnEnable()

end

 
function Hydrate:OnDisable()

end

function Hydrate:ChatCommand(input) -- trying to debug this
    self:Print(self.message)
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    --[[if not input or input:trim() == "" then
        --InterfaceOptionsFrame_OpenToCategory("Hydrate!")
    elseif input then
        --InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("hy", "Hydrate!", input)
    end]]
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

