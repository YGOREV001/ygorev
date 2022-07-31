--Crush Card Virus
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)--OPD
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--When a DARK monster with 1000 ATK or less you control is destroyed by battle and sent to the Graveyard
function s.cfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c:IsAttackBelow(1000)
end
function s.filter(c)
	return c:IsAttackAbove(1500)
end
function s.hgfilter(c)
	return not c:IsPublic() or s.filter(c)
end
function s.fgfilter(c)
	return c:IsFacedown() or s.filter(c)
end
function s.tgfilter(c)
	return ((c:IsLocation(LOCATION_HAND) and c:IsPublic()) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())) and s.filter(c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(s.hgfilter,tp,0,LOCATION_HAND,1,nil)
		or Duel.IsExistingMatchingCard(s.fgfilter,tp,0,LOCATION_MZONE,1,nil)) and eg:IsExists(s.cfilter,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND)
	local ct=0
	--Destroy all monsters your opponent controls and in their hand with 1500 or more ATK
	if #conf>0 then
		local dg=conf:Filter(s.filter,nil)
		Duel.ConfirmCards(tp,dg)
		ct=Duel.Destroy(dg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	--Until the End Phase of your opponent's next turn, your opponent cannot Summon/Set monsters with 1500 or more ATK
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetTarget(s.splimit)
	if Duel.GetTurnPlayer()~=tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1,tp)	
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e6,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,0,1,aux.Stringid(id,0),nil)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsAttackAbove(1500)
end
