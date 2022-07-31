--Pumpking the King of Ghosts
local s,id=GetID()
function s.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

--During each Standby Phase: All other Zombie monsters you control gain 200 ATK/DEF
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,c)
	for tc in aux.Next(g) do
		tc:UpdateAttack(200,nil,c)
		tc:UpdateDefense(200,nil,c)
	end
end

function s.atkfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end