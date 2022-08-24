--Cyber Shield
local s,id=GetID()
local YGOREV_CARD_HARPIELADY=100015004
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--The equipped monster gains 400 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(400)
	c:RegisterEffect(e1)	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetCondition(s.eqcon)
	e3:SetTarget(s.reptg)
	e3:SetOperation(s.repop)
	e3:SetValue(1)
	c:RegisterEffect(e3)	
end
s.listed_names={YGOREV_CARD_HARPIELADY}
--if "Harpie Lady" is the equipped monster, this card gains the following effects
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return ec and ec:IsCode(YGOREV_CARD_HARPIELADY)
end
--At the start of the Damage Step, if the equipped monster attacks a Level 6 or lower monster: You can destroy that monster
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	return Duel.GetAttacker()==c and bc and bc:IsControler(1-tp) and bc:IsFaceup() and bc:IsLevelBelow(6) and c:IsCode(YGOREV_CARD_HARPIELADY)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local bc=ec:GetBattleTarget()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
--If the equipped monster would be destroyed, you can destroy this card instead
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

