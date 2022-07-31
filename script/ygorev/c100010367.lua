--The Bewitching Phantom Thief
local s,id=GetID()
function s.initial_effect(c)
	-- Declare card type
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	-- Check if normal draw has happened
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
--During your opponent's Draw Phase, before they draws
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp) and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_DRAW)
		and Duel.GetDrawCount(1-tp)>0 and Duel.GetFlagEffect(1-tp,id)==0
end
--Declare 1 card type (Monster/Spell/Trap)
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Shuffle your opponent's Deck
	Duel.ShuffleDeck(1-tp)	
	if not c:IsRelateToEffect(e) or Duel.GetDrawCount(1-tp)~=1 then return end
	--Look at the drawn card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(1)
	e1:SetOperation(s.drawcheck)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,tp)
end

--Your opponent reveals the card drawn and if it is the type declared, it is discarded.
function s.drawcheck(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW and (r&REASON_RULE)==REASON_RULE then
		local dc=eg:GetFirst()
		if not dc then return end
		Duel.ConfirmCards(tp,dc)
		local opt=e:GetLabel()		
		if (opt==0 and dc:IsType(TYPE_MONSTER)) or (opt==1 and dc:IsType(TYPE_SPELL)) or (opt==2 and dc:IsType(TYPE_TRAP)) then
			Duel.SendtoGrave(dc,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW and (r&REASON_RULE)==REASON_RULE then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE+PHASE_STANDBY,0,1)
	end
end

