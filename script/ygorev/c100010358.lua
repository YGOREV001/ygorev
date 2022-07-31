--Masked Sorcerer
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--negate eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e1:SetCountLimit(1,id)
	e2:SetCondition(s.efcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)	
end

--If this card is targeted by an attack or by an opponent's card effect 
--Effect
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
--Reveal any number of Spells from your hand
function s.rvfilt(c)
	return c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function s.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilt,tp,LOCATION_HAND,0,1,nil) end
	local sg=Duel.GetMatchingGroup(s.rvfilt,tp,LOCATION_HAND,0,nil)	
	local maxsp=#sg
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp,maxsp*3)
	if #g<=0 then return false end
	
	local _,maxg=g:GetMaxGroup(Card.GetLevel)
	local _,ming=g:GetMinGroup(Card.GetLevel)
	local maxc=math.ceil(maxg/3)
	local minc=math.ceil(ming/3)	
	if maxc>maxsp then maxc=maxsp end
	if not Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp,maxc*3) then return false end		
	if minc>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,maxc*3) then	
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.rvfilt,tp,LOCATION_HAND,0,minc,maxc,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		maxlv=#g*3
		e:SetLabel(maxlv)
	end	
end
--Special Summon 1 Spellcaster monster from your hand whose Level is equal or lower than the number of Spells revealed x3
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,2),nil)
	local ct=e:GetLabel()
	if not ct or not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,ct) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,ct)	
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	--Shuffle this card into the Deck
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
