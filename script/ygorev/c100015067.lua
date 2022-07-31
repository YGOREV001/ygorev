--7 Completed
local s,id=GetID()
local YGOREV_CARD_SLOTMACHINE=100015002
function s.initial_effect(c)
	--Equip only to a Machine Normal Monster: It gains 700 ATK or DEF
	aux.AddEquipProcedure(c,nil,s.eqfilter,nil,nil,nil,s.eqop)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.eqfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_NORMAL)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		if opt==0 then 
			e1:SetCode(EFFECT_UPDATE_ATTACK)
		else 
			e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		end
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

--Banish 3 "7 Completed" from your Graveyard and/or face-up field, including this face-up card
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(id) and c:IsAbleToRemoveAsCost()
end
function s.rescon(sg,e,tp,mg)
	return sg:IsContains(e:GetHandler())
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0 and aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,0) end
	local rg=aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,1,tp,HINTMSG_REMOVE)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
--Special Summon 1 "Slot Machine" from your hand, Deck or Graveyard
function s.spfilter(c,e,tp)
	return c:IsCode(YGOREV_CARD_SLOTMACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		--it becomes unaffected by Spells, also it gains 2100 ATK/DEF
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)		
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(s.efilter)
		tc:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
end