--Prevent Rat
local s,id=GetID()
function s.initial_effect(c)
	--def UP
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(s.valUp)
	c:RegisterEffect(e1)
	--def DOWN
	local e2=e1:Clone()
	e2:SetValue(s.valDown)
	c:RegisterEffect(e2)
end

--Gains 100 DEF for each card you control.
function s.valUp(e,c)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)*100 
end

--Loses 200 DEF for each card your opponent controls.
function s.valDown(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)* -200
end
