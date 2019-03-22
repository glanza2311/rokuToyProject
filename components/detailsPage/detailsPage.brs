function init()
  m.showImage = m.top.findNode("detailShowImage")
  m.network = m.top.findNode("showNetwork")
  m.genres = m.top.findNode("showGenres")
  m.buttons = m.top.findNode("detailsPageMenu")
  m.videoPlayer = m.top.findNode("VideoPlayer")
  m.overhang = m.top.findNode("overhang")

  m.top.network = m.top.findNode("showNetwork")
  m.top.genre = m.top.findNode("showGenres")
  m.top.showImage = m.top.findNode("detailShowImage")

  m.top.observeField("visible","changeData")
end function


sub changeData(event)
  print "detailsPage.brs - [changeData]"
  isVisible = event.getData()
  if isVisible and m.top.focusedContent <> invalid
    ' m.network.text = "Network: " + m.top.focusedcontent.network
    ' m.genre.text = "Genres: " + m.top.focusedcontent.genres[0]+ ", " + m.top.focusedcontent.genres[1]
    ' m.showImage.uri =  m.top.focusedcontent.originalImage
    m.buttons.setFocus(true)
  end if
end sub

Sub onItemSelected()
    print "detailsPage.brs - [onItemSelected]--Getting into the player"
    'if first button is Play
    if m.top.itemSelected = 0
    m.overhang.visible = false
    videoContent = createObject("RoSGNode", "ContentNode")
    videoContent.url = "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8"
    videoContent.streamformat = "hls"
    m.videoPlayer.content = videoContent
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
    end if
End Sub

Sub OnVideoPlayerStateChange()
  print "detailsPage.brs - [OnVideoPlayerStateChange]"
  if m.videoPlayer.state = "error"
    ' error handling
    print "There was an error trying to play the video"
    m.videoPlayer.visible = false
  else if m.videoPlayer.state = "playing"
    ' playback handling
  else if m.videoPlayer.state = "finished"
    m.videoPlayer.visible = false
  end if
End Sub

' set proper focus on buttons and stops video if return from Playback to details
Sub onVideoVisibleChange()
  print "detailsPage.brs - [onVideoVisibleChange]--Getting out of player"
  if m.videoPlayer.visible = false and m.top.visible = true
    m.overhang.visible = true
    m.buttons.setFocus(true)
    m.videoPlayer.control = "stop"
  end if
End Sub
