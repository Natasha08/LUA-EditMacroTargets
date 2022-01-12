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
        UpdateMacro(from, to, 121);
        print("Bulk Edit Macro Targets: Macros have been updated!");
    end
end
