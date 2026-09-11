--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
function colourShift( _colour )
  local _index = colourEcco( "idx", _colour, 0 )
  if _index == #tColours -1 then  --SHIFT THE INDEX IN COLOUR TABLE
    _index = 2
  else
    _index = _index +1
  end
  --RETURN ALL THE COLOUR DATA BACK TO scoreInsert for SB EDITING
  return colourEcco( "all", "ERR", _index )
end

function colourEcco( _flag, _col, _i )  --"USER"  SET DEFAULT INDEXES TO PREDICTED FACECARD FOR BONUSROUND
  --FLAGS "all", "tbl", "col", "idx" AS WE ARE HAVING SIDE EFFECTS WITH PADDING OTHER VALUES WE DON'T WANT IN FRONT, AFTER IS NO ISSUE - JUST BEFORE
  if _col ~= "ERR" then
    for iC =1, #tColours -1 do
      if _col == tColours[ iC ][1] then
        _idx = iC
        _tbl = tColours[ iC ][4]
        break
      end
    end
  elseif _i ~= 0 then
    _col = tColours[ _i ][1]
    _idx = _i
    _tbl = tColours[ _i ][4]
  end
  
  if _flag == "all" then    --RETURN TEXT, TABLE, INDEX
    return _col, _tbl, _idx
  elseif _flag == "tbl" then
    return _tbl
  elseif _flag == "col" then
    return _col
  elseif _flag == "idx" then
    return _idx
  end
end

function colourPlus(_num)     -- +1 SLIDING COLOUR INDEX
  _num = _num +1
  if _num > #tColours -1 then
    _num = 1
  end
  return tColours[ _num ][1], _num
end

function colourText2Sound( _text )
  for i=1, #tColours -1 do
    if tColours[ i ][1] == _text then
      return tColours[ i ][3] --COLOUR TABLE ON 4
    end
  end
end

function rndColour()  --REMEMBER tColours = { {TEXT, COLOUR TABLE, SOUND },{},... }
  local index = math.random(1, #tColours -1)
  --local cIndex = colourEcco( "idx", tColours[ index ][1], 0)  --PROVES INDEX IS ACCURATE
  return tColours[ index ][1], index
end

--REMEMBER tColours = { {TEXT, SOUND TIMING, SOUND },{},... }
function rndCards5()
  local c1, _ = rndColour()
  local c2, _ = rndColour()
  local c3, _ = rndColour()
  local c4, _ = rndColour()
  local c5, _ = rndColour()
  
  while c1 == c2 or c1 == c3 or c1 == c4 or c1 == c5 or
    c2 == c3 or c2 == c4 or c2 == c5 or
    c3 == c4 or c3 == c5 or
    c4 == c5 do
      if c1 == c2 then
        c2, _ = rndColour()
      elseif c1 == c3 or c2 == c3 then
        c3, _ = rndColour()
      elseif c1 == c4 or c2 == c4 or c3 == c4 then
        c4, _ = rndColour()
      elseif c1 == c5 or c2 == c5 or c3 == c5 or c4 == c5 then
        c5, _ = rndColour()
      end
  end
  return c1,c2,c3,c4,c5
end