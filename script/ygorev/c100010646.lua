--Resurrection of Chakra
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=aux.FilterBoolFunction(Card.IsCode,100010530),forcedselection=s.forcedselection,location=LOCATION_HAND+LOCATION_DECK})
	c:RegisterEffect(e1)
end
s.listed_names={100010530}
function s.mfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) 
end

function s.forcedselection(e,tp,sg,sc)
	return sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end


