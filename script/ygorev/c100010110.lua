--Ameba
local s,id=GetID()
function s.initial_effect(c)
	--If this card is discarded by an opponent's card effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.drcon)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	--Discarded from hand or deck by opp effect
	return (tp~=rp and tp==e:GetLabel()) and ((e:GetHandler():IsPreviousLocation(LOCATION_HAND) and (r&0x4040)==0x4040)or (e:GetHandler():IsPreviousLocation(LOCATION_DECK) and (r&REASON_EFFECT)~=0 and rp==1-tp))
end

--Inflict 2000 damage to your opponent
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,2000,REASON_EFFECT)
end