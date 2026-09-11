--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
--]]
function love.textinput( _char )	--HELPS EXPLAIN FUNCTIONS FILTER
	local _acedoxCMD = tMenu:eccoACEDOXbools()	--T/F
	local _menuCMD = false
	local _buff = ""
	if #_char == 1 and _char ~= "\"" then	--ROBB DAWSON "BUG IS ACTUALLY PROCESSED AS "\""
		--if _char == "+" then					--HELP TYPIST AVOID +# OR +CHAR
			--if not tStory.plusED then
				--tStory.plusED = true
			--elseif tStory.plusED then
				--tStory.plusED2 = true
			--end
		if tMap.plusED2 and _char ~= " " and _char ~= "T" then
			tMap.keylog = tMap.keylog .. " "
			tMap.plusED2 = false
			tMap.plusED = false
		elseif tMap.plusED and _char ~= " " and _char ~= "+" and _char ~= "T" and _char ~= "c" then
			tMap.keylog = tMap.keylog .. " "
			tMap.plusED = false
		else
			tMap.plusED2 = false
			tMap.plusED = false
		end
		tMap.tabTAB = false
		if tPortHole.drawMENU then
			_buff, _menuCMD = buffKeyLog( _char, tMap.keylog )
			if _menuCMD and _char ~= "e" then
				menusUpdate( _char )
			elseif _acedoxCMD then
				--tMenu.tMenuACEDOXcmds.turnedON
				menusUpdate( _char )
			end
			--elseif tSM.l3[ tSM.idxState ] == "LCS-TA" then	--NEED TO MAKE SURE ANY 1 LINE IS FINISHED
				--tStory.typeDeadFast.perLineSTOP = true		--KILL LOOP@EOL
		else		--BUILDING UP THE TYPING FROM AUTHOR/USER
			tMap.keylog, _menuCMD = buffKeyLog( _char, tMap.keylog )
		end
	end
end

