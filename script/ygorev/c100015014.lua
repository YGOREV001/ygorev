--Remnants Devourer
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(s.rmcon)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsRace,1,false,1,true,c,c:GetControler(),nil,false,nil,RACE_DINOSAUR)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,false,true,true,c,nil,nil,false,nil,RACE_DINOSAUR)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
--If this card destroys a monster by battle: Banish it, and if you do, this card gains ATK equal to the Level of the destroyed monster x100
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsAbleToRemove() then
		if Duel.Remove(bc,POS_FACEUP,REASON_EFFECT) then			
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(bc:GetLevel()*100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end

