--Whiptail Crow
local s,id=GetID()
function s.initial_effect(c)
	--atk down	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)	
end
--Loses 400 ATK, unless your opponent controls more cards than you do
function s.atkval(e)
	local g1=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_ONFIELD,0)
	local g2=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),0,LOCATION_ONFIELD)
	if g1>=g2 then return -400
	else return 0 end
end
--If this card inflicts battle damage to your opponent: You can discard 1 Winged Beast or DARK monster
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.cfilter(c)
	return (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_WINGEDBEAST)) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function s.thfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_DECK)
end
--Add 1 Counter Trap from your Deck to your hand
function s.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end