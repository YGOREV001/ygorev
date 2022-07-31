--Black Tyranno
local s,id=GetID()
function s.initial_effect(c)
	--Special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--This card can attack all Defense Position monsters your opponent controls once each
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(s.atkfilter)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

--You can Tribute 2 Dinosaur monsters (min. 1 Normal monster)
function s.spcheck(sg,tp)
	return aux.ReleaseCheckMMZ(sg,tp) and sg:IsExists(s.chk,1,nil,sg)
end
function s.chk(c,sg)
	return c:IsRace(RACE_DINOSAUR) and c:IsOnField() and sg:IsExists(Card.IsType,1,c,TYPE_NORMAL)
end
function s.cfilter(c,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsOnField() 
end
function s.posfilter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function s.atkfilter(e,c)
	return c:IsPosition(POS_DEFENSE)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,2,true,s.spcheck,e:GetHandler(),tp) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.cfilter,2,2,true,s.spcheck,e:GetHandler(),tp)
	Duel.Release(sg,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--Special Summon this card from your hand
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then	
		--change all Attack Position monsters your opponent controls to Defense Position	
		local g2=Duel.GetMatchingGroup(s.posfilter,tp,0,LOCATION_MZONE,nil)
		if #g2>0 then
			Duel.ChangePosition(g2,POS_FACEUP_DEFENSE)
		end
	end
end