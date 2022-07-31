--Jellyfish
local s,id=GetID()
local YGOREV_CARD_UMI = 100010591
function s.initial_effect(c)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
--While "Umi" is on the field, this card cannot be destroyed by battle
function s.envfilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_UMI)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.envfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(YGOREV_CARD_UMI)
end
