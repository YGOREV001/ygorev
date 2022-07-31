--Turtle Oath
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=aux.FilterBoolFunction(Card.IsCode,100010526),matfilter=s.mfilter,forcedselection=s.forcedselection,location=LOCATION_HAND+LOCATION_DECK})
	c:RegisterEffect(e1)
end
s.listed_names={100010526}
function s.mfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) 
end
function s.cfilter(c,g,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_MZONE) 
end
function s.forcedselection(e,tp,sg,sc)
	return sg:IsExists(s.cfilter,1,nil)
end


