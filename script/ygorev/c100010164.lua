--Yamatano Dragon Scroll
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)	
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

function s.filter(c,e,tp)
	local att=c:GetAttribute()
	return c:IsFaceup()	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,att,c)
end
function s.spfilter(c,e,tp,att,mc)
	return c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.chkfilter(c,tc)
	local att=tc:GetAttribute()
	return c:IsFaceup() and c:IsAttribute(att)
end
--You can target 1 Dragon monster you control
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.chkfilter(chkc,e:GetLabelObject()) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	e:SetLabelObject(g:GetFirst())
end
--Special Summon 1 Dragon monster from your hand with the same Attribute of that target
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,att)
	if #g>0 then
		Duel.BreakEffect()	
		if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP) and tc:IsRelateToEffect(e) then
			--Shuffle that target into the Deck.
			g:GetFirst():CompleteProcedure()
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end