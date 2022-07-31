--Doma The Angel of Silence
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.aclimit1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.econ1)
	e3:SetValue(s.elimit)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetOperation(s.aclimit3)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCondition(s.econ2)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
end

--If each player has the same number of Spells in their Graveyards (min. 1), you can Special Summon this card from your hand
function s.spcon(e,c)
	if c==nil then return true end
	local spellTp = Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)
	local spellOp = Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),0,LOCATION_GRAVE,nil,TYPE_SPELL)	
	return spellTp > 0 and spellTp == spellOp
end

--Each player can only activate 1 Spell/Trap per turn
function s.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_CONTROL+RESET_PHASE+PHASE_END,0,1)
end
function s.econ1(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	e:GetHandler():RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_CONTROL+RESET_PHASE+PHASE_END,0,1)
end
function s.econ2(e)
	return e:GetHandler():GetFlagEffect(id+1)~=0
end
function s.elimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
