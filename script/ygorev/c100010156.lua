--Yamadron
local s,id=GetID()
function s.initial_effect(c)
	--This card can attack up to 3 times on monsters during each Battle Phase. 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(2)
	c:RegisterEffect(e1)
end

