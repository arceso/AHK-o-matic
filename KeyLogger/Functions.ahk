^a::formater("keylog.txt")
esc::Reload
^t::Test()

SetWorkingDir %A_ScriptDir%


Test() {
  insertKeyPress("a", "filecaca")
}

keylogger(char, file) {
  GetKeyState, State, %char%
  windowsEOL := "`r`n"
  fileappend, [%A_Hour%:%A_Min%:%A_Sec%:%A_Msec%][%State%]:%char%%windowsEOL%,%file%
}

formater(fileName) {
  recordedLines := Object()
  everyEventPaired := Object()
  fileTimeStart := getLineAt(fileName, 1)
  recordedLines.Push(getLineAt(fileName, 1))
  fileSize := getFileSize(fileName)
  lineCount := 0
  Loop, Read, %fileName%
  {
    for index, line in recordedLines {
      relation := relationType(A_LoopReadLine, line)
      if (relation = "new") {
        recordedLines.Push(A_LoopReadLine)
      } else if (relation = "complementary") {
        everyEventPaired.Push(getLine(recordedLines[index] ,A_LoopReadLine, fileTimeStart, fileName))
        recordedLines.RemoveAt(index)
        if (recordedLines.Length() = 0) and (lineCount < fileSize) {
          recordedLines.Push(getLineAt(fileName, lineCount+2))
        }
      } else if (relation = "same") {
      }
    }
    lineCount ++
  }

  interlacedArray := interlaceEvents(orderByStartTime(setRelativeTimes(everyEventPaired)))
  printArr(interlacedArray, "Interlaced")
  writeToFile(interlacedArray)
}

getLine(recordedLine, currentLine, fileTimeStart, fileName) {
  start := calcTime(currentLine, fileTimeStart)
  duration := calcTime(currentLine, recordedLine)
  key := getKey(currentLine)
  return {start: start, duration: duration, key: key}
}

calcTime(firstLine, secondLine) {
  firstTime := getTime(firstLine)
  secondTime := getTime(secondLine)
  return calcTimes(firstTime, secondTime)
}

getKey(line) {
  return SubStr(line, 19, 1)
}

getState(state) {
  return SubStr(state, 16, 1)
}

getTime(time) {
  return SubStr(time ,2, 12)
}

getLineAt(fileName, number) {
  FileReadLine, line, %fileName%, %number%
  return line
}

relationType(firstLine, secondLine) { ; first is on the record, second the actual one.
  if (getKey(firstLine) = getKey(secondLine)) {
    if (getState(firstLine) = getState(secondLine)) {
      relation := "same"
    } else if (getState(firstLine) = "U") {
      relation := "complementary"
    } else if (getState(firstLine) = "D") {
      relation := "new"
    }
  } else if (getState(firstLine) = "D") {
    relation := "new"
  }
  return relation
}

calcTimes(firstTime, secondTime) {
  fTimeTot := fullTimeToMS(firstTime)
  sTimeTot := fullTimeToMS(secondTime)
  return fTimeTot - sTimeTot
}

fullTimeToMS(time){
  hours := SubStr(time, 1, 2) * 1000 * 60 * 60
  mins := SubStr(time, 4, 2) * 1000 * 60
  secs := SubStr(time, 7, 2) * 1000
  msecs := SubStr(time, 10, 3)
  totalTime := hours + mins + secs + msecs
  return totalTime
}

getFileSize(fileName) {
  count := 0
  Loop, Read, %fileName%
  {
    count ++
  }
  return count
}

setRelativeTimes(array) {
  baseTime := array[1].start
  for index, event in array {
    array[index].start := event.start - baseTime
    a:=array[index].start
  }
  return array
}
;;;;;;;;;;;;;;;;;;;;;;;;; from almost raw input to ahkformated data functions

