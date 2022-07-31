--Magical Hats
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	--Negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(3,id)
	e2:SetCondition(s.natcon)
	e2:SetOperation(s.natop)
	c:RegisterEffect(e2)
	--Negate eff
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DICE) 
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(s.efcon)
	e3:SetCountLimit(3,id)
	e3:SetTarget(s.eftg)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.natcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	--You can only use this effect up to 3 times this turn
	local c=e:GetHandler()		
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCountLimit(3,id)
	e1:SetCondition(s.natcon)
	e1:SetOperation(s.natop)
	Duel.RegisterEffect(e1,tp)
	--negate eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_NEGATE) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetCondition(s.efcon)
	e2:SetCountLimit(3,id)
	e2:SetTarget(s.eftg)
	e2:SetOperation(s.efop)
	Duel.RegisterEffect(e2,tp)	
	e:SetLabel(100)
end

--This turn, if a monster you control is targeted by an attack or by an opponent's card effect, while you control an Spellcaster monster
function s.filter(c,tp,e)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
end

--Your opponent declares 2 numbers from 1 to 6, then, you roll a six-sided die, then, if the result is none of the numbers your opponent declared, negate the attack or effect
--Attack
function s.natop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_ONFIELD,0,1,nil) then return false end		
	local t={}
	local i=1
	local p=1
	for i=1,6 do t[i]=i end
	local a1=Duel.AnnounceNumber(1-tp,table.unpack(t))
	for i=1,6 do
		if a1~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	local a2=Duel.AnnounceNumber(1-tp,table.unpack(t))
	local dc=Duel.TossDice(tp,1)
	if dc~=a1 and dc~=a2 then Duel.NegateAttack() end	
	if e:GetLabel()~=100 then s.regop(e,tp,eg,ep,ev,re,r,rp) end
end

--Effect
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.filter,1,nil,tp,e) and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_ONFIELD,0,1,nil)	
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp,chk)
	if not Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_ONFIELD,0,1,nil) then return false end	
	local t={}
	local i=1
	local p=1
	for i=1,6 do t[i]=i end
	local a1=Duel.AnnounceNumber(1-tp,table.unpack(t))
	for i=1,6 do
		if a1~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	local a2=Duel.AnnounceNumber(1-tp,table.unpack(t))
	local dc=Duel.TossDice(tp,1)
	if dc~=a1 and dc~=a2 then Duel.NegateActivation(ev) end	
	if e:GetLabel()~=100 then s.regop(e,tp,eg,ep,ev,re,r,rp) end
end