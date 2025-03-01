local redZones = {
    {
        x = 2349.61,    -- x koordinatı
        y = 2557.08,    -- y koordinatı
        z = 46.67,    -- z kordinato
        radius = 92.0,   -- BÜYÜKLÜK
        visibleDistance = 300.0, -- UZAKLIK
        color = {r = 255, g = 0, b = 0, a = 128} -- RENK
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
            if distance < redZone.visibleDistance then
                DrawMarker(28, redZone.x, redZone.y, redZone.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, redZone.radius, redZone.radius, redZone.radius, redZone.color.r, redZone.color.g, redZone.color.b, redZone.color.a, false, false, 2, false, nil, nil, false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    for _, redZone in ipairs(redZones) do
        local blip = AddBlipForRadius(redZone.x, redZone.y, redZone.z, redZone.radius)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, 128)
    end
end)
