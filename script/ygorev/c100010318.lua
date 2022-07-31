--Dig Beak
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon and return a target to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
end

--When a Reptile monster you control is targeted by an attack
function s.spcon(e,tp,eg,ep,ev,re,r,rp)		
	local at=eg:GetFirst()
	if at:IsFaceup() and at:IsControler(tp) and at:IsRace(RACE_REPTILE) and at:IsFaceup() then
		e:GetLabelObject():Clear()
		e:GetLabelObject():Merge(at)
		return true
	end
	return false
end
--Special Summon this card from your hand
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local tc=e:GetLabelObject():GetFirst()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)	
		--Return the targeted monster to the hand
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		--Change the battle position of the attacking monster
		if at:IsRelateToBattle() then
			Duel.ChangePosition(at,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
		end
	end
end
