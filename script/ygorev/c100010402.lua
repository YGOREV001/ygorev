--Hyo
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

--Special Summon 1 Level 6 or lower Warrior or WATER Normal Monster from your hand, and if you do, monsters your opponent currently controls cannot attack during their next turn, then, return this card to your hand
function s.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(6) and(c:IsRace(RACE_WARRIOR) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.atkfilter(c)
	return c:IsFaceup()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		--Monsters your opponent currently controls cannot attack during their next turn
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then		
			local g2=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil)
			local tc=g2:GetFirst()
			for tc in aux.Next(g2) do
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(3206)
				e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_ATTACK)
				e2:SetRange(LOCATION_MZONE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e2)
			end
			--Return this card to your hand
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
