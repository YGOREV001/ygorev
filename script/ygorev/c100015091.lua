--Metalmorph
local s,id=GetID()
function s.initial_effect(c)
	--Activate this card by targeting 1 face-up monster you control
	aux.AddPersistentProcedure(c,0,s.filter,CATEGORY_ATKCHANGE,EFFECT_FLAG_DAMAGE_STEP,nil,TIMING_DAMAGE_STEP,s.condition,nil,nil,s.operation)
	--Becomes Machine
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.PersistentTargetFilter)
	e2:SetValue(RACE_MACHINE)
	c:RegisterEffect(e2)
	--Destroy this card when the monster leaves the field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.descon2)
	e3:SetOperation(s.desop2)
	c:RegisterEffect(e3)
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function s.filter(c)
	return c:IsFaceup()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--Increase ATK
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetCondition(s.atkcon)
		e1:SetTarget(aux.PersistentTargetFilter)
		e1:SetValue(1000)
		c:RegisterEffect(e1)		
	else
		c:CancelToGrave(false)
	end
end

--If it attacks, it gains 1000 ATK, during damage calculation only
function s.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL	and e:GetHandler():IsHasCardTarget(Duel.GetAttacker())
end
