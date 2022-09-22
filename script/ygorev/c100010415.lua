--Sky Hunter
local s,id=GetID()
local YGOREV_CARD_MOUNTAIN = 100010588
function s.initial_effect(c)
	--add to hand/special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end

--You can target 1 Level 4 or lower Winged Beast monster from your Graveyard
function s.filter(c,e,tp)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsLevelBelow(4) and (c:IsAbleToHand() or (chk==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	--Field validation
	if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_MOUNTAIN),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_MOUNTAIN)) then e:SetLabel(1) end
	--At the end of the Battle Phase, if this card battled
	return e:GetHandler():GetBattledGroupCount()>0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc,e,tp,check) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,check)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if tc:IsAbleToHand() and (e:GetLabel()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or Duel.SelectOption(tp,573,1152)==0) then
		--Add it to your hand
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		--If "Mountain" is on the field, you can Special Summon it instead
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end