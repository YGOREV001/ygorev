--Dark Magic Ritual
local s,id=GetID()
local YGOREV_CARD_DARKMAGICIAN=100010344
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=aux.FilterBoolFunction(Card.IsCode,100015060),matfilter=s.mfilter,forcedselection=s.forcedselection,location=LOCATION_HAND+LOCATION_DECK})
	c:RegisterEffect(e1)
end
s.listed_names={100015060}
function s.mfilter(c)
	return c:IsLocation(LOCATION_MZONE+LOCATION_HAND) 
end
function s.cfilter1(c,g,tp)
	return c:IsCode(YGOREV_CARD_DARKMAGICIAN)
end
function s.forcedselection(e,tp,sg,sc)
	return sg:IsExists(s.cfilter1,1,nil)
end


