--Insection
local s,id=GetID()
function s.initial_effect(c)
	--swarm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FLIP+EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

--You can Special Summon up to 3 Insect Normal Monsters from your hand or Deck whose combined Levels are 4 or less.
function s.cfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,4,e,tp)
end
function s.spfilter(c,lv,e,tp)
	if lv>4 then lv=4 end
	return c:IsLevelBelow(lv) and c:IsRace(RACE_INSECT) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.rescon(lv)
	return function(sg,e,tp,mg)
		return sg:GetSum(Card.GetLevel)<=lv
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,4,e,tp)
	if #sg==0 then return end
	local tg=aux.SelectUnselectGroup(sg,e,tp,1,ft,s.rescon(4),1,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end
