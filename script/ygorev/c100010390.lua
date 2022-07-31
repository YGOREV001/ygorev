--Baron of the Fiend Sword
local s,id=GetID()
function s.initial_effect(c)
	--atk UP
	--While there is a Equip Card equipped to this card, it gains 600 ATK 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.eqcon1)
	e1:SetValue(600)
	c:RegisterEffect(e1)
	--atk DOWN	
	--While there is no Equip Card equipped to this card, this card loses 600 ATK
	local e2=e1:Clone()
	e2:SetCondition(s.eqcon2)
	e2:SetValue(-600)
	c:RegisterEffect(e2)
end

function s.eqcon1(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()> 0
end
	
function s.eqcon2(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()==0
end