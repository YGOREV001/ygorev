--Castle of Dark Illusions
local s,id=GetID()
function s.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(s.sumcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end

--Cannot be Normal Summoned, unless you control a Fiend monster (Cannot be Set from your hand)
function s.sumcon(e)
	return not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_FIEND),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

--During the Standby Phase: All other Fiend monsters you control gain 100 ATK/DEF
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,c)
	for tc in aux.Next(g) do
		tc:UpdateAttack(100,nil,c)
		tc:UpdateDefense(100,nil,c)
	end
end

function s.atkfilter(c)
	return c:IsRace(RACE_FIEND)
end