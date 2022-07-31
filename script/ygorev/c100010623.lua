--Soul of the Pure
local s,id=GetID()
local tratk=0
local trdef=0
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

--Tribute 1 monster
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,nil,1,1,false,nil,nil)
	tratk=g:GetFirst():GetAttack()
	trdef=g:GetFirst():GetDefense()
	Duel.Release(g,REASON_COST)	
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if tratk>1000 or trdef>1000 then
		--Draw 1 card for each 1000 ATK the Tributed monster had on the field
		Duel.Draw(tp,math.floor(tratk/1000),REASON_EFFECT)	
		--Gain 1000 LP for each 1000 DEF the Tributed monster had on the field
		Duel.Recover(tp,math.floor(trdef/1000)*1000,REASON_EFFECT)
	end
end

