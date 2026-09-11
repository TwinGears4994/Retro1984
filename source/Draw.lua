--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
--local _colour
--_colour = setColourHL( "text", idx, tMenu.ROTline1, 1, tMenu.menuPointerIdx )
--love.graphics.setColor( _colour )
			--( "fb", _numCount, 0, _numCount, _mPointer -_lines )
	--HELPED CHANGE ACTIVE MOVING POINTER IN MENUS WHICH WAS PRETTY COOL REALLY
function setColourHL(_txt, _hl1,_hl2, _hlActive1,_hlActive2 )	--TIME TO BREAK OUT THE MENU HIGHTLIGHTING INTO A FUNCTION
	local _colour
	if _txt == "text" then
		if _hl1 == _hl2 and _hlActive1 == _hlActive2  then
			_colour = tMenu.hlTextActive						--"HIGHLIGHTED" & ACTIVE COLOUR
		elseif _hl1 == _hl2 then
			_colour = tMenu.hlText									--"HIGHLIGHTED" COLOUR
		else
			_colour = tMenu.text										--NORMAL TEXT COLOUR
		end
	elseif _txt == "<>" then
		if _hlActive1 == _hlActive2 and _hl1 == _hl2 then
			_colour = tMenu.hlBraceActive						--"HIGHLIGHTED" & ACTIVE <> COLOUR
		elseif _hl1 == _hl2 then
			_colour = tMenu.hlBrace									--"<>" COLOUR
		else
			_colour = tMenu.Brace										--NORMAL BRACKET COLOUR
		end
	else
		_colour = tPortHole.skyblue								--4th COLOUR SYSTEM COLOUR
	end
	return  _colour
end

function drawBoarder() 
  -- *** BOARDER COLOUR CHANGES LIKE MATH GAME FOR USER FEEDBACK ***
  if tPortHole.buildMode == 1 then  --BROKEN IS RED MEANING NOT SAVING BROKEN STORY
    love.graphics.setColor( unpack( tPortHole.red ) )     --NORMAL BUILD MODE ERROR COLOURS
  elseif tPortHole.buildMode == 2 then  --								--ROTATE OUT PER-SECOND WHILE tPortHole.BBON
    love.graphics.setColor( unpack( tPortHole.orange ) )
  elseif tPortHole.buildMode == 3 then  --
    love.graphics.setColor( unpack( tPortHole.yellow ) )
  elseif tPortHole.buildMode == 4 then  --
    love.graphics.setColor( unpack( tPortHole.blue ) )
	elseif tPortHole.buildMode == 5 then  --
    love.graphics.setColor( unpack( tPortHole.purple ) )
	elseif tPortHole.buildMode == 6 then  --
		love.graphics.setColor( unpack( tPortHole.white ) )
	elseif tPortHole.buildMode == 7 then  --
    love.graphics.setColor( unpack( tPortHole.green ) )   --PLAY MODE
  end
  love.graphics.rectangle( "fill", 0,0, tPortHole.W, tPortHole.H )
  --BLACK SQUARE TO FRAME UP SIZE OF BOARDER
  love.graphics.setColor( unpack( tPortHole.black ) )
  love.graphics.rectangle( "fill", 1,1, tPortHole.bdrW, tPortHole.bdrH )
end

function drawNewAuthor( _typed )
  local _x = tPortHole.xbdr
  local _y = tPortHole.ybdr
  local _col = tPortHole.xColumn
  local _font = tPortHole.fontPixSize
  local _w = tPortHole.bdrW - _x*2
  local _txt = "Create a NEW-AUTHOR name which will become a directory, the name can also be an email address. Either way when your eventsAA are done you can archive/zip the authors directory up and share eventsAA with ease."
  love.graphics.setColor( tMenu.hlText ) 			--GREEN AS WE ARE IN BUILD MODE
  love.graphics.printf( "AUTHOR:", _x, _y, _w, "left" )
  --USER TYPING TO BE SEEN AFTER ABOVE PRINTF
  love.graphics.setColor( tMenu.hlTextActive ) 	--YELLOW GOLD USER INPUT
  love.graphics.printf( _typed, _col, _y, _w, "left" )
  love.graphics.setColor( tMenu.text2 )
  love.graphics.printf( _txt, _x, _y +_font, _w, "left" )
end

function drawListAuthor( _tAuthors, _typed )
  local _x = tPortHole.xbdr
  local _y = tPortHole.ybdr
  local _yPad = tPortHole.yPad
  local _col = tPortHole.xColumn
  local _font = tPortHole.fontPixSize
  local _w = tPortHole.bdrW/2 -_x*2
  --local _txt = "LIST-OF-AUTHORS:"
  love.graphics.setColor( tMenu.hlText )
  love.graphics.printf( "LIST-OF-AUTHORS:", _x, _y, _w, "left" )
  love.graphics.setColor( tMenu.hlTextActive ) --YELLOW GOLD
  love.graphics.printf( _typed, _col *2, _y, _w, "left" )
  _y = _y + _yPad
	if tMenu.menuPointerIdx == 0 then
		love.graphics.setColor( tMenu.hlTextActive )  --YELLOW GOLD USER INPUT
	else
		love.graphics.setColor( tMenu.text )  				--green
	end
  love.graphics.printf( "0.", _x, _y +_font, _w, "left" )
	love.graphics.printf( "NEW-AUTHOR", _col /2, _y +_font, _w, "left" )
  local _y2 = _y +_font *2
	for i=1, #_tAuthors do													--PROCESS THE #.(s)
		if tMenu.menuPointerIdx == i then
			love.graphics.setColor( tMenu.hlTextActive )
		else
			love.graphics.setColor( tMenu.text )
		end
    love.graphics.printf( tostring(i) .. ".", _x, _y2, _w, "left" )
    _y2 = _y2 + _font
  end
--  if tMenu.menuPointerIdx == i then
--		love.graphics.setColor( tMenu.hlTextActive )
--	else
--		love.graphics.setColor( tMenu.text )
--	end
  _y2 = _y +_font *2
	for i=1, #_tAuthors do													--PROCESS AUTHOR(s)
		if tMenu.menuPointerIdx == i then
			love.graphics.setColor( tMenu.hlTextActive )
		else
			love.graphics.setColor( tMenu.text )	--orange
		end
    love.graphics.printf( _tAuthors[i], _col /2, _y2, _w, "left" )
    _y2 = _y2 + _font
  end
end

