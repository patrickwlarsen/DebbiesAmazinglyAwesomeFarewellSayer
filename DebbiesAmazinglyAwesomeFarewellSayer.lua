--Variables
local playerName = UnitName("player")
local eventPartyJoined = CreateFrame("frame")
local eventPartyRosterUpdated = CreateFrame("frame")
local eventAddonLoaded = CreateFrame("frame")
local partyMembers
SLASH_FRWSAYER1 = '/frw'
SLASH_FRWSAYERCOUNT1 = '/frwsize'

----------------------------------------------
--	Events									--
----------------------------------------------

eventAddonLoaded:RegisterEvent("PLAYER_LOGIN")
eventAddonLoaded:SetScript("OnEvent", function(self, event, arg1, arg2)
	if(GetCVar("FarewellMSG")) then
		FarewellMSG = GetCVar("FarewellMSG")
	else
		RegisterCVar("FarewellMSG", "Farewell friend.")
	end
	if(GetCVar("FRWSAYERGroupSize")) then
		FRWSAYERGroupSize = GetCVar("FRWSAYERGroupSize")
	else
		RegisterCVar("FRWSAYERGroupSize", 10)
	end
end)

eventPartyJoined:RegisterEvent("GROUP_JOINED")
eventPartyJoined:SetScript("OnEvent", function(self, event, arg1, arg2)
--	SendChatMessage("Hello beautifuls! :3", "PARTY", nil, "CHANNEL")
	partyMembers = GetHomePartyInfo()
end)

eventPartyRosterUpdated:RegisterEvent("GROUP_ROSTER_UPDATE")
eventPartyRosterUpdated:SetScript("OnEvent", function(self, event, arg1, arg2)
	if(GetNumGroupMembers() == 0) 
		then
			if(partyMembers) then 
				if(tablelength(partyMembers) <= FRWSAYERGroupSize) then
					sendGoodbyeMessageToAllPartyMembers()
				else end
			else end
		else
			partyMembers = GetHomePartyInfo()
	end
end)

----------------------------------------------
--	Functions								--
----------------------------------------------
sendGoodbyeMessageToAllPartyMembers = function()
	if(partyMembers) then
		for index, value in ipairs(partyMembers) do 
			SendChatMessage(FarewellMSG, "WHISPER", nil, value)
		end
		partyMembers = nil
	else end
end

local function handlerFarewellMSG(msg, editbox)
	if(msg) then 
		if(msg ~= "") then
			FarewellMSG = msg
			SetCVar("FarewellMSG", FarewellMSG)
			print("Saved new farewell message: " .. FarewellMSG)
		else
			print("Usage: /frw farewell message")
		end
	end
end

local function handlerFRWSAYERGroupSize(sizelimit, editbox)
	if(sizelimit) then 
		sizelimit = tonumber(sizelimit)
		if(type(sizelimit) == "number") then
			if(sizelimit > 0) then
				FRWSAYERGroupSize = sizelimit
				SetCVar("FRWSAYERGroupSize", FRWSAYERGroupSize)
				print("New group size limit: " .. FRWSAYERGroupSize)
			else
				print("Usage: /frwsize groupsize")
			end
		else
			print("Usage: /frwsize farewell groupsize")
		end
	end
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end


----------------------------------------------
--	Code									--
----------------------------------------------
print("Loaded Debbies Amazingly Awesome Farewell Sayer.")

SlashCmdList["FRWSAYER"] = handlerFarewellMSG
SlashCmdList["FRWSAYERCOUNT"] = handlerFRWSAYERGroupSize