function love.keypressed( _word )	--WORD HELPS EXPLAIN FUNCTION FILTER
	local _acedoxCMD = tMenu:eccoACEDOXbools()	--T/F		(NOT) MENUS ACTIVE TRUE
	local _fnFOLDER, _FILE = false, false
	--local _idx = tStory.rms.idx
	if #_word > 1 then		--FILTER BY WORD/SINGLE CHARACTER SIZE
		if tPortHole.drawMENU and tMenu.menuPointerIdx >2 then
			if _word == "escape" then
				goESC()		--FALLBACKS
			elseif _word == "left" then
				menusUpdate( _word )
				goLeft()
			elseif _word == "right" then
				menusUpdate( _word )
				goRight()
			elseif _word == "up" then
				menusUpdate( _word )
				goUp()
			elseif _word == "down" then
				menusUpdate( _word )
				goDown()
			elseif _word == "return" then
				menusUpdate( _word )
			elseif _word == "backspace" then
				menusUpdate( _word )
			end
		elseif tPortHole.drawMENU then --and tMenu.menuPointerIdx <= 2 then
			if _word == "escape" then				--ROLL BACK MENUS >> MENUS >> LCT-TA GUI >> QUESTION >> QUESTION ...
				--_ = meXit()
				goESC()									--older code needs going over
			elseif _word == "left" then
				goLeft()
			elseif _word == "right" then
				goRight()
			elseif _word == "up" then
				goUp()
			elseif _word == "down" then
				goDown()
			end
		elseif not tPortHole.drawMENU then		-- *** <= RETRO-TERM ***
			if _word == "escape" then					--ROLL BACK MENUS >> MENUS >> LCT-TA GUI >> QUESTION >> QUESTION ...
				if tSM.curState == "NEW-AUTHOR" or tSM.curState == "NEW-EVENT" then				--MOVE INTO LIST-*
					tSM:walk( true )
				elseif tSM.curState == "NEW-EVENT" or tSM.curState == "SELECT-EVENT" then
					tSM.idxLoop = 1								--AUTHOR
					tSM.idxState = 2							--LIST
					tSM.curState = tSM.l1[ tSM.idxState ]
				elseif tSM.curState == "MENUS" then		--FALLBACK TO LCS-TA
					tSM:walk( false )
				elseif tSM.curState == "GLASSES" then	--FALLBACK TO LCS-TA
					tSM:walk( false )
					tSM:walk( false )
				end
			elseif _word == "left" then
				goLeft()
			elseif _word == "right" then
				goRight()
			elseif _word == "up" then
				goUp()
			elseif _word == "down" then
				goDown()
			elseif _word == "tab" then   -- *** SIMULATE THE <TAB><TAB> IN A *NIX TERMINAL ***
				if #tMap.keylog > 0 then
					local _char = string.match( tMap.keylog, "%a+")  --CHARACTER MATCHING
					if #_char > 0 and tMap.tabTAB then
						--LIST ALL THE CMDS STARTING WITH FIRST LETTER OF THE TEXT STRING
						tPortHole.cmdForcast = tabTab( string.lower( _char ) )
						tMap.tabTAB = false
						tMap.keylog = _char --GOING TO LEAVE THE USER WITH CHARACTER LEADING COMMAND
					elseif tMap.tabTAB == false then
						tMap.tabTAB = true
					end
				end
			elseif _word == "rshift" or _word == "lshift" then -- or _key == "lshift" then
				tMenu.tEditLine.cap = true			--MAY HAVE KILLED THIS NEED NOW...
				_word = ""
			elseif _word == "backspace" then	--OTHER THAN MENUS
				--tDrawState *** "NEW-AUTHOR" & "NEW-EVENT" & "LCS-TA" ***
				tMap.keylog = string.sub( tMap.keylog, 1, #tMap.keylog -1 )
			--2 DIFFERENT CMDFORCAST DEALS?
			elseif _word == "return" then			-- *** AUTHOR/USER FINISHED TYPING NOT MENUON ***
				if #tPortHole.cmdForcast > 0 then tPortHole.cmdForcast = {} end	--RetroDraw
			end
		end
		if _word == "return" then			--	<RETURN>
			if #tPortHole.cmdForcast > 0 then
				tPortHole.cmdForcast = {}
			end						--TAB-TAB RESET
			if #tPortHole.eccoDisplayBuff >0 then	--SECOND ASSIGNMENT OF TABLE!
				tPortHole.eccoDisplayBuff = { GO = false, firstLine = 0, lastLine = 0 }
			end		--RESET BUFFER
			
			if tSM.idxLoop == 1 then
				if tSM.curState == "NEW-AUTHOR" then	--tSM.l1[ tSM.idxState ]
					if string.match( tMap.keylog, "%a+" ) then		--AT LEAST 1 LETTER
						createDir( tMap.keylog ) --USER TYPED NEW-AUTHOR
						tSM:walk( true )
					end
				elseif tSM.curState == "SELECT-AUTHOR" then --FEEDING OFF THE .DRAW()	--tSM.l1[ tSM.idxState ]
					-- *** PROCESSING THE NON-KEY ***
					if tMap.keylog == "" then
						tMap.keylog = tostring( tMenu.menuPointerIdx )	--LOOPBACK POINTER SELECTION
					end
						-- *** WITH KEY-STROKES BELOW ***
					if tMap.keylog == "0" then		--NEW-AUTHOR SELECTED
						tMap.keylog = ""
						tSM:walk( false )
						tSM:walk( false )
					elseif tonumber( tMap.keylog ) > 0 then 					--CHANGE CURRENT AUTHOR SELECTED
						tMap.authors.idxA = tMenu.menuPointerIdx				--SET SELECTEDC AUTHOR
						tMap.hAuthor = tMap.authors[ tonumber( tMap.keylog ) ]
						tMap.keylog = ""
						tSM:walk( true )
						--tSM:walk( true )  															--MOVING INTO LOOP2, "LIST-EVENTS" WITH FALLBACK
					end
				end
			elseif tSM.idxLoop == 2 then
				local _fileEXISTS = false
				if tSM.curState == "SELECT-EVENT" then	--tSM.l2[ tSM.idxState ]
					-- *** PROCESSING THE NON-KEY ***
					if tMap.keylog == "" then
						tMap.keylog = tostring( tMenu.menuPointerIdx )
					end
						-- *** WITH KEY-STROKES BELOW ***
					if tonumber( tMap.keylog ) == 0 then
						--CREATE NEW-EVENT AND PUT THAT IN MEMORY
						tMap.eventsA.idx = tonumber( tMap.keylog )	--WE NEED THAT INDEX LATER SO SET INDEX
						tMap.fileName = tMap.eventsA[ tMap.eventsA.idx ]
						tMap.keylog = ""
						tSM:walk( false )
					elseif tonumber( tMap.keylog ) > 0 then
						tMap.eventsA.idx = tonumber( tMap.keylog )
						--tStory.authors.idxA = tMenu.menuPointerIdx
						tMap.fileName = tMap.eventsA[ tMap.eventsA.idx ]	--UPDATE TO RV# VAR SHORTLY WHEN LOADING
						tMap.keylog = ""
						--CHECKING FILE DATA SIZE, LOAD DATA >0
						_fnFOLDER, _FILE, _size = chkFileZero( tMap.authors[ tMap.authors.idxA ], tMap.fileName )
						if _FILE and _size >0 then
							tMap.deadTYPIST = eventFileLoad( tMap.hAuthor, tMap.fileName ) --SORT OUT EDIT MODE ETC
						else
							tMap:setNewMap( tMap.hAuthor, tMap.fileName )  --SETUP NEW STORY AS FILE IS 0 BYTES IN SIZE
							tRetro:rmCreate( tMap.fileName,"R1",{ m =0, x =0, y =0, z =0 },nil )
							tMap:ticToc( true, nil )
							--keyLogCmdCheck()	--THERE IS NO SPOON
							--keyLogInjectCmds()	--UPDATE OUR FILES CONTENTS
							--WE DON'T NEED TO SAVE YET BUT NICE TO SEE FILE SIZE CHANGE
							eventFileSave( tMap.hAuthor, tMap.fileName )
							--tMap.keylog = "load"
							--love.keypressed( "return" )
						end
						tSM:walk( true )
					end
				elseif tSM.curState == "NEW-EVENT" then		--tSM.l2[ tSM.idxState ]
					_fnFOLDER, _FILE = false, false
					local _fileSize = nil
					if string.match( tMap.keylog, "%a+" ) then				--AT LEAST 1 LETTER
						tMap.fileName = tMap.keylog
					else
						tMap.fileName = "DieHold2046"	--DEFAULT filename
					end
					--WE REALLY DO NEED TO CREATE THE FILE TO MAKE LIFE EASIER WHEN WE JUMP BACK TO STORY LIST
					_fnFOLDER, _FILE, _fileSize = chkFileZero( tMap.hAuthor, tMap.fileName )
					if not _FILE then
						createFSEvent( tMap.hAuthor, tMap.fileName, _fnFOLDER ) 			--WORKS FINE
						--COULD REALLY USE A WAY TO TELL IF FILENAME LOADED IS RV# OR NOT! EVEN FROM CREATION POV
						tMap.hEventName, tMap.hRVnum = isFileNameRV( tMap.fileName )
						tMap.keylog = ""
						tSM:walk( true )
					else
						tMap.keylog = tMap.keylog .." FILE-EXISTS"
						--tSM:walk( false )
					end
				end
			elseif tSM.idxLoop == 3 then  													--<RETURN> PROCESS CMDS FOR USER
				if tSM.curState == "LCS-TA" then	--tSM.l3[ tSM.idxState ]
					local _runLOOP = false	--_objsCloneABLE, false
					local _tKeylog = {}
					tMap.tw = {}
					local _SUDO = false
					local _tw = {}																--CLONE ALL TWS
					if tPortHole.BBON or tMap.deadTYPIST then
						_SUDO = true		--local _SUDO = "DEAD-TYPIST-TOOLBOX" or "USER"
					end
					--EXTRA SPACE BECAUSE WE CUT UP THE WORDS NOW WITH " " & "'" AND FILTERS a,and,the...
					_tKeylog = seperateWords( tMap.keylog .." " ) --SPACE TERMINATOR
					if #_tKeylog > 0 then
						tMap.tw = bldCmdControl( _tKeylog )					--WILL NOW RETURN NESTED TABLE!
						_tw = tRetro:tblClone( tMap.tw )
						--_runLOOP = bldCmdControl( _tKeylog ) 				--TRANSLATE PLAYERS TEXT INTO TRIPWIRES & ASSUMED OBJECTS
						-- *** MATCH TYPED AGAINST OBJECTS TW'S ***	PLAY-MODE ONLY
						--if _runLOOP then														-- *** SEARCH FOR LEFT OVER ROOT-OBJS.count == 0 FROM MOVING TABLES ABOUT ****** THE dt MIRROR loop3 ECCO ON <RETURN> ***
						if #_tw >0 then
							if not tMap.deadTYPIST then								--AND CCMD MATCHING WILL HELP SLOW DOWN THIS LOOPING
								removeDeadCount()
								addGhostTW()
							end
							for a = 1, #_tw do	-- *** LOOP THROUGH NESTS ***
								--local _BOOL = runTWaction( tMap.tw[ a ], _SUDO )	NO OBJ NO TW & NO GHOST-OBJS ANYMORE
								if not tMap.deadTYPIST and not tPortHole.BBON then		--DEADTYPIST NEED TO BE DONE
									if _tw[1] ~= "d" then				--FILTER DIRT FROM TW
										local _TW = runTWaction( _tw[ a ], _SUDO )	--CMD ACTIONS AFTER TRIPWIRE
										--WE MAY FILE SWAPOUT AND CONTINUE WITH CURRENT USER-TW ACTIONS!
										if _TW then
											rmTWchk( _tw[ a ] )							--RE-CODE OUR TW CHECKING
										end
									end
								else
									runTWaction( _tw[ a ], _SUDO )
								end
								--runTWaction( tMap.tw[ a ], _SUDO )	--CMD ACTIONS AFTER TRIPWIRE
							end
							--_runLOOP = runTWaction( tMap.tw, _SUDO )	--DIRT, MULTI-DIRT, R# JUMPS...
							-- *** SEARCH FOR LEFT OVER ROOT-OBJS.count == 0 ***
--							if not tMap.deadTYPIST then
--								removeDeadCount()
--								addGhostTW()
--							end
						end
						-- *** KEYLOG HISTORY STORAGE ***
						--CHECK AND SEE IF _SUDO IS USEFUL ANYMORE...?	-- not _SUDO and
						if #tMap.keylog >0 and not tMap.keyLogDROPIT then		--FALLBACK FOR "playerstart" AT END OF DEAD-TYPIST
							table.insert( tMap.tKeyLogHistory, tMap.keylog )
							tMap.tKeyLogHistory.idx = #tMap.tKeyLogHistory
							tMap.tKeyLogHistory.bUP = false
							--ADJUST BOARDER COLOUR TO ERROR COUNT,	HOLDING OUT HERE AS IT'S PER-SECOND ANYWAYS
							--keyLogCmdCheck()		--keyLogInjectCmds()
							--tPortHole:updateBdrColour( tMap.cmdsKeyLog )	--ROTATE 1st ERROR COLOUR
						end
					end
					--RESET TYPED NESTED TRIPWIRE DEFAULTS - NEST DISMANTLED
					tMap.keyLogDROPIT = false
					tMap.tw = {}
					tMap.keylog = ""
				elseif tSM.l3[ tSM.idxState ] == "MENUS" then					--<RETURN> PROCESS CMDS FOR USER
					tMap.tabTAB = false
					tMap.plusED = false
				end
			end
		elseif tMenu.tMenuACEDOXcmds.editLineON and _word == "delete" and --DATA LOCKED?
		not tMap.hDataLOCKED then
			--REMOVE THE LINE THAT MPOINTER IS CURRENTLY ON
			_ = buffKeyLog( "d", _keyLog )
			menusUpdate( "d" )
		end
	end
end

function buffKeyLog( _char, _keyLog )
--ALLOW MENUS KEY(s) Add Edit Delete reOrder eXit = a,e,d,o,x + all arrows
	local _menuCMD = false
	local _acedoxCMD = tMenu:eccoACEDOXbools()	--T/F
	if tPortHole.drawMENU and tMenu.menuPointerIdx >2
	and _char ~= "x" and not _acedoxCMD then --MPOINTER NEED BE INSIDE THE MENUS DANCE OF DATA
		if _char == "a" then -- and not tMenu.tMenuACEDOXcmds.addLineON then -- and not tMenu.objAddLine then				--"A"dd A LINE TO THE MENUS
			tMenu:addLineON()
			_char = ""
		elseif _char == "c" then -- and not tMenu.tMenuACEDOXcmds.copyLineON then		--"C"opy LINE	
			tMenu:copyLineON()
			_char = ""
		elseif _char == "e" then -- and not tMenu.tMenuACEDOXcmds.editLineON then -- and not tMenu.objAddLine then		--"E"dit LINE
			if tMenu.tEditLine.location == 11 and tMenu.menuPointerIdx == 6 then
				menusUpdate( 'return' )
			end
			tMenu:editLineON()
			_char = ""
		elseif _char == "d" and not tMap.hDataLOCKED then 
			-- and not tMenu.tMenuACEDOXcmds.delLineON		--"D"elete BLANK-DATA												
			tMenu:delLineON()
			_char = ""			--UNDO LIKE BEFORE, MAKE A COPY OF THE DELETED LIST
			--tMenu:delMenusMPointer( tMenu.tEditLine.location )	--DELETE TARGET IN MENUS
		--elseif _char == "o" then -- and not tMenu.objAddLine then		--re"O"rder LINES
			--tMenu:reOrderLineON()
			--_char = ""
		end
		return _char, true		--FALLBACK
	elseif tPortHole.drawMENU and not _acedoxCMD then
		if _char == "x" then							--e"X"it THE MENUS
			_char = meXit()
			return "", true		--FALLBACK
		end
	elseif tPortHole.drawMENU and string.match( _char,"%d" ) and tonumber(_char) > 0 and --then
		(( tSM.idxDState >= 1 and tSM.idxDState <= 4 ) or tSM.idxDState == 6 ) then
		--and not _acedoxCMD then
		--tSM.curState == "MENUS" )then
		if ( tSM.idxDState >= 1 and tSM.idxDState <= 4 ) then --or tSM.idxDState == 6 then
			tMenu.menuPointerIdx = tonumber( _char )
			--		elseif ( tMenu.tM3ROT.menuIdx == 2 or tMenu.tM3ROT.menuIdx == 3 ) then
			--			tMenu.menuPointerIdx = tonumber( _char ) + 2
			--		elseif tMenu.tM3ROT.menuIdx == 1 then
			--			tMenu.menuPointerIdx = tonumber( _char ) + 2
		end
	elseif _char == "@" or _char == "_" or _char == "&" or
	_char == "-" or _char == "." or _char == " " then	--SPACE NEW HERE
		if tSM.curState ~= "LIST-AUTHORS" and tSM.curState ~= "LIST-EVENTS" then
			return _keyLog .. string.sub( _char,1,1 ), _menuCMD
		end
		--PROCESS NUMBERS
	elseif string.match( _char,"%d" )  then
		return _keyLog .. string.match( _char,"%d" ), _menuCMD
	--LIMIT THE EXTRA SYMBOLS FOR THE STORIES AS THEY MY BE NEEDED
	elseif ( _char == "!" or _char == "'" or _char == "#" or _char == "$" or _char == "%" ) or
		( _char == "^" or _char == "*" or _char == "(" or _char == ")" ) or
		( _char == "," or _char == "/" or _char == ":" or _char == ";" ) or 
		( _char == "+" or _char == "|" or _char == "~" ) then
		if tSM.curState == "LCS-TA" then
			return _keyLog .. string.sub( _char,1,1 ), _menuCMD
		end
		--PROCESS THE OTHER 4 STATES KEPT CHARACTERS THE
	elseif tSM.curState ~= "LIST-AUTHORS" and tSM.curState ~= "LIST-EVENTS"
	and #_char >0 then
		return _keyLog .. string.match( _char,"%a" ), _menuCMD  --APPEND 1 LETTER
	end
	return _keyLog, _menuCMD		--FALLBACK
