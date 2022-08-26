--Hinotama
local s,id=GetID()
function s.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--Reveal up to 3 FIRE monsters from your hand
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,3,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g,REASON_EFFECT+REASON_REVEAL)	
		Duel.ShuffleHand(tp)
		e:SetLabel(#g*700)		
	end	
end
--Inflict 500 damage to your opponent for each
function s.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local dmg=e:GetLabel()
	Duel.Damage(1-tp,dmg,REASON_EFFECT,true)
	Duel.RDComplete()
end


