--Cocoon of Evolution
local s,id=GetID()
local COUNTER =0x66f
local YGOREV_CARD_PFULTGREATMOTH=100015023
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	
end
--During the End Phase, place 1 Counter on this card
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(COUNTER,1,true)
end
--You can send this card to the Graveyard
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(e:GetHandler():GetCounter(COUNTER))
	Duel.Release(e:GetHandler(),REASON_COST)
end

--Special Summon 1 Insect monster from your hand or Deck whose Level is less than or equal to the number of Counters on this card x2
function s.spfilter(c,e,tp,ct)
	return c:IsLevelBelow(ct*2) and ((c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) 
			or (c:IsCode(YGOREV_CARD_PFULTGREATMOTH) and c:IsCanBeSpecialSummoned(e,0,tp,true,true))) -- Perfectly Ultimate Greath Moth filter
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetHandler():GetCounter(COUNTER)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

--Special Summon it
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
		local tc=g:GetFirst()
		if tc:IsCode(YGOREV_CARD_PFULTGREATMOTH) then -- Perfectly Ultimate Greath Moth filter
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)			
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
