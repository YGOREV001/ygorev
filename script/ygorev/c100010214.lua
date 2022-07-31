--Unknown Warrior of Fiend
local s,id=GetID()
local YGOREV_CARD_UNKNOWNWOFFND = 100010214

function s.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Destroy replace
end

--Gains 1000 ATK for each "Unknown Warrior of Fiend" in your Graveyard
function s.filter(c)
	return c:IsCode(YGOREV_CARD_UNKNOWNWOFFND)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end