function drawNewEvent( _typed )
  local _x = tPortHole.xbdr
  local _y = tPortHole.ybdr
  local _ypad = tPortHole.yPad
  local _col = tPortHole.xColumn
  local _font = tPortHole.fontPixSize
  local _w = tPortHole.bdrW -_x*2
  local _txt = "Type in your NEW-EVENT <RETURN> will be found inside your AUTHOR folder."
  love.graphics.setColor( tMenu.hlText ) --GREEN AS WE ARE IN BUILD MODE
  love.graphics.printf( "NEW-EVENT:", _x, _y, _w, "left" )
  --USER TYPING TO BE SEEN AFTER ABOVE PRINTF
  love.graphics.setColor( tMenu.hlTextActive ) --YELLOW GOLD USER INPUT
	_y = _y +_ypad	--NEGITIVE SPACE NEEDED
  love.graphics.printf( _typed, _col *1.3, _y, _w, "left" )
  local _y2 = _y + _font --REQUIRED SPACING FROM 1st TITLE LINE
  love.graphics.setColor( tMenu.text )
  love.graphics.printf( _txt, _x, _y2, _w, "left" ) --_y +_pad +_font
end

function drawListEvents( _eventsA, _typed )
  local _x = tPortHole.xbdr
  local _y = tPortHole.ybdr
  local _ypad = tPortHole.yPad
  local _col = tPortHole.xColumn		--IS 1/6th COLUMN
  local _font = tPortHole.fontPixSize
  local _w = tPortHole.bdrW -_ypad
	local _mpointer = tMenu.menuPointerIdx
  --local _txt = "LIST-OF-AUTHORS:"
  love.graphics.setColor( tMenu.hlText )
  love.graphics.printf( "LIST-OF-EVENTS:", _x, _y, _w, "left" )
  love.graphics.setColor( tMenu.hlTextActive ) --YELLOW GOLD USER INPUT
  love.graphics.printf( _typed, _col *2, _y, _w, "left" )
  _y = _y + _ypad
	--MAKE SURE POINTER ISN'T BEYOND THE LIST LENGTH...
	if _mpointer > #_eventsA then tMenu.menuPointerIdx = #_eventsA end
  if _mpointer == 0 then
		love.graphics.setColor( tMenu.hlTextActive )
	else
		love.graphics.setColor( tMenu.text )	--orange
	end
  love.graphics.printf( "0.", _x +_ypad, _y +_font, _w, "left" )
	love.graphics.printf( "NEW-EVENT", _col /2, _y +_font, _w, "left" )
  local _y2 = _y +_font *2 
  for i=1, #_eventsA do	--SMALL Y-BUG TO FIND
		if tMenu.menuPointerIdx == i then
			love.graphics.setColor( tMenu.hlTextActive )
		else
			love.graphics.setColor( tMenu.text )	--orange
		end
    love.graphics.printf( tostring(i) .. ".", _x +_ypad, _y2, _w, "left" )
    _y2 = _y2 + _font
  end
  --love.graphics.setColor( tMenu.hlText )
  --love.graphics.printf( "NEW-EVENT", _col /2, _y +_pad +_font, _w, "left" )
  _y2 = _y + _font *2
  for i=1, #_eventsA do
		if tMenu.menuPointerIdx == i then
			love.graphics.setColor( tMenu.hlTextActive )
		else
			love.graphics.setColor( tMenu.text )	--orange
		end
    --local _fileNameTrim = string.sub( _eventsA[i], 1, #_eventsA[i] -4 ) --TRIM OFF .TXT OR .CVS
    --WOULD LIKE TO HAVE A 2ND COLOUMB ON DISPLAY WHEN LINE 27 IS REACHED.
		--OR WE NEED A SCROLL OR EVEN SIDEWAYS SCROLL TO BE ABLE TO MOVE AROUND VERY LARGE LIBRARY
		love.graphics.printf( _eventsA[i], _col /2, _y2, _w, "left" )
    _y2 = _y2 + _font
  end
end

function dRetroTerm( _typed )  								--MY FUN RETRO-1984-TERMINAL FEELING BACK INTO THE MISSING PAST
	--runCharWideAdjust()
	local _lineCount = 1
	--local _mPointer = tMenu.menuPointerIdx
  local _yPad = tPortHole.yPad
  local _font = tPortHole.fontPixSize
  --local _fileNameTrim = string.sub( tMap.fileName, 1, #tMap.fileName -4 ) --TRIM OFF .TXT OR .CVS
  local _rmNum = tMap.rms[ tMap.rms.idx ].rRoomNum --or "R1"
	local _padTime = ":0"
	local _displayTime = ""
	local _label = ""
	if tMap.rmHours < 10 then
		_displayTime = _displayTime .. "0"
	end	
	_displayTime = _displayTime .. tostring( tMap.rmHours )
	if tMap.rmMinutes < 10 then
		_displayTime = _displayTime .. _padTime
	else
		_displayTime = _displayTime .. ":"
	end
	_displayTime = _displayTime .. tostring( tMap.rmMinutes )
	if tMap.rmSeconds < 10 then
		_displayTime = _displayTime .. _padTime
	else
		_displayTime = _displayTime .. ":"
	end
	_displayTime = _displayTime .. tostring( tMap.rmSeconds ) 
	--_displayTime = _displayTime .. ":" tostring( tMap.rmFraction )
	--local _inRmTime = tostring(tMap.rmHours).. tostring(tMap.rmMinutes) ..":".. tostring( tMap.rmSeconds )
	_label = tMap.rms[ tMap.rms.idx ].rLabel or ""
	--local _rmStory = tMap.rms[ tMap.rms.idx ].rStory
	local _colour = tPortHole.skyblue
	local _lines = 0
	local _xC = tPortHole.xC
	local _yL = tPortHole.yL 
	local _xC2 = tPortHole.xC2
	local _w = tPortHole.bdrW - ( tPortHole.xbdr *2 )
	local _yPlusLine = _font + _yPad
	local _char = 100
	local _space = "              "	--14 SPACES AT THIS TIME
	-- *** DRAWING RETROTERMINAL IN-LINE AGAIN ***
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	love.graphics.printf( "EVENT:", _xC, _yL, _w, "left" )				--1st LINE
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
	--LETS PAD SPACE ON TEXT 
  love.graphics.printf( _space .. tMap.hEventName, _xC, _yL, _w, "left" )
	--_y2 = _y + _font
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	love.graphics.printf( "RV #:", _xC2, _yL, _w, "left" )	--1st LINE
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
  love.graphics.printf( _space .. tMap.hRVnum, _xC2, _yL, _w, "left" )
	_yL = _yL + _yPlusLine
	_lineCount = _lineCount +1
	
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	love.graphics.printf( "LABEL:", _xC, _yL, _w, "left" )				--2nd LINE
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
  love.graphics.printf( _space .. _label, _xC, _yL, _w, "left" )
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	love.graphics.printf( "TIME:", _xC2, _yL, _w, "left" )			--2nd LINE
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
  love.graphics.printf( _space .. _displayTime, _xC2, _yL, _w, "left" )
	_yL = _yL + _yPlusLine
	_lineCount = _lineCount +1
	
	--MXYZ FOR AUTHOR BUILD-MODE TO SEE
	if tPortHole.BBON then
		local _map4D = tMap.rms[ tMap.rms.idx ].rMap4D
		local _mxyz = _map4D.m ..",".. _map4D.x ..",".. _map4D.y ..",".. _map4D.z
		_colour = setColourHL( "sys", 0, 0, 0, 0 )
		love.graphics.setColor( _colour )
		love.graphics.printf( "M-XYZ:", _xC, _yL, _w, "left" )				--2nd LINE
		_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
		love.graphics.setColor( _colour )
		love.graphics.printf( _space .. _mxyz, _xC, _yL, _w, "left" )
		_colour = setColourHL( "sys", 0, 0, 0, 0 )
		love.graphics.setColor( _colour )
		love.graphics.printf( "ACTION:", _xC2, _yL, _w, "left" )			--2nd LINE
		_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
		love.graphics.setColor( _colour )
		love.graphics.printf( _space .. tMap.rms[ tMap.rms.idx ].rEnteredRmCount, _xC2, _yL, _w, "left" )
		_yL = _yL + _yPlusLine
		_lineCount = _lineCount +1
	end
	
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	local _NOEXITS = tMap.rmNOEXITS
	love.graphics.printf( "EXISTS:", _xC, _yL, _w, "left" )			--3rd LINE
	if _NOEXITS then
		_colour = setColourHL( "sys", 0, .9,.5,0 )
		love.graphics.setColor( _colour )
		
	end
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
	--IF MENUS AND MPOINTER OBJECT THEN HL OBJECT 1st THEN OTHERS DIFFERENT COLOUR OR <HL>
	_label = hasValue( "ccat", tMap.rms[ tMap.rms.idx ].rExits )
  love.graphics.printf( _space .. _label, _xC, _yL, _w, "left" )
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	love.graphics.printf( "ROOM #:", _xC2, _yL, _w, "left" )		--3rd LINE
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
  love.graphics.printf( _space .. _rmNum, _xC2, _yL, _w, "left" )
	_yL = _yL + _yPlusLine
	_lineCount = _lineCount +1
	
	-- *** ON-AUTHOR: ***
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	love.graphics.printf( "ON-AUTHOR:", _xC, _yL, _w, "left" )
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
	--IF MENUS AND MPOINTER OBJECT THEN HL OBJECT 1st THEN OTHERS DIFFERENT COLOUR OR <HL>
	_label = hasValue( "catOnAuOBJ", tMap.auLeg )
  love.graphics.printf( "       " .._space.. _label, _xC, _yL, _w, "left" )
	local _loop = math.floor( #hasValue( "catOnAuOBJ", tMap.auLeg ) /_char ) +1
	if _loop > 0 then
		for z =1, _loop do
			_yL = _yL + _yPlusLine
		end
	else
		_yL = _yL + _yPlusLine
	end
	_lineCount = _lineCount +1
	
	-- *** VISIBLE: ***
	--_w = tPortHole.bdrW		--ONLY NEED A FEW OBJECTS TO WORDWRAP AND SCREW UP DISPLAY LINE
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	love.graphics.printf( "VISIBLE:", _xC, _yL, _w, "left" )
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
	--IF MENUS AND MPOINTER OBJECT THEN HL OBJECT 1st THEN OTHERS DIFFERENT COLOUR OR <HL>
	_label = hasValue( "catRmOBJ", tMap.rms[ tMap.rms.idx ].rObj )
  love.graphics.printf( _space .. _label, _xC, _yL, _w, "left" )
	_loop = math.floor( #hasValue( "catRmOBJ", tMap.rms[ tMap.rms.idx ].rObj ) /_char ) +1
	if _loop > 0 then
		for z =1, _loop do
			_yL = _yL + _yPlusLine
		end
	else
		_yL = _yL + _yPlusLine
	end
	_lineCount = _lineCount +1
	-- *** STORY: ***
	_colour = setColourHL( "sys", 0, 0, 0, 0 )
	love.graphics.setColor( _colour )
	love.graphics.printf( "STORY:", _xC, _yL, _w, "left" )		--"$ " BEFORE "STORY:"
	_colour = setColourHL( "text", 1, 1, 1, 1 )	--HL IS YELLOW/GOLD
	love.graphics.setColor( _colour )
	if #tPortHole.eccoDisplayBuff >0 then		--WHAT'S IN THE BUFFER FOR THE USER?
		_label = ccat( " ", tPortHole.eccoDisplayBuff )
		--TRACK HOW MY CARRAGE RETURNS WE HAVE IN THE TEXT ABOUT TO BE PRINTED
		_loop = newLineCount( _label )	-- *** COUNT CARRAGE RETURNS '\n' ***
		love.graphics.printf( _space .. _label, _xC, _yL, _w, "left" )
		if _loop >0 then
			for z =1, _loop do
				_yL = _yL + _yPlusLine
			end
		else
			_yL = _yL + _yPlusLine
		end
	else
		_yL = _yL + _yPlusLine
	end
	_lineCount = _lineCount +1 -- _loop
  -- 		*** BOARDER COLOUR SWITCH ***
--  if tPortHole.buildMode == 1 then              --BROKEN IS RED MEANING CAN NOT SAVE STORY
--    love.graphics.setColor( unpack( tPortHole.red ) )     		--STORY NOT SAVED YET
--  elseif tPortHole.buildMode == 2 then  --
--    love.graphics.setColor( unpack( tPortHole.yellow ) )  		--SINGLE ROOM BUILD MODE
--  elseif tPortHole.buildMode == 3 then  --
--    love.graphics.setColor( unpack( tPortHole.orange ) )  		--NORMAL ROOM BUILD MODE
--  elseif tPortHole.buildMode == 4 then  --
--    love.graphics.setColor( unpack( tPortHole.green ) )   		--NEW PLAY MODE
--  end
  if #tPortHole.cmdForcast > 0 then
    local txt = table.concat(tPortHole.cmdForcast, " ")
    love.graphics.printf( "   ".. txt, _xC, _yL, _w, "left" )    			--CMD LINE FORCAST HELP
    if #txt <73 then        --CURRENTLY 73.5px CHARACTER WIDE TEXT STRING WITH FONT AS IS...
      _y2 = _y2 +_font
    elseif #txt <147 then   																	--2nd LINE PERFECT
      _y2 = _y2 +_font *2 +_yPad *1.5
    elseif #txt <220 then   																	--3rd LINE PERFECT
      _y2 = _y2 +_font *3 +_yPad *2
    elseif #txt <294 then   																	--4rd LINE PERFECT
      _y2 = _y2 +_font *4 +_yPad *2.5
    elseif #txt <367 then   																	--5th LINE PERFECT
      _y2 = _y2 +_font *5 +_yPad *3
    elseif #txt <441 then   																	--6th UNTESTED
      _y2 = _y2 +_font *6 +_yPad *3.5
    elseif #txt <514 then   																	--7th UNTESTED
      _y2 = _y2 +_font *7 +_yPad *4
    end
  end
	--SPLIT OFF BETWEEN CLI OPTION OR A MENU LIKE FOR CREATING TRIPWIRES, THIS TIME LESS MENUS
	if not tPortHole.drawMENU then	--DRAW MENUS
		--		*** 	DRAW CLI/TERMINAL 	*** 
		love.graphics.printf( "$", _xC, _yL, _w, "left" )    				--CMD LINE
		love.graphics.setColor( tMenu.hlBraceActive )
		--		if tMap.tKeyLogHistory.idx > 0 then										--INJECT HISTORY
		--			tMap.keylog = tMap.tKeyLogHistory[ tMap.tKeyLogHistory.idx ]
		--		end
		love.graphics.printf( "   " .. tMap.keylog, _xC, _yL, _w, "left" )
	elseif tPortHole.drawMENU then	--DRAW MENUS
		if #tPortHole.cmdForcast > 0 then tPortHole.cmdForcast = {} end	--RetroDraw
		_y2, _lines = drawMenuSel( _xC, _yL, _w, _yPad )
		--2nd LINE(s)
		if tMenu.tRmAu.menuIdx == 1 then													--	*** DRAW ROOM-THEATER ***	
			_y2, _lines = drawMenuRmTheater( _xC, _yL, _w, _yPad, _lines )
		elseif tMenu.tRmAu.menuIdx == 2 then											--	*** DRAW IN-ROOM OBJ ***
			_y2, _lines = drawMenuInRmObj( _xC, _yL, _w, _yPad, _lines )
		elseif tMenu.tRmAu.menuIdx == 3 then											--	*** DRAW ON-AUTHOR OBJ ***
			_y2, _lines = drawMenuOnAuObj( _xC, _yL, _w, _yPad, _lines )
		elseif tMenu.tRmAu.menuIdx == 4 then											--	*** DRAW STORY MENU ***
			_y2, _lines = drawMenuStory( _xC, _yL, _w, _yPad, _lines )
		end
		--if _lines > 0 then
		drawMenuACEDOX( _xC, _yL, _w, _yPad, _lines)
		--end
		--		if tMenu.drawEditBoxON then
		--			--<RIGHT OR RETURN> TO SET IF NOT A SEPERATE MENU AND TEXT IN-LINE MENUS
		--			drawEditBox()
		--		end
	end
end

--function drawMenuSel( _x, _y, _w, _pad )				--	*** SELECTED/CURRENT MENU - LINE 1&2 ***
--	local _col = (_w -_pad) /#tMenu.tRmAu.textList
--	local _font = tPortHole.fontPixSize
--	local _mPointer = tMenu.menuPointerIdx
--	local _hlPointer = tMap.auLeg.idx or tMap.rms[ tMap.rms.idx ].rObj.idx
--	local _y2 = _y
--	local _x2 = _x
--	local _lines = 0
--	if _hlPointer < 1 then _hlPointer = 1 end
--	for idx =1, #tMenu.tRmAu.textList do					--FIRST LINE - "IN-ROOM MENU","ON-AUTHOR MENU"
--		local _colour = setColourHL( "text", idx, tMenu.tRmAu.menuIdx, 1, _mPointer )
--		love.graphics.setColor( _colour )
--		love.graphics.printf( tMenu.tRmAu.textList[ idx ], _x2, _y2, _col, "center" )
--		_x2 = _x2 +_col
--	end
--	_x2 = _x
--	for idx =1, #tMenu.tRmAu.textList do
--		local _colour = setColourHL( "<>", idx, tMenu.tRmAu.menuIdx, 1, _mPointer )
--		love.graphics.setColor( _colour )
--		love.graphics.printf( "<", _x2, _y2, _col, "left")
--		love.graphics.printf( ">", _x2, _y2, _col, "right")
--		_x2 = _x2 +_col		--COLOUM WALK
--	end
--	_x2 = _x
--	_y2 = _y2 + _font		--LOVE THE SPACING LIKE THIS, JUST WORKS
--	_col = (_w -_pad) / #tMenu.tMenuPOTT.textList
--	_lines = _lines +1
--	for idx =1, #tMenu.tMenuPOTT.textList do				--2nd LINE - "PARTS","OBJECTS","TRIPWIRE"
--		_colour = setColourHL( "text", idx, tMenu.tMenuPOTT.menuIdx, 1+1, _mPointer )
--		love.graphics.setColor( _colour )
--		love.graphics.printf( tMenu.tMenuPOTT.textList[ idx ], _x2, _y2, _col, "center" )
--		_x2 = _x2 +_col
--	end
--	_x2 = _x
--	for idx =1, #tMenu.tMenuPOTT.textList do
--		_colour = setColourHL( "<>", idx, tMenu.tMenuPOTT.menuIdx, 1+1, _mPointer )
--		love.graphics.setColor( _colour )
--		love.graphics.printf( "<", _x2, _y2, _col, "left")
--		love.graphics.printf( ">", _x2, _y2, _col, "right")
--		_x2 = _x2 +_col
--	end
--	_lines = _lines +1
--	return _y2 + _font, _lines
--end
----BEGINNING OF THE 4 MAIN MENU OPTIONS TO DRAW
--function drawMenuRmTheater( _x, _y, _w, _pad, _lines )
--	local _padNum = (_w -_pad) /21
--	local _col = (_w -_pad) /3
--	local _colour = tPortHole.blue
--	local _font = tPortHole.fontPixSize
--	local _numCount = 1
--	local _mPointer = tMenu.menuPointerIdx
--	if _mPointer < 1 then tMenu.menuPointerIdx =1 end	--RESET TO POSITIVE VALUE
--	local _space = _pad *6		--#. SPACE THEN .. ( _pad = tPortHole.pad *2 )
--	local _x2 = _x +_font
--	local _x3 = _x2 +_col +_font
--	local _y2 = _y
--	local _label = "NONE-FOUND"
--	local _tSingleRm = tMap.rms[ tMap.rms.idx ]
--	--LIST EVERYTHING ABOUT ROOM	--hasValue( "text" OR "catRmOBJ" OR "catOnAuOBJ" OR "catHide" )
--	--SELECTION #.'s DRAW FIRST
--	if tMenu.tRmAu.menuIdx == 1 then									-- < "ROOM-THEATER" >
--		if tMenu.tMenuPOTT.menuIdx == 1 then							-- < "PARTS LIST" >
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "ROOM LABEL:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", _tSingleRm.rLabel )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "ROOM AUTHOR:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", _tSingleRm.rAuthor )	--if #_tSingleRm.rLabel == 0 then _label = "NONE-FOUND" else _label = _tSingleRm.rAuthor end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "ROOM NUMBER:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", _tSingleRm.rRoomNum )	--if #_tSingleRm.rLabel == 0 then _label = "NONE-FOUND" else _label = _tSingleRm.rAuthor end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "ROOM EXISTS:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--ONLY DISPLAY THE ONE TO BE EDITED...
--			if _tSingleRm.rExits.idx > 0 then
--				_label = hasValue( "text", _tSingleRm.rExits[ _tSingleRm.rExits.idx ] )
--			else
--				_label = "NA"
--			end
--			--_label = hasValue( "ccat", _tSingleRm.rExits )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
--				--------ADDING 4 MORE LINES July 10th 2025
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "ROOM TIMER:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", tostring( _tSingleRm.rTimer ) )	--if #_tSingleRm.rLabel == 0 then _label = "NONE-FOUND" else _label = _tSingleRm.rAuthor end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "ROOM COUNT DOWN:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			if _tSingleRm.rCountDOWN then _label = "TRUE" else _label = "FALSE" end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "ROOM LAND LAYER LOCK:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", tostring( _tSingleRm.rLandLayerLock ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "ENTERING-ROOM COUNT:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", tostring( _tSingleRm.rEnteredRmNum ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "MULTI,X,Y,Z 3DMAP:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "ccat", {_tSingleRm.rMap4D.m,_tSingleRm.rMap4D.x,_tSingleRm.rMap4D.y,_tSingleRm.rMap4D.z} )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			if _tSingleRm.rDataLOCKED then _label = "TRUE" else _label = "FALSE" end
--			love.graphics.printf( "ROOM DATA LOCKED:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_label = hasValue( "text", _tSingleRm.rDataLOCKED )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" ) --+ _font /3
--			_numCount = _numCount +1
			
--		--THIS PLACE HOLDER WILL BE SKIPPED BUT LEFT IN PLACE WITH KEYBOARD ALLOWS -3/+3 JUMPS
--		--tMenu.tMenuPOTT.menuIdx WILL EITHER BE 1 OR 4 ONLY WITH JUMPING TO HELP USER WITH LESS ARROWING AROUND
--		elseif tMenu.tMenuPOTT.menuIdx == 2 then	--"ROOM-THEATER" with "OBJECTS"
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "NO OBJECTS", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", "TW-REACTION ONLY" ) --_tSingleRm.rObj[ _objIdx ].label )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
--			-- *** "ROOM-THEATER" >  < "TW-ACTION" > ***
--		elseif tMenu.tMenuPOTT.menuIdx == 3 then --and #_tSingleRm.rObj >0 then
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			love.graphics.printf( "NO TW-ACTION", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", "TW-REACTION ONLY") --_tSingleRm.rObj[ _objIdx ].label )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			_numCount = _numCount +1
			
--			-- *** "ROOM-THEATER" >  < "TW-REACTION" > ***
--		elseif tMenu.tMenuPOTT.menuIdx == 4 then --and #_tSingleRm.rObj >0 then
--			for x =1, #tMap.rms[ tMap.rms.idx ].rTripWire do
--				_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--				love.graphics.setColor( _colour )
--				--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--				love.graphics.printf( "TW RE-ACTION:", _x2, _y2, _col, "left" )
--				_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--				love.graphics.setColor( _colour )
--				_label = hasValue( "ccat", tMap.rms[ tMap.rms.idx ].rTripWire[ x ] ) --_tSingleRm.rObj[ _objIdx ].label )
--				_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--				_numCount = _numCount +1
--			end
--		end
--	end
--	_y2 = _y2 + _font
--	return _y2, _lines +_numCount
--end

--function drawMenuInRmObj( _x, _y, _w, _pad, _lines )
--	local _padNum = (_w -_pad) /21
--	local _col = (_w -_pad) /3
--	local _colour = tPortHole.blue
--	local _font = tPortHole.fontPixSize
--	local _numCount = 1
--	local _mPointer = tMenu.menuPointerIdx
--	if _mPointer < 1 then tMenu.menuPointerIdx =1 end	--RESET TO POSITIVE VALUE
--	local _space = _pad *6		--#. SPACE THEN .. ( _pad = tPortHole.pad *2 )
--	--local _hlPointer = tMap.rms[ tMap.rms.idx ].rObj.idx
--	local _x2 = _x +_font
--	local _x3 = _x2 +_col +_font
--	local _y2 = _y
--	local _label = "NONE-FOUND"
--	local _objIdx = tMap.rms[tMap.rms.idx].rObj.idx --FOR EITHER 2 OBJECT STORAGE
--	local _tSingleRm = tMap.rms[ tMap.rms.idx ] --.rObj[_objIdx]
--	--LIST EVERYTHING ABOUT ROOM	--hasValue( "text" OR "catRmOBJ" OR "catOnAuOBJ" OR "catHide" )
--	--SELECTION #.'s DRAW FIRST
--	if tMenu.tRmAu.menuIdx == 2 then									-- IN-ROOM OBJ
--		if tMenu.tMenuPOTT.menuIdx == 1 and #_tSingleRm.rObj >0 then	--"PARTS LIST"
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJECT LABEL:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", _tSingleRm.rObj[ _objIdx ].label )
--			--_label = hasValue( "catRmOBJ", _tSingleRm.rObj )	--if #_tSingleRm.rObj == 0 then _label = "NONE-FOUND" else _label = ccatRmObj( _tSingleRm.rObj ) end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ COUNT:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tSingleRm.rObj[ _objIdx ].count ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
--			----------------------------------
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ PACKAGE SIZE:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tSingleRm.rObj[ _objIdx ].packSize ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ PACKAGE LABEL:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tSingleRm.rObj[ _objIdx ].packLabel ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
--			-------------------------------------
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ HIDDEN:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			if _tSingleRm.rObj[ _objIdx ].objHIDDEN then _label = "TRUE" else _label = "FALSE" end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ TIMER:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tSingleRm.rObj[ _objIdx ].timer ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ COUNT DOWN:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			if _tSingleRm.rObj[ _objIdx ].countDOWN then _label = "TRUE" else _label = "FALSE" end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ ON:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			if _tSingleRm.rObj[ _objIdx ].objON then _label = "TRUE" else _label = "FALSE" end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ AUTHOR:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tSingleRm.rObj[ _objIdx ].author ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ VALUE:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tSingleRm.rObj[ _objIdx ].cost ) )
--			_y2 = pfLine( "$" .. _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--		elseif tMenu.tMenuPOTT.menuIdx == 2  and #_tSingleRm.rObj >0 then					-- "OBJECTS" THEN IS true/false
--			_y2 =	drawMenuObjs( _x, _y2, _w, _pad, tMenu.tMenuPOTT.mLIST )	-- IS true/false BOOL
--			_numCount = _numCount +1
--		elseif tMenu.tMenuPOTT.menuIdx == 3 then					-- "TW-ACTION"
--			_y2 =	drawMenuTWsAction( _x, _y2, _w, _pad, tMenu.tMenuPOTT.mLIST )
--			_numCount = _numCount +1
--		elseif tMenu.tMenuPOTT.menuIdx == 4 then					-- "TW-REACTION"
--			_y2 =	drawMenuTWsReAction( _x, _y2, _w, _pad, tMenu.tMenuPOTT.mLIST )
--			_numCount = _numCount +1
--		end
--	end
--	_y2 = _y2 + _font
--	--drawMenuACEDOX( _x, _y2, _w, _pad,  _lines +_numCount  )
--	return _y2, _lines +_numCount
--end
----		*** ON-AUTHOR MENU ***
--function drawMenuOnAuObj( _x, _y, _w, _pad, _lines )	--PARTS DEFAULT 1st
--	local _padNum = (_w -_pad) /21
--	local _col = (_w -_pad) /3
--	local _colour
--	local _font = tPortHole.fontPixSize
--	local _numCount = 1
--	local _mPointer = tMenu.menuPointerIdx
--	if _mPointer < 1 then tMenu.menuPointerIdx =1 end	--RESET TO POSITIVE VALUE
--	local _space = _pad *6		--#. SPACE THEN .. ( _pad = tPortHole.pad *2 )
--	--local _hlPointer = tMap.rms[ tMap.rms.idx ].rObj.idx
--	local _x2 = _x +_font
--	local _x3 = _x2 +_col +_font
--	local _y2 = _y
--	local _label = "NONE-FOUND"
--	local _objIdx = tMap.auLeg.idx	--FOR EITHER 2 OBJECT STORAGE
--	local _tAuObjs = tMap.auLeg
--	--LIST EVERYTHING ABOUT SELF.PLAYER	--hasValue( "text" OR "catRmOBJ" OR "catOnAuOBJ" OR "catHide" )
--	--SELECTION #.'s DRAW FIRST
--	if tMenu.tRmAu.menuIdx == 3 then									-- < "ON-AUTHOR MENU" >
--		if tMenu.tMenuPOTT.menuIdx == 1 and #_tAuObjs >0 then	-- *** < "PARTS" > ***
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJECT LABEL:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", _tAuObjs[ _objIdx ].label )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ COUNT:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tAuObjs[ _objIdx ].count ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
--			----------------------------
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ PACKAGE SIZE:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tAuObjs[ _objIdx ].packSize ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ PACKAGE LABEL:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label =  hasValue( "text", tostring( _tAuObjs[ _objIdx ].packLabel ) )
--			_y2 = pfLine( _label,_x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
--			--------------------------
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ HIDDEN:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			if _tAuObjs[ _objIdx ].objHIDDEN then _label = "TRUE" else _label = "FALSE" end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ TIMER:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", tostring( _tAuObjs[ _objIdx ].timer ) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ COUNT DOWN:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_label = hasValue( "text", _tAuObjs[ _objIdx ].objHIDDEN )
--			if _tAuObjs[ _objIdx ].countDOWN then _label = "TRUE" else _label = "FALSE" end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ ON:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_label = hasValue( "text", _tAuObjs[ _objIdx ].objHIDDEN )
--			if _tAuObjs[ _objIdx ].objON then _label = "TRUE" else _label = "FALSE" end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ AUTHOR:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", _tAuObjs[ _objIdx ].author )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "OBJ VALUE:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", tostring( _tAuObjs[ _objIdx ].cost ) )
--			_y2 = pfLine( "$" .. _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
--		elseif tMenu.tMenuPOTT.menuIdx == 2 then					-- "OBJECTS" THEN IS true/false
--			_y2 =	drawMenuObjs( _x, _y2, _w, _pad, tMenu.tMenuPOTT.mLIST )	-- IS true/false BOOL
--			_numCount = _numCount +1
--		elseif tMenu.tMenuPOTT.menuIdx == 3 then					-- "TW-ACTION"
--			_y2 =	drawMenuTWsAction( _x, _y2, _w, _pad, tMenu.tMenuPOTT.mLIST )
--			_numCount = _numCount +1
--		elseif tMenu.tMenuPOTT.menuIdx == 4 then					-- "TW-REACTION"
--			_y2 =	drawMenuTWsReAction( _x, _y2, _w, _pad, tMenu.tMenuPOTT.mLIST )
--			_numCount = _numCount +1
--		end
--	end
--	_y2 = _y2 + _font
--	--drawMenuACEDOX( _x, _y2, _w, _pad,  _lines +_numCount  )
--	return _y2, _lines +_numCount
--end

--function drawMenuStory( _x, _y, _w, _pad, _lines )	--	*** 41 STORY, PARTS ONLY ***
--	local _padNum = (_w -_pad) /21
--	local _col = (_w -_pad) /3
--	local _colour
--	local _tSingleRm = tMap.rms[ tMap.rms.idx ]
--	local _font = tPortHole.fontPixSize
--	local _numCount = 1
--	local _mPointer = tMenu.menuPointerIdx
--	if _mPointer < 1 then tMenu.menuPointerIdx =1 end	--RESET TO POSITIVE VALUE
--	local _space = _pad *6		--#. SPACE THEN .. ( _pad = tPortHole.pad *2 )
--	--local _hlPointer = tMap.rms[ tMap.rms.idx ].rObj.idx
--	local _x2 = _x +_font
--	local _x3 = _x2 +_col +_font
--	local _y2 = _y
--	local _label = "NONE-FOUND"
--	--[[ 
--	HEADER: STORY RV#, START R#, CCMDS, EDITABLE
--	ROOM: R#, LABEL, EXISTS, IMAGE, SOUND, DATALOCK, LANDLAYERLOCK, TIMER, COUNTER
--	]]
--	if tMenu.tRmAu.menuIdx == 4 then									-- < "STORY MENU" - "PARTS" ONLY >
--		tMenu.tMenuPOTT.menuIdx = 1
--		if tMenu.tMenuPOTT.menuIdx == 1 then							-- 
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "STORY RV#:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", tMap.hRVnum )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
--			--HEADER MATERIAL 1st
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "START ROOM#:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", tostring(tMap.hPlayerStart) )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "CUSTOM CMDS:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "cCatbb", tMap.hCCmds )
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "PER FLOOR:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			_label = hasValue( "text", tostring( tMap.level ) )
--			_y2 = pfLine( "-+ " .. _label, _x3, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			_colour = setColourHL( "fb", _numCount, 0, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_x2 = pfLine( tostring( _numCount )..".", _x2, _y2, _padNum, "right" )
--			love.graphics.printf( "STORY DATA LOCKED:", _x2, _y2, _col, "left" )
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--_label = hasValue( "bool", tMap.hEDIT )
--			if tMap.hDataLOCKED then _label = "TRUE" else _label = "FALSE" end
--			_y2 = pfLine( _label, _x3, _y2, _w, "left" )
--			--_x2 = _x
--			_numCount = _numCount +1
			
--			--			if _tSingleRm.rCountDOWN then _label = "TRUE" else _label = "FALSE" end
--			--			--_label = hasValue( "text", tostring( _tSingleRm.rCountDOWN ) )
--			--			_y2 = pfLine( _label, _x2 +_col, _y2, _w, "left" )		--_y2 = _y2 + _font IN RETURN ;)
--			--			_x2 = _x
--			--			_numCount = _numCount +1
--		end
--		--STORY CUSTOM CMDS 
--		--STORY EDITING - T/F
--		--LABEL, HIDDEN, COUNT, AUTHOR, TIMER, COUNTDOWN, OBJ-ON, COMMENTS, IMAGE, SOUND
--		--end
--	end
--	_y2 = _y2 + _font
--	--_numCount = _numCount +1
--	--drawMenuACEDOX( _x, _y2, _w, _pad,  _lines +_numCount  )
--	return _y2, _lines +_numCount
--end

--function drawMenuObjs( _x, _y, _w, _pad, _bOBJS )
--	local _padNum = (_w -_pad) /21
--	local _col = (_w -_pad) /3
--	local _lines = 2																	--NUMBER OF LINES IN MENU
--	local _colour
--	--local _table = tMenu.tMenuObjsTWs.textList			--{"ON-PERSON OBJECTS","IN-ROOM OBJECTS"}
--	local _font = tPortHole.fontPixSize
--	local _numCount = 1
--	local _mPointer = tMenu.menuPointerIdx
--	local _space = _pad *6
--	local _hlPointer = tMap.auLeg.idx 		--tMenu.menuPointerIdx - _lines
--	local _y2 = _y
--	local _x2 = _x +_font
--	local _x3 = _x2 +_col +_font
--	local _tObjs = tMap.rms[ tMap.rms.idx ].rObj	-- *** "IN-ROOM MENU" ***
--	--local _tTWs = tMap.rms[ tMap.rms.idx ].rObj[1].tripWire	-- *** "IN-ROOM MENU" ***
--	if tMenu.tRmAu.menuIdx == 3 then									-- *** "ON-AUTHOR OBJ" ***
--		_tObjs = tMap.auLeg
--	end
--	if _bOBJS and #_tObjs >0 then											--LIST ALL 1.OBJECT(S)...
--		for idx =1, #_tObjs do
--			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
--			love.graphics.setColor( _colour )
--			--love.graphics.printf( tostring( idx )..".", _x2, _y2, _padNum, "right" )
--			_x2 = _x2 + _pad *4
--			local _label = tostring( _tObjs[ idx ].label ) .."(" ..tostring( _tObjs[ idx ].count ) ..")"
--			love.graphics.printf( _label, _x2 +_space, _y2, _w, "left" )
--			_y2 = _y2 + _font
--			_x2 = _x
--			_numCount = _numCount +1
--		end
--	end
--	return _y2
--end
----		*** TRIPWIRE MENU <Cmd/Obj/R#/Dirt> ***	BUT WHOS TW ARE WE LOOKING AT?
--function drawMenuTWsAction( _x, _y, _w, _pad, _bTWS )
--	local _padNum = (_w -_pad) /21
--	local _col = (_w -_pad) /3
--	local _lines = 2														--NUMBER OF LINES IN MENU
--	local _colour
--	--local _table = tMenu.tMenuObjsTWs.textList			--{"ON-PERSON OBJECTS","IN-ROOM OBJECTS"}
--	local _font = tPortHole.fontPixSize
--	local _numCount = 1
--	local _mPointer = tMenu.menuPointerIdx
--	local _space = _pad *6
--	--local _hlPointer = tMap.auLeg.idx --tMenu.menuPointerIdx - _lines
--	local _y2 = _y
--	local _x2 = _x +_font
--	local _x3 = _x2 +_col +_font
--	local _label = "NONE-FOUND"
--	--HOW MANY SOURCES? BOTH OBJECTS & ROOM TRIPWIRE
--	--"IN-ROOM" TW HAS ONLY TW-REACTION SO AS TO NOT CONFUSE ANYONE
--	--if 
--	local _iObj = tMap.rms[ tMap.rms.idx ].rObj.idx		--PIN DOWN THE ROOM INDEX
--	--local _tTWs = tMap.rms[ tMap.rms.idx ].rObj[ _iObj ].tripWire	-- *** "IN-ROOM" OBJECT.TWS ***
--		--local bTWS = foobar
--		--if tMenu.tRmAu.menuIdx == 1 then									-- or 
--			--_tTWs = tMap.auLeg[ _idxObj ].tripWire
----	if tMenu.tRmAu.menuIdx == 3 then									-- or *** "ON-AUTHOR OBJ" ***
----		_tTWs = tMap.auLeg[ _idxRmObj ].tripWire	--ON-AUTHOR OBJECT.TWS
----	elseif tMenu.tMenuPOTT.menuIdx == 3 then						-- or *** "TW-ACTION" ***
		
----	end
----	--OBJ IN USE SHOULD BE HL IN LCS ABOVE MENUS, KEEP THAT INTUITION/PATTERNS CHANGES USEFUL
----	if #_tTWs >0 then --_bTWS and											--LIST ALL 1.OBJECT(S)...
----		for idx =1, #_tTWs do
----			_colour = setColourHL( "text", _numCount, _mPointer -_lines, _numCount, _mPointer -_lines )
----			love.graphics.setColor( _colour )
----			--love.graphics.printf( tostring( idx )..".", _x2, _y2, _padNum, "right" )
----			_x2 = _x2 + _pad *4
----			local _label = tostring( _tTWs[ idx ].label ) .."(" ..tostring( _tTWs[ idx ].count ) ..")"
----			love.graphics.printf( _label, _x3, _y2, _w, "left" )
----			_y2 = _y2 + _font
----			_x2 = _x
----			_numCount = _numCount +1
----		end
----	end
----	--drawMenuACEDOX( _x, _y, _w, _pad, _lines +_numCount )
--	return _y2
--end

--function drawMenuTWsReAction( _x, _y, _w, _pad, _bTWS )
	
--	--drawMenuACEDOX( _x, _y, _w, _pad, _lines +_numCount )
--	return _y --2
--end

----2nd OR 3rd LINE IN MENU PRESENTATION
--function drawMenuACEDOX( _x, _y, _w, _pad, _lines )
--	local tText = tMenu.tMenuACEDOXcmds.textList		--{"Add","Edit","Delete","reOrder","eXit"}
--	local _colour
--	local _x2 = _x
--	local _y2 = _y
--	local _font = tPortHole.fontPixSize
--	local _col = (_w -_pad) /6
--	--local _line = tMenu.menuPointerIdx -1
--	--	if _lines < 1 then _lines =1 end
--	--	if tMenu.tRmAu.menuIdx == 2 then			--OBJECT MENU
--	--		if tMenu.tMenuObjsTWs == 1 then						--"ON-PERSON OBJECTS"
--	--			_lines = 2 + #tMap.auLeg +1
--	--		elseif tMenu.tMenuObjsTWs == 2 then				--"IN-ROOM OBJECTS"
--	--			_lines = 2 + #tMap.rms[ tMap.rms.idx ].rObj +1
--	--		end
--	--	elseif tMenu.tRmAu.menuIdx == 3 then			--TRIPWIRE MENU
--	--		if tMenu.tMenuTWs == 1 then							--"TRIPWIRE: Cmd/Obj/R#/Dirt"
--	--			--_lines = 2 + #tMap.rms[ tMap.rms.idx ].rTripWire
--	--		elseif tMenu.tMenuTWs == 2 then					--"ACTION: Cmd/Obj/R#/File/Com/Sty"
--	--			--_lines = 2 + #tMap.auLeg
--	--		end
--	--	end
--	local _hl = 0
--	if tPortHole.drawMENU then
--		_hl = 3
--	else
--		_hl = 0
--	end
--	for idx =1, 6 do
--		--if idx == 1 and tMenu.tEditLine == 11 then 
--		_colour = setColourHL( "text", idx, tMenu.tMenuACEDOXcmds.menuIdx, _hl, tMenu.tMenuACEDOXcmds.menuIdx )
--		love.graphics.setColor( _colour )
--		love.graphics.printf( tText[ idx ], _x2, _y2, _col, "center" )
--		_x2 = _x2 +_col
--	end
--	_x2 = _x
--	for idx =1, 6 do
--		_colour = setColourHL( "<>", idx, tMenu.tMenuACEDOXcmds.menuIdx, _hl, tMenu.tMenuACEDOXcmds.menuIdx )
--		love.graphics.setColor( _colour )
--		love.graphics.printf( "<", _x2, _y2, _col, "left")
--		love.graphics.printf( ">", _x2, _y2, _col, "right")
--		_x2 = _x2 +_col
--	end
--	return _y2
--end

--function drawMenuExit( _x, _y, _w, _pad )	--MAKE THIS GENERIC FOR MANY OVERLAY CHOICES
--	local _colour
--	local _font = tPortHole.fontPixSize
--	_colour = setColourHL( "text", 1, 1, 1, 1 )
--	love.graphics.setColor( _colour )
--	love.graphics.printf( "TERMINATE PROGRAM", _x, _y, _x, "center" )
--	_y = _y + _font
--	for idx =1, 2 do
--		_colour = setColourHL( "text", idx, tMenu.tMenuExit.menuIdx, _lines, tMenu.menuPointerIdx )
--		love.graphics.setColor( _colour )
--		love.graphics.printf( tMenu.tMenuExit.textList[ idx ], _x, _y, _x, "center" )
--	end
--	--_y = _y + _font
--	for idx =1, 2 do
--		_colour = setColourHL( "<>", idx, tMenu.tMenuExit.menuIdx, idx, tMenu.menuPointerIdx )
--		love.graphics.setColor( _colour )
--		love.graphics.printf( "<", _x, _y, _x, "left")
--		love.graphics.printf( ">", _x, _y, _x, "right")
--	end
--	return _y
--end

--function pfLine( _label, _x, _y, _w, _lcr )
--	love.graphics.printf( _label, _x, _y, _w, _lcr )
--	if _lcr == "left" then
--		return _y + tPortHole.fontPixSize
--	elseif _lcr == "right" then
--		return _x + tPortHole.yPad *12
--	elseif _lcr == "center" then
--		return "FOOBAR"
--	end
--end