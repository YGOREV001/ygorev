--Hane-Hane
local s,id=GetID()
local YGOREV_CARD_FOREST = 100010587
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

--Target 1 card on the field; If "Forest" is on the field, you can target 2 cards instead.
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	
	if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_FOREST),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_FOREST)) then
		if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	else 
		if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsAbleToHand() end
		if chk==0 then return true end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)			
	end	
end

--Return to the hand. 
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_FOREST),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_FOREST)) then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local g=tg:Filter(Card.IsRelateToEffect,nil,e)
		if tg then
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end	
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end			
	end
end
