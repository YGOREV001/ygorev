--Mask of Light & Darkness
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
	--ATK up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.atkcon1)
	e1:SetValue(s.atkval1)
	c:RegisterEffect(e1)
	--ATK down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.atkcon2)
	e2:SetValue(s.atkval2)
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

--While your LP is higher than your opponent's, this card gains ATK equal to the difference (max. 2000)  
function s.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local cont=c:GetControler()
	return Duel.GetLP(cont)-Duel.GetLP(1-cont)>0
end
function s.atkval1(e,c)
	local cont=c:GetControler()
	local lpdif=Duel.GetLP(cont)-Duel.GetLP(1-cont)
	if lpdif>2000 then lpdif=2000 end
	return lpdif
end
--While your LP is lower than your opponent's, monsters your opponent controls lose ATK equal to the difference (max. 2000)  
function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cont=c:GetControler()
	return Duel.GetLP(1-cont)-Duel.GetLP(cont)>0
end
function s.atkval2(e,c)
	local cont=c:GetControler()
	local lpdif=Duel.GetLP(1-cont)-Duel.GetLP(cont)
	if lpdif>2000 then lpdif=2000 end
	return lpdif
end

--Card Effects--END
