--Lucky Trinket
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--Change die result
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetOperation(s.repop("dice",Duel.GetDiceResult,Duel.SetDiceResult,function(tp) Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3)) return Duel.AnnounceNumber(tp,1,2,3,4,5,6) end))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TOSS_COIN_NEGATE)
	e3:SetOperation(s.repop("coin",Duel.GetCoinResult,Duel.SetCoinResult,function(tp) Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4)) return 1-Duel.AnnounceCoin(tp) end))
	c:RegisterEffect(e3)
end

--When a card or effect that requires a coin(s) toss or a die (or dice) roll is activated, you can decide the result of 1 die or coin, and if you do, you lose 1500 LP
function s.repop(typ,func1,func2,func3)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local dc={func1()}
			local ct=(ev&0xff)+(ev>>16)
			local ac=1
			if ct>1 then
				if typ=="dice" then
					Duel.Hint(HINT_SELECTMSG,ep,aux.Stringid(id,1))
					local val,idx=Duel.AnnounceNumber(ep,table.unpack(dc,1,ct))
					ac=idx+1
				else
					local tab={}
					for i=1,ct do
						table.insert(tab,60+(1-dc[i]))
					end
					Duel.Hint(HINT_SELECTMSG,ep,aux.Stringid(id,2))
					Duel.SelectOption(ep,table.unpack(tab))
				end
				dc[ac]=func3(ep)
			else
				dc[1]=func3(ep)
			end
			func2(table.unpack(dc))
			
			Duel.SetLP(tp,Duel.GetLP(tp)-1500)
		end
	end
end
