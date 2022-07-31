--Yado Karyu
local s,id=GetID()
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

--If this face-up card is changed from Defense Position to Attack Position
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetPreviousPosition()&POS_FACEUP_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos()
end

--Draw 1 card.
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDraw(tp,1) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
