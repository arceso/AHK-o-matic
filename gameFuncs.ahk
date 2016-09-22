#Include miscFuncs.ahk

moveMouse(x, y) {
  speed := 5
  MouseMove, x, y, speed
}

dragMouse(x, y) {
  Click down
  moveMouse(x, y)
  Click up
  Sleep 100
}

moveAndClickOnBox(x0, y0, x1, y1) {
  rndX := rnd(x0, x1)
  rndY := rnd(y0, y1)
  moveMouse(rndX, rndY)
  waitAbout(20)
  click
}

rndHoldKey(key, duration) {
  Send, {%key% down}
  waitAbout(duration)
  Send, {%key% up}
}

holdKey(key, duration) {
  Send, {%key% down}
  Sleep, duration
  Send, {%key% up}
}

holdTwoKeys(key1, key2, duration) {
  Send, {%key1% down}
  waitAbout(100)
  Send, {%key2% down}
  waitAbout(duration)
  Send, {%key1% up}
  waitAbout(100)
  Send, {%key2% up}
}

doubleClickOnWP() {
  side := 24
  halfWidth := a_screenWidth/2
  halfHeight := a_screenHeight/2
  xBeg := halfWidth - (side/2)
  yBeg := halfHeight - (side/2)
  xEnd := halfWidth + (side/2)
  yEnd := halfHeight + (side/2)
  moveAndClickOnBox(xBeg, yBeg, xEnd, yEnd)
  click
}

rndTurn(side, fraction) {
  if side = left
    key := "a"
  else if side = right
    key:= "d"
  timeForFullTurn := 3000
  timeForTurn := timeForFullTurn*fraction
  holdKey(key, timeForTurn)
}

turn(side, fraction) {
  if side = left
    key := "a"
  else if side = right
    key:= "d"
  timeForFullTurn := 2975
  timeForTurn := timeForFullTurn*fraction
  holdKey(key, timeForTurn)
}

whisper(name, content) {
  holdKey("Enter", 15)
  wait(10, 15)
  holdKey("Tab", 15)
  wait(10, 15)
  Send %name%
  holdKey("Tab", 15)
  wait(10, 15)
  Send %content%
}

type(text)  { ; No lee espacios, se los come, si quieres eso, implementa " " -> "Space"
  while StrLen(text){
    StringTrimRight, char, text, % StrLen(text) - 1
    StringTrimLeft, text, text, 1
    rndHoldKey(char, 10)
    waitAbout(5)
  }
}
