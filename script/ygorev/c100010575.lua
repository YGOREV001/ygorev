--Megamorph
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.condition)
	e2:SetValue(s.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function s.condition(e)
	return Duel.GetLP(0)~=Duel.GetLP(1)
end
function s.value(e,c)
	local p=e:GetHandler():GetControler()
	if Duel.GetLP(p)<Duel.GetLP(1-p) and Duel.GetLP(1-p)-Duel.GetLP(p)<=2000 then
		return 1500
	elseif Duel.GetLP(p)>Duel.GetLP(1-p) and Duel.GetLP(p)-Duel.GetLP(1-p)<=2000 then
		return -1500
	end
end