end

function keyLogInjectCmds()	--INJECT BACKWARDS BECAUSE WE ARE DROPPING INTO 1st PLACE OVER AND OVER
	--ZERO-FILE ABOUT TO BE OVER WRITTEN ;)
	local _text = ""	
	--if tMap.cmdsKeyLog.MAPLOCK == false then
	if tMap.hDataLOCKED == true then
		_text = "true"
	else
		_text = "false"
	end
	keyLogCmdClean( "maplock" )
	table.insert( tMap.tKeyLogHistory,1, "maplock " .._text )
	
	keyLogCmdClean( "setplayerstart" )
	_text = "setplayerstart " ..tostring( tMap.hPlayerStart )
	table.insert( tMap.tKeyLogHistory,1, _text )
	
	keyLogCmdClean( "ccmd" )					--FALLBACK TO MANY LINES AS WE NEED 1/2 LEVELS LIKE MY HOUSE STAIRWAY
	_text = "ccmd " .. ccat( " ", tRetro.hCCmds )
	table.insert( tMap.tKeyLogHistory,1, _text )
	
	keyLogCmdClean( "maplabel" )			--tMap.hEventName		--maplabel NEXT ALWAYS ONTOP LABEL
	_text = "maplabel " .. tMap.hEventName
	table.insert( tMap.tKeyLogHistory,1, _text )
	
	keyLogCmdClean( "author" )
	_text = "author " ..tostring( tMap.hAuthor )
	table.insert( tMap.tKeyLogHistory,1, _text )
	
	keyLogCmdClean( "rvnum" )
	_text = "rvnum " ..tostring( tMap.hRVnum )
	table.insert( tMap.tKeyLogHistory,1, _text )
	
	keyLogCmdClean( "bb" )
	table.insert( tMap.tKeyLogHistory,1, "bb" )
	
	--WHAT ABOUT playerstart AT THE END OF THE FILE, THUS TRIGGER BB TO FLIP TO PLAY MODE OR STAY IN BUILD MODE
