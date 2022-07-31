--Javelin Beetle
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--1 ritual summon per turn (YGOREV Generic Ritual Restriction)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.spcon0)
	e0:SetOperation(s.stopfs0)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Level 3 or lower Insect monsters you control can attack your opponent directly
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(function(_,c) return c:IsRace(RACE_INSECT) and c:IsLevelBelow(3) end)
	e2:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e2)
	
end

--1 ritual summon per turn (YGOREV Generic Ritual Restriction) --START
function s.spcon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousLocation()&LOCATION_HAND
end
function s.stopfs0(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit0)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit0(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_RITUAL)
end
--1 ritual summon per turn (YGOREV Generic Ritual Restriction) --END

--Card Effects--START
--When this card is Ritual Summoned: You can Special Summon any number of Level 3 or lower Insect monsters from your Graveyard up to the number of cards your opponent controls -1 
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local maxc=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)-1
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and maxc>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,maxc,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local maxc=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)-1
	if maxc>0 then	
		local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),maxc)
		if ft<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp,lv)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)	
	end
end
--Card Effects--END
