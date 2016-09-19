
rnd(min, max) {
    random, num, %min% , %max%
    return num
}

about(number) {
  variation := number*.08
  rndDur := rnd(number-variation, number+variation)
  return rndDur
}

showMouseCoordinates() {
  MouseGetPos, xpos, ypos
  Msgbox, The cursor is at X:%xpos% Y:%ypos%.
}

wait(min, max) {
  time := rnd(min, max)
  Sleep, time
}

waitAbout(duration) {
  rndDur := about(duration)
  Sleep, rndDur
}

getColorAt(x, y) {
  PixelGetColor, hexColor, x, y
  return, hexColor
}

getColorAtCursor(){
    MouseGetPos, xpos, ypos
    PixelGetColor, hexColor, xpos, ypos
    MSGBox, Color: %hexColor%
}
