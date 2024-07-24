local redZones = {
    {
        x = 2349.61,    -- Red zone x koordinatı
        y = 2557.08,    -- Red zone y koordinatı
        z = 46.67,    -- Red zone z koordinatı
        radius = 92.0,   -- Red zone yarıçapı
        visibleDistance = 300.0, -- Marker'ın görüleceği maksimum mesafe
        color = {r = 255, g = 0, b = 0, a = 128} -- Red zone renk (RGBA)
    },
    {
        x = 1475.28,    -- Red zone x koordinatı
        y = 6336.26,    -- Red zone y koordinatı
        z = 18.66,    -- Red zone z koordinatı
        radius = 92.0,   -- Red zone yarıçapı
        visibleDistance = 300.0, -- Marker'ın görüleceği maksimum mesafe
        color = {r = 255, g = 0, b = 0, a = 128} -- Red zone renk (RGBA)
    },
    {
        x = 3802.93,    -- Red zone x koordinatı
        y = 4443.13,    -- Red zone y koordinatı
        z = 4.12,    -- Red zone z koordinatı
        radius = 92.0,   -- Red zone yarıçapı
        visibleDistance = 300.0, -- Marker'ın görüleceği maksimum mesafe
        color = {r = 255, g = 0, b = 0, a = 128} -- Red zone renk (RGBA)
    },
    -- İstediğiniz kadar red zone ekleyebilirsiniz
}

local isInRedZone = {}

for i = 1, #redZones do
    isInRedZone[i] = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for i, redZone in ipairs(redZones) do
            local distance = #(vector3(redZone.x, redZone.y, redZone.z) - playerCoords)

            if distance < redZone.radius then
                if not isInRedZone[i] then
                    isInRedZone[i] = true
                    TriggerEvent('QBCore:Notify', 'Red Zone\'a girdiniz!', 'error')
                end
            else
                if isInRedZone[i] then
                    isInRedZone[i] = false
                    TriggerEvent('QBCore:Notify', 'Red Zone\'dan çıktınız!', 'success')
                end
            end

            -- Draw the dome marker only if within the visible distance
            if distance < redZone.visibleDistance then
                DrawMarker(28, redZone.x, redZone.y, redZone.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, redZone.radius, redZone.radius, redZone.radius, redZone.color.r, redZone.color.g, redZone.color.b, redZone.color.a, false, false, 2, false, nil, nil, false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    for _, redZone in ipairs(redZones) do
        local blip = AddBlipForRadius(redZone.x, redZone.y, redZone.z, redZone.radius)
        SetBlipColour(blip, 1) -- 1 is red color
        SetBlipAlpha(blip, 128)
    end
end)
