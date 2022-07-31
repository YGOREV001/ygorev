--Hard Armor
local s,id=GetID()
function s.initial_effect(c)
	--Equip only to a Warrior monster
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR))
	--ATK increase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(400)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)		
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(s.desreptg)
	e5:SetOperation(s.desrepop)
	c:RegisterEffect(e5)
end

function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return tg 
		and tg:IsReason(REASON_BATTLE+REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end

--f the equipped monster would be destroyed by battle or by a card effect, you can destroy this card instead
function s.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand() and not c:IsCode(id)
end

function s.desrepop(e,tp,eg,ep,ev,re,r,rp)		
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) then	
		-- you can add 1 Equip Spell from your Deck to your hand, except "Hard Armor"
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end			
		end
	end	
end