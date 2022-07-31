--Tears of a Mermaid
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end

--When an opponent's monster declares an attack on a Level 4 or lower Fish monster you control

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local bt=Duel.GetAttackTarget()
	return bt and bt:IsLocation(LOCATION_MZONE) and bt:IsControler(tp) and bt:GetLevel()>=4 and bt:IsRace(RACE_FISH)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return Duel.GetAttacker():IsRelateToBattle() end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
end

--Destroy the attacking monster
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.GetFirstTarget()	
	Duel.Destroy(dc,REASON_EFFECT)	
	--Draw 1 card
	Duel.Draw(tp,1,REASON_EFFECT)	
end
