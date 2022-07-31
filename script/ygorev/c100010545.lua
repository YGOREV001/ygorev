--Gravedigger Ghoul
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(s.remtg)
	e2:SetOperation(s.remop)
	c:RegisterEffect(e2)
end
-- During the End Phase: Target 1 monster from the turn player's Graveyard; banish it
function s.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--If you cannot banish a card by this effect, destroy this card
	if not Duel.IsExistingTarget(s.rmfilter,Duel.GetTurnPlayer(),LOCATION_GRAVE,0,1,nil) then
		e:SetLabel(0) --Effect cannot be resolved
		return true
	end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.rmfilter(chkc) end	
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,Duel.GetTurnPlayer(),LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,Duel.GetTurnPlayer(),LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	e:SetLabel(1) --Effect can be resolved
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)	
	if e:GetLabel()~=1 then	Duel.Destroy(e:GetHandler(),REASON_EFFECT) 
	else
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)	
		if not Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) then Duel.Destroy(e:GetHandler(),REASON_EFFECT)	end		
	end		
end

