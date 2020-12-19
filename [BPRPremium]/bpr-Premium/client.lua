RegisterNetEvent("AC:cleanareavehy")
RegisterNetEvent("AC:cleanareapedsy")
RegisterNetEvent("AC:cleanareaentityy")
RegisterNetEvent("AC:openmenuy")
RegisterNetEvent("AC:adminmenuenabley")
RegisterNetEvent("AC:invalid")
RegisterNetEvent("AC:awakey")

local titolo = "~u~AC ~s~Admin Menu"
local pisellone = PlayerId(-1)
local pisello = GetPlayerName(pisellone)
local showblip = false
local showsprite = false
local nameabove = true
local esp = true
local Enabled = true
local verif = false
local verifcheck = 0

AddEventHandler("AC:awakey", function(arg)
	if arg == "3Ay7ZxwWg8gBWqEa" then
	verif = true
	end
end)

TriggerServerEvent('AC:adminmenuenable')

AddEventHandler("AC:adminmenuenabley", function()
	Enabled = false
	showblip = false
	showsprite = false
	nameabove = false
	esp = true
end)

AddEventHandler("AC:invalid", function()
	ForceSocialClubUpdate()
end)


local LR = {}

LR.debug = false

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 2000
	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end

local menus = {}
local keys = {up = 172, down = 173, left = 174, right = 175, select = 176, back = 177}
local optionCount = 0

local currentKey = nil
local currentMenu = nil

local menuWidth = 0.21
local titleHeight = 0.10
local titleYOffset = 0.03
local titleScale = 0.9
local buttonHeight = 0.040
local buttonFont = 0
local buttonScale = 0.370
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.005
local bytexd = "Ace Guard"
local function debugPrint(text)
	if LR.debug then
		Citizen.Trace("[LR] " .. tostring(text))
	end
end

local function setMenuProperty(id, property, value)
	if id and menus[id] then
		menus[id][property] = value
		debugPrint(id .. " menu property changed: { " .. tostring(property) .. ", " .. tostring(value) .. " }")
	end
end

local function isMenuVisible(id)
	if id and menus[id] then
		return menus[id].visible
	else
		return false
	end
end

local function setMenuVisible(id, visible, holdCurrent)
	if id and menus[id] then
		setMenuProperty(id, "visible", visible)

		if not holdCurrent and menus[id] then
			setMenuProperty(id, "currentOption", 1)
		end

		if visible then
			if id ~= currentMenu and isMenuVisible(currentMenu) then
				setMenuVisible(currentMenu, false)
			end

			currentMenu = id
		end
	end
end

local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextFont(font)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow(2, 2, 0, 0, 0)
	end

	if menus[currentMenu] then
		if center then
			SetTextCentre(center)
		elseif alignRight then
			SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
			SetTextRightJustify(true)
		end
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

local function drawRect(x, y, width, height, color)
	DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end

local function drawTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight / 2

		if menus[currentMenu].titleBackgroundSprite then
			DrawSprite(
				menus[currentMenu].titleBackgroundSprite.dict,
				menus[currentMenu].titleBackgroundSprite.name,
				x,
				y,
				menuWidth,
				titleHeight,
				0.,
				255,
				255,
				255,
				255
			)
		else
			drawRect(x, y, menuWidth, titleHeight, menus[currentMenu].titleBackgroundColor)
		end

		drawText(
			menus[currentMenu].title,
			x,
			y - titleHeight / 2 + titleYOffset,
			menus[currentMenu].titleFont,
			menus[currentMenu].titleColor,
			titleScale,
			true
		)
	end
end

local function drawSubTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight + buttonHeight / 2

		local subTitleColor = {
			r = menus[currentMenu].titleBackgroundColor.r,
			g = menus[currentMenu].titleBackgroundColor.g,
			b = menus[currentMenu].titleBackgroundColor.b,
			a = 255
		}

		drawRect(x, y, menuWidth, buttonHeight, menus[currentMenu].subTitleBackgroundColor)
		drawText(
			menus[currentMenu].subTitle,
			menus[currentMenu].x + buttonTextXOffset,
			y - buttonHeight / 2 + buttonTextYOffset,
			buttonFont,
			subTitleColor,
			buttonScale,
			false
		)

		if optionCount > menus[currentMenu].maxOptionCount then
			drawText(
				tostring(menus[currentMenu].currentOption) .. " / " .. tostring(optionCount),
				menus[currentMenu].x + menuWidth,
				y - buttonHeight / 2 + buttonTextYOffset,
				buttonFont,
				subTitleColor,
				buttonScale,
				false,
				false,
				true
			)
		end
	end
end

local function drawButton(text, subText)
	local x = menus[currentMenu].x + menuWidth / 2
	local multiplier = nil

	if
		menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and
			optionCount <= menus[currentMenu].maxOptionCount
	 then
		multiplier = optionCount
	elseif
		optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and
			optionCount <= menus[currentMenu].currentOption
	 then
		multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
	end

	if multiplier then
		local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
		local backgroundColor = nil
		local textColor = nil
		local subTextColor = nil
		local shadow = false

		if menus[currentMenu].currentOption == optionCount then
			backgroundColor = menus[currentMenu].menuFocusBackgroundColor
			textColor = menus[currentMenu].menuFocusTextColor
			subTextColor = menus[currentMenu].menuFocusTextColor
		else
			backgroundColor = menus[currentMenu].menuBackgroundColor
			textColor = menus[currentMenu].menuTextColor
			subTextColor = menus[currentMenu].menuSubTextColor
			shadow = true
		end

		drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
		drawText(
			text,
			menus[currentMenu].x + buttonTextXOffset,
			y - (buttonHeight / 2) + buttonTextYOffset,
			buttonFont,
			textColor,
			buttonScale,
			false,
			shadow
		)

		if subText then
			drawText(
				subText,
				menus[currentMenu].x + buttonTextXOffset,
				y - buttonHeight / 2 + buttonTextYOffset,
				buttonFont,
				subTextColor,
				buttonScale,
				false,
				shadow,
				true
			)
		end
	end
end

function LR.CreateMenu(id, title)
	-- Default settings
	menus[id] = {}
	menus[id].title = title
	menus[id].subTitle = bytexd

	menus[id].visible = false

	menus[id].previousMenu = nil

	menus[id].aboutToBeClosed = false

	menus[id].x = 0.75
	menus[id].y = 0.19

	menus[id].currentOption = 1
	menus[id].maxOptionCount = 10
	menus[id].titleFont = 1
	menus[id].titleColor = {r = 255, g = 255, b = 255, a = 255}
	Citizen.CreateThread(
		function()
			while true do
				Citizen.Wait(0)
				local ra = RGBRainbow(1.0)
				menus[id].titleBackgroundColor = {r = ra.r, g = ra.g, b = ra.b, a = 105}
				menus[id].menuFocusBackgroundColor = {r = ra.r, g = ra.g, b = ra.b, a = 100} 
			end
		end)
	menus[id].titleBackgroundSprite = nil

	menus[id].menuTextColor = {r = 255, g = 255, b = 255, a = 255}
	menus[id].menuSubTextColor = {r = 189, g = 189, b = 189, a = 255}
	menus[id].menuFocusTextColor = {r = 255, g = 255, b = 255, a = 255}
	menus[id].menuBackgroundColor = {r = 0, g = 0, b = 0, a = 100}

	menus[id].subTitleBackgroundColor = {
		r = menus[id].menuBackgroundColor.r,
		g = menus[id].menuBackgroundColor.g,
		b = menus[id].menuBackgroundColor.b,
		a = 255
	}

	menus[id].buttonPressedSound = {name = "~h~~r~> ~s~SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET"}

	debugPrint(tostring(id) .. " menu created")
end

