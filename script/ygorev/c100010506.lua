--Bolt Escargot
local s,id=GetID()
local YGOREV_FUSION_MAT1=100010071
local YGOREV_FUSION_MAT2=100010048
local YGOREV_NUMOFDIFFMATS=2
local YGOREV_CARD_MOUNTAIN=100010588
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
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
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

s.listed_names={YGOREV_CARD_MOUNTAIN}
--Card Effects--START
--Reveal up to 2 Thunder monsters from your hand, until the End Phase
function s.cfilter(c)
	return c:IsRace(RACE_THUNDER) and not c:IsPublic()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local rt=Duel.GetTargetCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if rt>2 then rt=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,rt,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g,REASON_EFFECT+REASON_REVEAL)		
		for sc in aux.Next(g) do
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
		end	
		Duel.ShuffleHand(tp)
		e:SetLabel(#g)		
	end	
end
--Target up to 2 Set cards your opponent controls
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
--Destroy it
function s.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if #rg>0 then
		Duel.Destroy(rg,REASON_EFFECT)
	end
end
--"Mountain" must be on the field to activate and resolve this effect
function s.envfilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_MOUNTAIN)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.envfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(YGOREV_CARD_MOUNTAIN)
end

--If this card is destroyed: You can add 1 Level 4 or lower Thunder monster from your Deck to your hand
function s.thfilter(c,e,tp)
	return c:IsRace(RACE_THUNDER) and c:IsAbleToHand() and c:IsLevelBelow(4)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Card Effects--END