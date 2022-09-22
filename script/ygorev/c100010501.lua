--Water Magician
local s,id=GetID()
local YGOREV_FUSION_MAT1=100010351
local YGOREV_FUSION_MAT2=100010002
local YGOREV_NUMOFDIFFMATS=2
local YGOREV_CARD_UMI = 100010591
local YGOREV_CARD_YAMI = 100010593
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,YGOREV_FUSION_MAT1,YGOREV_FUSION_MAT2)	
	--(YGOREV Generic Fusion Procedure)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(s.condition)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)
	--special summon WATER
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.thcost1)
	e1:SetTarget(s.thtg1)
	e1:SetOperation(s.thop1)
	c:RegisterEffect(e1)
	--special summon Spellcaster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id+1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.thcost2)
	e2:SetTarget(s.thtg2)
	e2:SetOperation(s.thop2)
	c:RegisterEffect(e2)
end

--Min 1 material face-up on the field (YGOREV Generic Fusion Restriction)--START
function s.spfilter1(c)
	return c:IsCode(YGOREV_FUSION_MAT1,YGOREV_FUSION_MAT2) and c:IsAbleToGrave() and (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup())
end
function s.spfilter2(c,mat1)
	return c:IsCode(YGOREV_FUSION_MAT1,YGOREV_FUSION_MAT2) and c:IsAbleToGrave() and ((c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND)) and c:GetCode()~=mat1
end
function s.rescon(sg,e,tp,mg)
	return Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0 and sg:IsExists(s.spfilter1,1,nil) and sg:IsExists(s.spfilter2,1,nil) and sg:GetClassCount(Card.GetCode)==YGOREV_NUMOFDIFFMATS
end
function s.breakcon(sg,e,tp,mg)
	return #sg == 0 or #sg == YGOREV_NUMOFDIFFMATS
end
function s.condition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g=g1:Clone()
	g:Merge(g2)
	return #g1>0 and #g2>0
		and aux.SelectUnselectGroup(g,e,tp,YGOREV_NUMOFDIFFMATS,YGOREV_NUMOFDIFFMATS,s.rescon,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g=g1:Clone()
	g:Merge(g2)
	local sg=aux.SelectUnselectGroup(g,e,tp,0,YGOREV_NUMOFDIFFMATS,s.rescon,1,tp,HINTMSG_TOGRAVE,s.breakcon) 
	if #sg > 0 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Duel.SendtoGrave(sg,REASON_MATERIAL)
	c:SetMaterial(sg)
	sg:DeleteGroup()	
	--1 Fusion Summon per turn (YGOREV Generic Fusion Restriction)
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
	return (sumtype&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
--Min 1 material face-up on the field (YGOREV Generic Fusion Restriction)--END

--Card Effects--START

--Discard 1 WATER monster
function s.cfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function s.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	if #g>0 then
		local g1=g:GetFirst()
		e:SetLabelObject(g1)
	end
end
--Target 1 other WATER monster in your Graveyard; add it to your hand. If "Umi" is on the field, you can Special Summon it instead
function s.thfilter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c~=e:GetLabelObject() and (c:IsAbleToHand() or (chk==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end	
	if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_UMI),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_UMI)) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectOption(tp,573,1152)==1 then 
			--If "Umi" is on the field, you can Special Summon it instead
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()		
		else
			--Add it to your hand
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)			
		end		
	else
		--Add it to your hand
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)		
	end
end

--Reveal 1 Spellcaster monster from your hand
function s.cfilter2(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and Duel.IsExistingTarget(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and not c:IsPublic()
end
function s.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)	
	if #g>0 then
		Duel.ConfirmCards(1-tp,g,REASON_EFFECT+REASON_REVEAL)
		local g1=g:GetFirst()	
		Duel.ShuffleHand(tp)
		e:SetLabel(g1:GetLevel())
	end	
end
--Target 1 Level 4 or lower Spellcaster monster in your Graveyard; add it to your hand. If "Yami" is on the field, you can Special Summon it instead
function s.thfilter2(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and (c:IsAbleToHand() or (chk==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and c:IsLevelBelow(4)
end

function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter2(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_YAMI),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_YAMI)) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectOption(tp,573,1152)==1 then 
			--If "Yami" is on the field, you can Special Summon it instead
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()		
		else
			--Add it to your hand
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)			
		end		
	else
		--Add it to your hand
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)		
	end
end
--Card Effects--END