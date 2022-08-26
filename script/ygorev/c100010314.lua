--Beaked Snake
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon and return a target to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
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

--When a Reptile monster you control is targeted by a card effect
function s.thfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsRace(RACE_REPTILE) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)	
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or #tg==0 then return false end
	local cg=tg:Filter(s.thfilter,nil,tp)
	if #cg>0 then
		e:GetLabelObject():Clear()
		e:GetLabelObject():Merge(cg)
		return true
	end
	return false
end
--Special Summon this card from your hand
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetFirst()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)	
		--Negate the effect
		Duel.NegateActivation(ev)
	end
end
