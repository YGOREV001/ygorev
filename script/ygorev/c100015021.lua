--La Jinn the Mystical Genie of the Lamp
local s,id=GetID()
local YGOREV_CARD_ANCIENTLAMP = 100015095
function s.initial_effect(c)
	--atk down	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.atkcon)
	e1:SetValue(-600)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end

--While there is no "Ancient Lamp" in your Graveyard, this card loses 600 ATK
function s.atkcon(e)
	return not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,YGOREV_CARD_ANCIENTLAMP),e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
--You can target 1 "Ancient Lamp" in your Graveyard; Shuffle that target and this card into the Deck, and if you do, draw 1 card
function s.filter(c)
	return c:IsCode(YGOREV_CARD_ANCIENTLAMP) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local c=e:GetHandler()
	local tc=g1:GetFirst()
		
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then	
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,0,REASON_EFFECT) then
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)		
		end	
	end
end
