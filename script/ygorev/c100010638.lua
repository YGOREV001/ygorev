--Fiendish Mirror Ritual
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=aux.FilterBoolFunction(Card.IsCode,100010531),matfilter=s.mfilter,forcedselection=s.forcedselection,location=LOCATION_HAND+LOCATION_DECK})
	c:RegisterEffect(e1)
end
s.listed_names={100010531}
function s.mfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) 
end
function s.forcedselection(e,tp,sg,sc)
	return sg:IsExists(Card.IsRace,1,nil,RACE_FIEND)
end


