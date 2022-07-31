--Mech Mole Zombie
local s,id=GetID()
local YGOREV_FUSION_MAT1=100010280
local YGOREV_FUSION_MAT2=100010127
local YGOREV_FUSION_MAT3=100010445
local YGOREV_NUMOFDIFFMATS=3
local matsonfield=0
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
	--multiple effs
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.cond2)
	e1:SetOperation(s.operation2)
	c:RegisterEffect(e1)	
	--check mats on field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.matcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
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
function s.cond2(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetSummonType()&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function s.matcheck(e,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local lg=g:Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD,c,SUMMON_TYPE_SPECIAL)
	local fc=g:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)	
	matsonfield=fc
end

--When this card is Fusion Summoned: You can apply the following effects in sequence, depending on the number of Materials on the field used to Fusion Summon this card:
function s.setfilter(c)
	return (c:GetType()==TYPE_TRAP and not (c:GetType()==TYPE_CONTINUOUS or c:GetType()==TYPE_COUNTER)) and c:IsSSetable() and not c:IsForbidden()
end

function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=matsonfield
	if c:IsRelateToEffect(e) then	
		--1+: Destroy 1 Level 4 or lower monster on the field 
		if ct>=1 and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsLevelBelow,4),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then	
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)	
			local g1=Duel.SelectMatchingCard(tp,aux.FilterFaceupFunction(Card.IsLevelBelow,4),tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if #g1>0 then 
				Duel.Destroy(g1,REASON_EFFECT) 
			end			
		end
		--2+: Set 1 Normal Trap from your Deck 
		if ct>=2 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then		
			local g2=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g2>0 then 
				Duel.SSet(tp,g2)
			end			
		end
		
		--3: Special Summon 1 Level 4 or lower monster from your Graveyard, and if you do, it becomes Zombie
		if ct>=3 and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsLevelBelow,4),tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then	
			local sg=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsLevelBelow,4),tp,LOCATION_GRAVE,0,nil,e,tp)
			if #sg~=0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sp=sg:Select(tp,1,1,nil)
				local tc=sp:GetFirst()
				if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_RACE)
					e1:SetValue(RACE_ZOMBIE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end		
		end		
	end		
end


--Card Effects--END