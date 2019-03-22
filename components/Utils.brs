
'******************************************************
'Registry Helper Functions
'******************************************************
Function RegRead(key, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key) then return sec.Read(key)
    return invalid
End Function

Function RegWrite(key, val, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
    sec.Flush() 'commit it
End Function

Function RegDelete(key, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Delete(key)
    sec.Flush()
End Function


'******************************************************
'Insertion Sort
'Will sort an array directly, or use a key function
'******************************************************
Sub Sort(A as Object, key=invalid as dynamic)

    if type(A)<>"roArray" then return

    if (key=invalid) then
        for i = 1 to A.Count()-1
            value = A[i]
            j = i-1
            while j>= 0 and A[j] > value
                A[j + 1] = A[j]
                j = j-1
            end while
            A[j+1] = value
        next

    else
        if type(key)<>"Function" then return
        for i = 1 to A.Count()-1
            valuekey = key(A[i])
            value = A[i]
            j = i-1
            while j>= 0 and key(A[j]) > valuekey
                A[j + 1] = A[j]
                j = j-1
            end while
            A[j+1] = value
        next

    end if

End Sub

' insert value into array
sub SortedInsert(A as object, value as string)
    count = a.count()
    a.push(value)       ' use push to make sure array size is correct now
    if count = 0
        return
    endif
    ' should do a binary search, but at least this is better than push and sort
    for i = count-1 to 0 step -1
        if value >= a[i]
            a[i+1] = value
            return
        endif
        a[i+1] = a[i]
    end for
    a[0] = value
end sub

sub internalQSort(A as Object, left as integer, right as integer)
    i = left
    j = right
    pivot = A[(left+right)/2]
    while i <= j
        while A[i] < pivot
            i = i + 1
        end while
        while A[j] > pivot
            j = j - 1
        end while
        if (i <= j)
            tmp = A[i]
            A[i] = A[j]
            A[j] = tmp
            i = i + 1
            j = j - 1
        end if
    end while
    if (left < j)
        internalQSort(A, left, j)
    endif
    if (i < right)
        internalQSort(A, i, right)
    end if
end sub

sub internalKeyQSort(A as Object, key as dynamic, left as integer, right as integer)
    i = left
    j = right
    pivot = key(A[(left+right)/2])
    while i <= j
        while key(A[i]) < pivot
            i = i + 1
        end while
        while key(A[j]) > pivot
            j = j - 1
        end while
        if (i <= j)
            tmp = A[i]
            A[i] = A[j]
            A[j] = tmp
            i = i + 1
            j = j - 1
        end if
    end while
    if (left < j)
        internalKeyQSort(A, key, left, j)
    endif
    if (i < right)
        internalKeyQSort(A, key, i, right)
    end if
end sub

'******************************************************
'Quick Sort
'Will sort an array directly, or use a key function
'******************************************************
Sub QuickSort(A as Object, key=invalid as dynamic)
    if type(A)<>"roArray" then return
    ' weed out trivial arrays
    if A.count() < 2 then return

    if (key=invalid) then
        internalQSort(A, 0, A.count() - 1)
    else
        if type(key)<>"Function" then return

        internalKeyQSort(A, key, 0, A.count() - 1)
    end if
End Sub


'******************************************************
'Convert anything to a string
'
'Always returns a string
'******************************************************
Function tostr(any)
    ret = AnyToString(any)
    if ret = invalid ret = type(any)
    if ret = invalid ret = "unknown" 'failsafe
    return ret
End Function


'******************************************************
'Get a " char as a string
'******************************************************
Function Quote()
    q$ = Chr(34)
    return q$
End Function


'******************************************************
'isxmlelement
'
'Determine if the given object supports the ifXMLElement interface
'******************************************************
Function isxmlelement(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifXMLElement") = invalid return false
    return true
End Function


'******************************************************
'islist
'
'Determine if the given object supports the ifList interface
'******************************************************
Function islist(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifArray") = invalid return false
    return true
End Function


'******************************************************
'isint
'
'Determine if the given object supports the ifInt interface
'******************************************************
Function isint(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifInt") = invalid return false
    return true
End Function

'******************************************************
'isfunc
'******************************************************
Function isfunc(obj as dynamic) As Boolean
    tf = type(obj)
    return tf="Function" or tf="roFunction"
End Function

'******************************************************
' validstr
'
' always return a valid string. if the argument is
' invalid or not a string, return an empty string
'******************************************************
Function validstr(obj As Dynamic) As String
    if isnonemptystr(obj) return obj
    return ""
End Function


'******************************************************
'isstr
'
'Determine if the given object supports the ifString interface
'******************************************************
Function isstr(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifString") = invalid return false
    return true
End Function


'******************************************************
'isnonemptystr
'
'Determine if the given object supports the ifString interface
'and returns a string of non zero length
'******************************************************
Function isnonemptystr(obj)
    if isnullorempty(obj) return false
    return true
End Function


'******************************************************
'isnullorempty
'
'Determine if the given object is invalid or supports
'the ifString interface and returns a string of non zero length
'******************************************************
Function isnullorempty(obj)
    if obj = invalid return true
    if not isstr(obj) return true
    if Len(obj) = 0 return true
    return false
End Function


'******************************************************
'isbool
'
'Determine if the given object supports the ifBoolean interface
'******************************************************
Function isbool(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifBoolean") = invalid return false
    return true
End Function


'******************************************************
'isfloat
'
'Determine if the given object supports the ifFloat interface
'******************************************************
Function isfloat(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifFloat") = invalid return false
    return true
End Function


'******************************************************
'strtobool
'
'Convert string to boolean safely. Don't crash
'Looks for certain string values
'******************************************************
Function strtobool(obj As dynamic) As Boolean
    if obj = invalid return false
    if type(obj) <> "roString" return false
    o = strTrim(obj)
    o = Lcase(o)
    if o = "true" return true
    if o = "t" return true
    if o = "y" return true
    if o = "1" return true
    return false
End Function


'******************************************************
'itostr
'
'Convert int to string. This is necessary because
'the builtin Stri(x) prepends whitespace
'******************************************************
Function itostr(i As Integer) As String
    str = Stri(i)
    return strTrim(str)
End Function


'******************************************************
'Get remaining hours from a total seconds
'******************************************************
Function hoursLeft(seconds As Integer) As Integer
    hours% = seconds / 3600
    return hours%
End Function


'******************************************************
'Get remaining minutes from a total seconds
'******************************************************
Function minutesLeft(seconds As Integer) As Integer
    hours% = seconds / 3600
    mins% = seconds - (hours% * 3600)
    mins% = mins% / 60
    return mins%
End Function


'******************************************************
'Pluralize simple strings like "1 minute" or "2 minutes"
'******************************************************
Function Pluralize(val As Integer, str As String) As String
    ret = itostr(val) + " " + str
    if val <> 1 ret = ret + "s"
    return ret
End Function


'******************************************************
'Trim a string
'******************************************************
Function strTrim(str As String) As String
    st=CreateObject("roString")
    st.SetString(str)
    return st.Trim()
End Function


'******************************************************
'Tokenize a string. Return roList of strings
'******************************************************
Function strTokenize(str As String, delim As String) As Object
    st=CreateObject("roString")
    st.SetString(str)
    return st.Tokenize(delim)
End Function


'******************************************************
'Replace substrings in a string. Return new string
'******************************************************
Function strReplace(basestr As String, oldsub As String, newsub As String) As String
    newstr = ""

    i = 1
    while i <= Len(basestr)
        x = Instr(i, basestr, oldsub)
        if x = 0 then
            newstr = newstr + Mid(basestr, i)
            exit while
        endif

        if x > i then
            newstr = newstr + Mid(basestr, i, x-i)
            i = x
        endif

        newstr = newstr + newsub
        i = i + Len(oldsub)
    end while

    return newstr
End Function


'******************************************************
'Get all XML subelements by name
'
'return list of 0 or more elements
'******************************************************
Function GetXMLElementsByName(xml As Object, name As String) As Object
    list = CreateObject("roArray", 100, true)
    if islist(xml.GetBody()) = false return list

    for each e in xml.GetBody()
        if e.GetName() = name then
            list.Push(e)
        endif
    next

    return list
End Function


'******************************************************
'Get all XML subelement's string bodies by name
'
'return list of 0 or more strings
'******************************************************
Function GetXMLElementBodiesByName(xml As Object, name As String) As Object
    list = CreateObject("roArray", 100, true)
    if islist(xml.GetBody()) = false return list

    for each e in xml.GetBody()
        if e.GetName() = name then
            b = e.GetBody()
            if type(b) = "roString" list.Push(b)
        endif
    next

    return list
End Function


'******************************************************
'Get first XML subelement by name
'
'return invalid if not found, else the element
'******************************************************
Function GetFirstXMLElementByName(xml As Object, name As String) As dynamic
    if islist(xml.GetBody()) = false return invalid

    for each e in xml.GetBody()
        if e.GetName() = name return e
    next

    return invalid
End Function


'******************************************************
'Get first XML subelement's string body by name
'
'return invalid if not found, else the subelement's body string
'******************************************************
Function GetFirstXMLElementBodyStringByName(xml As Object, name As String) As dynamic
    e = GetFirstXMLElementByName(xml, name)
    if e = invalid return invalid
    if type(e.GetBody()) <> "roString" return invalid
    return e.GetBody()
End Function


'******************************************************
'Get the xml element as an integer
'
'return invalid if body not a string, else the integer as converted by strtoi
'******************************************************
Function GetXMLBodyAsInteger(xml As Object) As dynamic
    if type(xml.GetBody()) <> "roString" return invalid
    return strtoi(xml.GetBody())
End Function


'******************************************************
'Parse a string into a roXMLElement
'
'return invalid on error, else the xml object
'******************************************************
Function ParseXML(str As String) As dynamic
    if str = invalid return invalid
    xml=CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function


'******************************************************
'Get XML sub elements whose bodies are strings into an associative array.
'subelements that are themselves parents are skipped
'namespace :'s are replaced with _'s
'
'So an XML element like...
'
'<blah>
'    <This>abcdefg</This>
'    <Sucks>xyz</Sucks>
'    <sub>
'        <sub2>
'        ....
'        </sub2>
'    </sub>
'    <ns:doh>homer</ns:doh>
'</blah>
'
'returns an AA with:
'
'aa.This = "abcdefg"
'aa.Sucks = "xyz"
'aa.ns_doh = "homer"
'
'return an empty AA if nothing found
'******************************************************
Sub GetXMLintoAA(xml As Object, aa As Object)
    for each e in xml.GetBody()
        body = e.GetBody()
        if type(body) = "roString" then
            name = e.GetName()
            name = strReplace(name, ":", "_")
            aa.AddReplace(name, body)
        endif
    next
End Sub


'******************************************************
'Walk an AA and print it
'******************************************************
Sub PrintAA(aa as Object)
    print "---- AA ----"
    if aa = invalid
        print "invalid"
        return
    else
        cnt = 0
        for each e in aa
            x = aa[e]
            PrintAny(0, e + ": ", aa[e])
            cnt = cnt + 1
        next
        if cnt = 0
            PrintAny(0, "Nothing from for each. Looks like :", aa)
        endif
    endif
    print "------------"
End Sub


'******************************************************
'Walk a list and print it
'******************************************************
Sub PrintList(list as Object)
    print "---- list ----"
    PrintAnyList(0, list)
    print "--------------"
End Sub


'******************************************************
'Print an associativearray
'******************************************************
Sub PrintAnyAA(depth As Integer, aa as Object)
    for each e in aa
        x = aa[e]
        PrintAny(depth, e + ": ", aa[e])
    next
End Sub


'******************************************************
'Print a list with indent depth
'******************************************************
Sub PrintAnyList(depth As Integer, list as Object)
    i = 0
    for each e in list
        PrintAny(depth, "List(" + itostr(i) + ")= ", e)
        i = i + 1
    next
End Sub


'******************************************************
'Print anything
'******************************************************
Sub PrintAny(depth As Integer, prefix As String, any As Dynamic)
    if depth >= 10
        print "**** TOO DEEP " + itostr(5)
        return
    endif
    prefix = string(depth*2," ") + prefix
    depth = depth + 1
    str = AnyToString(any)
    if str <> invalid
        print prefix + str
        return
    endif
    if type(any) = "roAssociativeArray"
        print prefix + "(assocarr)..."
        PrintAnyAA(depth, any)
        return
    endif
    if islist(any) = true
        print prefix + "(list of " + itostr(any.Count()) + ")..."
        PrintAnyList(depth, any)
        return
    endif

    print prefix + "?" + type(any) + "?"
End Sub


'******************************************************
'Print an object as a string for debugging. If it is
'very long print the first 4000 chars.
'******************************************************
Sub Dbg(pre As Dynamic, o=invalid As Dynamic)
    p = AnyToString(pre)
    if p = invalid p = ""
    if o = invalid o = ""
    s = AnyToString(o)
    if s = invalid s = "???: " + type(o)
    if Len(s) > 4000
        s = Left(s, 4000)
    endif
    print p + s
End Sub


'******************************************************
'Try to convert anything to a string. Only works on simple items.
'
'Test with this script...
'
'    s$ = "yo1"
'    ss = "yo2"
'    i% = 111
'    ii = 222
'    f! = 333.333
'    ff = 444.444
'    d# = 555.555
'    dd = 555.555
'    bb = true
'
'    so = CreateObject("roString")
'    so.SetString("strobj")
'    io = CreateObject("roInt")
'    io.SetInt(666)
'    tm = CreateObject("roTimespan")
'
'    Dbg("", s$ ) 'call the Dbg() function which calls AnyToString()
'    Dbg("", ss )
'    Dbg("", "yo3")
'    Dbg("", i% )
'    Dbg("", ii )
'    Dbg("", 2222 )
'    Dbg("", f! )
'    Dbg("", ff )
'    Dbg("", 3333.3333 )
'    Dbg("", d# )
'    Dbg("", dd )
'    Dbg("", so )
'    Dbg("", io )
'    Dbg("", bb )
'    Dbg("", true )
'    Dbg("", tm )
'
'try to convert an object to a string. return invalid if can't
'******************************************************
Function AnyToString(any As Dynamic) As dynamic
    if any = invalid return "invalid"
    if isstr(any) return any
    if isint(any) return itostr(any)
    if isbool(any)
        if any = true return "true"
        return "false"
    endif
    if isfloat(any) return Str(any)
    if type(any) = "roTimespan" return itostr(any.TotalMilliseconds()) + "ms"
    return invalid
End Function


'******************************************************
'Walk an XML tree and print it
'******************************************************
Sub PrintXML(element As Object, depth As Integer)
    print tab(depth*3);"Name: [" + element.GetName() + "]"
    if invalid <> element.GetAttributes() then
        print tab(depth*3);"Attributes: ";
        for each a in element.GetAttributes()
            print a;"=";left(element.GetAttributes()[a], 4000);
            if element.GetAttributes().IsNext() then print ", ";
        next
        print
    endif

    if element.GetBody()=invalid then
        ' print tab(depth*3);"No Body"
    else if type(element.GetBody())="roString" then
        print tab(depth*3);"Contains string: [" + left(element.GetBody(), 4000) + "]"
    else
        print tab(depth*3);"Contains list:"
        for each e in element.GetBody()
            PrintXML(e, depth+1)
        next
    endif
    print
end sub


'******************************************************
'Dump the bytes of a string
'******************************************************
Sub DumpString(str As String)
    print "DUMP STRING"
    print "---------------------------"
    print str
    print "---------------------------"
    l = Len(str)-1
    i = 0
    for i = 0 to l
        c = Mid(str, i)
        val = Asc(c)
        print itostr(val)
    next
    print "---------------------------"
End Sub


'******************************************************
'Validate parameter is the correct type
'******************************************************
Function validateParam(param As Object, paramType As String,functionName As String, allowInvalid = false) As Boolean
    if type(param) = paramType then
        return true
    endif

    if allowInvalid = true then
        if type(param) = invalid then
            return true
        endif
    endif

    print "invalid parameter of type "; type(param); " for "; paramType; " in function "; functionName
    return false
End Function


Function wrap(num As Integer, size As Dynamic) As Integer
    ' wraps via mod if size works
    ' else just clips negatives to zero
    ' (sort of an indefinite size wrap where we assume
    '  size is at least num and punt with negatives)
    remainder = num
    if isint(size) and size<>0
        base = int(num/size)*size
        remainder = num - base
    else if num<0
        remainder = 0
    end if
    return remainder
End Function


Function gmdate(seconds as Dynamic) as Dynamic
  a   = seconds
  b   = 60
  c   = Fix(a / b)
  sec = a - b * c


 a   = Fix(a/60)
 b   = 60
 c   = Fix(a / b)
 min = a - b * c

 a   = Fix(a/60)
 b   = 60
 c   = Fix(a / b)
 hour = a - b * c

if sec >= 10
  longSec = sec.toStr()
  sec = Left(longSec, 2)
else
  sec = "0"+sec.toStr()
  sec = Left(sec, 2)
end if

 if min >= 10
  min = min.toStr()
 else
  min = "0"+min.toStr()
 end if

if hour >= 10
 hour = hour.toStr()
else
 hour = "0"+hour.toStr()
end if
 if hour = "00"
   ' code here
   tmes_string =  min+":"+sec
 else
   ' code here
   tmes_string =  hour+":"+min+":"+sec
 end if
 return tmes_string
End FUnction

Function dateNow()
  dt = CreateObject ("roDateTime")
  seconds = dt.AsSeconds()
  'if IsDSTNow()
  ''  seconds = seconds-(5*3600)
  'else
  ''  seconds = seconds-(6*3600)
  'end if
  ms = seconds.ToStr () + Right ("00" + dt.GetMilliseconds ().ToStr (), 3)
  return ms
End Function

Function dateAsSeconds()
  dt = CreateObject ("roDateTime")
  seconds = dt.AsSeconds()
  return seconds
End Function

Function dateISO(adjustment=0)
  adjust = adjustment*86400
  ' if IsDSTNow()
  '   adjust = adjust-(5*3600)
  ' else
  '   adjust = adjust-(6*3600)
  ' end if
  dt = CreateObject ("roDateTime")
  fixedDate = dt.AsSeconds()+adjust
  dt.fromSeconds(fixedDate)
  dateString = Left(dt.ToISOString(),10)
  regex = CreateObject("roRegex", "-","i")
  return regex.ReplaceAll(dateString,"")
End Function

Function getDeviceId(random=false)
  di = CreateObject("roDeviceInfo")
  if random
    deviceId = RegRead("deviceId")
    if deviceId = invalid
      newId = di.GetRandomUUID()
      RegWrite("deviceId",newId)
      return newId
    else
      return deviceId
    end if
  else
    return di.GetChannelClientId()
  end if
End Function

Function getDeviceModel()
  di = CreateObject("roDeviceInfo")
  return di.GetModel()
End Function

Function IsRIDADisabled()
  di = CreateObject("roDeviceInfo")
  return di.IsRIDADisabled()
End Function

Function getAdvertisingId(force=false)
  di = CreateObject("roDeviceInfo")
  if di.IsRIDADisabled() and not force
    return ""
  else
    return di.GetRIDA()
  end if
End Function

Function getAppVersion()
  di = CreateObject("roAppInfo")
  return di.GetVersion()
End Function

Function getAppID()
  di = CreateObject("roAppInfo")
  return di.GetID()
End Function

Function getDeviceVersion()
  di = CreateObject("roDeviceInfo")
  return di.GetVersion()
End Function

Function GetConnectionType()
  di = CreateObject("roDeviceInfo")
  return di.GetConnectionType()
End Function

'******************************************************************************
'**
'** Extract a string from an associative array returned by ParseJson
'** Return the default value if the field is missing, invalid or the wrong type
'**
'******************************************************************************
Function getString(json As Dynamic,fieldName As String,defaultValue="" As String) As String
    returnValue = defaultValue
    if json <> Invalid
        if type(json) = "roAssociativeArray" or GetInterface(json,"ifAssociativeArray") <> invalid
            fieldValue = json.LookupCI(fieldName)
            if fieldValue <> Invalid
                if type(fieldValue) = "roString" or type(fieldValue) = "String" or GetInterface(fieldValue,"ifString") <> Invalid
                    returnValue = fieldValue
                end if
            end if
        end if
    end if
    return returnValue
End Function

Function getObject(json As Dynamic,fieldName As String,defaultValue=invalid As Dynamic) As Dynamic
    returnValue = defaultValue
    if json <> Invalid
        if type(json) = "roAssociativeArray" or GetInterface(json,"ifAssociativeArray") <> invalid
            fieldValue = json.LookupCI(fieldName)
            if fieldValue <> Invalid
                if type(fieldValue) = "roAssociativeArray" or type(fieldValue) = "AssociativeArray" or GetInterface(fieldValue,"ifAssociativeArray") <> Invalid
                    returnValue = fieldValue
                end if
            end if
        end if
    end if
    return returnValue
End Function

Function getArray(json As Dynamic,fieldName As String,defaultValue=[] As Dynamic) As Dynamic
    returnValue = defaultValue
    if json <> Invalid
        if type(json) = "roAssociativeArray" or GetInterface(json,"ifAssociativeArray") <> invalid
            fieldValue = json.LookupCI(fieldName)
            if fieldValue <> Invalid
                if type(fieldValue) = "roArray" or type(fieldValue) = "Array" or GetInterface(fieldValue,"ifArray") <> Invalid
                    returnValue = fieldValue
                end if
            end if
        end if
    end if
    return returnValue
End Function

'******************************************************************************
'**
'** Extract an integer from an associative array returned by ParseJson
'** Return the default value if the field is missing, invalid or the wrong type
'**
'******************************************************************************
Function getInteger(json As Dynamic,fieldName As String,defaultValue=0 As Integer) As Integer
    returnValue = defaultValue
    if json <> Invalid
        if type(json) = "roAssociativeArray" or GetInterface(json,"ifAssociativeArray") <> invalid
            fieldValue = json.LookupCI(fieldName)
            if fieldValue <> Invalid
                if type(fieldValue) = "roInteger" or type(fieldValue) = "Integer" or type(fieldValue) = "roInt" or GetInterface(fieldValue,"ifInt") <> Invalid
                    returnValue = fieldValue
                end if
            end if
        end if
    end if
    return returnValue
End Function


function createButtonRowlist (elements as Dynamic, direction as String, fontSize,width,height )
  if direction = "horizontal"
    data = CreateObject("roSGNode", "ContentNode")
    row = data.CreateChild("ContentNode")
    for each item in elements
      ' code here
      button = row.CreateChild("ButtonNode")
      button.text = item
      button.fontSize = 30
      button.width = width
      button.height = height
      button.fontName = "FuturaLTPro-Bold"
    end for
          return data
  else direction = "vertical"
    data = CreateObject("roSGNode", "ContentNode")
    for i=0 to elements.count()-1 step 1
        row = data.CreateChild("ContentNode")
        button = row.CreateChild("ButtonNode")
        button.text = elements[i]
        button.fontSize = 30
        button.width = width
        button.height = height
        button.fontName = "FuturaLTPro-Bold"

    end for
    return data
  end if
end function

' Helper function to add and set fields of a content node
function AddAndSetFields(node as object, aa as object)
  'This gets called for every content node -- commented out since it's pretty verbose
  'print "UriHandler.brs - [AddAndSetFields]"
  addFields = {}
  setFields = {}
  for each field in aa
    if node.hasField(field)
      if aa[field] <> invalid
        if field = "contentType"

        else if field = "seasonNumber"

        else
          setFields[field] = aa[field]
        end if
      end if
    else
      addFields[field] = aa[field]
    end if
  end for
  node.setFields(setFields)
  node.addFields(addFields)
end function


function nodeToItem(node)
  item = CreateObject("roAssociativeArray")
  for each key in node.keys()
    if (key <> "change" and key <> "focusable" and key <> "focusedChild" and key <> "id" )
      item[key] = node[key]
    end if
  end for
  return item
end function

function startTimeAsHour(startTime)
  date = CreateObject("roDateTime")
  date.FROMISO8601String(startTime)
  date.ToLocalTime()
  hour = date.GetHours()
  min = date.GetMinutes()
  footer = "AM"
  if hour >= 12
    hour -= 12
    footer = "PM"
  end if
  if hour = 0
    hour = 12
  end if
  formattedHour = itostr(hour)
  formattedMin = itostr(min)
  if hour < 10
    formattedHour = "0" + formattedHour
  end if
  if min < 10
    formattedMin = "0" + formattedMin
  end if
  return formattedHour +":"+ formattedMin + footer
end function


function capitalize(text)
  if text = invalid
    return invalid
  end if
  sentence = LCase(text)
  words = sentence.Split(" ")
  result = ""
  for each word in words
    firstLetter = UCase(Left(word, 1))
    result += firstLetter + Mid(word, 2, Len(word)) + " "
  end for
  return strTrim(result)
end function


function createGridList(list,size)
 Parent = createObject("RoSGNode","ContentNode")
 for i = 0 to list[0].items.count()-1 step size
   row = createObject("RoSGNode","RowNode")
   if i = 0
     row.Title = UCase(list[0].title)
   end if
   for j = i to i + size-1
     if list[0].items[j] <> invalid
       item = createObject("RoSGNode","ItemNode")
       AddAndSetFields(item,list[0].items[j])
       row.appendChild(item)
     end if
   end for
   Parent.appendChild(row)
 end for
 return Parent
end function


function createRowList (list)
  RowsItem = createObject("RoSGNode","ContentNode")
  for each tempRow in list
    row = createObject("RoSGNode","RowNode")
    row.title = tempRow.title
    row.apiEndpoint = tempRow.apiEndpoint
    for each tempItem in tempRow.items
      item = createObject("RoSGNode","ItemNode")
      for each key in tempItem
        if key <> "primarybutton" and key <> "secondarybutton"
          item[key] = tempItem[key]
        else
          item[key] = itemToNode(tempItem[key],"ItemNode")
        end if
      end for
      row.appendChild(item)
    end for
    RowsItem.appendChild(row)
  end for
  return RowsItem
end function

function getImage(images,name,size)
  if type(images) <> "roArray" or images.count() = 0
    return "x"
  end if
  for each image in images
    if image.name = name
      for each imageSize in image.sizes
        if imageSize.size = size
          if imageSize.url <> "" and imageSize.url <> invalid
            return imageSize.url
          else
            return "x"
          end if
        end if
      end for
    end if
  end for
  return "x"
end function

function getObjectByProperty(objects,property,value)
  if type(objects) <> "roArray" or objects.count() = 0
    return "x"
  end if
  for each objectAA in objects
    if objectAA[property] <> invalid and objectAA[property] = value
      return objectAA
    end if
  end for
  return "x"
end function

function getIndexOfByProperty(objects,property,value)
  if type(objects) <> "roArray" or objects.count() = 0
    return -1
  end if
  for i=0 to objects.count()-1 step 1
    if objects[i][property] <> invalid and objects[i][property] = value
      return i
    end if
  end for
  return -1
end function

function parseItem (item,itemType, properties = {})
  r = CreateObject("roRegex", "&#39;", "i")
  r2 = CreateObject("roRegex", "(\r\n|\r|\n)", "")
  r3 = CreateObject("roRegex", "&amp;", "i")
  itemAA = CreateObject("roAssociativeArray")
  itemAA.isContinueWatching = properties.isContinueWatching
  if item.isHero <> invalid
    itemToParse = item.content
    if item.links <> invalid and item.links[0] <> invalid
      itemAA.primaryButton = {}
      itemAA.primaryButton.append(item)
      itemAA.primaryButton["tagline"] = item.title
      itemAA.primaryButton["editorialTagline"] = item.editorialTagline
      itemAA.primaryButton.append(item.content)
      itemAA.primaryButton["content"] = item.content.title
      itemAA.primaryButton.append(item.links[0])
      itemAA.primaryButton.fontSize = 22
      itemAA.primaryButton.focusedFontSize = 25
      itemAA.primaryButton.text = UCase(itemAA.primaryButton.title)
      itemAA.primaryButton.delete("title")
      itemAA.primaryButton.height = 52
      itemAA.primaryButton.fontName = "FuturaLTPro-Bold"
      itemAA.primaryButton.focusedFontName = "FuturaLTPro-Bold"
      itemAA.primaryButton.backgroundImage = getImage(itemToParse.images,"background","3x")
      itemAA.primaryButton.logoImage = getImage(itemToParse.images,"logo","2x")
      ' if item.links <> invalid and item.links[1] = invalid
      '   itemAA.secondaryButton = {}
      '   itemAA.secondaryButton.append(itemAA.primaryButton)
      '   itemAA.secondaryButton.fontName = "FuturaLTPro-Heavy"
      '   itemAA.secondaryButton.fontSize = 22
      '   itemAA.secondaryButton.focusedFontSize = 25
      '   itemAA.secondaryButton.height = 52
      '   itemAA.secondaryButton.text = "More Info"
      '   itemAA.secondaryButton.title = "More Info"
      ' end if
    end if
    if item.links <> invalid and item.links[1] <> invalid
      itemAA.secondaryButton = {}
      itemAA.secondaryButton.append(item)
      itemAA.secondaryButton["tagline"] = item.title
      itemAA.secondaryButton.append(item.content)
      itemAA.secondaryButton["content"] = item.content.title
      itemAA.secondaryButton.append(item.links[1])

      itemAA.secondaryButton.fontSize = 22
      itemAA.secondaryButton.focusedFontSize = 25
      itemAA.secondaryButton.text = itemAA.secondaryButton.title
      itemAA.secondaryButton.delete("title")
      itemAA.secondaryButton.height = 52
      itemAA.secondaryButton.fontName = "FuturaLTPro-Heavy"
      itemAA.secondaryButton.focusedFontName = "FuturaLTPro-Heavy"
      ' itemAA.secondaryButton.backgroundImage = getImage(itemToParse.images,"background","3x")
      ' itemAA.secondaryButton.logoImage = getImage(itemToParse.images,"logo","1x")
    end if
  else
    if properties.isContinueWatching <> invalid and properties.isContinueWatching = true and item.show <> invalid
      item.sectionTitle = item.title
      item.show.description = item.description
      episodeImagesIndex = getIndexOfByProperty(item.images,"name","landscape")
      showImagesIndex = getIndexOfByProperty(item.show.images,"name","background")
      item.show.images[showImagesIndex] = item.images[episodeImagesIndex]
      item.show.images[showImagesIndex].name = "background"
      item.show.Delete("trailer")
      item.Append(item.show)
      itemToParse = item
    else
      itemToParse = item
    end if
  end if
  for each key in itemToParse
    if key = "images"
      if itemType = "card"
        itemAA.primaryImage = getImage(itemToParse.images,"landscape","1x")
        if item.isHero <> invalid
          itemAA.secondaryImage = getImage(item.images,"banner5x2","3x")
          if itemAA.secondaryImage = "x"
            itemAA.secondaryImage = getImage(itemToParse.images,"landscape","3x")
          end if
        else
          itemAA.secondaryImage = getImage(itemToParse.images,"landscape","3x")
        end if
        itemAA.backgroundImage = getImage(itemToParse.images,"background","3x")
        itemAA.logoImage = getImage(itemToParse.images,"logo","1x")
        itemAA.feedPreviewImage = getImage(itemToParse.images,"landscape","1x")
      else if itemType = "poster"
        itemAA.primaryImage = getImage(itemToParse.images,"portrait","1x")
        itemAA.secondaryImage = getImage(itemToParse.images,"landscape","3x")
      end if
    else if key = "description" or key = "title"
      itemAA[key]=r.ReplaceAll(r2.ReplaceAll(r3.ReplaceAll(itemToParse[key],"&"),""), "'")
    else if key = "itemType" and itemType = "live"
      itemAA[key] = "live"
      itemAA["contentType"] = itemToParse.itemType
      itemAA["feedTitle"] = itemToParse.title
      itemAA.primaryImage = getImage(itemToParse.images,"landscape","1x")
      itemAA.secondaryImage = getImage(itemToParse.images,"landscape","3x")
      itemAA.backgroundImage = getImage(itemToParse.images,"background","3x")
      itemAA.logoImage = getImage(itemToParse.images,"logo","1x")
      itemAA.feedPreviewImage = getImage(itemToParse.images,"landscape","1x")
    else if key = "theme"
      itemAA.themeName = itemToParse.theme.themeName
      itemAA.themeColor = itemToParse.theme.themeColor
      itemAA.textColor = itemToParse.theme.textColor
    else if key = "content" or key = "links"

    else if key = "trailer"
      itemAA["videoUrl"] = itemToParse.trailer["videoUrl"]
      itemAA["trailerDuration"] = itemToParse.trailer["duration"]
    else
      itemAA[key] = itemToParse[key]
    end if
  end for
  return itemAA
end function



function itemToNode(item, nodeType = "ItemNode")
 itemAA = createObject("RoSGNode",nodeType)
 for each key in item
   itemAA[key] = item[key]
 end for
 return itemAA
end function


function month(name)
  if name = "Jan"
    return "01"
  else if name = "Feb"
    return "02"
  else if name = "Mar"
    return "03"
  else if name = "Apr"
    return "04"
  else if name = "May"
    return "05"
  else if name = "Jun"
    return "06"
  else if name = "Jul"
    return "07"
  else if name = "Aug"
    return "08"
  else if name = "Sep"
    return "09"
  else if name = "Oct"
    return "10"
  else if name = "Nov"
    return "11"
  else if name = "Dec"
    return "12"
  end if
end function


function airdateToSeconds(date)
  regex = CreateObject("roRegex", " ", "")
  airDate = regex.split(date)
  formatedAirDate = airDate[3]+"-"+month(airDate[2])+"-"+airDate[1]+" "+airDate[4]
  utc = strtoi(Left(airDate[5],3))*3600
  date = CreateObject("roDateTime")
  date.FROMISO8601String(formatedAirDate)
  seconds = date.AsSeconds()-utc

  return seconds
end function

function startTimeAsSeconds(startTime,timezone)
  date = CreateObject("roDateTime")
  date.FROMISO8601String(startTime)
  seconds = date.AsSeconds()
  ' if IsDSTNow() and timezone = "WEST"
  '   timezoneOffset=7
  ' else if not IsDSTNow() and timezone = "WEST"
  '   timezoneOffset=8
  ' else if IsDSTNow() and timezone = "EAST"
  '   timezoneOffset=4
  ' else if not IsDSTNow() and timezone = "EAST"
  '   timezoneOffset=5
  ' end if
  ' seconds = seconds+(timezoneOffset*3600)
  return seconds
end function

function startTimeAsDate(startTime)
  date = CreateObject("roDateTime")
  date.FROMISO8601String(startTime)
  date.ToLocalTime()
  result = itostr(date.GetHours())
  result += " : " + itostr(date.GetMinutes())
  ' if IsDSTNow() and timezone = "WEST"
  '   timezoneOffset=7
  ' else if not IsDSTNow() and timezone = "WEST"
  '   timezoneOffset=8
  ' else if IsDSTNow() and timezone = "EAST"
  '   timezoneOffset=4
  ' else if not IsDSTNow() and timezone = "EAST"
  '   timezoneOffset=5
  ' end if
  ' seconds = seconds+(timezoneOffset*3600)
  return seconds
end function


Function IsDSTNow () As Boolean

    dstNow = False

    tzList = {}
    ' diff - Local time minus GMT for the time zone
    ' dst  - False if the time zone never observes DST
    tzList ["US/Puerto Rico-Virgin Islands"]    = {diff: -4,    dst: False}
    tzList ["US/Guam"]                          = {diff: -10,   dst: False}
    tzList ["US/Samoa"]                         = {diff: -11,   dst: True}    ' Should be 13 [Workaround Roku bug]
    tzList ["US/Hawaii"]                        = {diff: -10,   dst: False}
    tzList ["US/Aleutian"]                      = {diff: -10,   dst: True}
    tzList ["US/Alaska"]                        = {diff: -9,    dst: True}
    tzList ["US/Pacific"]                       = {diff: -8,    dst: True}
    tzList ["US/Arizona"]                       = {diff: -7,    dst: False}
    tzList ["US/Mountain"]                      = {diff: -7,    dst: True}
    tzList ["US/Central"]                       = {diff: -6,    dst: True}
    tzList ["US/Eastern"]                       = {diff: -5,    dst: True}
    tzList ["Canada/Pacific"]                   = {diff: -8,    dst: True}
    tzList ["Canada/Mountain"]                  = {diff: -7,    dst: True}
    tzList ["Canada/Central Standard"]          = {diff: -6,    dst: False}
    tzList ["Canada/Central"]                   = {diff: -6,    dst: True}
    tzList ["Canada/Eastern"]                   = {diff: -5,    dst: True}
    tzList ["Canada/Atlantic"]                  = {diff: -4,    dst: True}
    tzList ["Canada/Newfoundland"]              = {diff: -3.5,  dst: True}
    tzList ["Europe/Iceland"]                   = {diff: 0,     dst: False}
    tzList ["Europe/Ireland"]                   = {diff: 0,     dst: True}
    tzList ["Europe/United Kingdom"]            = {diff: 0,     dst: True}
    tzList ["Europe/Portugal"]                  = {diff: 0,     dst: True}
    tzList ["Europe/Central European Time"]     = {diff: 1,     dst: True}
    tzList ["Europe/Greece/Finland"]            = {diff: 2,     dst: True}

    ' Get the Roku device's current time zone setting
    tz = CreateObject ("roDeviceInfo").GetTimeZone ()

    ' Look up in our time zone list - will return Invalid if time zone not listed
    tzEntry = tzList [tz]

    ' Return False if the current time zone does not ever observe DST, or if time zone was not found
    If tzEntry <> Invalid And tzEntry.dst
        ' Get the current time in GMT
        dt = CreateObject ("roDateTime")
        secsGmt = dt.AsSeconds ()

        ' Convert the current time to local time
        dt.ToLocalTime ()
        secsLoc = dt.AsSeconds ()

        ' Calculate the difference in seconds between local time and GMT
        secsDiff = secsLoc - secsGMT

        ' If the difference between local and GMT equals the difference in our table, then we're on standard time now
        dstDiff = tzEntry.diff * 60 * 60 - secsDiff
        If dstDiff < 0 Then dstDiff = -dstDiff

        dstNow = dstDiff > 1   ' Use 1 sec not zero as Newfoundland time is a floating-point value
    Endif

    Return dstNow

End Function

function getUTC(timezone)
  timezone_ = ""
  if IsDSTNow() and timezone = "WEST"
    timezone_="-700"
  else if not IsDSTNow() and timezone = "WEST"
    timezone_="-800"
  else if IsDSTNow() and timezone = "EAST"
    timezone_="-400"
  else if not IsDSTNow() and timezone = "EAST"
    timezone_="-500"
  end if
  return timezone_
end function

function normalizeString(input)
  r = CreateObject("roRegex", "&#39;", "i")
  r2 = CreateObject("roRegex", "&amp;", "i")
  r3 = CreateObject("roRegex", "&quot;", "i")
  if type(input) <> invalid
    return r.ReplaceAll(r2.ReplaceAll(r3.ReplaceAll(input,"''"),"&"), "'")
  else
    return ""
  end if
end function


function EncodeWatchingHistory(list)
  params = ""
  ander = ""
  pos% = 0
  for each item in list
    arrayString = "items["+itostr(pos%)+"][partnerApiId]="+item["partnerApiId"]
    arrayString = arrayString+"&items["+itostr(pos%)+"][progress]="+itostr(item["progress"])
    arrayString = arrayString+"&items["+itostr(pos%)+"][isAdPlaying]="+AnyToString(item["isAdPlaying"])
    params = params + ander + arrayString
    ander = "&"
    pos% = pos% + 1
  end for
  return params
end function


function liveRemainingTime(onNow,upNext,feed,resumed=false)
  currentTime=dateAsSeconds()
  startTime = startTimeAsSeconds(onNow.startTime,feed)
  if upNext <> invalid
    duration = startTimeAsSeconds(upNext.startTime,feed)-startTime
  else
    duration = 0
  end if
  remaining = duration - (currentTime-startTime)
  if duration = 0
    percent = 0
  else
    percent = Int(((currentTime-startTime)/duration)*100)
  end if
  stripText = ""
  minutesLabel = "minute"
  leftLabel = " left"
  if resumed
    minutesLabel = "m"
    leftLabel = " left"
  end if
  if percent < 11
    stripText += "Just Started"
  else if percent > 10 and percent < 80
    stripText = durationTime(remaining,{resumed:true})
    stripText += leftLabel
  else if percent > 79
    stripText = "Ending Soon"
  end if
  return stripText
end function

sub set_episodes_watched_as_anonimous_user (episodes)
  RegWrite("anonymous_watched_episodes",itostr(episodes))
end sub

function get_episodes_watched_as_anonimous_user()
  return StrToI(toStr(RegRead("anonymous_watched_episodes")))
end function

function bump_episode_counter()
    episode_count = StrToI(toStr(RegRead("anonymous_watched_episodes")))
    episode_count += 1
  RegWrite("anonymous_watched_episodes",itostr(episode_count))
end function

function bump_video_binge_play_count()
    episode_count = StrToI(toStr(RegRead("video_binge_play_count")))
    episode_count += 1
  RegWrite("video_binge_play_count",itostr(episode_count))
end function

sub set_video_binge_play_count(episodes)
  RegWrite("video_binge_play_count",itostr(episodes))
end sub

function get_video_binge_play_count()
  return StrToI(toStr(RegRead("video_binge_play_count")))
end function

function getLaunchType()
  launched = RegRead("launched")
  RegWrite("launched","true")
  return launched
end function

function underscore(text)
  if text = invalid
    return invalid
  end if
  sentence = LCase(text)
  r2 = CreateObject("roRegex", "[^a-zA-Z\d\s]", "")
  r3 = CreateObject("roRegex", " [^a-zA-Z\d\s] ", "")
  cleared = r2.ReplaceAll(r3.ReplaceAll(sentence," "),"")
  words = cleared.Split(" ")
  result = words.Join("_")
  return strTrim(result)
end function

function get_geolocation_swid()
  swid = RegRead("swid","geolocation")
  if swid = invalid
    return "none"
  else
    return swid
  end if
end function

function get_mvpd_id()
  mvpdid = RegRead("providerID","mvpd")
  if mvpdid = invalid
    return "000"
  else
    return mvpdid
  end if
end function

function get_freeform_swid()
  user = RegRead("user","oneid")
  if user = invalid
      return "none"
  else
    user_ = ParseJson(user)
    return user_.swid
  end if
end function

function get_user_type()
  user = RegRead("user","oneid")
  if user = invalid
      return "ANONYMOUS"
  else
    user_ = ParseJson(user)
    return user_.type
  end if
end function

function getOneIdUserId()
 if (get_user_type() = "ANONYMOUS")
   return "none"
 else
   return getOneIdUser().userId
 end if
end function

function getOneIdUser()
  user = RegRead("user","oneid")
    if user <> invalid
      return ParseJson(user)
    else
      return invalid
    end if
end function

function getSwidSender()
  if (get_user_type() = "ANONYMOUS")
    return get_geolocation_swid()
  else
    return get_freeform_swid()
  end if
end function

function getMVPD()
  mvpd = RegRead("mvpd","mvpd")
  if mvpd <> invalid
    return LCase(mvpd)
  else
    return "none"
  end if
end function

function getAuthenticatedUserFlag()
  mvpdInfo = RegRead("mvpd","mvpd")
  if mvpdInfo <> invalid
    return "true"
  else
    return "false"
  end if
end function


function getOneIdAuthenticatedUserFlag()
  if get_user_type() <> "ANONYMOUS"
    return "true"
  else
    return "false"
  end if
end function

function getMVPDUserId()
  userId = RegRead("userId","mvpd")
  if userId <> invalid
    return LCase(userId)
  else
    return "none"
  end if
end function

function getContentId(content)
  if content.partnerApiId = ""
    return content.showMsId
  else
    return underscore(content.partnerApiId)
  end if
end function

function continuous_play_from_to(from,to_)
  formattedFrom = "f[{0}]:f[ep{1}]:f[{2}]"
  formattedTo = ":t[{0}]:t[ep{1}]:t[{2}]"
  formatted = Substitute(formattedFrom, underscore(from.showTitle), underscore(from.fullEpisodeNumber), getContentId(from))
  formatted += Substitute(formattedTo, underscore(to_.showTitle), underscore(to_.fullEpisodeNumber), getContentId(to_))
  return formatted
end function


function indexOf(arr as Object, element as Dynamic) as Integer
            if not type(arr) = "roArray" then return -1

            size = arr.count()

            if size = 0 then return -1

            for i = 0 to size - 1
                if arr[i] = element then return i
            end for

            return -1
  end function


function getVideoTrackCode(fullEpisodeNumber)
  regex1 = CreateObject("roRegex", "S(.*)E","i")
  season = (regex1.Match(fullEpisodeNumber)[1])
  regex2 = CreateObject("roRegex", "E(.*)","i")
  episode = (regex2.Match(fullEpisodeNumber)[1])
  if season <> invalid and episode <> invalid
    if StrToI(episode) < 10
      episode = "0" + episode
    end if
    return "ep" + season + episode
  else
    return "none"
  end if
end function

function getGeolocationObject()
  user = RegRead("geolocation","geolocation")
  if user <> invalid
    return ParseJson(user)
  else
    return invalid
  end if
end function

function getCountry()
  geolocation = getGeolocationObject()
  if geolocation = invalid then return invalid
  if LCase(GetString(geolocation,"country")) = "usa"
    return "United States"
  else
    return invalid
  end if
end function

function getState()
  geolocation = getGeolocationObject()
  if geolocation = invalid then return invalid
  country = getCountry()
  state = GetString(geolocation,"state")
  if country <> invalid and state <> ""
    return USStateName(state)
  else
    return invalid
  end if
end function

function getCity()
  geolocation = getGeolocationObject()
  if geolocation = invalid then return invalid
  country = getCountry()
  city = GetString(geolocation,"city")
  if country <> invalid and city <> ""
    return capitalize(city)
  else
    return invalid
  end if
end function

function USStateName(state_abbrev)
  us_state_abbrev = {
    "AL": "Alabama",
    "AK": "Alaska",
    "AZ": "Arizona",
    "AR": "Arkansas",
    "CA": "California",
    "CO": "Colorado",
    "CT": "Connecticut",
    "DE": "Delaware",
    "FL": "Florida",
    "GA": "Georgia",
    "HI": "Hawaii",
    "ID": "Idaho",
    "IL": "Illinois",
    "IN": "Indiana",
    "IA": "Iowa",
    "KS": "Kansas",
    "KY": "Kentucky",
    "LA": "Louisiana",
    "ME": "Maine",
    "MD": "Maryland",
    "MA": "Massachusetts",
    "MI": "Michigan",
    "MN": "Minnesota",
    "MS": "Mississippi",
    "MO": "Missouri",
    "MT": "Montana",
    "NE": "Nebraska",
    "NV": "Nevada",
    "NH": "New Hampshire",
    "NJ": "New Jersey",
    "NM": "New Mexico",
    "NY": "New York",
    "NC": "North Carolina",
    "ND": "North Dakota",
    "OH": "Ohio",
    "OK": "Oklahoma",
    "OR": "Oregon",
    "PA": "Pennsylvania",
    "RI": "Rhode Island",
    "SC": "South Carolina",
    "SD": "South Dakota",
    "TN": "Tennessee",
    "TX": "Texas",
    "UT": "Utah",
    "VT": "Vermont",
    "VA": "Virginia",
    "WA": "Washington",
    "WV": "West Virginia",
    "WI": "Wisconsin",
    "WY": "Wyoming"
}
  return us_state_abbrev[UCase(state_abbrev)]
end function

function httpGet(http,type_,quantity)
  if type_ = "timeout"
    return http.GetToStringWithTimeout(quantity)
  else if type_ = "retries"
    return http.GetToStringWithRetry(quantity)
  end if
end function

function httpPost(http,quantity,params)
  return http.PostFromStringWithTimeout(params,quantity)
end function

sub makeRequest(task_ , type_, endpoint, httpType , httpQuantity)
  if type_ <> invalid
    task_["type"] = type_
  end if
  if endpoint <> invalid
    task_["endpoint"] = endpoint
  end if
  task_["httpType"] = httpType
  task_["httpQuantity"] = httpQuantity
  task_["control"] = "RUN"
end sub

sub cancelRequest(task_)
  task_["control"] = "STOP"
  task_["type"] = "CANCEL"
  task_["control"] = "RUN"
end sub

function getDisponibility(show)
  if show.numberOfSeasons > 1
    return Pluralize(show.numberOfSeasons,"Season")
  else if show.numberOfEpisodes > 0
    return Pluralize(show.numberOfEpisodes,"Episode")
  else if show.numberOfClips > 0
    return Pluralize(show.numberOfClips,"Clip")
  else
    return ""
  end if
end function


function durationTime(duration,properties = {resumed:false,episode:false})
  stripText = ""
  secondsLabel = "s"
  if properties.resumed = invalid then properties.resumed = false
  if properties.episode = invalid then properties.episode = false
  if properties.resumed
    minutesLabel = "m"
    hoursLabel = "h"
  else if properties.episode
    hoursLabel = " hr."
    minutesLabel = " min."
    secondsLabel = " sec."
  else
    minutesLabel = "minute"
    hoursLabel = "hour"
  end if

    if duration >= 3600
      stripText = Left(gmdate(duration),2)
      if StrToI(stripText) < 10
        stripText = itostr(StrToI(stripText))
      end if
      if properties.resumed or properties.episode
        stripText = stripText + hoursLabel
      else
        stripText = Pluralize(StrToI(stripText),hoursLabel)
      end if
      minutes = Mid(gmdate(duration),4,5)
      if StrToI(stripText) < 10
        minutes = itostr(StrToI(minutes))
      end if
      if minutes <> "0"
          if properties.resumed or properties.episode
          if Left(minutes, 1) = "0"
            minutes = Right(minutes, 1)
          end if
            stripText += " " + minutes + minutesLabel
          else
            stripText += " " + Pluralize(StrToI(Left(minutes,2)),minutesLabel)
          end if
      end if
    else if duration >= 60
      minutes = Left(gmdate(duration),2)
      if properties.resumed or properties.episode
        if Left(minutes, 1) = "0"
          minutes = Right(minutes, 1)
        end if
        stripText +=  minutes + minutesLabel
      else
        stripText += Pluralize(StrToI(minutes),minutesLabel)
      end if
    else
      if properties.resumed or properties.episode
        stripText +=  itostr(duration) + secondsLabel
      else
        stripText += Pluralize(duration,secondsLabel)
      end if
    end if
  return stripText
end function

sub deleteMVPD()
  RegDelete("mvpd","mvpd")
  RegDelete("name","mvpd")
  RegDelete("providerName","mvpd")
  RegDelete("providerID","mvpd")
  RegDelete("thumbnail","mvpd")
  RegDelete("userId","mvpd")
end sub

sub deleteOneID()
  RegDelete("user","oneid")
  RegDelete("deviceId")
end sub

function isTrailerPlayable()
  trailer_playable = RegRead("areTrailersPlayable")
  if trailer_playable = invalid or trailer_playable = "true"
    return true
  end if
  return false
end function

function getTrailerStatus()
  return m.global.areTrailersPlayable
end function


function createLetterRectangle(backgroundColor, letterColor, charactr,poster = false)
  if poster then rectangle = CreateObject("roSGNode", "Poster") else rectangle = CreateObject("roSGNode", "Rectangle")
  if poster then rectangle.uri = backgroundColor else rectangle.color = backgroundColor
  rectangle.height ="151"
  rectangle.width = "123"
  letter = CreateObject("roSGNode", "Label")
  letter.width = "123"
  letter.height = "151"
  letter.color = letterColor
  letter.horizAlign = "center"
  letter.vertAlign = "center"
  letter.inheritParentOpacity = "false"
  font = CreateObject("roSGNode", "Font")
  font.uri = "pkg:/fonts/FuturaLTPro-Bold.ttf"
  font.size = "80"
  letter.text = charactr
  letter.font = font
  rectangle.appendChild(letter)
  return rectangle
end function


function getOneIDUserName()
  user = ParseJson(RegRead("user","oneid"))
  user_first_name = ""
  if type(user) = "roAssociativeArray" and user.DoesExist("firstName")
    username = user.firstName
    user_first_name = UCase(mid(username, 0, 1)) + mid(username, 2)
  end if
  return user_first_name
end function

function getMVPDObjectInfo()
  mvpd_info = RegRead("mvpd","mvpd")
  info = {}
  if mvpd_info <> invalid
    info = ParseJson(mvpd_info)
  end if
  return info
end function

function leading_zero(num, size)
result = num
while (result.Len() < size)
  result = "0" + result
end while
return result
end function


function unpluralizeString(feedType)
  response = feedType
  word = feedType.Split("")
  if (word[word.Count() - 1] = "s")
    response = Mid(feedType, 1, Len(feedType) - 1)
  end if
  return response
end function

function getDeeplinkType(deep_link)
  cleaned_url = deep_link.Replace("abcfamilyplayer://", "")
  params = cleaned_url.Split("/")
  deeplink_params = invalid
  deeplinkType = params[0]
  if deeplinkType <> invalid then deeplinkType = unpluralizeString(deeplinkType) else deeplinkType = ""
  if deeplinkType = "show" 'Deeplink to episode edge case
    if params.Count() > 2
      deeplinkType = "episode"
    end if
  end if
  if deeplinkType <> ""
    if deeplinkType = "episode"
      deeplink_params = {
        name: params[1],
        feed_id: params[3]
      }
    else
      if params.Count() >= 2
        deeplink_params = {
          feed_id: params[1]
        }
      end if
    end if
  end if
return {deeplinkType: deeplinkType, params: deeplink_params}
end function


function getEndpointBasedOnDeeplink(deeplink)
  response = invalid
  fallbackEndpoint = "/programming/homepage"
  deeplinkInfo = getDeeplinkType(deeplink)
  if deeplinkInfo <> invalid then deepLinkParams = deeplinkInfo.params else deepLinkParams = invalid
  if deepLinkParams <> invalid
    if deeplinkInfo.deeplinkType = "section"
      response = "/programming/" + deepLinkParams.feed_id
    end if
  end if
  return response
end function

function capitalizeFirstLetter(word)
  r = CreateObject("roRegex", "\b[a-z]", "i")
  match = r.Match(word)[0]
  if match = invalid
    return word
  end if
  return r.Replace(word, UCase(match))
end function

function capitalizeEachWord(text)
  if text = invalid
    return invalid
  end if
  sentence = text
  words = sentence.Split(" ")
  result = ""
  for i=0 to words.Count()-1 step 1
    word = words[i]
    words[i] = capitalizeFirstLetter(word)
  end for
  spacesWords = words.Join(" ")


  dottedwords = spacesWords.Split(".")
  for i=0 to dottedwords.Count()-1 step 1
    wordd = dottedwords[i]
    dottedwords[i] = capitalizeFirstLetter(wordd)
  end for
  return  dottedwords.Join(".")
end function

function getAnalyticItemType(itemType)
  response = ""
  if itemType <> ""
    response = itemType
    if itemType = "collection"
      response = "Section"
    end if
  end if
  return response
end function

sub showOneIdReminderScreen(allowCloseChannel = false)
  m.is_reminder_visible = true
  set_episodes_watched_as_anonimous_user(0)
  showOneIDWelcome({allowCloseChannel: allowCloseChannel, instance: "reminder"})
end sub

sub showHomeOnLaunch()
  print "===========showHeader on show home lauch ======="
  showheader({focus:true})
  getHomePage({"httpType":"retries","httpQuantity":3})
  m.top.removeChild(m.top.FindNode("gotoHomeTimer"))
end sub

function createErrorNode(options)
  buttons = options.buttons
  errorNode = CreateObject("roSGNode", "ErrorNode")
  errorNode.update(options)
  return errorNode
end function

function createButtonsNode(buttonsData)
  buttons = createObject("RoSGNode","ContentNode")
  for each item in buttonsData
    markup_node = createObject("RoSGNode","ButtonNode")
    markup_node.update(item)
    buttons.appendChild(markup_node)
  end for
  return buttons
end function

sub triggerAnalyticEvent(callback, params = {})
  ' We should call this sub on top level.
  m.top.AnalyticHandler.CallFunc(callback, params)
end sub

sub setUserProperties(userProperties)
  print "============on setUserProperties=============="
  m.top.AnalyticHandler.CallFunc("setUserProperty", { userProperties: userProperties })
end sub

function isMVPDExpired()
  mvpd_info = getMVPDObjectInfo()
  if mvpd_info <> invalid and mvpd_info.Count() > 0
    expires = mvpd_info.expires
    if expires = invalid then expires = "0"
    expires$ = expires
    now$ = dateNow()
    expires! = Val(expires$)
    now! = Val(now$)
    expires% = expires!/1000
    now% = now!/1000
    remainingTime% = expires% - now%
    limit% = 0
    if remainingTime% <= limit%
      return true
    end if
  end if
  return false
end function

function createLabel(options = {} , component = "Label")
  label = CreateObject("roSGNode", component)
  for each key in label.keys()
    if options[key] <> invalid
      label[key] = options[key]
      options.delete(key)
    end if
  end for
  font = CreateObject("roSGNode", "Font")
  for each key in font.keys()
    if options[key] <> invalid
      font[key] = options[key]
    end if
  end for
  label.font = font
  return label
end function


function getMVPDInfo()
  mvpdInfo = RegRead("mvpd","mvpd")
  if mvpdInfo <> invalid
    return ParseJson(mvpdInfo)
  else
    return invalid
  end if
end function

function presentOnArray(valueToLook, values)
  if valueToLook = invalid then return false
  for each value in values
    if valueToLook = value
      return true
    end if
  end for
  return false
end function

function setAnalyticSourceValue(value)
    print "=====on setAnalyticSourceValue========:",value
    RegWrite("analytic_video_source", value)
end function

function getAnalyticSourceValue()
    response = RegRead("analytic_video_source")
    if response = invalid then response = "Manual"
    return response
end function

function isSystemDeeplink()
    return getAnalyticSourceValue() = "System Deeplink"
end function

function ceiling(x)
  i = int(x)
  if i < x then i = i + 1
  return i
end function

sub triggerSimpleClickAnalyticEvent(callback, params = {}, clickType = "")
  ' We should call this sub on top level.
  currentView = m.top.ComponentController.currentView
  if currentView <> invalid then params["pageName"] = currentView.id
  params["clickType"] = clickType
  m.top.AnalyticHandler.CallFunc(callback, params)
end sub

function getCurrentViewId()
  currentView = m.top.ComponentController.currentView
  if currentView <> invalid
    return currentView.id
  end if
  return ""
end function

Function getBoolean(json As Dynamic,fieldName As String,defaultValue=false As Boolean) As Boolean
    returnValue = defaultValue
    if json <> Invalid
        if type(json) = "roAssociativeArray" or GetInterface(json,"ifAssociativeArray") <> invalid
            fieldValue = json.LookupCI(fieldName)
            if fieldValue <> Invalid
                if type(fieldValue) = "roBoolean" or type(fieldValue) = "Boolean" or GetInterface(fieldValue,"ifBoolean") <> Invalid
                    returnValue = fieldValue
                end if
            end if
        end if
    end if
    return returnValue
End Function

function getDeepLink()
  return m.top.launch_args
end function

Function getOpenGlSupport()
  di = CreateObject("roDeviceInfo")
  return di.GetGraphicsPlatform() = "opengl"
End Function

sub sendLaunchEventAnalyticEvent(eventInfo = {})
  triggerAnalyticEvent("sendLaunchEvent", eventInfo)
end sub

sub Notify_Roku_UserIsLoggedIn(rsgScreen = invalid as Object)
    ' get the global node
    if type(m.top) = "roSGNode"  ' was called from a component script
        globalNode = m.global
    else ' must pass roSGScreen when calling from main() thread
        globalNode = rsgScreen.getGlobalNode()
    end if

    ' get the Roku Analytics component used for RED
    RAC = globalNode.roku_event_dispatcher
    if RAC = invalid then
        RAC = createObject("roSGNode", "Roku_Analytics:AnalyticsNode")
        RAC.debug = true ' for verbose output to BrightScript console, optional
        RAC.init = {RED: {}} ' activate RED as a provider
        globalNode.addFields({roku_event_dispatcher: RAC})
    end if

    ' dispatch an event to Roku
    RAC.trackEvent = {RED: {eventName: "Roku_Authenticated"}}
end sub

sub resetOmnitureVideoBingeCount()
  m.top.AnalyticHandler.CallFunc("resetVideoBingeCount")
end sub

sub bumpOmnitureVideoBingeCount()
  m.top.AnalyticHandler.CallFunc("bumpVideoBingeCount")
end sub
