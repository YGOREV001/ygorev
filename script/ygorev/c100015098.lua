--Mirror Force
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)--OPD
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--When your opponent monster declares an attack
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.filter(c,atk)
	return c:IsFaceup() and c:IsAttackPos() and c:GetAttack()<=atk
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,ec:GetAttack()) end
	ec:CreateEffectRelation(e)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil,ec:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
--Destroy all your opponent's Attack Position monsters whose ATK is lower or equal to the attacking monster's ATK
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	if not (ec and ec:IsRelateToEffect(e) and ec:IsFaceup()) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil,ec:GetAttack())
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
