--Ancient Lamp
local s,id=GetID()
local YGOREV_CARD_LAJINNMTMGENIEOTL=100015021
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--When your opponent declares a direct attack
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function s.spfilter(c,e,tp)
	return c:IsCode(YGOREV_CARD_LAJINNMTMGENIEOTL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--Target 1 monster your opponent controls, except the attacking monster
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local label=e:GetLabel()
	local bc=Duel.GetAttacker()
	local excg=Group.FromCards(bc)
	local dc=Duel.GetAttackTarget()
	if dc then excg:AddCard(dc) end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and not excg:IsContains(chkc) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,excg) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,excg)
end
--Attacks it instead
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	local bc=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()	
	if bc:CanAttack() and not bc:IsImmuneToEffect(e)
		and tc and tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then
		Duel.CalculateDamage(bc,tc)		
		--Special Summon 1 "La Jinn the Mystical Genie of the Lamp" from your hand or Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end	
end