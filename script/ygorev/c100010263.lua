--Metal Guardian
local s,id=GetID()
function s.initial_effect(c)
	--Up to 3 times, while this card is face-up on the field, this card cannot be destroyed by battle or by card effects	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(3)
	e1:SetValue(s.valcon)
	c:RegisterEffect(e1)
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE+REASON_EFFECT)~=0
end