--Tao the Chanter
local s,id=GetID()
function s.initial_effect(c)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.adjustop)
	c:RegisterEffect(e2)
	--cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetLabel(0)
	e3:SetValue(s.actlimit)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
end
function s.actlimit(e,te,tp)
	if not te:IsHasType(EFFECT_TYPE_ACTIVATE) or not te:IsActiveType(TYPE_SPELL) then return false end
	if tp==e:GetHandlerPlayer() then return e:GetLabel()==1
	else return e:GetLabel()==2 end
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_SPELL)
	local te=e:GetLabelObject()
	if b1>b2 then te:SetLabel(1)
	elseif b2>b1 then te:SetLabel(2)
	else te:SetLabel(0) end
end
