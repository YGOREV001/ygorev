--Crow Goblin
local s,id=GetID()
local YGOREV_CARD_MOUNTAIN = 100010588
function s.initial_effect(c)
	--Inflict damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdcon)
	e1:SetTarget(s.hdtg)
	e1:SetOperation(s.hdop)
	c:RegisterEffect(e1)
end

--If this card destroys a monster by battle: Your opponent discards 1 random card. 
function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end	
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end

function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,0,LOCATION_HAND)	
	if #g>0 then	
		--If "Mountain" is on the field, you can look at your opponent's hand and discard 1 card from their hand instead
		if (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_MOUNTAIN),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(YGOREV_CARD_MOUNTAIN))
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then	
				local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
				local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
				Duel.ConfirmCards(p,g)
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
				local sg=g:Select(p,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
				Duel.ShuffleHand(1-p)			
		else
			local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
			local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
			local dg=g:RandomSelect(tp,1)
			Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
		end	
	end
end
