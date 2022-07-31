--Kunai with Chain
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--If you control a Beast-Warrior or Warrior monster, apply 1 or both of these effects
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR+RACE_WARRIOR)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return false
		elseif e:GetLabel()==1 then
			return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()
		else return false end
	end
	local b1=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and Duel.GetTurnPlayer()~=tp
		and Duel.GetAttacker():IsLocation(LOCATION_MZONE) and Duel.GetAttacker():IsAttackPos()
		and Duel.GetAttacker():IsCanChangePosition() and Duel.GetAttacker():IsCanBeEffectTarget(e)
	local b2=e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	Duel.SetTargetParam(opt)
	if opt==0 or opt==2 then
		Duel.SetTargetCard(Duel.GetAttacker())
	end
	if opt==1 or opt==2 then
		if e:GetLabel()==1 then
			aux.RemainFieldCost(e,tp,eg,ep,ev,re,r,rp,1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		Duel.SetOperationInfo(0,HINTMSG_TARGET,e:GetHandler(),1,0,0)
	end
	e:SetLabel(0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	--When an opponent's monster declares an attack: Change it to Defense Position
	if opt==0 or opt==2 then
		local tc=Duel.GetAttacker()
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:CanAttack() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	end
	--Target 1 face-up monster you control; it gains 500 ATK
	if opt==1 or opt==2 then
		local tc=e:GetLabelObject()
		--Atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.SendtoGrave(c,REASON_RULE)
	end
	Duel.BreakEffect()
end
