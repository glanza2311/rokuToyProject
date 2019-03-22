function init()
  m.mainPage = m.top.findNode("mainPage")
  m.overhang = m.top.findNode("overhang")
  m.detailsPage = m.top.findNode("detailsPage")
  m.tracker=m.top.createChild("TrackerTask")
  m.LoadingIndicator = m.top.findNode("LoadingIndicator")
  m.top.setFocus(true)
end function

'Function that runs when an item in the row is selected
sub OnRowItemSelected()
  print "HelloWorld.brs - [OnRowItemSelected]"
  'set the show details in the detailsPage
  m.detailsPage.focusedContent = m.top.focusedcontent
  m.detailsPage.network.text = "Network: " + m.top.focusedcontent.network
  m.detailsPage.genre.text = "Genres: " + m.top.focusedcontent.genres[0]+ ", " + m.top.focusedcontent.genres[1]
  m.detailsPage.showImage.uri =  m.top.focusedcontent.originalImage

  ' set focus and visibility
  m.mainPage.visible = "false"
  m.detailsPage.setFocus(true)
  m.overhang.visible = false
  m.detailsPage.visible = "true"
end sub

' Function that runs when the app is loading, before the content is set
' It stops the loading image and shows the main page
sub OnChangeContent()
  print "HelloWorld.brs - [OnChangeContent]"
  m.loadingIndicator.control = "stop"
  if m.top.content <> invalid
      m.mainPage.visible = "true"
      m.mainPage.setFocus(true)
  end if
end sub

' Remote control button handler
function onKeyEvent(key as String, press as Boolean) as Boolean
  print "HelloWorld.brs - [onKeyEvent]"
  result = false
  if press then
    if key = "back"
        if m.mainPage.visible = false and m.detailsPage.videoPlayerVisible = false
        m.mainPage.visible = true
        m.detailsPage.visible = false
        m.mainPage.setFocus(true)
        m.overhang.visible = true
        result = true
        else if m.mainPage.visible = false and m.detailsPage.videoPlayerVisible = true
        m.detailsPage.videoPlayerVisible = false
        result = true
      end if
    end if
  end if
  return result
end function
