--Kazejin
local s,id=GetID()
local YGOREV_CARD_GATEGUARDIAN=100015053 
function s.initial_effect(c)
	--Place itself in the S/T zone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--negate eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(s.efcon)
	e2:SetTarget(s.eftg)
	e2:SetOperation(s.efop)
	c:RegisterEffect(e2)
end
s.listed_names={YGOREV_CARD_GATEGUARDIAN}
--If this face-up card is destroyed in a Monster Zone: you can place it face-up in your Spell & Trap Zone as a Continuous Spell
function s.filter(c)
	return c:IsRace(RACE_AQUA+RACE_THUNDER)and c:IsAbleToHand()
end
function s.thcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	--Add 1 Aqua or Thunder monster from your Deck to your hand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--If a "Gate Guardian" you control is targeted by a card or effect: You can shuffle this card from your Graveyard into the Deck, and if you do, negate the effect
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if not tc:IsLocation(LOCATION_MZONE) or not tc:IsCode(YGOREV_CARD_GATEGUARDIAN) then return false end
	return g
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()	
	if chk==0 then return c:IsAbleToDeckAsCost() end	
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST) then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateActivation(ev)
end