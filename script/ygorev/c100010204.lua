--Big Eye
local s,id=GetID()
function s.initial_effect(c)
	--FLIP: Look at up to 3 cards from the top of each player Deck, then place them on the top of their Decks in any order.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)	
--Sort your Deck
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINTMSG_NUMBER,tp,HINT_NUMBER)
		if ct==2 then
			ac=Duel.AnnounceNumber(tp,1,2)
		else
			ac=Duel.AnnounceNumber(tp,1,2,3)
		end
	end
	Duel.SortDecktop(tp,tp,ac)
	
--Sort your opponent's Deck
	local ctOp=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ctOp==0 then return end
	local bc=1
	if ctOp>1 then
		Duel.Hint(HINTMSG_NUMBER,tp,HINT_NUMBER)
		if ctOp==2 then
			bc=Duel.AnnounceNumber(tp,1,2)
		else
			bc=Duel.AnnounceNumber(tp,1,2,3)
		end
	end
	Duel.SortDecktop(tp,1-tp,ctOp)
end
