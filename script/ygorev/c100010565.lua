--Germ Infection
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.NOT(aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE)))
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--register
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_EQUIP)
	e3:SetOperation(s.regop)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--atkdown
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetLabelObject(e1)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,id)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
end

--Loses 300 ATK/DEF during each End Phase
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsContains(e:GetHandler()) then return end
	local pe=e:GetLabelObject()
	pe:SetValue(0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)	
	local ec=e:GetHandler():GetEquipTarget()
	local preatk=ec:GetAttack()	
	local pe=e:GetLabelObject()
	local atk=pe:GetValue()
	pe:SetValue(atk-300)	
	local curatk=ec:GetAttack()
	
	--if its ATK or DEF has been reduced to 0 as a result, destroy the equipped monster
	local dg=Group.CreateGroup()	
	if preatk~=0 and curatk==0 then dg:AddCard(ec) end	
	Duel.Destroy(dg,REASON_EFFECT)	
end

--If this card equipped to a monster is destroyed and sent to the Graveyard: Add this card to your hand
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

