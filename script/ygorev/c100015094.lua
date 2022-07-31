--The Eye of Truth
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--Your opponent must keep their hand revealed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e2)
	--During your Main Phase: You can pay 1000 LP; your opponent reveals their Main Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.chkcond)
	e2:SetCost(s.chkcost)
	e2:SetOperation(s.chkop)
	c:RegisterEffect(e2)
end

function s.chkcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp) and Duel.IsMainPhase()
end
function s.chkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.GetFlagEffect(tp,id)==0 end
	Duel.PayLPCost(tp,1000)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.chkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleDeck(1-tp)
	end
end
