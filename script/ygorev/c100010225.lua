--Madjinn Gunn
local s,id=GetID()
function s.initial_effect(c)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--Discard 1 DARK monster
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.filter1(c,tp)
	local lv=c:GetOriginalLevel()
	return lv>=1 and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
		and Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil,lv)
end
function s.filter2(c,lv)
	return c:IsFaceup() and c:IsLevelBelow(lv)
end

--Target 1 face-up monster your opponent controls with a Level lower or equal to the discarded monster
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter2(chkc,e:GetLabel()) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.SendtoGrave(cg,REASON_DISCARD+REASON_COST)
	local lv=cg:GetFirst():GetLevel()
	e:SetLabel(lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil,lv)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

--Destroy it
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end