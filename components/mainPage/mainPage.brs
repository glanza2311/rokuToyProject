function init()
  m.background = m.top.findNode("background")
  m.showTitle = m.top.findNode("showTitle")
  m.rating = m.top.findNode("showRating")
  m.heroImage = m.top.findNode("heroImage")
  m.description = m.top.findNode("showDescription")
  m.rowlist = m.top.findNode("showRowlist")

  'Create mainPageHandler which connects to the API and returns the data
  m.mainPageHandler = CreateObject("roSGNode","mainPageHandler")
  m.mainPageHandler.observeField("content", "onMainPageHandlerContentChange")
  m.mainPageHandler.control = "RUN"
  m.rowsContent = []

  m.rowlist.setFocus(true)
  m.top.observeField("visible","focusRowlistWhenVisible")
  m.heroImage.observeField("loadStatus","printLoadStatus")
end function

'If the data returned from the API is valid, calls the Function
'that populates the rowlist item
sub onMainPageHandlerContentChange(event)
  print "mainPage.brs - [onMainPageHandlerContentChange]"
  rowsInfo = event.getData()
  data = invalid
  if rowsInfo <> invalid
    data = GetRowListContent(rowsInfo.shows)
  end if
   m.rowlist.content = data
end sub

'Function that populates the rowList content, receives an array with all the shows
'Sets all the values in the rowListItemData (Rowlist itemContent)
function GetRowListContent(shows=[])
   print "mainPage.brs - [GetRowListContent]"
   data = CreateObject("roSGNode", "ContentNode")
   rows = [shows.slice(0, 40),shows.slice(40,100), shows.slice(100,140)]
   for numRows = 0 to rows.Count() - 1
       row = data.CreateChild("ContentNode")
       row.title = "ShowRow " + stri(numRows+1)
       _shows = rows[numRows]
       for i = 0 to _shows.Count() - 1
           currentItem = _shows[i]
           item = row.CreateChild("rowlistItemData")
           item.posterUrl = currentItem.image.medium
           item.originalImage = currentItem.image.original
           item.showTitle = currentItem.name
           item.rating = currentItem.rating.average
           item.description = currentItem.summary
           item.genres = currentItem.genres
           if currentItem.network <> invalid then
            item.network =  currentItem.network.name
           else
            item.network = "Unknown Network"
           end if
       end for
   end for
   return data
end function

'Handler of focused item in RowList
sub OnItemFocused()
  itemFocused = m.top.itemFocused
  'When an item gains the key focus, set to a 2-element array,
  'where element 0 contains the index of the focused row,
  'and element 1 contains the index of the focused item in that row.
  if itemFocused.Count() = 2 then
     focusedContent            = m.top.content.getChild(itemFocused[0]).getChild(itemFocused[1])
     if focusedContent <> invalid then
       m.top.focusedContent    = focusedContent
       m.heroImage.uri = focusedContent.originalImage
       m.heroImage.loadingBitmapUri = "https://via.placeholder.com/910x470.png?text=Loading-Image"
       m.heroImage.failedBitmapUri = "https://via.placeholder.com/910x470.png?text=Image-Not-Available"
       m.showTitle.text = focusedContent.showTitle
       m.rating.text = "Rating: "+ focusedContent.rating.ToStr() +"/10"
       m.description.text = focusedContent.description
    end if
  end if
end sub

'Sets focus on the rowlist whenever the mainPage is visible
sub focusRowlistWhenVisible()
  if m.top.visible = true then
    m.rowlist.setFocus(true)
  end if
end sub

sub printLoadStatus(event)
  print event.getData()
end sub
