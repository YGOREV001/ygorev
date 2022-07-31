--Garnecia Elefantis
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
--You can discard 1 card
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.filter1(c,tp)
	local tpe=c:GetType()
	return tpe~=0 and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tpe)
end
function s.filter2(c,tpe)
	return c:IsFaceup() and c:IsType(tpe)
end
--Target 1 face-up card of the same type (Monster/Spell/Trap)
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and s.filter2(chkc,e:GetLabel()) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.SendtoGrave(cg,REASON_DISCARD+REASON_COST)
	local g=Duel.GetOperatedGroup()
	local ctp=g:GetFirst():GetType()&0x7
	e:SetLabel(ctp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,ctp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
--Destroy it.
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end