--Mystical Sheep
local s,id=GetID()
function s.initial_effect(c)
	--If this card is destroyed by battle and sent to the Graveyard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
		and e:GetHandler():GetReasonCard():IsRelateToBattle()
end


function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=e:GetHandler():GetReasonCard()
	Duel.SetTargetCard(rc)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if rc:IsRelateToEffect(e) then
		--The monster who destroyed this card cannot declare an attack
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		rc:RegisterEffect(e1)
		--When that monster leaves the field, draw 1 card
		local e2=Effect.CreateEffect(e:GetHandler())		
		e2:SetCategory(CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetOperation(s.drop)
		rc:RegisterEffect(e2)
	end
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	Duel.Draw(c:GetOwner(),1,REASON_EFFECT)
end
