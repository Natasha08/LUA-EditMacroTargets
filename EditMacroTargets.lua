-- ---------------------------------
-- Bulk Edit Targets
-- Originally by omadasala

SLASH_EditMacroTargets1 = "/emt";
SLASH_EditMacroTargets2 = "/editmacrotargets";


-- TODOS
-- if either from or to is empty display an error
  -- on button click
  -- when using the replace method
-- configure help tips
-- style user displayed messages and warnings
-- refactor/cleanup

local LibOO = LibStub("LibOO-1.0", true);
local EMT = CreateFrame("Frame", "EMT_TargetFrame", UIParent, "EtherealFrameTemplate");
local INITIAL_MACRO_INDEX = 1;
_G.EMT = LibStub("AceAddon-3.0"):NewAddon(EMT, "EditMacroTargets", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0", "AceComm-3.0", "AceSerializer-3.0");
_G.EditMacroTargets = _G.EMT;
local EMT = _G.EMT;
EMT.locked = false;

local function UpdateMacro(from, to, previousIndex)
    if (MacroFrame and MacroFrame:IsShown()) then HideUIPanel(MacroFrame);end
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
        UpdateMacro(from, to, nextIndex);
    else
        HideUIPanel(Modal);
        print("Bulk Edit Macro Targets: Macros have been updated!");
    end
end

local function DisplayModal()
    EMT:SetSize(300, 360);
    EMT:SetPoint("CENTER", UIParent, "CENTER");
    EMT:SetFrameLevel(100)

    EMT.title = EMT:CreateFontString(nil, "OVERLAY");
    EMT.title:SetFontObject("GameFontHighlight");
    EMT.title:SetPoint("CENTER", EMT.TitleBg, "CENTER", 5, 0);
    EMT.title:SetText("Bulk Edit Target Options");

    EMT.saveButton = CreateFrame("Button", "saveButton", EMT, "EMT_ButtonTemplate");
    EMT.saveButton:SetPoint("CENTER", EMT, "Bottom", 0, 70);
    EMT.saveButton:SetSize(70, 30);
    EMT.saveButton:SetText("Save");
    EMT.saveButton:SetNormalFontObject("GameFontNormalLarge");
    EMT.saveButton:SetHighlightFontObject("GameFontHighlightLarge");
    EMT.saveButton:SetScript("OnClick", function(self)
        from = EMT.editInput1:GetText();
        to = EMT.editInput2:GetText();
        UpdateMacro(from, to);
    end)

    EMT.editInput1 = CreateFrame("EditBox", "FromInput", EMT, "EMT_EditBoxTemplate");
    EMT.editInput1:SetPoint("LEFT", EMT, "TOP", -60, -100);
    EMT.editInput1:SetWidth(180);
    EMT.editInput1:SetHeight(40);
    EMT.editInput1:SetMovable(false);
    EMT.editInput1:SetAutoFocus(true);
    EMT.editInput1:SetMaxLetters(100);

    EMT.editInput2 = CreateFrame("EditBox", "ToInput", EMT, "EMT_EditBoxTemplate");
    EMT.editInput2:SetPoint("LEFT", EMT,  "TOP", -60, -130);
    EMT.editInput2:SetWidth(180);
    EMT.editInput2:SetHeight(40);
    EMT.editInput2:SetMovable(false);
    EMT.editInput2:SetAutoFocus(false);
    EMT.editInput2:SetMaxLetters(100);
end

EMT:RegisterEvent("PLAYER_REGEN_DISABLED", function()
    EMT.locked = true;
end)

EMT:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    EMT.locked = false;
end)

SlashCmdList["EditMacroTargets"] = function(msg)
    if UnitIsDeadOrGhost("player") or EMT.locked then
       return print("EditMacroTargets is locked while dead or in combat.");
    end

    local from, to = msg:match("^(%S*)%s*(.-)$");

    if from ~= nil and to ~= nil then
        UpdateMacro(from, to);
    end

    if msg == "" then
        DisplayModal();
    end
end
