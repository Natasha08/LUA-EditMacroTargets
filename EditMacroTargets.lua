-- ---------------------------------
-- Bulk Edit Targets
-- Originally by omadasala

SLASH_EditMacroTargets1, SLASH_EditMacroTargets2 = "/emt", "/editmacrotargets";

-- TODOS (CLOSED TO NEW FEATURES!)
-- configure help tips
-- refactor/cleanup
-- versioning and checking for updates

local LibOO = LibStub("LibOO-1.0", true);
local INITIAL_MACRO_INDEX = 1;
local App = CreateFrame("Frame", "BET_Main_Frame", UIParent, "BasicFrameTemplate");
_G.EMT = LibStub("AceAddon-3.0"):NewAddon(App, "EditMacroTargets", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0", "AceComm-3.0", "AceSerializer-3.0");
_G.EditMacroTargets = _G.EMT;
local EMT = _G.EMT;
EMT.App = App;
EMT.locked = false;
local macrosUpdated = 0;

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
    if (MacroFrame ~= nil and MacroFrame:IsShown()) then MacroFrame:Hide();end
    if from == "" then EMT:Print("the target name you are changing to is missing.");end
    if to == "" then return EMT:Print("the target name you are changing from is missing.");end

    currentIndex = previousIndex or INITIAL_MACRO_INDEX;
    name, icon, body, isLocal = GetMacroInfo(currentIndex);

    at = string.gsub("@name", "name", from);
    target = string.gsub("target=name", "name", from);


    if body:find(at) or body:find(target) then
        macroText = string.gsub(body, from, to);
        EditMacro(currentIndex, name, nil, macroText);
        macrosUpdated = macrosUpdated + 1;
    end

    local nextIndex = currentIndex + 1;

    nextName, nextIcon, nextBody, nextIsLocal = GetMacroInfo(nextIndex);

    if nextName ~= nil then
        EMT:UpdateMacro(from, to, nextIndex);
    else
        EMT.App:Hide();
        local message = string.gsub("* macros have been updated!", "*", macrosUpdated);
        if macrosUpdated == 1 then
            message = "1 macro has been updated!";
        end

        EMT:Print(message);
        macrosUpdated = 0;
    end
end

function EMT:CreateChildFrames(frame)
    frame:SetSize(250, 300);
    frame:SetPoint("center", UIParent, "center");
    frame:SetFrameLevel(100);

    frame.title = frame:CreateFontString(nil, "OVERLAY");
    frame.title:SetFontObject("GameFontNormal");
    frame.title:SetPoint("center", frame.TitleBg, "center", 5, 0);
    frame.title:SetText("Edit Macro Targets");

    frame.saveButton = CreateFrame("Button", "saveButton", frame, "EMT_ButtonTemplate");
    frame.saveButton:SetText("Save");
    frame.saveButton:SetScript("OnClick", function()
        local popup = StaticPopup_Show("EMT_CONFIRMATION_FOR_UPDATING_MACROS");
        if (popup) then
            popup.frame = frame;
        end
    end)

    frame.editTargetFrom = CreateFrame("EditBox", "BET_EditTargetFromEditBox", frame, "EMT_EditBoxTemplate");
    frame.editTargetFrom.Label = frame.editTargetFrom:CreateFontString(nil , "Background", "GameFontNormal");
    frame.editTargetFrom.Label:SetText("The target name to change from:");
    frame.editTargetFrom.Label:SetPoint("left", frame.editTargetFrom, "left", 0, 30);

    frame.editTargetTo = CreateFrame("EditBox", "BET_TargetToEditBox", frame, "EMT_EditBoxTemplate");
    frame.editTargetTo:SetPoint("center", frame,  "center", 0, -10);
    frame.editTargetTo.Label = frame.editTargetTo:CreateFontString(nil , "Background", "GameFontNormal");
    frame.editTargetTo.Label:SetText("The target name to change to:");
    frame.editTargetTo.Label:SetPoint("left", frame.editTargetTo, "left", 0, 30);
end

function EMT:CreateInterfaceOptionsApp()
    EMT.InterfaceOptionsApp = CreateFrame("frame", "EMT_InterfaceOptionsApp", EMT, "BackdropTemplate");
	EMT.InterfaceOptionsApp.name = "EditMacroTargets";
    EMT.InterfaceOptionsApp:Hide();
    EMT:CreateChildFrames(EMT.InterfaceOptionsApp);
	InterfaceOptions_AddCategory (EMT.InterfaceOptionsApp);
end

function EMT:AppSetup()
    EMT.App:Hide();
    EMT:CreateChildFrames(EMT.App);
end

function EMT:CreateDialogue()
    StaticPopupDialogs["EMT_CONFIRMATION_FOR_UPDATING_MACROS"] = {
        text = "This will modify all relevant macros, and cannot be undone. Are you sure you want to continue?",
        button1 = "Okay",
        button2 = "Cancel",
        hideOnEscape = true,
        OnAccept = function(self)
            from = self.frame.editTargetFrom:GetText();
            to = self.frame.editTargetTo:GetText();
            EMT:UpdateMacro(from, to);
        end
    }
end

EMT:RegisterEvent("PLAYER_LOGIN", function()
    EMT:AppSetup();
    EMT:CreateDialogue();
    EMT:CreateInterfaceOptionsApp();
end)

EMT:RegisterEvent("PLAYER_REGEN_DISABLED", function()
    EMT.locked = true;
end)

EMT:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    EMT.locked = false;
end)

function EMT:ToggleDisplay()
    if (EMT.App:IsVisible()) then
        EMT.App:Hide();
    else
        EMT.App:Show();
    end
end

SlashCmdList["EditMacroTargets"] = function(msg)
    local command, rest = msg:match("^(%S*)%s*(.-)$");
    local from, to, extra = strsplit(" ", msg, 3);

    if UnitIsDeadOrGhost("player") or EMT.locked then
        return EMT:Print("EMT is locked while player is dead or in combat.");
    end

    if msg == "" then
        EMT:ToggleDisplay();
    elseif command == "help" then
        print("help methods will go here");
    elseif from ~= "" and to ~= "" then
        if extra ~= "" and extra ~= nil then
            EMT:Print(string.gsub("Extra arguments entered: *", "*", extra));
            EMT.App.editTargetFrom:SetText(from);
            EMT.App.editTargetTo:SetText(to);
            EMT.App:Show();
        else
            EMT:Print("Double check your target names before saving!");
            EMT.App.editTargetFrom:SetText(from);
            EMT.App.editTargetTo:SetText(to);
            EMT.App:Show();
        end
    else
        EMT:Print("The target player name you are changing to is missing.");
        EMT.App.editTargetFrom:SetText(from);
        EMT.App:Show();
    end
end