function LR.CreateSubMenu(id, parent, subTitle)
	if menus[parent] then
		LR.CreateMenu(id, menus[parent].title)

		if subTitle then
			setMenuProperty(id, "subTitle", (subTitle))
		else
			setMenuProperty(id, "subTitle", (menus[parent].subTitle))
		end

		setMenuProperty(id, "previousMenu", parent)

		setMenuProperty(id, "x", menus[parent].x)
		setMenuProperty(id, "y", menus[parent].y)
		setMenuProperty(id, "maxOptionCount", menus[parent].maxOptionCount)
		setMenuProperty(id, "titleFont", menus[parent].titleFont)
		setMenuProperty(id, "titleColor", menus[parent].titleColor)
		setMenuProperty(id, "titleBackgroundColor", menus[parent].titleBackgroundColor)
		setMenuProperty(id, "titleBackgroundSprite", menus[parent].titleBackgroundSprite)
		setMenuProperty(id, "menuTextColor", menus[parent].menuTextColor)
		setMenuProperty(id, "menuSubTextColor", menus[parent].menuSubTextColor)
		setMenuProperty(id, "menuFocusTextColor", menus[parent].menuFocusTextColor)
		setMenuProperty(id, "menuFocusBackgroundColor", menus[parent].menuFocusBackgroundColor)
		setMenuProperty(id, "menuBackgroundColor", menus[parent].menuBackgroundColor)
		setMenuProperty(id, "subTitleBackgroundColor", menus[parent].subTitleBackgroundColor)
	else
		debugPrint("Failed to create " .. tostring(id) .. " submenu: " .. tostring(parent) .. " parent menu doesn't exist")
	end
end

function LR.CurrentMenu()
	return currentMenu
end

function LR.OpenMenu(id)
	if id and menus[id] then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		setMenuVisible(id, true)

		if menus[id].titleBackgroundSprite then
			RequestStreamedTextureDict(menus[id].titleBackgroundSprite.dict, false)
			while not HasStreamedTextureDictLoaded(menus[id].titleBackgroundSprite.dict) do
				Citizen.Wait(0)
			end
		end

		debugPrint(tostring(id) .. " menu opened")
	else
		debugPrint("Failed to open " .. tostring(id) .. " menu: it doesn't exist")
	end
end

function LR.IsMenuOpened(id)
	return isMenuVisible(id)
end

function LR.IsAnyMenuOpened()
	for id, _ in pairs(menus) do
		if isMenuVisible(id) then
			return true
		end
	end

	return false
end

function LR.IsMenuAboutToBeClosed()
	if menus[currentMenu] then
		return menus[currentMenu].aboutToBeClosed
	else
		return false
	end
end

function LR.CloseMenu()
	if menus[currentMenu] then
		if menus[currentMenu].aboutToBeClosed then
			menus[currentMenu].aboutToBeClosed = false
			setMenuVisible(currentMenu, false)
			debugPrint(tostring(currentMenu) .. " menu closed")
			PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			optionCount = 0
			currentMenu = nil
			currentKey = nil
		else
			menus[currentMenu].aboutToBeClosed = true
			debugPrint(tostring(currentMenu) .. " menu about to be closed")
		end
	end
end

function LR.Button(text, subText)
	local buttonText = text
	if subText then
		buttonText = "{ " .. tostring(buttonText) .. ", " .. tostring(subText) .. " }"
	end

	if menus[currentMenu] then
		optionCount = optionCount + 1

		local isCurrent = menus[currentMenu].currentOption == optionCount

		drawButton(text, subText)

		if isCurrent then
			if currentKey == keys.select then
				PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
				debugPrint(buttonText .. " button pressed")
				return true
			elseif currentKey == keys.left or currentKey == keys.right then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		debugPrint("Failed to create " .. buttonText .. " button: " .. tostring(currentMenu) .. " menu doesn't exist")

		return false
	end
end

function LR.MenuButton(text, id)
	if menus[id] then
		if LR.Button(text) then
			setMenuVisible(currentMenu, false)
			setMenuVisible(id, true, true)

			return true
		end
	else
		debugPrint("Failed to create " .. tostring(text) .. " menu button: " .. tostring(id) .. " submenu doesn't exist")
	end

	return false
end

function LR.CheckBox(text, bool, callback)
	local checked = "~r~~h~OFF"
	if bool then
		checked = "~g~~h~ON"
	end

	if LR.Button(text, checked) then
		bool = not bool
		debugPrint(tostring(text) .. " checkbox changed to " .. tostring(bool))
		callback(bool)

		return true
	end

	return false
end


