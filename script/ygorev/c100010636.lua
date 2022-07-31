--Commencement Dance
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc(c,RITPROC_GREATER,aux.FilterBoolFunction(Card.IsCode,100010538),nil,nil,nil,nil,s.mfilter,nil,LOCATION_HAND+LOCATION_DECK)
	c:RegisterEffect(e1)
end
s.listed_names={100010538}
function s.mfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) 
end