end

function keyLogCmdClean( _cmd )
	local _count = 1
	local _first, _end = 0,0
	while _count < #tMap.tKeyLogHistory do
		--NEED CMDS TO BE FOUND AT BEGINNING OF LINE!
		_first, _end = string.find( tMap.tKeyLogHistory[ _count ], _cmd )
		if _first == 1 and _end > _first then
			table.remove( tMap.tKeyLogHistory, _count )
			_count = 1
		else
			_count = _count +1
		end
	end
	--tMap.keyLogDROPIT = false	--FALLBACK FOR ALL THE DELETING GOING ON, DEFAULT FALSE ANYWAYS
end

function menusUpdate( _wide )
	local _location = tMenu.tEditLine.location
	local _word, _char = "",""
	if #_wide >1 then 
		_word = _wide
	else
		_char = _wide
	end
	if tPortHole.drawMENU then
		if _location == 11 then								-- *** "ROOM-THEATER","PARTS LIST" ***
			location11( _word, _char )
		elseif _location == 12 then						--*** "ROOM-THEATER","OBJECTS" ***
			location14( _word, _char )
		elseif _location == 14 then						--*** "ROOM-THEATER","TW-REACTION" ***
			location14( _word, _char )
		elseif _location == 21 then						-- *** "IN-ROOM OBJ","PARTS LIST" ***
			location2131( _word, _char, true )	--true IS IN ROOM
		elseif _location == 22  then					-- *** "IN-ROOM OBJ","OBJECTS" ***
			location2232( _word, _char, true )
		elseif _location == 23 then						--*** "IN-ROOM OBJ","TW-ACTION" ***
			location2333( _word, _char )
		elseif _location == 24 then						--*** "IN-ROOM OBJ","TW-REACTION" ***
			location2434( _word, _char )
		elseif _location == 31 then						-- *** "ON-AUTHOR OBJ","PARTS LIST" ***
			location2131( _word, _char, false )
		elseif _location == 32 then						-- *** "ON-AUTHOR OBJ","OBJECTS" ***
			location2232( _word, _char, false )
		elseif _location == 33 then						--*** "ON-AUTHOR OBJ","TW-ACTION" ***
			location2333( _word, _char )
		elseif _location == 34 then						--*** "ON-AUTHOR OBJ","TW-REACTION"
			location2434( _word, _char )
		elseif _location == 41 then 					-- *** "STORY","PARTS LIST" ***
			location41( _word, _char )
		end
	end