function LR.ComboBox(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if itemsCount > 1 and isCurrent then
		selectedItem = '← '..tostring(selectedItem)..' →'
	end

	if LR.Button(text, selectedItem) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
			if currentIndex > 1 then
				currentIndex = currentIndex - 1
			else
				currentIndex = itemsCount
			end
		elseif currentKey == keys.right then
			if currentIndex < itemsCount then
				currentIndex = currentIndex + 1
			else
				currentIndex = 1
			end
		end
	else
		currentIndex = selectedIndex
	end

	callback(currentIndex, selectedIndex)
	return false
end

function TSE(a,b,c,d,e,f,g,h,i,m)
	TriggerServerEvent(a,b,c,d,e,f,g,h,i,m)
end

function LR.Display()
	if isMenuVisible(currentMenu) then
		if menus[currentMenu].aboutToBeClosed then
			LR.CloseMenu()
		else
			ClearAllHelpMessages()

			drawTitle()
			drawSubTitle()

			currentKey = nil

			if IsDisabledControlJustPressed(0, keys.down) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption < optionCount then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
				else
					menus[currentMenu].currentOption = 1
				end
			elseif IsDisabledControlJustPressed(0, keys.up) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption > 1 then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
				else
					menus[currentMenu].currentOption = optionCount
				end
			elseif IsDisabledControlJustPressed(0, keys.left) then
				currentKey = keys.left
			elseif IsDisabledControlJustPressed(0, keys.right) then
				currentKey = keys.right
			elseif IsDisabledControlJustPressed(0, keys.select) then
				currentKey = keys.select
			elseif IsDisabledControlJustPressed(0, keys.back) then
				if menus[menus[currentMenu].previousMenu] then
					PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					setMenuVisible(menus[currentMenu].previousMenu, true)
				else
					LR.CloseMenu()
				end
			end

			optionCount = 0
		end
	end
end

function LR.SetMenuWidth(id, width)
	setMenuProperty(id, "width", width)
end

function LR.SetMenuX(id, x)
	setMenuProperty(id, "x", x)
end

function LR.SetMenuY(id, y)
	setMenuProperty(id, "y", y)
end

function LR.SetMenuMaxOptionCountOnScreen(id, count)
	setMenuProperty(id, "maxOptionCount", count)
end

function LR.SetTitleColor(id, r, g, b, a)
	setMenuProperty(id, "titleColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleColor.a})
end

function LR.SetTitleBackgroundColor(id, r, g, b, a)
	setMenuProperty(
		id,
		"titleBackgroundColor",
		{["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleBackgroundColor.a}
	)
end

function LR.SetTitleBackgroundSprite(id, textureDict, textureName)
	setMenuProperty(id, "titleBackgroundSprite", {dict = textureDict, name = textureName})
end

function LR.SetSubTitle(id, text)
	setMenuProperty(id, "subTitle", (text))
end


function LR.SetMenuBackgroundColor(id, r, g, b, a)
	setMenuProperty(
		id,
		"menuBackgroundColor",
		{["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuBackgroundColor.a}
	)
end

function LR.SetMenuTextColor(id, r, g, b, a)
	setMenuProperty(id, "menuTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuTextColor.a})
end

function LR.SetMenuSubTextColor(id, r, g, b, a)
	setMenuProperty(id, "menuSubTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuSubTextColor.a})
end

function LR.SetMenuFocusColor(id, r, g, b, a)
	setMenuProperty(id, "menuFocusColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuFocusColor.a})
end

function LR.SetMenuButtonPressedSound(id, name, set)
	setMenuProperty(id, "buttonPressedSound", {["name"] = name, ["set"] = set})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		AddTextEntry("FMMC_KEY_TIP1", "")
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		AddTextEntry("FMMC_KEY_TIP1", "")
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local function getPlayerIds()
	local players = {}
	for i = 0, GetNumberOfPlayers() do
		if NetworkIsPlayerActive(i) then
			players[#players + 1] = i
		end
	end
	return players
end


function DrawText3D(x, y, z, text, r, g, b)
	SetDrawOrigin(x, y, z, 0)
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.0, 0.20)
	SetTextColour(r, g, b, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end

local function notify(text, param)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(param, false)
end

local SpartanIcS = "AceG"
local SpartanIcZ = titolo
local sMX = "SelfMenu"
local sMXS = "Self Menu"
local TRPM = "TeleportMenu"
local advm = "AdvM"
local VMS = "VehicleMenu"
local OPMS = "OnlinePlayerMenu"
local poms = "PlayerOptionsMenu"
local crds = "Credits"
local MSTC = "MiscTriggers"
local espa = "ESPMenu"

local function DrawTxt(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.4)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function RequestModelSync(mod)
    local model = GetHashKey(mod)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
          Citizen.Wait(0)
    end
end




local function teleporttocoords()
	local pizdax = KeyboardInput("Enter X pos", "", 100)
	local pizday = KeyboardInput("Enter Y pos", "", 100)
	local pizdaz = KeyboardInput("Enter Z pos", "", 100)
	if pizdax ~= "" and pizday ~= "" and pizdaz ~= "" then
			if	IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
					entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
					entity = GetPlayerPed(-1)
			end
			if entity then
				SetEntityCoords(entity, pizdax + 0.5, pizday + 0.5, pizdaz + 0.5, 1, 0, 0, 1)
				notify("~g~Teleported to coords!", false)
			end
else
	notify("~b~Invalid coords!", true)
	end
end

local function TeleportToWaypoint()
	if DoesBlipExist(GetFirstBlipInfoId(8)) then
		local blipIterator = GetBlipInfoIdIterator(8)
		local blip = GetFirstBlipInfoId(8, blipIterator)
		WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
		wp = true
	else
		notify("~b~No waypoint!", true)
	end

	local zHeigt = 0.0
	height = 1000.0
	while wp do
		Citizen.Wait(0)
		if wp then
			if
				IsPedInAnyVehicle(GetPlayerPed(-1), 0) and
					(GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1))
			 then
				entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
				entity = GetPlayerPed(-1)
			end

			SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
			FreezeEntityPosition(entity, true)
			local Pos = GetEntityCoords(entity, true)

			if zHeigt == 0.0 then
				height = height - 25.0
				SetEntityCoords(entity, Pos.x, Pos.y, height)
				bool, zHeigt = GetGroundZFor_3dCoord(Pos.x, Pos.y, Pos.z, 0)
			else
				SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
				FreezeEntityPosition(entity, false)
				wp = false
				height = 1000.0
				zHeigt = 0.0
				notify("~g~Teleported to waypoint!", false)
				break
			end
		end
	end
end

local function spawnvehicle()
	local ModelName = KeyboardInput("Enter Vehicle Spawn Name", "", 100)
	if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
		RequestModel(ModelName)
		while not HasModelLoaded(ModelName) do
			Citizen.Wait(0)
		end
		local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId(-1)), GetEntityHeading(PlayerPedId(-1)), true, true)
		SetPedIntoVehicle(PlayerPedId(-1), veh, -1)
	else
		notify("~b~~h~Model is not valid!", true)
	end
end

local function repairvehicle()
	SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0)
	SetVehicleLights(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
	SetVehicleBurnout(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
	Citizen.InvokeNative(0x1FD09E7390A74D54, GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
	SetVehicleUndriveable(vehicle,false)
end


function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

local Spectating = false

function SpectatePlayer(player)
	local playerPed = PlayerPedId(-1)
	Spectating = not Spectating
	local targetPed = GetPlayerPed(player)

	if (Spectating) then
		local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

		RequestCollisionAtCoord(targetx, targety, targetz)
		NetworkSetInSpectatorMode(true, targetPed)

		notify("Spectating " .. GetPlayerName(player), false)
	else
		local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

		RequestCollisionAtCoord(targetx, targety, targetz)
		NetworkSetInSpectatorMode(false, targetPed)

		notify("Stopped Spectating " .. GetPlayerName(player), false)
	end
end


function RequestControl(entity)
	local Waiting = 0
	NetworkRequestControlOfEntity(entity)
	while not NetworkHasControlOfEntity(entity) do
		Waiting = Waiting + 100
		Citizen.Wait(100)
		if Waiting > 5000 then
			notify("Hung for 5 seconds, killing to prevent issues...", true)
		end
	end
end

function getEntity(player)
	local result, entity = GetEntityPlayerIsFreeAimingAt(player, Citizen.ReturnResultAnyway())
	return entity
end

function GetInputMode()
	return Citizen.InvokeNative(0xA571D46727E2B718, 2) and "MouseAndKeyboard" or "GamePad"
end



function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
	
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
	
		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next
	
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumeratePeds()
		return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
		return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function RotationToDirection(rotation)
	local retz = rotation.z * 0.0174532924
	local retx = rotation.x * 0.0174532924
	local absx = math.abs(math.cos(retx))

	return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
end

function OscillateEntity(entity, entityCoords, position, angleFreq, dampRatio)
	if entity ~= 0 and entity ~= nil then
		local direction = ((position - entityCoords) * (angleFreq * angleFreq)) - (2.0 * angleFreq * dampRatio * GetEntityVelocity(entity))
		ApplyForceToEntity(entity, 3, direction.x, direction.y, direction.z + 0.1, 0.0, 0.0, 0.0, false, false, true, true, false, true)
	end
end

Citizen.CreateThread(
	function()
		while Enabled do
			Citizen.Wait(0)

			DisplayRadar(true)
			if DeleteGun then
                local cB = getEntity(PlayerId(-1))
                if IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
                    notify(
                        '~g~Delete Gun Enabled!~n~~w~Use The ~b~Pistol~n~~b~Aim ~w~and ~b~Shoot ~w~To Delete!'
                    )
                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_PISTOL'), 999999, false, true)
                    SetPedAmmo(GetPlayerPed(-1), GetHashKey('WEAPON_PISTOL'), 999999)
                    if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey('WEAPON_PISTOL') then
                        if IsPlayerFreeAiming(PlayerId(-1)) then
                            if IsEntityAPed(cB) then
                                if IsPedInAnyVehicle(cB, true) then
                                    if IsControlJustReleased(1, 142) then
                                        SetEntityAsMissionEntity(GetVehiclePedIsIn(cB, true), 1, 1)
                                        DeleteEntity(GetVehiclePedIsIn(cB, true))
                                        SetEntityAsMissionEntity(cB, 1, 1)
                                        DeleteEntity(cB)
                                        notify('~g~Deleted!')
                                    end
                                else
                                    if IsControlJustReleased(1, 142) then
                                        SetEntityAsMissionEntity(cB, 1, 1)
                                        DeleteEntity(cB)
                                        notify('~g~Deleted!')
                                    end
                                end
                            else
                                if IsControlJustReleased(1, 142) then
                                    SetEntityAsMissionEntity(cB, 1, 1)
                                    DeleteEntity(cB)
                                    notify('~g~Deleted!')
                                end
                            end
                        end
                    end
                end
            end



if esp then
	for i=1,128 do
	  if  ((NetworkIsPlayerActive( i )) and GetPlayerPed( i ) ~= GetPlayerPed( -1 )) then
		local ra = RGB(1.0)
		local pPed = GetPlayerPed(i)
		local cx, cy, cz = table.unpack(GetEntityCoords(PlayerPedId(-1)))
		local x, y, z = table.unpack(GetEntityCoords(pPed))
		local disPlayerNames = 130
		local disPlayerNamesz = 999999
		  if nameabove then
			distance = math.floor(GetDistanceBetweenCoords(cx,  cy,  cz,  x,  y,  z,  true))
			  if ((distance < disPlayerNames)) then
				if NetworkIsPlayerTalking( i ) then
				  DrawText3D(x, y, z+1.2, GetPlayerServerId(i).."  |  "..GetPlayerName(i), ra.r,ra.g,ra.b)
				else
				  DrawText3D(x, y, z+1.2, GetPlayerServerId(i).."  |  "..GetPlayerName(i), 255,255,255)
				end
			  end
		  end
		local message =
		"Name: " ..
		GetPlayerName(i) ..
		"\nServer ID: " ..
		GetPlayerServerId(i) ..
		"\nPlayer ID: " .. i .. "\nDist: " .. math.round(GetDistanceBetweenCoords(cx, cy, cz, x, y, z, true), 1)
		if IsPedInAnyVehicle(pPed, true) then
				 local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
		  message = message .. "\nVeh: " .. VehName
		end
		if ((distance < disPlayerNamesz)) then
		if espinfo and esp then
		  DrawText3D(x, y, z - 1.0, message, ra.r, ra.g, ra.b)
		end
		if espbox and esp then
		  LineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
		  LineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
		  LineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
		  LineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
		  LineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
		  LineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
		  LineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)

		  TLineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
		  TLineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
		  TLineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
		  TLineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
		  TLineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
		  TLineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
		  TLineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)

		  ConnectorOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
		  ConnectorOneEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
		  ConnectorTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
		  ConnectorTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
		  ConnectorThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
		  ConnectorThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
		  ConnectorFourBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
		  ConnectorFourEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)

		  DrawLine(
		  LineOneBegin.x,
		  LineOneBegin.y,
		  LineOneBegin.z,
		  LineOneEnd.x,
		  LineOneEnd.y,
		  LineOneEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  LineTwoBegin.x,
		  LineTwoBegin.y,
		  LineTwoBegin.z,
		  LineTwoEnd.x,
		  LineTwoEnd.y,
		  LineTwoEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  LineThreeBegin.x,
		  LineThreeBegin.y,
		  LineThreeBegin.z,
		  LineThreeEnd.x,
		  LineThreeEnd.y,
		  LineThreeEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  LineThreeEnd.x,
		  LineThreeEnd.y,
		  LineThreeEnd.z,
		  LineFourBegin.x,
		  LineFourBegin.y,
		  LineFourBegin.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  TLineOneBegin.x,
		  TLineOneBegin.y,
		  TLineOneBegin.z,
		  TLineOneEnd.x,
		  TLineOneEnd.y,
		  TLineOneEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  TLineTwoBegin.x,
		  TLineTwoBegin.y,
		  TLineTwoBegin.z,
		  TLineTwoEnd.x,
		  TLineTwoEnd.y,
		  TLineTwoEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  TLineThreeBegin.x,
		  TLineThreeBegin.y,
		  TLineThreeBegin.z,
		  TLineThreeEnd.x,
		  TLineThreeEnd.y,
		  TLineThreeEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  TLineThreeEnd.x,
		  TLineThreeEnd.y,
		  TLineThreeEnd.z,
		  TLineFourBegin.x,
		  TLineFourBegin.y,
		  TLineFourBegin.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  ConnectorOneBegin.x,
		  ConnectorOneBegin.y,
		  ConnectorOneBegin.z,
		  ConnectorOneEnd.x,
		  ConnectorOneEnd.y,
		  ConnectorOneEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  ConnectorTwoBegin.x,
		  ConnectorTwoBegin.y,
		  ConnectorTwoBegin.z,
		  ConnectorTwoEnd.x,
		  ConnectorTwoEnd.y,
		  ConnectorTwoEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  ConnectorThreeBegin.x,
		  ConnectorThreeBegin.y,
		  ConnectorThreeBegin.z,
		  ConnectorThreeEnd.x,
		  ConnectorThreeEnd.y,
		  ConnectorThreeEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  ConnectorFourBegin.x,
		  ConnectorFourBegin.y,
		  ConnectorFourBegin.z,
		  ConnectorFourEnd.x,
		  ConnectorFourEnd.y,
		  ConnectorFourEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		end
		if esplines and esp then
		  DrawLine(cx, cy, cz, x, y, z, ra.r, ra.g, ra.b, 255)
		end
	  end
	end
  end
  end


if showCoords then
	x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	roundx = tonumber(string.format("%.2f", x))
	roundy = tonumber(string.format("%.2f", y))
	roundz = tonumber(string.format("%.2f", z))

	DrawTxt("~r~X:~s~ "..roundx, 0.05, 0.00)
	DrawTxt("~r~Y:~s~ "..roundy, 0.11, 0.00)
	DrawTxt("~r~Z:~s~ "..roundz, 0.17, 0.00)
end
if Noclip then
	local currentSpeed = 2
	local noclipEntity =
		IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
	FreezeEntityPosition(PlayerPedId(-1), true)
	SetEntityInvincible(PlayerPedId(-1), true)

	local newPos = GetEntityCoords(entity)

	DisableControlAction(0, 32, true)
	DisableControlAction(0, 268, true)

	DisableControlAction(0, 31, true)

	DisableControlAction(0, 269, true)
	DisableControlAction(0, 33, true)

	DisableControlAction(0, 266, true)
	DisableControlAction(0, 34, true) 

	DisableControlAction(0, 30, true)

	DisableControlAction(0, 267, true) 
	DisableControlAction(0, 35, true) 

	DisableControlAction(0, 44, true)
	DisableControlAction(0, 20, true)

	local yoff = 0.0
	local zoff = 0.0

	if GetInputMode() == "MouseAndKeyboard" then
		if IsDisabledControlPressed(0, 32) then
			yoff = 0.5
		end
		if IsDisabledControlPressed(0, 33) then
			yoff = -0.5
		end
		if IsDisabledControlPressed(0, 34) then
			SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) + 3.0)
		end
		if IsDisabledControlPressed(0, 35) then
			SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) - 3.0)
		end
		if IsDisabledControlPressed(0, 44) then
			zoff = 0.21
		end
		if IsDisabledControlPressed(0, 20) then
			zoff = -0.21
		end
	end

	newPos =
		GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))

	local heading = GetEntityHeading(noclipEntity)
	SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
	SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
	SetEntityHeading(noclipEntity, heading)

	SetEntityCollision(noclipEntity, false, false)
	SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

	FreezeEntityPosition(noclipEntity, false)
	SetEntityInvincible(noclipEntity, false)
	SetEntityCollision(noclipEntity, true, true)
end
end
end)

Citizen.CreateThread(
	function()
		FreezeEntityPosition(entity, false)
		local playerIdxWeapon = 1;
		local showblip = false
		local WeaponTypeSelect = nil
		local WeaponSelected = nil
		local ModSelected = nil
		local currentItemIndex = 1
		local selectedItemIndex = 1
		local powerboost = { 1.0, 2.0, 4.0, 10.0, 512.0, 9999.0 }
		local spawninside = false
		LR.CreateMenu(SpartanIcS, SpartanIcZ)
		LR.CreateSubMenu(sMX, SpartanIcS, bytexd)
		LR.CreateSubMenu(TRPM, SpartanIcS, bytexd)
		LR.CreateSubMenu(advm, SpartanIcS, bytexd)
		LR.CreateSubMenu(VMS, SpartanIcS, bytexd)
		LR.CreateSubMenu(OPMS, SpartanIcS, bytexd)
		LR.CreateSubMenu(poms, OPMS, bytexd)
		LR.CreateSubMenu(crds, SpartanIcS, bytexd)
		LR.CreateSubMenu(espa, sMX, bytexd)


		local SelectedPlayer

		while Enabled do
			if LR.IsMenuOpened(SpartanIcS) then
				TSE('AC:checkup')
				DrawTxt("Ace Guard - ~r~Anti Cheat ~s~- "..pisello, 0.80, 0.9)
				notify("~u~Stay safety by Ace Guard", false)
				if LR.MenuButton("~h~~p~#~s~ Admin Menu", sMX) then
				elseif LR.MenuButton("~h~~p~#~s~ Online Players", OPMS) then
				elseif LR.MenuButton("~h~~p~#~s~ Teleport Menu", TRPM) then
				elseif LR.MenuButton("~h~~p~#~s~ Vehicle Menu", VMS) then
				elseif LR.MenuButton("~h~~p~#~s~ Server Options", advm) then
				elseif LR.MenuButton("~p~# ~b~Ace Guard Community", crds) then
								end

				LR.Display()
			elseif LR.IsMenuOpened(sMX) then
				if LR.MenuButton("~h~~p~#~s~ ESP Menu", espa) then
				elseif LR.Button("~h~~r~Suicide") then
					SetEntityHealth(PlayerPedId(-1), 0)
				elseif LR.Button("~h~~g~Heal/Revive") then
					SetEntityHealth(PlayerPedId(-1), 200)
				elseif LR.Button("~h~~b~Give Armour") then
					SetPedArmour(PlayerPedId(-1), 200)
				elseif LR.CheckBox("~h~Noclip",Noclip,function(enabled)Noclip = enabled end) then	
				elseif LR.CheckBox("~h~Delete Gun",DeleteGun, function(enabled)DeleteGun = enabled end)  then		
				end

				LR.Display()
            elseif LR.IsMenuOpened(OPMS) then
                local playerlist = GetActivePlayers()
                for i = 1, #playerlist do
                  local currPlayer = playerlist[i]
                  if LR.MenuButton("ID: ~y~["..GetPlayerServerId(currPlayer).."] ~s~"..GetPlayerName(currPlayer).." "..(IsPedDeadOrDying(GetPlayerPed(currPlayer), 1) and "~r~DEAD" or "~g~ALIVE"), 'PlayerOptionsMenu') then
                    SelectedPlayer = currPlayer
                  end
                end
		

				LR.Display()
			elseif LR.IsMenuOpened(poms) then
				LR.SetSubTitle(poms, "Player Options [" .. GetPlayerName(SelectedPlayer) .. "]")

				if LR.Button("~h~Spectate", (Spectating and "~g~[SPECTATING]")) then
					SpectatePlayer(SelectedPlayer)

				
				elseif LR.Button("~h~Teleport To") then
				local Entity = IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
				SetEntityCoords(Entity, GetEntityCoords(GetPlayerPed(SelectedPlayer)), 0.0, 0.0, 0.0, false)


				elseif LR.Button("~h~Give ~r~Vehicle") then
					local ped = GetPlayerPed(SelectedPlayer)
					local ModelName = KeyboardInput("Enter Vehicle Spawn Name", "", 100)
					if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
						RequestModel(ModelName)
						while not HasModelLoaded(ModelName) do
						Citizen.Wait(0)
						end
							local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(ped), GetEntityHeading(ped)+90, true, true)
						else
							notify("~b~Model is not valid!", true)
				end
			end



	LR.Display()
elseif IsDisabledControlPressed(0, 19)  then
			TSE('AC:openmenu')

				LR.Display()
			elseif LR.IsMenuOpened(TRPM) then
				if LR.Button("~h~Teleport to ~g~waypoint") then
					TeleportToWaypoint()
				elseif LR.Button("~h~Teleport to ~r~coords") then
					teleporttocoords()
				elseif LR.CheckBox("~h~Show ~g~Coords", showCoords, function (enabled) showCoords = enabled end) then
			end


				LR.Display()
			elseif LR.IsMenuOpened(VMS) then
				if LR.Button("~h~Spawn ~r~Custom ~s~Vehicle") then
					spawnvehicle()
				elseif LR.Button("~h~~r~Delete ~s~Vehicle") then
					DelVeh(GetVehiclePedIsUsing(PlayerPedId(-1)))
				elseif LR.Button("~h~~g~Repair ~s~Vehicle") then
					repairvehicle()
				elseif LR.CheckBox("~h~Vehicle Godmode", VehGod, function(enabled) VehGod = enabled end)then
			end

--------------------------

LR.Display()
elseif LR.IsMenuOpened(advm) then
	if LR.Button("Clean Area","~g~Vehicles") then
		TSE("AC:cleanareaveh")
	elseif LR.Button("Clean Area","~r~Peds") then
		TSE("AC:cleanareapeds")
	elseif LR.Button("Clean Area","~y~Entity") then
		TSE("AC:cleanareaentity")

end

	LR.Display()
	elseif LR.IsMenuOpened(crds) then
		if LR.Button("~h~Ace Guard") then
	end


		LR.Display()
	elseif LR.IsMenuOpened(espa) then
	if LR.CheckBox("~h~~r~ESP ~s~MasterSwitch", esp, function(enabled) esp = enabled end) then
	elseif LR.CheckBox("~h~~r~Name", nameabove, function(enabled) nameabove = enabled end) then
	elseif LR.CheckBox("~h~~r~ESP ~s~Box", espbox, function(enabled) espbox = enabled end) then
	elseif LR.CheckBox("~h~~r~ESP ~s~Info", espinfo, function(enabled) espinfo = enabled end) then
	elseif LR.CheckBox("~h~~r~ESP ~s~Lines", esplines, function(enabled) esplines = enabled end) then
	end

		LR.Display()
			end
			Citizen.Wait(0)
		end
	end)


