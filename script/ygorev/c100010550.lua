--Temple of Skulls
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Each turn, the first time a Fiend or Zombie monster you control would be destroyed by battle, it is not destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCountLimit(1,id)
	e2:SetValue(function(_,_,r) return r&REASON_BATTLE==REASON_BATTLE end)
	e2:SetTarget(function(_,c) return c:IsRace(RACE_FIEND+RACE_ZOMBIE) end)
	c:RegisterEffect(e2)
	--atk/def gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.atkcost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end


--You can send this face-up card to the Graveyard; this turn, Fiend and Zombie monsters you currently control gain 100 ATK/DEF for each monster in your Graveyard
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_FIEND+RACE_ZOMBIE),tp,LOCATION_MZONE,0,1,nil) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsRace,RACE_FIEND+RACE_ZOMBIE),tp,LOCATION_MZONE,0,nil)
	local mg=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)*100
	for tc in aux.Next(g) do
		tc:UpdateAttack(mg,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,c)
		tc:UpdateDefense(mg,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,c)		
	end
end