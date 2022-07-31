--Flame Champion
local s,id=GetID()
local YGOREV_FUSION_MAT1=100010056
local YGOREV_FUSION_MAT2=100010300
local YGOREV_FUSION_MAT3=100010407
local YGOREV_NUMOFDIFFMATS=3
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,YGOREV_FUSION_MAT1,YGOREV_FUSION_MAT2,YGOREV_FUSION_MAT3)	
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
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.atcon)
	e1:SetCost(s.atcost)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)
	--negate eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(s.efcon)
	e2:SetTarget(s.eftg)
	e2:SetOperation(s.efop)
	c:RegisterEffect(e2)	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.spcon)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

--Min 1 material face-up on the field (YGOREV Generic Fusion Restriction)--START
function s.spfilter1(c)
	return c:IsCode(YGOREV_FUSION_MAT1,YGOREV_FUSION_MAT2,YGOREV_FUSION_MAT3) and c:IsAbleToGrave() and (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup())
end
function s.spfilter2(c,mat1)
	return c:IsCode(YGOREV_FUSION_MAT1,YGOREV_FUSION_MAT2,YGOREV_FUSION_MAT3) and c:IsAbleToGrave() and ((c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND)) and c:GetCode()~=mat1
end
function s.spfilter3(c,mat1)
	return c:IsCode(YGOREV_FUSION_MAT1,YGOREV_FUSION_MAT2,YGOREV_FUSION_MAT3) and c:IsAbleToGrave() and ((c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND)) and c:GetCode()~=mat1
end
function s.rescon(sg,e,tp,mg)
	return Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0 and sg:IsExists(s.spfilter1,1,nil) and sg:IsExists(s.spfilter2,1,nil) and sg:IsExists(s.spfilter3,1,nil) and sg:GetClassCount(Card.GetCode)==YGOREV_NUMOFDIFFMATS
end
function s.breakcon(sg,e,tp,mg)
	return #sg == 0 or #sg == YGOREV_NUMOFDIFFMATS
end
function s.condition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g3=Duel.GetMatchingGroup(s.spfilter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	return #g1>0 and #g2>0 and #g3>0
		and aux.SelectUnselectGroup(g,e,tp,YGOREV_NUMOFDIFFMATS,YGOREV_NUMOFDIFFMATS,s.rescon,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g3=Duel.GetMatchingGroup(s.spfilter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
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

--If a FIRE monster is targeted by an attack or by an opponent's card effect
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d:IsAttribute(ATTRIBUTE_FIRE)
end

--Reveal 1 FIRE monster from your hand, until the End Phase
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsPublic()
end
function s.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g,REASON_EFFECT+REASON_REVEAL)
		local g1=g:GetFirst()
		local e1=Effect.CreateEffect(g1)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g1:RegisterEffect(e1)	
		Duel.ShuffleHand(tp)
	end	
end
--Attack
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
--Effect
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local bt=g:GetFirst()
	return bt and bt:IsAttribute(ATTRIBUTE_FIRE) and bt:IsFaceup() and bt:GetControler()==c:GetControler()
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g,REASON_EFFECT+REASON_REVEAL)
		local g1=g:GetFirst()
		local e1=Effect.CreateEffect(g1)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g1:RegisterEffect(e1)	
		Duel.ShuffleHand(tp)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end		
end
function s.efop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateActivation(ev)
end

--If this card inflicts battle damage to your opponent
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
--You can target 1 Pyro or FIRE monster in your Graveyard with ATK less or equal to the inflicted damage
function s.spfilter(c,e,tp,ev)
	return (c:IsRace(RACE_PYRO) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsAttackBelow(ev) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp,ev) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ev) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ev)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
--Special Summon it
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Card Effects--END