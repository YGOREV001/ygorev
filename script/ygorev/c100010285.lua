--Trent
local s,id=GetID()
local YGOREV_CARD_FOREST = 100010587
function s.initial_effect(c)
	--If "Forest" is on the field, you can Normal Summon this card without Tributing. 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	--[OPT] If this card is Summoned: Each player can target 1 Level 4 or lower Normal Monster from their Graveyards (if able); Special Summon them.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)	
	e2:SetTarget(s.sstg)
	e2:SetOperation(s.ssop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
s.listed_names={YGOREV_CARD_FOREST}
function s.ffilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_FOREST)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.ffilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

function s.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--Each player can target 1 Level 4 or lower Normal Monster from their Graveyards (if able)
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(1-tp,s.filter,1-tp,LOCATION_GRAVE,0,1,1,nil,e,1-tp)
	if #g1>0 and #g2>0 then
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,PLAYER_ALL,g1:GetFirst():GetOwner())
	elseif #g1>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	elseif #g2>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,1,0)
	end
end

--Special Summon them
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetCards(e)
	if #sg==0 then return end
	for tc in sg:Iter() do
		if Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)>0 then
			local sp=tc:GetControler()
			Duel.SpecialSummonStep(tc,0,sp,sp,false,false,POS_FACEUP)
		end
	end
	Duel.SpecialSummonComplete()
end