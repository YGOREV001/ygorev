--Starfish Anemone
local s,id=GetID()
local YGOREV_CARD_UMI = 100010591
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.cond)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

--If this card is discarded from your hand
function s.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_HAND and (r&REASON_DISCARD)~=0
end
--You can draw 1 card. If "Umi" is on the field, you can draw 2 cards instead.
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		--Draw 2 cards if "Umi" is on the field, or else just 1 card		
		if Duel.IsPlayerCanDraw(tp,2) then
			if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_UMI),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			or Duel.IsEnvironment(YGOREV_CARD_UMI)) then
				Duel.BreakEffect()
				Duel.Draw(tp,2,REASON_EFFECT)
				else 
				if Duel.IsPlayerCanDraw(tp,1) then
					Duel.BreakEffect()
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
		c:RegisterEffect(e)		
	end
end