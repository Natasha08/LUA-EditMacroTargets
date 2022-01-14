-- ---------------------------------
-- Bulk Edit Targets
-- Originally by omadasala

SLASH_EditMacroTargets1 = "/bet";

-- TODOS
-- if either from or to is empty display an error
  -- on button click
  -- when using the replace method
-- configure help tips
-- update slash commands (bet or betm, and when it is written out in long form)
-- is there a better way to get the first index of the macros, or get the list to map over?
-- refactor/cleanup


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
        UpdateMacro(from, to, nextIndex);
    else
        print("Bulk Edit Macro Targets: Macros have been updated!");
    end
end

local function DisplayModal(msg)
    local Modal = CreateFrame("Frame", "EMT_TargetFrame", UIParent, "EtherealFrameTemplate");

    Modal:SetSize(300, 360);
    Modal:SetPoint("CENTER", UIParent, "CENTER");
    Modal:SetFrameLevel(100)

    Modal.title = Modal:CreateFontString(nil, "OVERLAY");
    Modal.title:SetFontObject("GameFontHighlight");
    Modal.title:SetPoint("CENTER", Modal.TitleBg, "CENTER", 5, 0);
    Modal.title:SetText("Bulk Edit Target Options");

    Modal.saveButton = CreateFrame("Button", "saveButton", Modal, "EMT_ButtonTemplate");
    Modal.saveButton:SetPoint("CENTER", Modal, "Bottom", 0, 70);
    Modal.saveButton:SetSize(70, 30);
    Modal.saveButton:SetText("Save");
    Modal.saveButton:SetNormalFontObject("GameFontNormalLarge");
    Modal.saveButton:SetHighlightFontObject("GameFontHighlightLarge");
    Modal.saveButton:SetScript("OnClick", function(self)
        from = Modal.editInput1:GetText();
        to = Modal.editInput2:GetText();
        if (MacroFrame:IsShown()) then HideUIPanel(MacroFrame);end
        UpdateMacro(from, to, 121);
        HideUIPanel(Modal);
    end)

    Modal.editInput1 = CreateFrame("EditBox", "FromInput", Modal, "EMT_EditBoxTemplate");
    Modal.editInput1:SetPoint("LEFT", Modal, "TOP", -60, -100);
    Modal.editInput1:SetWidth(180);
    Modal.editInput1:SetHeight(40);
    Modal.editInput1:SetMovable(false);
    Modal.editInput1:SetAutoFocus(true);
    Modal.editInput1:SetMaxLetters(100);

    Modal.editInput2 = CreateFrame("EditBox", "ToInput", Modal, "EMT_EditBoxTemplate");
    Modal.editInput2:SetPoint("LEFT", Modal,  "TOP", -60, -130);
    Modal.editInput2:SetWidth(180);
    Modal.editInput2:SetHeight(40);
    Modal.editInput2:SetMovable(false);
    Modal.editInput2:SetAutoFocus(false);
    Modal.editInput2:SetMaxLetters(100);
end

SlashCmdList["EditMacroTargets"] = function(msg)
    local command, rest = msg:match("^(%S*)%s*(.-)$");

    if command == "replace" then
        local from, to = rest:match("^(%S*)%s*(.-)$");
        UpdateMacro(from, to, 121);
    end

    if msg == "" then
        DisplayModal(msg);
    end
end
