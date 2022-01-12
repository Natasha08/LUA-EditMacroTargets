-- ---------------------------------
-- Bulk Edit Targets
-- Originally by cptsamcarter

SLASH_BulkEditMacroTargets1 = "/bet";

local function UpdateMacro(from, to, previousIndex)
    currentIndex = previousIndex;
    name, icon, body, isLocal = GetMacroInfo(currentIndex);

    at = string.gsub("@name", "name", from)
    target = string.gsub("target=name", "name", to)


    if string.find(body, at) or string.find(body, target) then
        macroText = string.gsub(body, from, to);
        EditMacro(currentIndex, name, nil, macroText);
    end

    local nextIndex = currentIndex + 1;

    if previousIndex ~= nil then
        nextIndex = previousIndex + 1;
    end

    nextName, nextIcon, nextBody, nextIsLocal = GetMacroInfo(nextIndex);

    if nextName ~= nil then
        UpdateMacro(from , to, nextIndex);
    end
end

SlashCmdList["BulkEditMacroTargets"] = function(msg)
    local command, rest = msg:match("^(%S*)%s*(.-)$");

    if command == "replace" then
        local from, to = rest:match("^(%S*)%s*(.-)$");
        -- is there a way to determine what the starting index for macros is
        -- or a way to get a list of them to map over?
        UpdateMacro(from, to, 121);
        print("Bulk Edit Macro Targets: Macros have been updated!");
    end

    if msg == "" then
        local UIConfig = CreateFrame("Frame", "BET_TargetFrame", UIParent, "EtherealFrameTemplate");

        UIConfig:SetSize(300, 360);
        UIConfig:SetPoint("CENTER", UIParent, "CENTER");
        UIConfig:SetFrameLevel(100)

        UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
        UIConfig.title:SetFontObject("GameFontHighlight");
        UIConfig.title:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", 5, 0);
        UIConfig.title:SetText("Bulk Edit Target Options");

        UIConfig.editInput1 = CreateFrame("EditBox", "FromInput", UIConfig, "InputBoxTemplate");
        UIConfig.editInput1:SetPoint("LEFT", UIConfig, "TOP", -60, -100);
        UIConfig.editInput1:SetWidth(180);
        UIConfig.editInput1:SetHeight(400);
        UIConfig.editInput1:SetMovable(false);
        UIConfig.editInput1:SetAutoFocus(true);
        UIConfig.editInput1:SetMaxLetters(100);

        UIConfig.editInput2 = CreateFrame("EditBox", "ToInput", UIConfig, "InputBoxTemplate");
        UIConfig.editInput2:SetPoint("LEFT", UIConfig,  "TOP", -60, -130);
        UIConfig.editInput2:SetWidth(180);
        UIConfig.editInput2:SetHeight(400);
        UIConfig.editInput2:SetMovable(false);
        UIConfig.editInput2:SetAutoFocus(false);
        UIConfig.editInput2:SetMaxLetters(100);

        UIConfig.saveButton = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
        UIConfig.saveButton:SetPoint("CENTER", UIConfig, "Bottom", 0, 70);
        UIConfig.saveButton:SetSize(70, 30);
        UIConfig.saveButton:SetText("Save");
        UIConfig.saveButton:SetNormalFontObject("GameFontNormalLarge");
        UIConfig.saveButton:SetHighlightFontObject("GameFontHighlightLarge");
        UIConfig.saveButton:SetScript("OnClick", function(self)
            -- this event never fires
            print("IAMCLICKED")
        end)

    end
end
