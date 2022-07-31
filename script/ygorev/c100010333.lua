--Ancient Jar
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
--Shuffle all cards from both player's Graveyard into the Deck
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local cd1= math.floor(#g1/5)
	if Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) then Duel.ShuffleDeck(tp) end
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local cd2= math.floor(#g2/5)
	if Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) then Duel.ShuffleDeck(1-tp) end
	Duel.BreakEffect()
	--Each player draws 1 card for every 5 cards they shuffled this way to their respective Main Decks
	if cd1>0 then Duel.Draw(tp,cd1,REASON_EFFECT) end
	if cd2>0 then Duel.Draw(1-tp,cd2,REASON_EFFECT) end	
end
