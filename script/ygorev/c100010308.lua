--Jigen Bakudan
local s,id=GetID()
local COUNTER =0x66f
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	
end
--During the End Phase, place 1 Counter on this card
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(COUNTER,1) 
	--If this card has 4 or more Counters, destroy all monsters on the field
	if (e:GetHandler():GetCounter(COUNTER)>=4) then
		local sg1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
		local atk1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetBaseAttack)
		local sg2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		local atk2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetBaseAttack)
		sg1:Merge(sg2)
		Duel.Destroy(sg1,REASON_EFFECT)
		Duel.BreakEffect()
		--Each player takes damage equal to the total original ATK of the monsters they owned which were destroyed by this effect
		Duel.Damage(tp,atk1,REASON_EFFECT)
		Duel.Damage(1-tp,atk2,REASON_EFFECT)	
	end	
end