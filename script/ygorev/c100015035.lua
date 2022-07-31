--Exodia the Forbidden One
local s,id=GetID()
local YGOREV_CARD_LEFTARMOTFO=100015036
local YGOREV_CARD_LEFTLEGOTFO=100015037
local YGOREV_CARD_RIGHTARMOTFO=100015038
local YGOREV_CARD_RIGHTLEGOTFO=100015039
function s.initial_effect(c)
	--Cannot be Special Summoned
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--win	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(s.winop)
	c:RegisterEffect(e2)
end
s.listed_names={YGOREV_CARD_LEFTARMOTFO,YGOREV_CARD_LEFTLEGOTFO,YGOREV_CARD_RIGHTARMOTFO,YGOREV_CARD_RIGHTLEGOTFO}

--If you control this card, "Left Arm of the Forbidden One", "Left Leg of the Forbidden One", "Right Arm of the Forbidden One" and "Right Leg of the Forbidden One", you win the Duel
function s.check(g)
	local a1=false
	local a2=false
	local a3=false
	local a4=false
	local a5=false
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		if code==YGOREV_CARD_LEFTARMOTFO then a1=true
			elseif code==YGOREV_CARD_LEFTLEGOTFO then a2=true
			elseif code==YGOREV_CARD_RIGHTARMOTFO then a3=true
			elseif code==YGOREV_CARD_RIGHTLEGOTFO then a4=true
			elseif code==id then a5=true
		end
	end
	return a1 and a2 and a3 and a4 and a5
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local wtp=s.check(g1)
	local wntp=s.check(g2)
	if wtp and not wntp then
		Duel.Win(tp,WIN_REASON_EXODIA)
	elseif not wtp and wntp then
		Duel.Win(1-tp,WIN_REASON_EXODIA)
	elseif wtp and wntp then
		Duel.Win(PLAYER_NONE,WIN_REASON_EXODIA)
	end
end
