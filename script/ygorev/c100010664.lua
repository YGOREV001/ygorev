--Acid Trap Hole
local s,id=GetID()
function s.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.filter(c,tp,ep)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:GetLevel()>=6 and c:GetSummonPlayer()~=tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if not eg then return false end
	local tc=eg:GetFirst()
	if chkc then return chkc==tc end
	if chk==0 then return s.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