end

function meXit()
	tMenu:resetACEDOXbools()
	--tMenu.tMenuACEDOXcmds.menuIdx = 6
	tPortHole.drawMENU = false
	tSM:walk( false )									--ROLLING BACK TO LCS-TA
	return "" 	--_char
end

function goESC()	--FALLING BACK FLOW FROM DIFFERENT LOCATIONS
  --love.event.quit()
	--local partsVIEW = tMenu.tMenuObjsTWs.mLIST -- or tMenu.tMenuTWs.mTWS
	if tMenu.tMenuACEDOXcmds.editLineON then
		tMenu:resetACEDOXbools()	--KICK OUT OF EDIT MODE
		--tMenu.menuPointerIdx = 2	--ONLY USEFUL AS VISUAL FEEDBACK TO KNOW <ESC> DID SOMETHING
	elseif tPortHole.drawMENU and not tMenu.tMenuACEDOXcmds.editLineON then
		tMap.keylog = ""
		_ = meXit()
	elseif tSM.tDrawState[ tSM.idxDState ] == "LCS-TA" then	--FALLBACK TO l2
		tSM.idxLoop = 1					--SWITCH WILL TURN ON l2 - RE-CYCLED CODE
		tSM:walk( false )
		tMap.keylog = ""
		tPortHole.drawMENU = false
		drawMenuExit( _x, _y, _w, _pad )
		--tSM:walked( true )																					--FALLBACK
	elseif tSM.tDrawState[ tSM.idxDState ] == "LIST-EVENTS" then
		tSM.idxLoop = 0					--
		tSM:walk( false )
		tMap.keylog = ""
		--tSM:walked( true )																					--FALLBACK LOOP2 TO L1
			--	elseif tSM.tDrawState[ tSM.idxDState ] == "NEW-AUTHOR" or 
			--	tSM.tDrawState[ tSM.idxDState ] == "NEW-EVENT" then
			--		tSM:walk( true )																						--FLIP BACK TO "LIST-*"
	end