interlaceEvents(rawArray) {
  startHasBeenPut := false
  endHasBeenPut := false
  formatedArray := Object()
  printArr(rawArray, "Raw Array")
  for rawIndex, rawEvent in rawArray {
    bestStartTimePos := -1
    bestEndTimePos := -1
    for formIndex, formEvent in formatedArray {
      if (rawEvent.start < formEvent.time){
        bestStartTimePos := formIndex
      }
      if (rawEvent.start + rawEvent.duration < formEvent.time) {
        bestEndTimePos := formIndex
      }
    }
    if (bestStartTimePos > -1) {
      formatedArray.InsertAt(bestStartTimePos, transformRawToForm(rawEvent, "pressed"))
    } else {
      formatedArray.Push(transformRawToForm(rawEvent, "pressed"))
    }
    if (bestEndTimePos > -1) {
      formatedArray.InsertAt(formIndex, transformRawToForm(rawEvent, "released"))
    } else {
      formatedArray.Push(transformRawToForm(rawEvent, "released"))
    }
  }
  return formatedArray
}

transformRawToForm(event, state) {
  dur := state = "released" ? event.duration : 0
  return {time: event.start + dur, state: state, key: event.key}
}

orderByStartTime(rawArray) {
  placed := false
  for rawIndex, rawEvent in rawArray {
    changedTime := rawEvent.start
    for ordIndex, ordEvent in rawArray {
      if (rawEvent.start < ordEvent.start) and (changedTime < ordEvent.start) {
        swp := rawEvent[rawIndex]
        rawEvent[rawIndex] := rawEvent[ordIndex]
        rawEvent[ordIndex] := swp
      }
    }
  }
  return rawArray
}

; ------------------------ From interlaced Array to ahk file

writeToFile(array) {
  fileName := promptForFileName()
  initFile(fileName)
  array := relativiceTime(array)
  for index, event in array {
    inserWait(event.time, fileName)
    if (event.state = "pressed") {
      insertKeyPress(event.key, fileName)
    } else {
      insertKeyRelease(event.key, fileName)
    }
  }
  addEnding(fileName)
}

promptForFileName() {
  Title := "File name propmpt"
  Prompt := "Type the name of the script file"
  HIDE := "" ; "HIDE" for passwords.
  Width := 200
  Height := 130
  X := (A_ScreenWidth / 2 ) - ( Width / 2)
  Y := (A_ScreenHeight / 2 ) - ( Height / 2)
  InputBox, fileName, %Title%, %Prompt%, %HIDE%, Width, Height, X, Y
  return fileName . ".ahk"
}

inserWait(time, fileName) {
    windowsEOL := "`r`n"
    relPath := "Created_Scripts/"
    fileappend, waitAbout(%time%)%windowsEOL%,%fileName%
}

insertKeyPress(key, fileName) {
    windowsEOL := "`r`n"
    relPath := "Created_Scripts/"
    fileappend, Send`, {%key% down}%windowsEOL%,%fileName%
}

insertKeyRelease(key, fileName) {
    windowsEOL := "`r`n"
    relPath := "Created_Scripts/"
    fileappend, Send`, {%key% up}%windowsEOL%,%fileName%
}

relativiceTime(array) {
  relArr := ObjFullyClone(array)
  for index, event in array {
    prev := index > 1 ? index - 1 : index
    relArr[index].time := array[index].time - array[prev].time
  }
  return relArr
}

initFile(fileName) {
  windowsEOL := "`r`n"
  relPath := "Created_Scripts/"
  fileappend,`#Include ../miscFuncs.ahk%windowsEOL%,%fileName%
  fileappend,^!f::XX123XX()%windowsEOL%XX123XX() {%windowsEOL%,%fileName%
}

addEnding(fileName) {
  windowsEOL := "`r`n"
  fileappend,%windowsEOL%}%windowsEOL%,%fileName%
}

ObjFullyClone(obj) {
    nobj := ObjClone(obj)
    for k,v in nobj
        if IsObject(v)
            nobj[k] := ObjFullyClone(v)
    return nobj
}

printArr(array, name) {
  msgbox, %name%:
  for index, line in array {
    msgbox, Index: %index%
    time := line.time
    msgbox, time: %time%
    state := line.state
    msgbox, state: %state%
    key := line.key
    msgbox, key: %key%
  }
  msgbox, End of %name%.
}
