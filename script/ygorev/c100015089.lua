--Illusion Ritual
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=aux.FilterBoolFunction(Card.IsCode,100015059),matfilter=s.mfilter,forcedselection=s.forcedselection,location=LOCATION_HAND+LOCATION_DECK})
	c:RegisterEffect(e1)
end
function s.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) 
end
function s.cfilter1(c,g,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetLevel()==1
end
function s.forcedselection(e,tp,sg,sc)
	return sg:IsExists(s.cfilter1,1,nil)
end


