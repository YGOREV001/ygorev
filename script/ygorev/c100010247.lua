--Acid Crawler
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--FLIP: Each player discards up to 3 cards from their hands, then each player draws the same number of cards they discarded
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if h1>3 then h1=3 end
	local h2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if h2>3 then h2=3 end
	if h1>0 then 
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,h1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,h1)
	end
	if h2>0 then 
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,h2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,h2)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)	
	local turnp=Duel.GetTurnPlayer()
	local g1,g2
	local h1=Duel.GetFieldGroupCount(turnp,LOCATION_HAND,0)
	if h1>3 then h1=3 end
	local h2=Duel.GetFieldGroupCount(1-turnp,LOCATION_HAND,0)
	if h2>3 then h2=3 end
	if h1>0 then 
		Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
		g1=Duel.SelectMatchingCard(turnp,aux.TRUE,turnp,LOCATION_HAND,0,1,h1,nil)
		Duel.ConfirmCards(1-turnp,g1)
	end
	if h2>0 then 
		Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
		g2=Duel.SelectMatchingCard(1-turnp,aux.TRUE,1-turnp,LOCATION_HAND,0,1,h2,nil)
	end
	Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
	Duel.SendtoGrave(g2,REASON_DISCARD+REASON_EFFECT)
	Duel.BreakEffect()
	if #g1>0 then Duel.Draw(turnp,#g1,REASON_EFFECT) end	
	if #g2>0 then Duel.Draw(1-turnp,#g2,REASON_EFFECT) end
end
