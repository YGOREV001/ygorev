--Garma Sword Union
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc(c,RITPROC_EQUAL,aux.FilterBoolFunction(Card.IsCode,100010536),nil,nil,nil,nil,s.mfilter,nil,LOCATION_HAND+LOCATION_DECK)
	c:RegisterEffect(e1)
end
s.listed_names={100010536}
function s.mfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) 
end


