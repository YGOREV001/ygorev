--Amanojaku's Curse
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(s.updatkdeftarget)
	e1:SetOperation(s.updatkdefactivate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and ((c:GetAttack()>c:GetBaseAttack() or c:GetDefense()>c:GetBaseDefense()) or (c:GetAttack()<c:GetBaseAttack() or c:GetDefense()<c:GetBaseDefense()))
end
function s.updatkdeftarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,g,#g,0,0)
end
function s.updatkdefactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)	
	--The ATK/DEF of all monsters on the field whose ATK or DEF are higher than their original ATK/DEF becomes their original ATK/DEF - 700	
	--The ATK/DEF of all monsters on the field whose ATK or DEF are lower than their original ATK/DEF becomes their original ATK/DEF + 700	
	for sc in aux.Next(g) do
		--Higher ATK -> Original ATK-700
		if sc:GetAttack()>sc:GetBaseAttack() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(sc:GetBaseAttack()-700)
			sc:RegisterEffect(e1)	
		--Lower ATK -> Original ATK+700
		elseif sc:GetAttack()>sc:GetBaseAttack() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(sc:GetBaseAttack()+700)
			sc:RegisterEffect(e1)			
		end
		--Higher DEF -> Original DEF-700
		if sc:GetDefense()>sc:GetBaseDefense() then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(sc:GetBaseDefense()-700)
			sc:RegisterEffect(e2)	
		--Lower DEF -> Original DEF+700
		elseif sc:GetDefense()>sc:GetBaseDefense() then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(sc:GetBaseDefense()+700)
			sc:RegisterEffect(e2)			
		end
	end
end
