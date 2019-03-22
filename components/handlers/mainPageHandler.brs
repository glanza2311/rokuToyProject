
sub init()
  m.http = NewHttp("",invalid,"GET")
  m.top.functionName = "getContent"
end sub

'function that connects to the API to get de shows data
sub getContent()
  print "mainPageHandler.brs - [getContent]"
  m.url = "http://api.tvmaze.com/shows"
  m.http = NewHttp(m.url,invalid,"GET")
  m.http.AddHeader("X-Roku-Reserved-Dev-Id", "")
  rsp = httpGet(m.http,"timeout",10)

  if m.http.GetResponseCode() <> 200 then
    print "Error trying to get the response, ResponseCode:", m.http.GetResponseCode()
  else 'the Response Code was 200(OK)'
    response = ParseJson(rsp) 'parse a string and return a BrightScript Object (JSON)
    if response = invalid or type(response) <> "roArray" then
      print "The response is invalid"
    else
      setContent(response)
    end if
  end if
end sub

'Set the response returned from the API on the content field
function setContent(response)
  print "mainPageHandler.brs - [setContent]"
  shows = []
  for each showData in response
    shows.push(showData)
  end for
  m.top.content = { "Shows": shows }
end function