end

function pointerUpDownReset()
	if tSM.curState == "SELECT-AUTHOR" then
		if tMenu.menuPointerIdx > #tMap.authors then
			tMenu.menuPointerIdx = tMap.authors.idxA
		elseif tMenu.menuPointerIdx < 0 then
			tMenu.menuPointerIdx = tMap.authors.idxA	--#tStory.eventsA
		end 
	elseif tSM.curState == "SELECT-EVENT" then
		if tMenu.menuPointerIdx > #tMap.eventsA then
			tMenu.menuPointerIdx = tMap.eventsA.idx
		elseif tMenu.menuPointerIdx < 0 then
			tMenu.menuPointerIdx = tMap.eventsA.idx	--#tStory.eventsA
		end 
	end
end

function goUp()
	local _location = tMenu.tEditLine.location
	local _anyCmds = tMenu:eccoACEDOXbools()
	if tSM.curState == "LCS-TA" then
		--CMD LINE HISTORY BACKWARDS JUST AS CLI
		if tMap.tKeyLogHistory.idx <= 0 then
			tMap.tKeyLogHistory.idx = #tMap.tKeyLogHistory
		end
		if #tMap.tKeyLogHistory > 0 then
			tMap.tKeyLogHistory.idx = cliUpDown( "UP" )
			--tStory.tKeyLogHistory.bUP = cliUpDown( "UP" )
			tMap.keylog = tMap.tKeyLogHistory[ tMap.tKeyLogHistory.idx ]
		else
			tMap.keylog = ""
		end
	elseif tPortHole.drawMENU and not _anyCmds then
		if tMenu.menuPointerIdx >0 then
			tMenu.menuPointerIdx = tMenu.menuPointerIdx -1
		end
	elseif tSM.curState == "SELECT-AUTHOR" or tSM.curState == "SELECT-EVENT" then
		tMenu.menuPointerIdx = tMenu.menuPointerIdx -1
		pointerUpDownReset()
	end
