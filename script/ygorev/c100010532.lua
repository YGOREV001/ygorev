--Hungry Burger
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--1 ritual summon per turn (YGOREV Generic Ritual Restriction)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.spcon0)
	e0:SetOperation(s.stopfs0)
	c:RegisterEffect(e0)
	--draw1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.drcon1)
	e1:SetOperation(s.drop1)
	c:RegisterEffect(e1)	
	--draw2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.drcost2)
	e2:SetTarget(s.drtg2)
	e2:SetOperation(s.drop2)
	c:RegisterEffect(e2)
end

--1 ritual summon per turn (YGOREV Generic Ritual Restriction) --START
function s.spcon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousLocation()&LOCATION_HAND
end
function s.stopfs0(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit0)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit0(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_RITUAL)
end
--1 ritual summon per turn (YGOREV Generic Ritual Restriction) --END

--Card Effects--START
--When this card is Ritual Summoned: Draw 1 card for each card type (Monster/Spell/Trap) your opponent currently controls
function s.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function s.drop1(e,tp,eg,ep,ev,re,r,rp)
	local ctd=0
	local g1=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsType,TYPE_MONSTER),tp,0,LOCATION_ONFIELD,nil)
	if #g1>0 then ctd=ctd+1 end
	local g2=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsType,TYPE_SPELL),tp,0,LOCATION_ONFIELD,nil)
	if #g2>0 then ctd=ctd+1 end
	local g3=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsType,TYPE_TRAP),tp,0,LOCATION_ONFIELD,nil)
	if #g3>0 then ctd=ctd+1 end	
	if ctd>0 then
		Duel.Draw(tp,ctd,REASON_EFFECT)
	end
end

--You cand send 1 Monster, 1 Spell and 1 Trap from your field to the Graveyard; draw 3 cards
function s.cfilter(c,ct)
	return c:IsType(ct) and c:IsAbleToGraveAsCost()
end
function s.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetType)==3
end
function s.drcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL)
	local g3=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil,TYPE_TRAP)
	g1:Merge(g2)
	g1:Merge(g3)
	if chk==0 then return aux.SelectUnselectGroup(g1,e,tp,3,3,s.rescon,0) end
	local g=aux.SelectUnselectGroup(g1,e,tp,3,3,s.rescon,1,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--Card Effects--END