local blackObjects = { "prop_weed_pallet", "hei_prop_carrier_radar_1_l1", "v_res_mexball", "prop_rock_1_a", "prop_rock_1_b", "prop_rock_1_c", "prop_rock_1_d", "prop_player_gasmask", "prop_rock_1_e", "prop_rock_1_f", "prop_rock_1_g", "prop_rock_1_h", "prop_test_boulder_01", "prop_test_boulder_02", "prop_test_boulder_03", "prop_test_boulder_04", "apa_mp_apa_crashed_usaf_01a", "ex_prop_exec_crashdp", "apa_mp_apa_yacht_o1_rail_a", "apa_mp_apa_yacht_o1_rail_b", "apa_mp_h_yacht_armchair_01", "apa_mp_h_yacht_armchair_03", "apa_mp_h_yacht_armchair_04", "apa_mp_h_yacht_barstool_01", "apa_mp_h_yacht_bed_01", "apa_mp_h_yacht_bed_02", "apa_mp_h_yacht_coffee_table_01", "apa_mp_h_yacht_coffee_table_02", "apa_mp_h_yacht_floor_lamp_01", "apa_mp_h_yacht_side_table_01", "apa_mp_h_yacht_side_table_02", "apa_mp_h_yacht_sofa_01", "apa_mp_h_yacht_sofa_02", "apa_mp_h_yacht_stool_01", "apa_mp_h_yacht_strip_chair_01", "apa_mp_h_yacht_table_lamp_01", "apa_mp_h_yacht_table_lamp_02", "apa_mp_h_yacht_table_lamp_03", "prop_flag_columbia", "apa_mp_apa_yacht_o2_rail_a", "apa_mp_apa_yacht_o2_rail_b", "apa_mp_apa_yacht_o3_rail_a", "apa_mp_apa_yacht_o3_rail_b", "apa_mp_apa_yacht_option1", "proc_searock_01", "apa_mp_h_yacht_", "apa_mp_apa_yacht_option1_cola", "apa_mp_apa_yacht_option2", "apa_mp_apa_yacht_option2_cola", "apa_mp_apa_yacht_option2_colb", "apa_mp_apa_yacht_option3", "apa_mp_apa_yacht_option3_cola", "apa_mp_apa_yacht_option3_colb", "apa_mp_apa_yacht_option3_colc", "apa_mp_apa_yacht_option3_cold", "apa_mp_apa_yacht_option3_cole", "apa_mp_apa_yacht_jacuzzi_cam", "apa_mp_apa_yacht_jacuzzi_ripple003", "apa_mp_apa_yacht_jacuzzi_ripple1", "apa_mp_apa_yacht_jacuzzi_ripple2", "apa_mp_apa_yacht_radar_01a", "apa_mp_apa_yacht_win", "prop_crashed_heli", "apa_mp_apa_yacht_door", "prop_shamal_crash", "xm_prop_x17_shamal_crash", "apa_mp_apa_yacht_door2", "apa_mp_apa_yacht", "prop_flagpole_2b", "prop_flagpole_2c", "prop_flag_canada", "apa_prop_yacht_float_1a", "apa_prop_yacht_float_1b", "apa_prop_yacht_glass_01", "apa_prop_yacht_glass_02", "apa_prop_yacht_glass_03", "apa_prop_yacht_glass_04", "apa_prop_yacht_glass_05", "apa_prop_yacht_glass_06", "apa_prop_yacht_glass_07", "apa_prop_yacht_glass_08", "apa_prop_yacht_glass_09", "apa_prop_yacht_glass_10", "prop_flag_canada_s", "prop_flag_eu", "prop_flag_eu_s", "prop_target_blue_arrow", "prop_target_orange_arrow", "prop_target_purp_arrow", "prop_target_red_arrow", "apa_prop_flag_argentina", "apa_prop_flag_australia", "apa_prop_flag_austria", "apa_prop_flag_belgium", "apa_prop_flag_brazil", "apa_prop_flag_canadat_yt", "apa_prop_flag_china", "apa_prop_flag_columbia", "apa_prop_flag_croatia", "apa_prop_flag_czechrep", "apa_prop_flag_denmark", "apa_prop_flag_england", "apa_prop_flag_eu_yt", "apa_prop_flag_finland", "apa_prop_flag_france", "apa_prop_flag_german_yt", "apa_prop_flag_hungary", "apa_prop_flag_ireland", "apa_prop_flag_israel", "apa_prop_flag_italy", "apa_prop_flag_jamaica", "apa_prop_flag_japan_yt", "apa_prop_flag_canada_yt", "apa_prop_flag_lstein", "apa_prop_flag_malta", "apa_prop_flag_mexico_yt", "apa_prop_flag_netherlands", "apa_prop_flag_newzealand", "apa_prop_flag_nigeria", "apa_prop_flag_norway", "apa_prop_flag_palestine", "apa_prop_flag_poland", "apa_prop_flag_portugal", "apa_prop_flag_puertorico", "apa_prop_flag_russia_yt", "apa_prop_flag_scotland_yt", "apa_prop_flag_script", "apa_prop_flag_slovakia", "apa_prop_flag_slovenia", "apa_prop_flag_southafrica", "apa_prop_flag_southkorea", "apa_prop_flag_spain", "apa_prop_flag_sweden", "apa_prop_flag_switzerland", "apa_prop_flag_turkey", "apa_prop_flag_uk_yt", "apa_prop_flag_us_yt", "apa_prop_flag_wales", "prop_flag_uk", "prop_flag_uk_s", "prop_flag_us", "prop_flag_usboat", "prop_flag_us_r", "prop_flag_us_s", "prop_flag_france", "prop_flag_france_s", "prop_flag_german", "prop_flag_german_s", "prop_flag_ireland", "prop_flag_ireland_s", "prop_flag_japan", "prop_flag_japan_s", "prop_flag_ls", "prop_flag_lsfd", "prop_flag_lsfd_s", "prop_flag_lsservices", "prop_flag_lsservices_s", "prop_flag_ls_s", "prop_flag_mexico", "prop_flag_mexico_s", "prop_flag_russia", "prop_flag_russia_s", "prop_flag_s", "prop_flag_sa", "prop_flag_sapd", "prop_flag_sapd_s", "prop_flag_sa_s", "prop_flag_scotland", "prop_flag_scotland_s", "prop_flag_sheriff", "prop_flag_sheriff_s", "prop_flag_uk", "prop_flag_uk_s", "prop_flag_us", "prop_flag_usboat", "prop_flag_us_r", "prop_flag_us_s", "prop_flamingo", "prop_swiss_ball_01", "prop_air_bigradar_l1", "prop_air_bigradar_l2", "prop_air_bigradar_slod", "p_fib_rubble_s", "prop_money_bag_01", "p_cs_mp_jet_01_s", "prop_poly_bag_money", "prop_air_radar_01", "hei_prop_carrier_radar_1", "prop_air_bigradar", "prop_carrier_radar_1_l1", "prop_asteroid_01", "prop_xmas_ext", "p_oil_pjack_01_amo", "p_oil_pjack_01_s", "p_oil_pjack_02_amo", "p_oil_pjack_03_amo", "p_oil_pjack_02_s", "p_oil_pjack_03_s", "prop_aircon_l_03", "prop_med_jet_01", "p_med_jet_01_s", "hei_prop_carrier_jet", "bkr_prop_biker_bblock_huge_01", "bkr_prop_biker_bblock_huge_02", "bkr_prop_biker_bblock_huge_04", "bkr_prop_biker_bblock_huge_05", "hei_prop_heist_emp", "prop_weed_01", "prop_air_bigradar", "prop_juicestand", "prop_lev_des_barge_02", "hei_prop_carrier_defense_01", "prop_aircon_m_04", "prop_mp_ramp_03", "stt_prop_stunt_track_dwuturn", "ch3_12_animplane1_lod", "ch3_12_animplane2_lod", "hei_prop_hei_pic_pb_plane", "light_plane_rig", "prop_cs_plane_int_01", "prop_dummy_plane", "prop_mk_plane", "v_44_planeticket", "prop_planer_01", "ch3_03_cliffrocks03b_lod", "ch3_04_rock_lod_02", "csx_coastsmalrock_01_", "csx_coastsmalrock_02_", "csx_coastsmalrock_03_", "csx_coastsmalrock_04_", "mp_player_introck", "Heist_Yacht", "csx_coastsmalrock_05_", "mp_player_int_rock", "mp_player_introck", "prop_flagpole_1a", "prop_flagpole_2a", "prop_flagpole_3a", "prop_a4_pile_01", "cs2_10_sea_rocks_lod", "cs2_11_sea_marina_xr_rocks_03_lod", "prop_gold_cont_01", "prop_hydro_platform", "ch3_04_viewplatform_slod", "ch2_03c_rnchstones_lod", "proc_mntn_stone01", "prop_beachflag_le", "proc_mntn_stone02", "cs2_10_sea_shipwreck_lod", "des_shipsink_02", "prop_dock_shippad", "des_shipsink_03", "des_shipsink_04", "prop_mk_flag", "prop_mk_flag_2", "proc_mntn_stone03", "FreeModeMale01", "rsn_os_specialfloatymetal_n", "rsn_os_specialfloatymetal", "cs1_09_sea_ufo", "rsn_os_specialfloaty2_light2", "rsn_os_specialfloaty2_light", "rsn_os_specialfloaty2", "rsn_os_specialfloatymetal_n", "rsn_os_specialfloatymetal", "P_Spinning_Anus_S_Main", "P_Spinning_Anus_S_Root", "cs3_08b_rsn_db_aliencover_0001cs3_08b_rsn_db_aliencover_0001_a", "sc1_04_rnmo_paintoverlaysc1_04_rnmo_paintoverlay_a", "rnbj_wallsigns_0001", "proc_sml_stones01", "proc_sml_stones02", "maverick", "Miljet", "proc_sml_stones03", "proc_stones_01", "proc_stones_02", "proc_stones_03", "proc_stones_04", "proc_stones_05", "proc_stones_06", "prop_coral_stone_03", "prop_coral_stone_04", "prop_gravestones_01a", "prop_gravestones_02a", "prop_gravestones_03a", "prop_gravestones_04a", "prop_gravestones_05a", "prop_gravestones_06a", "prop_gravestones_07a", "prop_gravestones_08a", "prop_gravestones_09a", "prop_gravestones_10a", "prop_prlg_gravestone_05a_l1", "prop_prlg_gravestone_06a", "test_prop_gravestones_04a", "test_prop_gravestones_05a", "test_prop_gravestones_07a", "test_prop_gravestones_08a", "test_prop_gravestones_09a", "prop_prlg_gravestone_01a", "prop_prlg_gravestone_02a", "prop_prlg_gravestone_03a", "prop_prlg_gravestone_04a", "prop_stoneshroom1", "prop_stoneshroom2", "v_res_fa_stones01", "test_prop_gravestones_01a", "test_prop_gravestones_02a", "prop_prlg_gravestone_05a", "FreemodeFemale01", "p_cablecar_s", "stt_prop_stunt_tube_l", "stt_prop_stunt_track_dwuturn", "p_spinning_anus_s", "prop_windmill_01", "hei_prop_heist_tug", "prop_air_bigradar", "p_oil_slick_01", "prop_dummy_01", "hei_prop_heist_emp", "p_tram_cash_s", "hw1_blimp_ce2", "prop_fire_exting_1a", "prop_fire_exting_1b", "prop_fire_exting_2a", "prop_fire_exting_3a", "hw1_blimp_ce2_lod", "hw1_blimp_ce_lod", "hw1_blimp_cpr003", "hw1_blimp_cpr_null", "hw1_blimp_cpr_null2", "prop_lev_des_barage_02", "hei_prop_carrier_defense_01", "prop_juicestand", "S_M_M_MovAlien_01", "s_m_m_movalien_01", "s_m_m_movallien_01", "u_m_y_babyd", "CS_Orleans", "A_M_Y_ACult_01", "S_M_M_MovSpace_01", "U_M_Y_Zombie_01", "s_m_y_blackops_01", "a_f_y_topless_01", "a_c_boar", "a_c_cat_01", "a_c_chickenhawk", "a_c_chimp", "s_f_y_hooker_03", "a_c_chop", "a_c_cormorant", "a_c_cow", "a_c_coyote", "v_ilev_found_cranebucket", "p_cs_sub_hook_01_s", "a_c_crow", "a_c_dolphin", "a_c_fish", "hei_prop_heist_hook_01", "prop_rope_hook_01", "prop_sub_crane_hook", "s_f_y_hooker_01", "prop_vehicle_hook", "prop_v_hook_s", "prop_dock_crane_02_hook", "prop_winch_hook_long", "a_c_hen", "a_c_humpback", "a_c_husky", "a_c_killerwhale", "a_c_mtlion", "a_c_pigeon", "a_c_poodle", "prop_coathook_01", "prop_cs_sub_hook_01", "a_c_pug", "a_c_rabbit_01", "a_c_rat", "a_c_retriever", "a_c_rhesus", "a_c_rottweiler", "a_c_sharkhammer", "a_c_sharktiger", "a_c_shepherd", "a_c_stingray", "a_c_westy", "CS_Orleans", "prop_windmill_01", "prop_Ld_ferris_wheel", "p_tram_crash_s", "p_oil_slick_01", "p_ld_stinger_s", "p_ld_soc_ball_01", "p_parachute1_s", "p_cablecar_s", "prop_beach_fire", "prop_lev_des_barge_02", "prop_lev_des_barge_01", "prop_sculpt_fix", "prop_flagpole_2b", "prop_flagpole_2c", "prop_winch_hook_short", "prop_flag_canada", "prop_flag_canada_s", "prop_flag_eu", "prop_flag_eu_s", "prop_flag_france", "prop_flag_france_s", "prop_flag_german", "prop_ld_hook", "prop_flag_german_s", "prop_flag_ireland", "prop_flag_ireland_s", "prop_flag_japan", "prop_flag_japan_s", "prop_flag_ls", "prop_flag_lsfd", "prop_flag_lsfd_s", "prop_cable_hook_01", "prop_flag_lsservices", "prop_flag_lsservices_s", "prop_flag_ls_s", "prop_flag_mexico", "prop_flag_mexico_s", "csx_coastboulder_00", "des_tankercrash_01", "des_tankerexplosion_01", "des_tankerexplosion_02", "des_trailerparka_02", "des_trailerparkb_02", "des_trailerparkc_02", "des_trailerparkd_02", "des_traincrash_root2", "des_traincrash_root3", "des_traincrash_root4", "des_traincrash_root5", "des_finale_vault_end", "des_finale_vault_root001", "des_finale_vault_root002", "des_finale_vault_root003", "des_finale_vault_root004", "des_finale_vault_start", "des_vaultdoor001_root001", "des_vaultdoor001_root002", "des_vaultdoor001_root003", "des_vaultdoor001_root004", "des_vaultdoor001_root005", "des_vaultdoor001_root006", "des_vaultdoor001_skin001", "des_vaultdoor001_start", "des_traincrash_root6", "prop_ld_vault_door", "prop_vault_door_scene", "prop_vault_door_scene", "prop_vault_shutter", "p_fin_vaultdoor_s", "prop_gold_vault_fence_l", "prop_gold_vault_fence_r", "prop_gold_vault_gate_01", "des_traincrash_root7", "prop_flag_russia", "prop_flag_russia_s", "prop_flag_s", "ch2_03c_props_rrlwindmill_lod", "prop_flag_sa", "prop_flag_sapd", "prop_flag_sapd_s", "prop_flag_sa_s", "prop_flag_scotland", "prop_flag_scotland_s", "prop_flag_sheriff", "prop_flag_sheriff_s", "prop_flag_uk", "prop_yacht_lounger", "prop_yacht_seat_01", "prop_yacht_seat_02", "prop_yacht_seat_03", "marina_xr_rocks_02", "marina_xr_rocks_03", "prop_test_rocks01", "prop_test_rocks02", "prop_test_rocks03", "prop_test_rocks04", "marina_xr_rocks_04", "marina_xr_rocks_05", "marina_xr_rocks_06", "prop_yacht_table_01", "csx_searocks_02", "csx_searocks_03", "csx_searocks_04", "csx_searocks_05", "p_spinning_anus_s", "stt_prop_ramp_jump_xs", "stt_prop_ramp_adj_loop", "ex_props_exec_crashedp", "xm_prop_x17_osphatch_40m", "p_spinning_anus_s", "xm_prop_x17_sub", "csx_searocks_06", "p_yacht_chair_01_s", "p_yacht_sofa_01_s", "prop_yacht_table_02", "csx_coastboulder_00", "csx_coastboulder_01", "csx_coastboulder_02", "csx_coastboulder_03", "csx_coastboulder_04", "csx_coastboulder_05", "csx_coastboulder_06", "csx_coastboulder_07", "csx_coastrok1", "csx_coastrok2", "csx_coastrok3", "csx_coastrok4", "csx_coastsmalrock_01", "csx_coastsmalrock_02", "csx_coastsmalrock_03", "csx_coastsmalrock_04", "csx_coastsmalrock_05", "prop_yacht_table_03", "prop_flag_uk_s", "prop_flag_us", "prop_flag_usboat", "prop_flag_us_r", "prop_flag_us_s", "p_gasmask_s", "prop_flamingo", "p_crahsed_heli_s", "prop_rock_4_big2", "prop_fnclink_05crnr1", "prop_cs_plane_int_01", "prop_windmill_01" }

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		local handle,object = FindFirstObject()
		local finished = false
		repeat
			Citizen.Wait(1)
			if IsEntityAttached(object) and DoesEntityExist(object) then
				if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") or GetEntityModel(object) == GetHashKey("prop_weed_pallet") then
					ReqAndDelete(object,true)
				end
			end
			for i=1,#blackObjects do
				if GetEntityModel(object) == GetHashKey(blackObjects[i]) then
					ReqAndDelete(object,false)
				end
			end
			finished,object = FindNextObject(handle)
		until not finished
		EndFindObject(handle)
	end
