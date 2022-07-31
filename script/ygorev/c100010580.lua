--Ring of Magnetism
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,0,nil,s.eqlimit)
	--atk/def down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--Your opponent cannot target monsters you control for attacks or card effects, except the equipped monster
	--Effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(s.efftg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--Attacks
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetValue(s.atlimit)
	c:RegisterEffect(e5)
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler()
end
function s.efftg(e,c)
	return c~=e:GetHandler():GetEquipTarget() and c:IsType(TYPE_MONSTER)
end
function s.atlimit(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