end

function goDown()
	local _location = tMenu.tEditLine.location
	local _anyCmds = tMenu:eccoACEDOXbools()
	if tSM.curState == "LCS-TA" then				--CMD LINE HISTORY BACKWARDS JUST AS CLI
		if tMap.tKeyLogHistory.idx <= 0 then
			tMap.tKeyLogHistory.idx = #tMap.tKeyLogHistory
		end
		if tMap.tKeyLogHistory.idx == #tMap.tKeyLogHistory then
			tMap.keylog = ""									--WE DON'T WANT TO GET STUCK IN HISTORY ;)
		elseif #tMap.tKeyLogHistory > 0 then
			tMap.tKeyLogHistory.idx = cliUpDown( "DOWN" )
			tMap.keylog = tMap.tKeyLogHistory[ tMap.tKeyLogHistory.idx ]
		end
	elseif tPortHole.drawMENU and not _anyCmds then
		tMenu.menuPointerIdx = tMenu.menuPointerIdx +1
	elseif tSM.curState == "SELECT-AUTHOR" or tSM.curState == "SELECT-EVENT" then
		tMenu.menuPointerIdx = tMenu.menuPointerIdx +1
		pointerUpDownReset()
	end
end

function TWreACT( _menuLine1, _menuLine2, _anyCmds )		--R2L
	if not _anyCmds and tMenu.menuPointerIdx > 2 then	--NO CMDS JUMP MENUS COLUMBS
		if _menuLine1 == 4 and _menuLine2 == 4 then	--EITHER OBJECT LOCATION
			return 3
		elseif _menuLine1 == 3 and _menuLine2 == 3 then	--EITHER OBJECT LOCATION
			return 4
		end
	end
	return _menuLine2
