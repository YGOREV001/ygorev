--Dark Assailant
local s,id=GetID()
function s.initial_effect(c)		
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
--If this card is Summoned: You can discard any number of monsters from your hand
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
--Target 1 monster on the field whose Level is equal to the total Levels of the discarded monsters
function s.filter(c,g)
	return c:IsFaceup() and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
end
function s.cfilter(c)
	return c:HasLevel() and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,rg)
	end
	
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,rg)
	local tc=sg:GetFirst()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=rg:SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,99)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_COST)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
--Destroy it
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end