--Psychic Kappa
local s,id=GetID()
local YGOREV_CARD_UMI = 100010591
function s.initial_effect(c)
	--negate the attack. 
	local e1=Effect.CreateEffect(c)	
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost1)
	e1:SetCondition(s.con1)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Cost Change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cost2)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end

function s.con1(e,tp,eg,ep,ev,re,r,r)
	return (not Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,YGOREV_CARD_UMI),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and not Duel.IsEnvironment(YGOREV_CARD_UMI)) and Duel.GetAttacker():IsControler(1-tp)	
end

function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end

--If "Umi" is on the field, you can pay 500 LP instead.
function s.con2(e,tp,eg,ep,ev,re,r,r)
	return (Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,YGOREV_CARD_UMI),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_UMI)) and Duel.GetAttacker():IsControler(1-tp)
end

function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end