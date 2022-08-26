--Rock Ogre Grotto #1
local s,id=GetID()
local YGOREV_CARD_OGGROTTO2 = 100010063
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

s.listed_names={YGOREV_CARD_OGGROTTO2}
--If this card is destroyed by battle and sent to the Graveyard
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function s.filter(c,e,tp)
	return (c:IsCode(YGOREV_CARD_OGGROTTO2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

--Special Summon up to 2 "Rock Ogre Grotto #2" from your hand or Deck
function s.operation(e,tp,eg,ep,ev,re,r,rp)	
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ft,nil)
	for tc in aux.Next(sg) do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			--Original DEF becomes 2000
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE)
			e1:SetValue(2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	Duel.SpecialSummonComplete()
end
