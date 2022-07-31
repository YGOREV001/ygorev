--YGOREV Rules
local s,id=GetID()
local ctr=0
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.init)
end
function s.init(c)
	--summon face-up defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LIGHT_OF_INTERVENTION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
	--tribute summon lv7 or higher by using Tribute Summoned monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetCondition(s.otcon1)
	e2:SetTarget(aux.FieldSummonProcTg(s.ottg,s.sumtg1))
	e2:SetOperation(s.otop)
	e2:SetValue(SUMMON_TYPE_TRIBUTE)
	Duel.RegisterEffect(e2,0)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	Duel.RegisterEffect(e3,0)
	--tribute summon lv7 or higher by using field+hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e4:SetCondition(s.otcon2)
	e4:SetTarget(aux.FieldSummonProcTg(s.ottg,s.sumtg2))
	e4:SetOperation(s.otop)
	e4:SetValue(SUMMON_TYPE_NORMAL)
	Duel.RegisterEffect(e4,0)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	Duel.RegisterEffect(e5,0)
end
function s.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.spcheck(sg,tp)
	return aux.ReleaseCheckMMZ(sg,tp) and sg:IsExists(s.chk,1,nil,sg)
end
function s.chk(c,sg)
	return c:IsLocation(LOCATION_MZONE) and sg:IsExists(s.trfilter2,1,c)
end
function s.trfilter2(c)
	return c:IsLocation(LOCATION_HAND)  and c~=ctr
end
function s.otcon1(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckReleaseGroupCost(tp,s.otfilter,1,true,nil,nil)
end
function s.otcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckReleaseGroupCost(tp,Card.IsAbleToGrave,2,true,s.spcheck,c)
end
function s.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	ctr=c
	return mi<=2 and ma>=2 
end
function s.sumtg1(e,tp,eg,ep,ev,re,r,rp,c)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.otfilter,1,true,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.otfilter,1,1,true,nil,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end		
	return false
end
function s.sumtg2(e,tp,eg,ep,ev,re,r,rp,c)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsAbleToGrave,2,true,s.spcheck,c) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsAbleToGrave,2,2,true,s.spcheck,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end		
	return false
end
function s.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if not sg then return end
	Duel.Release(sg,REASON_COST)
	sg:DeleteGroup()
end