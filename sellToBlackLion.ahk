#Include gameFuncs.ahk
#Include miscFuncs.ahk

blWindowSizeX := 850
blWindowSizeY := 650
usablePositionX := 0
usablePositionY := 0

doAllTheThing() {
  moveBLWindowToACorner()
  waitAbout(30)
  moveBLWindowToAnUsableZone()
  waitAbout(30)
  changeToTradingPost()
  waitAbout(30)
  selectSellTab()
  waitAbout(30)
  selectSearchBox()
  waitAbout(30)
  selectAll()
  waitAbout(200)
  typeOnBox("major")
  waitAbout(30)
  holdKey("Tab", 30)
  waitAbout(30)
  sellRepetitively()
  waitAbout(30)
}

moveBLWindowToACorner() {
  boxSizeX0 :=  A_ScreenWidth
  boxSizeY0 :=  0
  boxSizeX1 := boxSizeX0*(11/10)
  boxSizeY1 := boxSizeY0*(11/10)

  outsideX := rnd(boxSizeX0, boxSizeX1)
  outsideY := rnd(boxSizeY0, boxSizeY1)

  dragMouse(outsideX, outsideY)
}

moveBLWindowToAnUsableZone() {
  visibleX := 155
  visibleY := 0
  usableZoneX := rnd(580, 548)
  usableZoneY := rnd(0,4)

  dragDistanceX := A_ScreenWidth - (usableZoneX - visibleX)
  dragDistanceY := usableZoneY - visibleY

  setBLWindowPos(dragDistanceX, dragDistanceY)
  dragMouse(dragDistanceX, dragDistanceY)
}

changeToTradingPost() {
  boxSizeX := 20
  boxSizeY := 20
  boxPositionX := 10
  boxPositionY := 145

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

selectSellTab() {
  boxSizeX := 130
  boxSizeY := 85
  boxPositionX := 570
  boxPositionY := 35

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

selectSearchBox() {
  boxSizeX := 140
  boxSizeY := 10
  boxPositionX := 60
  boxPositionY := 140

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

selectNthItem(itemsToSkip) {
  boxSizeX := 500
  boxSizeY := 40
  boxPositionX := 290
  boxPositionY := 195 + (boxSizeY * itemsToSkip)

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

selectCheapestAvailable() {
  boxSizeX := 175
  boxSizeY := 14
  boxPositionX := 465
  boxPositionY := 445

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

undercut() { ; Maybe the amount to undercut could be usefull
  boxSizeX := 7
  boxSizeY := 5
  boxPositionX := 512
  boxPositionY := 250
  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

uppercut() {
  boxSizeX := 7
  boxSizeY := 5
  boxPositionX := 512
  boxPositionY := 240
  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}


hitTheSellButton() { ; Amount
  boxSizeX := 100
  boxSizeY := 10
  boxPositionX := 326
  boxPositionY := 327

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

confirmConfirmation() {
  boxSizeX := 70
  boxSizeY := 260
  boxPositionX := 60
  boxPositionY := 170

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

clickOnGold() {
  boxSizeX := 30
  boxSizeY := 10
  boxPositionX := 337
  boxPositionY := 244

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

changeToSellTab() {
  boxSizeX := 150
  boxSizeY := 80
  boxPositionX := 150
  boxPositionY := 120

  calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY)
}

typeOnBox(text) {
  type(text)
}

promptForQuant() {
  Title := "AHK Black Lion Assistant"
  Prompt := "Type the AMOUNT of items to automate: "
  HIDE := "" ; "HIDE" for passwords.
  Width := 270
  Height := 130
  X := (A_ScreenWidth / 2 ) - ( Width / 2)
  Y := (A_ScreenHeight / 2 ) - ( Height / 2)
  repeat := true
  while (repeat) {
    InputBox, quant, %Title%, %Prompt%, %HIDE%, Width, Height, X, Y
    if quant is integer
      repeat := false
  }
  return quant
}

; Misc

calcBoxPosMoveAndClick(boxSizeX, boxSizeY, boxPositionX, boxPositionY) {
  global usablePositionX
  global usablePositionY

  boxInitX := usablePositionX + boxPositionX
  boxInitY := usablePositionY + boxPositionY
  boxEndX := usablePositionX + boxSizeX + boxPositionX
  boxEndY := usablePositionY + boxSizeY + boxPositionY

  moveAndClickOnBox(boxInitX, boxInitY, boxEndX, boxEndY)
}

setBLWindowPos(posX, posY) {
  global usablePositionX
  global usablePositionY

  usablePositionX :=  posX - 180
  usablePositionY :=  posY
}

sellRepetitively() {
  itemPrice := 108
  quantity := promptForQuant()
  itemsToSkip := 0 ; contador de cosas que no he podido vender.
  while (quantity > 0) {
      waitAbout(300)
    selectNthItem(itemsToSkip)
      waitAbout(500)
    selectCheapestAvailable()
      waitAbout(300)
    undercut()
      waitAbout(300)
    if (priceIsTooLow(getPrice(), itemPrice) == "true") {
      uppercut()
    }
      waitAbout(300)
    hitTheSellButton()
      waitAbout(300)
    confirmConfirmation()
    quantity := quantity - 1
  }
}

priceIsTooLow(sellPrice, vendorPrice) {
  listingFee := sellPrice * 0.05
  exchangeFee := sellPrice * 0.1
  totalFees := listingFee + exchangeFee
  is := sellPrice - totalFees <= vendorPrice ? "true" : "false"
  return is
}

getPrice() {
  clickOnGold()
  waitAbout(15)
  click
  waitAbout(15)
  copy()
  waitAbout(15)
  gold = %Clipboard%
  sendTab()
  waitAbout(15)
  copy()
  waitAbout(15)
  silver = %Clipboard%
  sendTab()
  waitAbout(15)
  copy()
  waitAbout(15)
  cooper = %Clipboard%
  return (gold*10000 + silver*100 + cooper)
}
