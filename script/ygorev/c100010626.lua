--The Judgement Hand
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)--OPD
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--At the start ot your Main Phase: Apply the following effects (in sequence)
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.rmfilter(c,p)
	return Duel.IsPlayerCanRemove(p,c) and not c:IsType(TYPE_TOKEN)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--Compare current cards qty on fields, hands and graves
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct1=#g1-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ct1=ct1-1 end
	
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct2=#g2-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ct2=ct2+1 end
	
	local g3=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local ct3=#g3-Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	
	if chk==0 then return ct1>0 or ct2>0 or ct3>0 end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Your opponent returns cards they control to the hand, so they control the same number of cards than you do
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct1=#g1-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if ct1>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
		local sg=g1:FilterSelect(1-tp,Card.IsAbleToHand,ct1,ct1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
--Your opponent discards cards from their hand, so they have the same number of cards on their hand than you do
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct2=#g2-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct2>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg=g2:FilterSelect(1-tp,Card.IsDiscardable,ct2,ct2,nil)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	end
--Your opponent banishes cards from their Graveyard, so they have the same number of cards on their Graveyard than you do
	local g3=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local ct3=#g3-Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	if ct3>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g3:FilterSelect(1-tp,Card.IsAbleToRemove,ct3,ct3,nil,1-tp,POS_FACEUP,REASON_EFFECT)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end	
end