end)

function ReqAndDelete(object,detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		while not NetworkHasControlOfEntity(object) do
			Citizen.Wait(1)
		end

		if detach then
			DetachEntity(object,0,false)
		end

		SetEntityCollision(object,false,false)
		SetEntityAlpha(object,0.0,true)
		SetEntityAsMissionEntity(object,true,true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
		if IsPedJumping(PlayerPedId()) then
			local jumplength = 0
			repeat
				Wait(0)
				jumplength=jumplength+1
				local isStillJumping = IsPedJumping(PlayerPedId())
			until not isStillJumping
			if jumplength > 250 then
				SetPedToRagdoll(ped, 5000, 1, 2)
                TriggerServerEvent("HG_AntiCheat:Jump", jumplength )
			end
        end
    end
	end
end)


	AddEventHandler("AC:cleanareavehy", function()
		for vehicle in EnumerateVehicles() do
			  SetEntityAsMissionEntity(GetVehiclePedIsIn(vehicle, true), 1, 1)
			  DeleteEntity(GetVehiclePedIsIn(vehicle, true))
			  SetEntityAsMissionEntity(vehicle, 1, 1)
			  DeleteEntity(vehicle)
			end
	end)

	AddEventHandler("AC:cleanareapedsy", function()
		PedStatus = 0
		for ped in EnumeratePeds() do
			PedStatus = PedStatus + 1
			if not (IsPedAPlayer(ped))then
				RemoveAllPedWeapons(ped, true)
				DeleteEntity(ped)
			end
		end
	end)

	AddEventHandler("AC:cleanareaentityy", function()
		objst = 0
		for obj in EnumerateObjects() do
			objst = objst + 1
				DeleteEntity(obj)
		end
	end)

	AddEventHandler("AC:openmenuy", function()
		LR.OpenMenu(SpartanIcS)
	end)

	if Config.Godmode then
		Citizen.CreateThread(function()
			while true do
				 Citizen.Wait(30000)
					local curPed = PlayerPedId()
					local curHealth = GetEntityHealth( curPed )
					SetEntityHealth( curPed, curHealth-2)
					local curWait = math.random(10,150)
					Citizen.Wait(curWait)
					if not IsPlayerDead(PlayerId()) then
						if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
							TriggerServerEvent("AC:ViolationDetected", "🐆Godmode")
						elseif GetEntityHealth(curPed) == curHealth-2 then
							SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
						end
					end
					if GetEntityHealth(PlayerPedId()) > 200 then
						TriggerServerEvent("AC:ViolationDetected", "🐆Godmode")
					end
					if GetPedArmour(PlayerPedId()) < 200 then
						Wait(50)
						if GetPedArmour(PlayerPedId()) == 200 then
							TriggerServerEvent("AC:ViolationDetected", "🐆Godmode")
						end
				end
			end
		end)
	end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- KILL PEDS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function KillAllPeds()
	local pedweapon
	local pedid
	for ped in EnumeratePeds() do 
			if DoesEntityExist(ped) then
					pedid = GetEntityModel(ped)
					pedweapon = GetSelectedPedWeapon(ped)
					if pedweapon == -1312131151 or not IsPedHuman(ped) then 
							ApplyDamageToPed(ped, 1000, false)
							DeleteEntity(ped)
					else
							switch = function (choice)
									choice = choice and tonumber(choice) or choice
								
									case =
									{
											[451459928] = function ( )
													ApplyDamageToPed(ped, 1000, false)
													DeleteEntity(ped)
											end,
								
											[1684083350] = function ( )
													ApplyDamageToPed(ped, 1000, false)
													DeleteEntity(ped)
											end,

											[451459928] = function ( )
													ApplyDamageToPed(ped, 1000, false)
													DeleteEntity(ped)
											end,
						
											[1096929346] = function ( )
													ApplyDamageToPed(ped, 1000, false)
													DeleteEntity(ped)
											end,

											[880829941] = function ( )
													ApplyDamageToPed(ped, 1000, false)
													DeleteEntity(ped)
											end,
				
											[-1404353274] = function ( )
													ApplyDamageToPed(ped, 1000, false)
													DeleteEntity(ped)
											end,

											[2109968527] = function ( )
													ApplyDamageToPed(ped, 1000, false)
													DeleteEntity(ped)
											end,
											
										 default = function ( )
										 end,
									}
									if case[choice] then
										 case[choice]()
									else
										 case["default"]()
									end
								end
								switch(pedid) 
					end
			 end
	end
end

Citizen.CreateThread(function()
	while (true) do
			Citizen.Wait(1)
			KillAllPeds()
			DeleteEntity(ped)
	end
end) 

local entityEnumerator = { __gc = function(enum) if enum.destructor and enum.handle then enum.destructor(enum.handle) end enum.destructor = nil enum.handle = nil end }

local function EnumerateEntities(initFunc, moveFunc, disposeFunc) return coroutine.wrap(function() local iter, id = initFunc() if not id or id == 0 then disposeFunc(iter) return end local enum = {handle = iter, destructor = disposeFunc} setmetatable(enum, entityEnumerator) local next = true repeat coroutine.yield(id) next, id = moveFunc(iter) until not next enum.destructor, enum.handle = nil, nil disposeFunc(iter) end) end

function EnumeratePeds() return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) end

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(100)
		thePeds = EnumeratePeds()
		PedStatus = 0
		for ped in thePeds do
			PedStatus = PedStatus + 1
			if not (IsPedAPlayer(ped))then
					DeleteEntity(ped)
					RemoveAllPedWeapons(ped, true)
			end
	end		
end
end)

Citizen.CreateThread(function()
		vehicle_weapons = {}
		
    for _,v in next, vehicle_weapon_names do
        table.insert(vehicle_weapons, GetHashKey(v))
    end

    while true do
        for i=0,256,1 do
		    local ply = GetPlayerPed(i)
		    local veh = GetVehiclePedIsIn(ply, false)

		    if DoesVehicleHaveWeapons(veh) then
			    for _,v in next, vehicle_weapons do
						DisableVehicleWeapon(true, v, veh, ply)
			    end
		    end
        end
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
        if (AntiCheat == true)then
		if IsPedJumping(PlayerPedId()) then
			local jumplength = 0
			repeat
				Wait(0)
				jumplength=jumplength+1
				local isStillJumping = IsPedJumping(PlayerPedId())
			until not isStillJumping
			if jumplength > 250 then
                        TriggerServerEvent("OK_AntiCheat:Jump", jumplength )
			cancel event
			end
        end
    end
	end
end)	





if Config.Spectate then
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
if NetworkIsInSpectatorMode() then
    TriggerServerEvent("AC:spectate")
    end
end
end)
end