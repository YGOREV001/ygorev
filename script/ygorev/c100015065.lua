--Toon Shining Palace
local s,id=GetID()
local YGOREV_CARD_TOONWORLD = 100015066
function s.initial_effect(c)
	-- Activate
	--You can only control 1 "Toon Shining Palace"
	c:SetUniqueOnField(1,0,id)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Toon monsters you control gain 400 ATK/DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOON))
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Cost Change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_LPCOST_CHANGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.costchange)
	c:RegisterEffect(e4)
	--If "Toon World" would be destroyed by an opponent's card effect, you can destroy this card instead
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(s.reptg)
	e5:SetValue(s.repval)
	c:RegisterEffect(e5)
	--If you do not control "Toon World", destroy this card
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetCondition(s.descon)
	c:RegisterEffect(e6)
end

s.listed_names={YGOREV_CARD_TOONWORLD}

--You pay 400 LP for "Toon World" maintenance cost instead
function s.costchange(e,re,rp,val)
	if re and re:GetHandler():IsCode(YGOREV_CARD_TOONWORLD) then
		return 400
	else
		return val
	end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsCode(YGOREV_CARD_TOONWORLD) and c:GetReasonPlayer()~=tp
	and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(s.repfilter,nil,tp)
		if #g==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function s.repval(e,c)
	return c==e:GetLabelObject()
end
function s.descon(e)
	return not Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,YGOREV_CARD_TOONWORLD),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
