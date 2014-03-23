-- Widget que muestra el % de brillo de la pantalla

local setmetatable = setmetatable
local io = { popen = io.popen }
local tonumber = tonumber

local brillo = {}


function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end


function brillo_actual()
    local f = io.popen("xbacklight -get")
    local actual = f:read("*all")
    f:close()
    
    return round(actual)
end

local function worker(format, wargs)
    local brillo = brillo_actual()
    return {brillo}
end

function brillo.add(tipo, percent)
    local actual = brillo_actual()

    if tipo == 'inc' or (tipo == 'dec' and actual > 15) then
        local cmd = string.format("xbacklight -%s  %s", tipo, percent)
        return os.execute(cmd)
    end
    
end


return setmetatable(brillo, { __call = function(_, ...) return worker(...) end })