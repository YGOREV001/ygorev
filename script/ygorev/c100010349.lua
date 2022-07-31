--Sacred Doll
local s,id=GetID()
function s.initial_effect(c)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(s.tglimit)
	c:RegisterEffect(e2)
	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.mtcon)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)
end
--Cannot be destroyed by battle by a DARK monster, also is unaffected by DARK monsters' effects
function s.efilter(e,te)
	local ec=te:GetOwner()
	return te:IsActiveType(TYPE_MONSTER) and ec:IsAttribute(ATTRIBUTE_DARK)
end
function s.tglimit(e,c)
	return c and c:IsAttribute(ATTRIBUTE_DARK)
end
--During your End Phase: Reveal 2 Spells from your hand or return this card to the hand
function s.cfilter(c)
	return c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil)
	if #g2>0 and g2:GetClassCount(Card.GetCode)>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g2:Select(tp,2,2,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
	end
end