end

function goLeft()
	local _location = tMenu.tEditLine.location
	local _mPointer = tMenu.menuPointerIdx -2
	local _menuLine1 = tMenu.tRmAu.menuIdx
	local _menuLine2 = tMenu.tMenuPOTT.menuIdx
	local _anyCmds = tMenu:eccoACEDOXbools()
	if tPortHole.drawMENU then
		if tMenu.menuPointerIdx == 1 then						--"IN-ROOM MENUS" or "ON-AUTHOR MENUS" - LINE 1
			if _menuLine1 > 1 then
				tMenu.tRmAu.menuIdx = _menuLine1 -1
			end
		elseif tMenu.menuPointerIdx == 2 then 		--OBJECT MENUS
			if _menuLine2 == 4 and _menuLine1 == 1 then	--JUMP L14 >> L12
				tMenu.tMenuPOTT.menuIdx = 2
			elseif _menuLine2 > 1 then
				tMenu.tMenuPOTT.menuIdx = _menuLine2 -1
			end
		end
		--tMenu.tMenuPOTT.menuIdx = TWreACT( _menuLine1, _menuLine2, _anyCmds )
	end
end

function goRight()
	local _location = tMenu.tEditLine.location
	local _mPointer = tMenu.menuPointerIdx -2
	local _menuLine1 = tMenu.tRmAu.menuIdx
	local _menuLine2 = tMenu.tMenuPOTT.menuIdx
	local _anyCmds = tMenu:eccoACEDOXbools()
	if tPortHole.drawMENU then
		if tMenu.menuPointerIdx == 1 then					--"IN-ROOM MENUS" or "ON-AUTHOR MENUS" - LINE 1
			if _menuLine1 < #tMenu.tRmAu.textList then
				tMenu.tRmAu.menuIdx = _menuLine1 +1
			end
		elseif tMenu.menuPointerIdx == 2 then 		--"PARTS LIST","OBJECTS","TRIPWIRES"
			if _menuLine2 == 2 and _menuLine1 == 1 then			--JUMP --L12 >> L14
				tMenu.tMenuPOTT.menuIdx = 4
			elseif _menuLine2 < #tMenu.tMenuPOTT.textList then
				tMenu.tMenuPOTT.menuIdx = _menuLine2 +1
			end
		end
		--tMenu.tMenuPOTT.menuIdx = TWreACT( _menuLine1, _menuLine2, _anyCmds )
	end
end

function cliUpDown( _upDown )		--TERMINAL HISTORY LIKE FEEL
	if _upDown == "UP" then
		if  tMap.tKeyLogHistory.idx > 1 and tMap.tKeyLogHistory.bUP then
			return tMap.tKeyLogHistory.idx -1
		end
	else
		if tMap.tKeyLogHistory.idx < #tMap.tKeyLogHistory then
			tMap.tKeyLogHistory.bUP = false
			return tMap.tKeyLogHistory.idx +1
		elseif tMap.tKeyLogHistory.idx == #tMap.tKeyLogHistory then
			tMap.keylog = ""	--RESET CMD LINE TO EMPTY
		end
	end
	tMap.tKeyLogHistory.bUP = true
	return #tMap.tKeyLogHistory
end