--Dung Beetle
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

--If a card(s) is sent to the Graveyard
function s.filter1(c,tp)
	return c:GetOwner()==1-tp
end
function s.filter2(c,tp)
	return c:GetOwner()==tp
end

--This card gains 100 ATK/DEF for each
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local d1=eg:FilterCount(s.filter1,nil,tp)*100
		local d2=eg:FilterCount(s.filter2,nil,tp)*100
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(d1+d2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
	Duel.RDComplete()
end
