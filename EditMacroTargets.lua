-- ---------------------------------
-- Bulk Edit Targets
-- Originally by omadasala

SLASH_EditMacroTargets1 = "/emt";
SLASH_EditMacroTargets2 = "/editmacrotargets";


-- TODOS
-- configure help tips
-- refactor/cleanup

local LibOO = LibStub("LibOO-1.0", true);
local EMT = CreateFrame("Frame", "EMT_TargetFrame", UIParent, "BasicFrameTemplate");
local INITIAL_MACRO_INDEX = 1;
_G.EMT = LibStub("AceAddon-3.0"):NewAddon(EMT, "EditMacroTargets", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0", "AceComm-3.0", "AceSerializer-3.0");
_G.EditMacroTargets = _G.EMT;
local EMT = _G.EMT;
EMT.locked = false;

local function setTextColor(text, color)
    local textColor = color or "8000ffff";
    return WrapTextInColorCode(text, textColor);
end
local header = setTextColor("EditMacroTargets: ");
function EMT:Print(msg)
    return print(header .. msg);
end

function EMT:ValidateText(text)
    return text ~= nil and text ~= "";
end

function EMT:UpdateMacro(from, to, previousIndex)
    if (MacroFrame ~= nil and MacroFrame:IsShown()) then HideUIPanel(MacroFrame);end
    if from == "" then EMT:Print("the target name you are changing to is missing.");end
    if to == "" then return EMT:Print("the target name you are changing from is missing.");end

    currentIndex = previousIndex or INITIAL_MACRO_INDEX;
    name, icon, body, isLocal = GetMacroInfo(currentIndex);

    at = string.gsub("@name", "name", from);
    target = string.gsub("target=name", "name", from);


    if body:find(at) or body:find(target) then
        macroText = string.gsub(body, from, to);
        EditMacro(currentIndex, name, nil, macroText);
    end

    local nextIndex = currentIndex + 1;

    if previousIndex ~= nil then
        nextIndex = previousIndex + 1;
    end

    nextName, nextIcon, nextBody, nextIsLocal = GetMacroInfo(nextIndex);

    if nextName ~= nil then
        EMT:UpdateMacro(from, to, nextIndex);
    else
        HideUIPanel(EMT);
        EMT:Print("Macros have been updated!");
    end
end

function EMT:CreateChildFrames()
    EMT:SetSize(250, 300);
    EMT:SetPoint("center", UIParent, "center");
    EMT:SetFrameLevel(100)

    EMT.title = EMT:CreateFontString(nil, "OVERLAY");
    EMT.title:SetFontObject("GameFontNormal");
    EMT.title:SetPoint("center", EMT.TitleBg, "center", 5, 0);
    EMT.title:SetText("Bulk Edit Target Options");

    EMT.saveButton = CreateFrame("Button", "saveButton", EMT, "EMT_ButtonTemplate");
    EMT.saveButton:SetText("Save");
    EMT.saveButton:SetScript("OnClick", function(self)
        from = EMT.editTargetFrom:GetText();
        to = EMT.editTargetTo:GetText();
        EMT:UpdateMacro(from, to);
    end)

    EMT.editTargetFrom = CreateFrame("EditBox", "EMT_editTargetFrom", EMT, "EMT_EditBoxTemplate");
    EMT.editTargetFrom.Label = EMT.editTargetFrom:CreateFontString(nil , "Background", "GameTooltipText");
    EMT.editTargetFrom.Label:SetText("The target name to change from");
    EMT.editTargetFrom.Label:SetPoint("left", EMT.editTargetFrom, "left", 0, 30);

    EMT.editTargetTo = CreateFrame("EditBox", "EMT_editTargetTo", EMT, "EMT_EditBoxTemplate");
    EMT.editTargetTo:SetPoint("center", EMT,  "center", 0, -10);
    EMT.editTargetTo.Label = EMT.editTargetTo:CreateFontString(nil , "Background", "GameTooltipText");
    EMT.editTargetTo.Label:SetText("The target name to change to");
    EMT.editTargetTo.Label:SetPoint("left", EMT.editTargetTo, "left", 0, 30);
end

EMT:RegisterEvent("PLAYER_LOGIN", function()
    HideUIPanel(EMT);
    EMT:CreateChildFrames();
end)

EMT:RegisterEvent("PLAYER_REGEN_DISABLED", function()
    EMT.locked = true;
end)

EMT:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    EMT.locked = false;
end)

function EMT:ToggleDisplay()
    if (EMT:IsVisible()) then
        HideUIPanel(EMT);
    else
        ShowUIPanel(EMT);
    end
end

SlashCmdList["EditMacroTargets"] = function(msg)
    if UnitIsDeadOrGhost("player") or EMT.locked then
        EMT:Print("EMT is locked while player is dead or in combat.");
    end

    if msg == "" then
        EMT:ToggleDisplay();
    elseif from ~= "" and to ~= "" then
        local from, to, extra = strsplit(" ", msg, 3);

        if extra ~= "" then
            EMT:Print(string.gsub("extra arguments entered: $", "$", extra));
            EMT.editTargetFrom:SetText(from);
            EMT.editTargetTo:SetText(to);
    
            ShowUIPanel(EMT);
        else
            EMT:UpdateMacro(from, to);
        end
    else
        EMT:Print("the target player name you are changing to is missing.");
        EMT.editTargetFrom:SetText(from);
        ShowUIPanel(EMT);
    end
end
