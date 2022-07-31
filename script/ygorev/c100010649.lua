--Zera Ritual
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=aux.FilterBoolFunction(Card.IsCode,100010529),matfilter=s.mfilter,forcedselection=s.forcedselection,location=LOCATION_HAND+LOCATION_DECK})
	c:RegisterEffect(e1)
end
s.listed_names={100010529}
function s.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) 
end
function s.cfilter1(c,g,tp)
	return c:IsRace(RACE_FIEND)
end
function s.cfilter2(c,g,tp)
	return c:IsRace(RACE_WARRIOR)
end
function s.forcedselection(e,tp,sg,sc)
	return sg:IsExists(s.cfilter1,1,nil) and sg:IsExists(s.cfilter2,1,nil)
end


