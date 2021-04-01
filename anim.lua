-- Pickups
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		
		-- if there's no nearby pickups we can wait a bit to save performance
		if next(pickups) == nil then
			Citizen.Wait(500)
		end

		for k,v in pairs(pickups) do
			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if distance <= 5.0 then
				ESX.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.25
				}, v.label)
			end

			if (closestDistance == -1 or closestDistance > 3) and distance <= 1.0 and not v.inRange and IsPedOnFoot(playerPed) then
			local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
				ESX.Streaming.RequestAnimDict(dict)
				TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
				Citizen.Wait(1000)
			
				TriggerServerEvent('esx:onPickup', v.id)
				PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
				v.inRange = true
			end
		end
	end
end)
