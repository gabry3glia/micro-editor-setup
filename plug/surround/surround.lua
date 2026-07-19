local micro = import("micro")
local buffer = import("micro/buffer")

local pairs = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ['"'] = '"',
    ["'"] = "'"
}

function onKeyPress(bp, key)
    -- Controlliamo se il tasto premuto è uno dei nostri simboli
    local closing = pairs[key]
    
    if closing ~= nil then
        local c = bp:Cursor()
        if c:HasSelection() then
            -- Prendi il testo selezionato
            local selText = c:GetSelection()
            -- Sostituisci con testo circondato
            c:ReplaceSelection(key .. selText .. closing)
            -- Fermiamo l'evento in modo che Micro non processi il tasto cancellando tutto
            return false
        end
    end
    -- Se non c'è selezione, lascia che Micro faccia il suo lavoro normale
    return true
end
