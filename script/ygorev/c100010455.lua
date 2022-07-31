--Rabid Horseman
local s,id=GetID()
local YGOREV_FUSION_MAT1=100010138
local YGOREV_FUSION_MAT2=100010013
local YGOREV_CARD_BATTLEOX = 100010138
local YGOREV_CARD_MYSTICHORSEMAN = 100010013
local YGOREV_NUMOFDIFFMATS=2
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
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--spsummon+todeck	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

s.listed_names={YGOREV_CARD_BATTLEOX,YGOREV_CARD_MYSTICHORSEMAN}
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
--If this card you control is destroyed: You can target 1 "Battle Ox" and 1 "Mystic Horseman" from your Graveyard: Special Summon 1 of those targets, then shuffle the other target into the Deck.

function s.ssfilter1(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tdfilter1(c,e,tp,code)
	return c:IsCode(code) and c:IsAbleToDeck()
end
function s.ssfilter2(c,e,tp)
	return (c:IsCode(YGOREV_CARD_BATTLEOX) or c:IsCode(YGOREV_CARD_MYSTICHORSEMAN)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.tdfilter2(c,e,tp,tgid)
	return (c:IsCode(YGOREV_CARD_BATTLEOX) or c:IsCode(YGOREV_CARD_MYSTICHORSEMAN)) and c:IsAbleToDeck() and not c:IsCode(tgid)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and (Duel.IsExistingTarget(s.ssfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,YGOREV_CARD_BATTLEOX) or Duel.IsExistingTarget(s.ssfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,YGOREV_CARD_MYSTICHORSEMAN))
		and (Duel.IsExistingTarget(s.tdfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,YGOREV_CARD_BATTLEOX) or Duel.IsExistingTarget(s.tdfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,YGOREV_CARD_MYSTICHORSEMAN)) end		
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,s.ssfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)	
	local g1id=g1:GetFirst():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,s.tdfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1id)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
	
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end	
	if tc1:IsRelateToEffect(e) and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)>0 and tc2:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc2,nil,2,REASON_EFFECT)
	end
end
--Card Effects--END