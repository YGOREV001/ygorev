--The Furious Sea King
local s,id=GetID()
local YGOREV_CARD_UMI = 100010591
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.drcon)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end

--If "Umi" is on the field, you can Special Summon this card (from your hand or Graveyard) by Tributing 2 WATER monsters
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function s.envfilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_UMI)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.envfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(YGOREV_CARD_UMI)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,2,false,aux.ReleaseCheckMMZ,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,2,2,false,aux.ReleaseCheckMMZ,nil)
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(YGOREV_CARD_UMI)) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
end

--At the end of the Battle Phase, if this card battled
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	--Field validation
	if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_UMI),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_UMI)) then e:SetLabel(1) end
	--At the end of the Battle Phase, if this card battled
	return e:GetHandler():GetBattledGroupCount()>0
end

--: You can draw 1 card
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDraw(tp,1) then
		Duel.Draw(tp,1,REASON_EFFECT)
		--if "Umi" is on the field, your opponent discards 1 random card from their hand
		if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_UMI),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_UMI) and e:GetLabel()==1) then
			Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
			local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
			if #g==0 then return end
			local sg=g:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		end
	end
end
