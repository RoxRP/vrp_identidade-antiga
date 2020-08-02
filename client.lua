-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = Proxy.getInterface("vRP")
vRPNserver = Tunnel.getInterface("vrp_identidade")
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
-- local css = [[
-- 	.div_registro {
-- 		background: rgba(15,15,15,0.9);
-- 		color: #999;
-- 		bottom: 9%;
-- 		right: 2.2%;
-- 		position: absolute;
-- 		padding: 20px 30px;
-- 		font-family: Arial;
-- 		line-height: 30px;
-- 		border-right: 3px solid #ff4500;
-- 		letter-spacing: 1.7px;
-- 		border-radius: 10px;
-- 	}
-- 	.div_registro b {
-- 		color: #ff4500;
-- 		padding: 0 4px 0 0;
-- 	}
-- ]]

local css = [[
	#emprego {
		width: 100%;
		text-align: center;
	}
	.div_registro h3 {
    text-align: center;
    margin-bottom: 5px;
    background-color: rgba(255,255,255,0);
  }
	.div_registro {
		width: 400px;
    background: rgba(15,15,15,0.8);
		color: #999;
		bottom: 15%;
		right: 2.2%;
		position: absolute;
		padding: 20px 30px;
		font-family: Arial;
		line-height: 24px;
		border-right: 3px solid #ff4500;
		letter-spacing: 1.2px;
		border-radius: 10px;
	}
	.div_registro b {
		color: #ff4500;
		padding: 0 4px 0 0;
	}
	* {
		box-sizing: border-box;
	}

	/* Create two equal columns that floats next to each other */
	.column1 {
		float: left;
		width: 50%;
	}
	.column2 {
		float: left;
		width: 50%;
	}

	/* Clear floats after the columns */
	.row:after {
		content: "";
		display: table;
		clear: both;
	}
]]

local identity = false
local pedHeadShot = RegisterPedheadshot(PlayerPedId())
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsControlJustPressed(0,344) and GetEntityHealth(PlayerPedId()) > 101 then
			if identity then
				vRP._removeDiv("registro")
				identity = false
        UnregisterPedheadshot(pedHeadShot)
			else
				local carteira,banco,coins,nome,sobrenome,idade,user_id,identidade,telefone,job,cargo,vip,multas,faturas = vRPNserver.Identidade()
				local bvip = ""
				local bjob = ""
				local bmultas = ""

				if vip ~= "" then
					bvip = "<br><b>VIP:</b>"..vip
				else
					bvip = "<br><b>VIP:</b>Nenhum"..vip
				end
				if job ~= "" then
					bjob = "<br><b>Emprego:</b>"..job
				end
				if cargo ~= "" then
					bjob = bjob.." ("..cargo..")"
				end

				if parseInt(multas) > 0 then
					bmultas = "<br><b>Multas:</b> $" .. multas
        end
        
        -- PHOTO
        -- while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        --   print('IsPedheadshotReady(handle): '..parseInt(IsPedheadshotReady(handle)))
        --   print('IsPedheadshotValid(handle): '..parseInt(IsPedheadshotValid(handle)))
        --   print('........')
        --   Citizen.Wait(100)
        -- end
        -- local txd = GetPedheadshotTxdString(handle)
        -- DrawSprite(txd, txd, 0.700,0.760,0.12,0.185, 0.0, 255, 255, 255, 255);

				vRP._setDiv("registro",css,"<div class='row'><h3><span>"..nome.." "..sobrenome.."</span> - <b>"..user_id.."</b></h3><div class='column1'><b>Idade:</b>"..idade.."<br><b>Doc.:</b>"..identidade.."<br><b>Fone:</b>"..telefone..bvip.."</div><div class='column2'><b>Carteira:</b>"..carteira.."<br><b>Banco:</b>"..banco.."<br><b>Faturas:</b>"..faturas.."<br><b>Coins:</b>"..coins.."</div><div id='emprego'"..bjob..bmultas.."</div></div>")
				-- vRP._setDiv("registro",css,"<b>Passaporte:</b> "..user_id.."<br><b>Nome:</b> "..nome.." "..sobrenome.."<br><b>Idade:</b> "..idade.."<br><b>Identidade:</b> "..identidade.."<br><b>Telefone:</b> "..telefone..bjob..bvip.."<br><b>Carteira:</b> "..carteira.."<br><b>Banco:</b> "..banco.."<br><b>Paypal:</b> "..paypal..bmultas.."<br><b>Coins:</b> "..coins)
				identity = true
			end
		end
	end
end)

local showPicture = false
local picture = nil
Citizen.CreateThread(function()
	while true do
    Citizen.Wait(5)
    if showPicture and identity then
      DrawSprite(picture, picture, 0.760, 0.730, 0.025, 0.04, 0.0, 255, 255, 255, 255)
    end
	end
end)

function notify()
  -- Get the ped headshot image.
	while not IsPedheadshotReady(pedHeadShot) or not IsPedheadshotValid(pedHeadShot) do
    Citizen.Wait(500) -- TODO 0
	end
  local txd = GetPedheadshotTxdString(pedHeadShot)
  showPicture = true
  picture = txd
end

-- CreateThread(function()
--   -- Get the ped headshot image.
--   local handle2 = RegisterPedheadshotTransparent(PlayerPedId())
--   while not IsPedheadshotReady(handle2) or not IsPedheadshotValid(handle2) do
--       Wait(0)
--   end
--   local txd = GetPedheadshotTxdString(handle2)

--   -- Add the notification text, the more text you add the smaller the font
--   -- size will become (text is forced on 1 line only), so keep this short!
--   SetNotificationTextEntry("STRING")
--   AddTextComponentSubstringPlayerName("Transparent Headshot")

--   -- Draw the notification
--   DrawNotificationAward(txd, txd, 200, 0, "FM_GEN_UNLOCK")
--   -- local time = 0
--   -- repeat
--   --   Citizen.Wait(1)
--   --   DrawSprite(txd, txd, 0.700, 0.760, 0.12, 0.185, 0.0, 255, 255, 255, 255)
--   --   time = time + 1
--   -- until time == 500
  
--   -- Cleanup after yourself!
--   UnregisterPedheadshot(handle2)
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(10000)
--     notify()
--     -- if identity then
--     --   local handle = RegisterPedheadshot(PlayerPedId())
--     --   while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
--     --     print('IsPedheadshotReady(handle): '..parseInt(IsPedheadshotReady(handle)))
--     --     print('IsPedheadshotValid(handle): '..parseInt(IsPedheadshotValid(handle)))
--     --     Wait(1000)
--     --   end
--     --   local txd = GetPedheadshotTxdString(handle)
--     --   DrawSprite(txd, txd, 0.700,0.760,0.12,0.185, 0.0, 255, 255, 255, 10000)
--     -- end
-- 	end
-- end)