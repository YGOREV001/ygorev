--Petit Moth
local s,id=GetID()
local YGOREV_CARD_COCOONOFEVOLUTION=100015027
local YGOREV_CARD_FOREST=100010587
function s.initial_effect(c)
	--search/spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.listed_names={YGOREV_CARD_COCOONOFEVOLUTION}
--Tribute this card
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c)
	return c:IsCode(YGOREV_CARD_COCOONOFEVOLUTION) and c:IsAbleToHand()
end
--Add 1 "Cocoon of Evolution" from your Deck to your hand
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		--If "Forest" is on the field, you can Special Summon it.
		if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_FOREST),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			or Duel.IsEnvironment(YGOREV_CARD_FOREST)) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then	
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
