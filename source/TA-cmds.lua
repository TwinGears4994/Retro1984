--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
--]]
function seperateWords( _keylog ) --TIME TO PARSE PLAYERS WORDS, WITH SPACES
	--_word ~= "a" and _word ~= "with" and _word ~= "the" and _word ~= "and"
	_table = {}
	if #_keylog > 1 then    --PLAYER NEEDS TO HAVE TYPED SOMETHING +SPACE ADDED
		local a, b, space, quote = 1,1,0,0
		local quotePAIR = false
		local _ = nil
		while b < #_keylog do --LOOP THROUGH THE LOGGED KEYS
			_, space = string.find( _keylog, "%s", b )
			if string.find( _keylog, "%'",b ) then
				_, quote = string.find( _keylog, "%'", b )
				if a +1 == quote or a == quote then --FOUND SPACE BEFORE SINGLE QUOTE
					--ASSUMING PAIRS WHEN WE GIVE OUT THE BOOL TRUE, LETS NOT ASSUME ANYMORE
					if string.find( _keylog, "%'", quote +1 ) then
						quotePAIR = true
					else
						a = a +1 --REMOVING SIDE EFFECT OF MISSING "'" BECAUSE IT LEADS WORD
					end
				end
			end
			--SPACE BEFORE SINGLE QUOTE CHARACTER IS THE FORK IN THE ROAD
			if not quotePAIR then
				_, b = string.find( _keylog, "%s", b )           --PARSE SPACING
				if a ~= b then
					table.insert( _table, string.sub( _keylog, a, b -1 ) )
					if string.sub( _keylog, a, b -1 ) == "TW" then
						table.insert( _table, " ")
					end
				end
				a = b +1
				b = b +1
			elseif quotePAIR then
				_, quote = string.find( _keylog, "%'", quote +1 )  --PARSE "'"
				--if a ~= b then
				table.insert( _table, string.sub( _keylog, a +1, quote -1 ) )
				--end
				a = quote +2
				b = quote +2		--A BECOME SAME AS B AND NOT USEFUL
				quotePAIR = false
			end
		end
		return _table
	else
		return ""
	end
end

--PROGRAM NEEDS TO RETURN TABLE AND STOP TALKING DIRECTLY TO tMap.tw AS CMD CONTROL NEEDS MORE FLEXIBILITY!
function bldCmdControl( _tblKeylog )  --CONVERT PLAYERS TEXT INTO TRIPWIRE PROCESSING JUST LIKE THE OLD PROGRAM
	--REMEMBER OBJECT MAYBE MISSING "s", "ies", "y" etc AND "n" OR "en" ADDED TO TAKEn AND EATen AS FEEDBACK  tMap.tw
	local _iCmdCtl = 1
	local _ccTbl = { idx = 0, {} }
	local _CCMD = false
	for iKey =1, #_tblKeylog do
		if _tblKeylog[1] == "ccmd" then
			_CCMD = true
		end
		if "TW" == _tblKeylog[ iKey ] then
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "TW", _iCmdCtl, _ccTbl[1] )
			_iCmdCtl = iKey +2
			--NEXT "TW" USEFUL IF WE ARE TO CCAT( after COMM T/F)
			--_split = string.find( _tblKeylog[1],"TW", _iKey )
		elseif " " == _tblKeylog[ iKey ] then
			table.insert( _ccTbl[1], "" )
		elseif isRoomNum( _tblKeylog[ iKey ] ) then					--R1001 OR R-1001 WORKS
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "room", _iCmdCtl, _ccTbl[1] )		--ROOM FOUND
		elseif isBuildCMD( _tblKeylog[ iKey ] ) then
			if _tblKeylog[1] == "repeat" then			--EXTRA PROCESSING IF WE FIND "repeat" - LETS MOVE THIS UP
				_ccTbl = { idx = 0 }	--WILL INSERT ENTIRE TABLE, SEE IF UPDATES MESS UP EARILER INJECTIONS DATA WISE!
				--_iKey = 2		--TIMER WINDOW UP NEXT, IS USEFUL INSIDE ORGINAL LOOP
				--CLONE _tblKeylog[1]
				local _tblStep = tRetro:tblClone( _tblKeylog )
				table.remove( _tblStep, 1 )		--REMOVE 1st 2 SECTIONS
				table.remove( _tblStep, 1 )		--WOULD LIKE TO KNOW TIMER WAS NEXT OR CMD WAS NEXT!
				local _tblRepeat = tRetro:tblClone( _tblStep )
				_tblRepeat[3] = "00:00:00:0"
				local _REPEAT = true
				--(SOURCE KEYLOG TIME WINDOW) NOW TIME OF HOUR:MIN:SEC:D + ROOM TIME START OF TIME WINDOW
				--END OF TIME WINDOW IS CURRENT START + TIMER TIME
				while _REPEAT do
					_tblRepeat[3] = addTime( _tblStep[3], _tblRepeat[3] )
					if _tblRepeat[3] <= _tblKeylog[2] then
						local _tbl = tRetro:tblClone( _tblRepeat )
						table.insert( _ccTbl ,_tbl )
						--_tblChanged = tRetro:tblClone( _tblRepeat )
					else
						_REPEAT = false
					end
				end
				--COULD RUN A LOOP OF FRACTAL SELF, UNLOADING OUR NEST OF ITEMS THROUGH bldCmdControl( TBL[NEST] )
				if #_ccTbl > 0 then
					_tbl = bldCmdControl( _ccTbl[ 1 ] )	--ADD CCMD CONTROL FOR 1 LINE TO BE COPIED FOR THE REST
					_tbl = _tbl[1]											--REMOVE NEST AND LOCATE ALL DATA AFTER "TW"
					local _iTW = { 1 }									--LIST OF INDEXES TO COPY CCMD ACROSS ALL NESTED DATA
					for a = 1, #_tbl do
						if string.find( _tbl[ a ], "TW" ) then
							table.insert( _iTW, a +1 )
						end
					end
					for b = 1, #_ccTbl do	--PUT IN ALL THE MISSING CCMD DATA
						for c = 1, #_iTW do
							if c == 1 then
								table.insert( _ccTbl[ b ], _iTW[ c ], _tbl[ c ] )
							else
								_ccTbl[ b ][ _iTW[ c ] ] =  _tbl[ _iTW[ c ] ]
							end
						end
					end
				end
				break
				--iKey = #_tblKeylog	--IF IT WAS A WHILE LOOP THIS WOULD WORK
			else
				_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "bcmd", _iCmdCtl, _ccTbl[1] )	--BUILD CMD FOUND
			end
		elseif isPlayCMD( _tblKeylog[ iKey ] ) then
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "pcmd", _iCmdCtl, _ccTbl[1] )		--PLAY CMD FOUND
		elseif _CCMD then-- isCustomCMD( _tblKeylog[ iKey ] ) then
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "ccmd", _iCmdCtl, _ccTbl[1] )		--CUSTOM CMD FOUND
		elseif isTime( _tblKeylog[ iKey ] ) then
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], ":", _iCmdCtl, _ccTbl[1] )				--REPRESENTS TIME FOUND
		elseif isNum( _tblKeylog[ iKey ] ) then							--NUMBER FOUND
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "#", _iCmdCtl, _ccTbl[1] )				
		elseif isDIRT( _tblKeylog[ iKey ] ) then							--NNN & N3 WORKS AS 3rd NORTH EXIST
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "dirt", _iCmdCtl, _ccTbl[1] )		--DIRECTION TO TRAVEL
		elseif isBOOL( _tblKeylog[ iKey ] ) then
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "&", _iCmdCtl, _ccTbl[1] )				--BOOL FOUND
			--elseif isDice( _tblKeylog[ iKey ] ) then
			--sortTW( _tblKeylog[ iKey ], "x", _iCmdCtl )				--DICE ROLL FOUND
		else
			--USER TYPES COOKIE RATHER THAN COOKIES WE NOW QUIETLY ADD THE MISSING "s"
			local _onAU, _iAu, _labelAu = tRetro:objAuEXISTS( _tblKeylog[ iKey ] )
			if _onAU then _tblKeylog[ iKey ] = _labelAu end
			local _inRM, _iRm, _labelRm = tRetro:objRmEXISTS( _tblKeylog[ iKey ] )
			if _inRM then _tblKeylog[ iKey ] = _labelRm end
			_ccTbl[1] = sortTW( _tblKeylog[ iKey ], "obj", _iCmdCtl, _ccTbl[1] )			--OBJECT FOUND AS FALL-BACK TO ALL OTHERS FAILED
		end
		--return true
	end
	return _ccTbl					--RETURN THE NEST
end
--SELF EXPANDING TRIPWIRE TO BE EXTENDED AND OR NESTED
function sortTW( _word, _type, _iCmdCtl, _ccTbl ) --"cmd","obj","room","dirt","#"
	if _word ~= "a" then
		--DIRT AND ROOM UPPER CAPITALIZATION
		if _type == "dirt" or _type == "room" then
			_word = string.upper( _word )
		end
		-- *** EXPANDING TRIPWIRES STORAGE TABLE ***
		local _iWalk = #tMap.tw
		--PROCESS 2 PARTS OR CONTINUE TO EXTEND TABLE?
		if #_ccTbl < 2 then											--LESS THAN 2 VALUES
			table.insert( _ccTbl, "" )							--ADD TRIPWIRE CMD VALUE SLICE
			table.insert( _ccTbl, "NONE" )					--ADD ANOTHER TRIPWIRE VALUE
		elseif _ccTbl[ _iWalk ] ~= "NONE" then
			table.insert( _ccTbl, "NONE" )
		end
		--EITHER 1st TWO NEED PROCESSING OR TABLE EXTENTION
		_iWalk = #_ccTbl
		if _ccTbl[ 2 ] == "NONE" then						--ASSIGN 1st 2 DATA PAIR VALUES
			_ccTbl[ _iCmdCtl ] = string.sub( _type,1,1 )	--ASSIGN TYPE 1 CHAR VALUE
			_ccTbl[ _iWalk ] = _word           		--ASSIGN WORD VALUE
		elseif _ccTbl[ _iWalk ] == "NONE" then		--	+1 CMD SLICE
			_ccTbl[ _iCmdCtl ] = _ccTbl[ _iCmdCtl ] .. string.sub( _type,1,1 )
			_ccTbl[ _iWalk ] = _word           		--ASSIGN WORD VALUE
		end
	end
	return _ccTbl
end

function setTW( _tw, _cmd )										--INSERT TRIPWIRE INTO TARGET OBJ OR ROOM
	_tw[1] = string.sub( _tw[1], 2, #_tw[1] )		--STRIP THE FIRST CHARACTER OF CMD CONTROL
	table.remove( _tw, 2 )											--REMOVING THAT CMD ALONG WITH IT
	--TRIPWIRE NOW CLEAN AND READY TO INSERT INTO OBJ OR ROOM
	local _idx = tMap.rms.idx
	local _iStart = 1
	local _split = string.find( _tw[1],"T", _iStart ) or 0
	local _iObj = string.find( _tw[1],"o", _iStart ) or 0		-- *** OBJECT FIND OR FAIL ***
	if _iObj == 0 then
		_iObj = string.find( _tw[ _split +2 ],"o",1 ) or 0
		if _iObj ~= 0 then _iObj = _split +2 + _iObj end
	end
	--local _rmOBJ, _iRmObj, _auOBJ, _iAuObj
	--OBJ BEFORE "TW" SPLIT WE NEED TO KNOW OBJECT EXISTS TO PLUG TRIPWIRE INTO IT
	if _iObj < _split and _iObj >0 then
		local _onAU, _iAu = tRetro:objAuEXISTS( _tw[ _iObj +1 ] )
		local _inRM, _iRm = tRetro:objRmEXISTS( _tw[ _iObj +1 ] )
		if _cmd == "+rtw" then										--TRIP OUT ALL OVER THE MAP
			for a =1, #tMap.rms do
				table.insert( tMap.rms[ a ].rTripWire, _tw )
			end
		elseif _cmd == "rtw" then
			--WOULD BE NICE TO MAKE SURE WE ARE NOT DUPLICATING A TW!
			table.insert( tMap.rms[ _idx ].rTripWire, _tw )
		elseif _cmd == "+tw" and _inRM then				--OBJECT IN-ROOM
			table.insert( tMap.rms[ _idx ].rObj[ _iRm ].tripWire, _tw ) 
		elseif _cmd == "++tw" and _onAU then			--OBJECT ON-PERSON
			table.insert( tMap.auLeg[ _iAu ].tripWire, _tw )
		elseif _cmd == "-tw" then

		end
		-- *** OBJ DATA BEYOND TW THUS PROBABLY CMD TIMER ***
	elseif _iObj > _split and _iObj ~= 0 then
		if _cmd == "+tw" then			--OBJECT IN-ROOM
			local _inRM, _iRm = tRetro:objRmEXISTS( _tw[ _iObj ] )
			if _inRM then table.insert( tMap.rms[ _idx ].rObj[ _iRm ].tripWire, _tw ) end
		elseif _cmd == "++tw" then			--OBJECT ON-PERSON
			local _onAU, _iAu = tRetro:objAuEXISTS( _tw[ _iObj ] )
			if _onAU then table.insert( tMap.auLeg[ _iAu ].tripWire, _tw ) end
		elseif _cmd == "rtw" then		--NON-OBJECT TARGET
			table.insert( tMap.rms[ _idx ].rTripWire, _tw )
		end
	end
end

-- *** PROCESS TRIPWIRE AND RETURN TRUE IF runGhostTWs() ***
function runTWaction( _tw, _SUDO ) --6 LOCATIONS: "RmTheater","RmTimer","ObjMatch","RmObjTimer","AuObjTimer",	"Typed" USED LIKE BOOL
	--tMap.keyLogDROPIT = true
	local _idx = 1
	local _iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime,_iBool = 0,0,0,0,0,0,0,0,0	--, _iObj2
	local _bCMD,_pCMD,_cCMD = false, false, false
	local _buildMODE = tPortHole.BBON
	local _trigger = nil
	local _BonAUN, _BiAuN, _AonAU, _AiAu, _ = false, 0, false, 0, nil
	local _BinRMN, _BiRmN, _AinRM, _AiRm = false, 0, false, 0
	local _BonAU, _BiAu, _BinRM, _BiRm = false, 0, false, 0
	--local _split = string.find( _tw[1], "T", _idx ) or 0
	local _mapCHANGED = false
	--FIX UP GLOBAL VARIABLES THAT SHOULD BE LOCAL ONLY...
	local _cmdHelper = "" 												--MATCH HELPER CCMDS from, to, etc
	local _cmd, _cmd2 = "", ""										--WHICH CMD IS 1st
	local _SUCCESS = false	--THIS FUNCTION TO RUN ITSELF
	if _buildMODE then	--WHAT MIGHT EXIST UPON FILE LOADING BUT ISN'T REQUIRED FOR FILE USE
		_SUDO = true		--AUTO BUILD MODE
	end
	_iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _bCMD,_pCMD,_cCMD, _cmd, _idx = idxEccoCmdControl( _tw, _idx )
	local _onAU, _inRM, _i, _label = false, false, 0, nil
	--CLONE COMPLEXITY MOVED UP HERE WILL HELP OTHER COMPLICATED CMDS...
	local _NUM, _OBJ, _DIRT, _RM, _TIME = false, false, false, false, false
	local _num, _obj, _dirt, _rmNum, _time = nil, nil, nil, nil, nil
	if _iNum > 0 then
		_num = tonumber( _tw[ _iNum ] )
		_NUM = true
	end
	if _iD > 0 then
		_dirt = _tw[ _iD ]
		_DIRT = true
	end
	if _iObj >0 then
		_obj = _tw[ _iObj ]
		_OBJ = true
	end
	if _iR >0 then
		_rmNum = _tw[ _iR ]
		_RM = true
	end
	if _iTime >0 then
		_time = _tw[ _iTime ]
		_TIME = true
	end
	---------------------------------------------------------
	-- JUMP ABOUT MAPING LOGIC (Dirt/Room)
	---------------------------------------------------------
	if ( not _bCMD and not _pCMD and not _cCMD ) and ( _iD ~= 0 or _iR ~= 0 ) then
		while _iD ~= 0 or _iR ~= 0 do			--LOWEST INDEX FIRST
			if ( _iD < _iR and _iD ~= 0 ) or _iR == 0 then	--( _iD < _iR and _iR ~= 0 ) or _iR == 0
				runCmdDirt( _tw[ _iD ], _SUDO, nil )	--DIRT "USER"
			elseif ( _iR < _iD and _iR ~= 0 ) or _iD == 0 then
				local _rmEXISTS, _, _mapB, _rmIdxB = isRmInSTORY( _tw[ _iR ] )
				--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
				if _rmEXISTS then
					tRetro:switchRoom( _mapB )
				end
			end
			if ( _iD < _iR and _iD ~=0 ) or _iR == 0 then
				_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iD )
			elseif ( _iR < _iD and _iR ~= 0 ) or _iD == 0 then
				_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iR )
			end
		end
		tMap:ticToc( true, "00:00:00:0" )		--MAY NEED TO REM-OUT
		tPortHole.eccoDisplayBuff.GO = true
		return false
		---------------------------------------------------------
		-- BUILD CMD BLOCK
		---------------------------------------------------------
	elseif _bCMD and _SUDO then				--COMM CMD COMES FROM trimFwdTW() ECHO FROM USER ON THE CLI
		--tMap.keyLogDROPIT = true
		if _cmd == "samecmd" then
			local _tbl = {}
			_iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, 1 )
			while _iP >0 or _iC >0 do
				if _iP ~= 0 then						--PLAY CMDS LISTED TO GO 1st
					table.insert( _tbl, _tw[ _iP ] )
					_iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iP )
				elseif _iC ~= 0 then				--CUSTOM CMDS NEXT UP
					table.insert( _tbl, _tw[ _iC ] )
					_iB,_iP,_iC,_iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iC )
				end
			end
			if #_tbl > 0 then
				table.insert( tMap.same, _tbl )
				tMap.same.CMD = true
			end
		elseif _cmd == "playsound" then
			while _iObj ~= 0 do
				playSound( _tw[ _iObj ] )
				_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iObj )
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "clrtxt" or  _cmd == "cleartext" then
			tPortHole.eccoDisplayBuff = { GO = false, firstLine = 0, lastLine = 0 }
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "rmlevel" then
			--if _iD > 0 then tMap.hLevel = _tw[ _iD ]
			if _iNum >0 then
				tMap.hLevel = tonumber( _tw[ _iNum ] )
			else 
				tMap.hLevel = 1000				--MY DEFAULT BETWEEN LEVELS VALUE
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "rmnum" then		--THIS HAS BEEN BEFORE AND MAYBE REMed OUT THIS TIME RATHER THAN DELETED AGAIN
			if _iNum >0 then
				tMap.rms[ tMap.rms.idx ].rRoomNum =  "R".. _tw[ _iNum ]
			elseif _iR >0 then
				tMap.rms[ tMap.rms.idx ].rRoomNum = _tw[ _iR ]
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "save" then					--MEMORY TO FILE DUMP
			tMap.keyLogDROPIT = true
			if not tMap.hDataLOCKED then
				_SUCCESS = eventFileSave( tMap.hAuthor, tMap.fileName )		--SAVING CURRENT IN-MEMORY MAP/STORY/EVENT RV#FILENAME
			else
				--WOULD LIKE TO SEND AUTHOR MESSAGE THAT CAN'T SAVE
			end
			return _SUCCESS
		elseif _cmd == "noexits" then		--NEED FEEDBACK TO AUTHOR ABOUT ACTIONS
			if tMap.rmNOEXITS then
				tMap.rmNOEXITS = false
			else
				tMap.rmNOEXITS = true
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "+rvnum" then
			newRVnum()
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "rvnum" then
			local _eventName, _RVnum = "",""
			if _iNum >0 then							--# IS RATHER STRONG HINT AUTHOR/USER WANTS A # OF RV#s AVAILABLE ON-SCREEN

			elseif _iObj ~= 0 then				--CHECK RV# BEFORE WE ASSIGN IT
				_eventName, _RVnum = isFileNameRV( _tw[ _iObj ] )
				if #_RVnum > 0 then
					tMap.hRVnum = string.upper( _RVnum )
				end
			else
				tMap.hRVnum = ""	--THIS ALLOWS CMDS TO BE IN FILE WITHOUT ASSIGNING ANY VALUE OR RESET/CLEARING VALUE
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "maplock" then
			if _tw[ _iB +1 ] == "true" or _tw[ _iP ] == "on" then
				tMap.hDataLOCKED = true
				--WOULD BE NICE TO REMOVE ANY LINE THAT SAYS "maplock false" FROM ZERO-FILE CREATION
			else
				tMap.hDataLOCKED = false
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "maplabel" and _iObj >0 then
			local _tbl = tRetro:tblClone( _tw )
			table.remove( _tbl, 1 )
			table.remove( _tbl, 1 )
			tMap.hEventName = ccat( " ", _tbl )
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "comm" then
			local _tbl = tRetro:tblClone( _tw )
			table.remove( _tbl, 1 )
			table.remove( _tbl, 1 )
			local _idx = tPortHole.eccoDisplayRndComm.idx
			local _rndNestEXISTS = false
			if _tbl[ 1 ] == "true" then		--RE-STORE RANDOM COMMENTS WHEN ALL COMMENTS OF TRIGGER HAVE RUN OUT
				--INSTEAD WE HAVE A POPULATE AND REMOVE USED TABLE AND THUS AGAIN DIFFERENT RND WITH POSSIBLE REPEAT
				table.remove( _tbl, 1 )			--BOOL TRIM
				_trigger = ccat( " ", tMap.tw[1] )	--ACCOUNT FOR NEST
				for i =1, #tPortHole.eccoDisplayRndComm do
					if _trigger == tPortHole.eccoDisplayRndComm[ i ][1] then
						tPortHole.eccoDisplayRndComm.trigger = _trigger
						tPortHole.eccoDisplayRndComm.idx = i
						_rndNestEXISTS = true
						break										--WE HAVE OUR TARGET INDEX
					end
				end
				if not _rndNestEXISTS then
					tPortHole.eccoDisplayRndComm.trigger = _trigger		--LEAVE OUR TRIGGER FOR dt TO MATCH UP LOOP3
					table.insert( tPortHole.eccoDisplayRndComm, { _trigger } )
					table.insert( tPortHole.eccoDisplayRndComm[ #tPortHole.eccoDisplayRndComm ], ccat( " ", _tbl ) )
					tPortHole.eccoDisplayRndComm.RND = true
					tPortHole.eccoDisplayRndComm.idx = #tPortHole.eccoDisplayRndComm
				elseif _rndNestEXISTS then
					table.insert( tPortHole.eccoDisplayRndComm[ _idx ], ccat( " ", _tbl ) )
					tPortHole.eccoDisplayRndComm.RND = true
				end
			elseif _tbl[ 1 ] == "false" then
				table.remove( _tbl, 1 )			--BOOL TRIM
				table.insert( tPortHole.eccoDisplayBuff, ccat( " ", _tbl ) )
				tPortHole.eccoDisplayBuff.GO = true
			else
				table.insert( tPortHole.eccoDisplayBuff, ccat( " ", _tbl ) )
				tPortHole.eccoDisplayBuff.GO = true
			end
			return false
		elseif _cmd == "menu" and not tMap.hDataLOCKED then	-- and _SUDO
			tSM:walk( true )
			_idx = _tblLen
			--return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "author" then
			if _iObj ~= 0 then tRetro:setAu( _tw[ _iObj ] ) end
			return false
		elseif _cmd == "ccmd" then
			_idx = string.find( _tw[1],"o", 1 ) or 0
			while _idx ~= 0 do
				runAddCCmd( _tw[ _idx +1 ] )
				_idx = string.find( _tw[1],"o", _idx +1 ) or 0	--_idx = _iObj
			end
			return false
			--NEED CMD CONTROL TO MAKE SURE +M ISN'T A FALSE POSITIVE
			--	_tw[1] == ""
		elseif _cmd == "+m" or _cmd == "-m" then		--_SUDO ALREADY APPLIED
			local _mapEXISTS, _rmNumB, _mapB, _rmIdxB = false, nil, tRetro:tblClone( tMap.rms[ tMap.rms.idx ].rMap4D ),nil
			--tMap.rmNOEXITS
			if _cmd == "+m" then						--nextRoomNum() >> nextRoomMap4D() WHICH DOES CLONE THE MAP TABLE
				_mapEXISTS, _rmNumB, _mapB, _rmIdxB = tRetro:nextRoomNum( tMap.rms[ tMap.rms.idx ].rRoomNum, _mapB, 1 )--, _N,_S,_W,_E,_D,_U )
			elseif _cmd == "-m" then --and _RM then
				_mapEXISTS, _rmNumB, _mapB, _rmIdxB = tRetro:nextRoomNum( tMap.rms[ tMap.rms.idx ].rRoomNum, _mapB, -1 )
			end
			if not _mapEXISTS then					--CREATE ROOM
				tRetro:rmCreate( tMap.rms[ tMap.rms.idx ].rLabel, "R".. _rmNumB, _mapB, nil )
			end
			tRetro:switchRoom( _mapB )
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE

		elseif _cmd == "clone" or _cmd == "copy" then	--	*** CLONE ***
			--HOW ABOUT ll AGAIN IN THE BOOLS?
			local _mapEXISTS, _rmNumB, _mapB, _rmIdxB = false, nil, nil ,nil
			local _iRm = nil
			--not _NUM and not _OBJ and not _DIRT and not _RM
			local _tbl = {}
			if _tw[ #_tw ] == "+m" then
				-- *** clone +m ***
				if not _NUM and not _OBJ and not _DIRT and not _RM then
					_tbl = tRetro:tblClone( tMap.rms[ tMap.rms.idx ] )
					_mapEXISTS, _rmNumB, _mapB, _rmIdxB = tRetro:nextRoomNum( _tbl.rRoomNum, _tbl.rMap4D, 1 )
					if not _mapEXISTS then
						_tbl.rRoomNum = "R".. _rmNumB
						_tbl.rMap4D = _mapB
					end
					-- *** clone R# +m ***
				elseif not _NUM and not _OBJ and not _DIRT and _RM then
					_mapEXISTS, _iRm, _mapB = tRetro:rmNumEXISTS( _tw[ _iR ] )
					if _mapEXISTS then
						_tbl = tRetro:tblClone( tMap.rms[ _iRm ] )
					else
						return false
					end
					_mapEXISTS, _rmNumB, _mapB, _rmIdxB = tRetro:nextRoomNum( _tbl.rRoomNum, _tbl.rMap4D, 1 )
					if not _mapEXISTS then
						_tbl.rRoomNum = "R".. _rmNumB
						_tbl.rMap4D = _mapB
					end

					-- *** clone # +m ***
				elseif _NUM and not _OBJ and not _DIRT and not _RM then
					_mapEXISTS, _iRm, _mapB = tMap:rmNumEXISTS( "R".. _tw[ _iNum ] )
					if _mapEXISTS then
						_tbl = tRetro:tblClone( tMap.rms[ _iRm ] )
					else
						return false
					end
					_mapEXISTS, _rmNumB, _mapB, _rmIdxB = tRetro:nextRoomNum( _tbl.rRoomNum, _tbl.rMap4D, 1 )
					if not _mapEXISTS then
						_tbl.rRoomNum = "R".. _rmNumB
						_tbl.rMap4D = _mapB
					end
				end
				if tMap.rmNOEXITS then	--NOEXITS MEANS DROP OUT OUR CLONES EXITS:{ DATA }
					_tbl.rExits = { idx = 0 }
				end
				table.insert( tMap.rms, _tbl )
				tRetro:switchRoom( _tbl.rMap4D )
				return false
			end

			--OLD CODE FOR CLONE TO OBJ
			if _iObj > 0 then
				_inRM, _i, _label = tRetro:objRmEXISTS( _tw[ _iObj ], nil )
				if not _inRM then
					_onAU, _i, _label = tRetro:objAuEXISTS( _tw[ _iObj ], nil )
				end
				if _inRM then _obj = _label end
				if _onAU then _obj = _label end
			end
			_map4D = tMap.rms[ tMap.rms.idx ].rMap4D
			_isMAP4D, _i4D = isMXYZinSTORY( _map4D ) --m= _map4D.m, x= _map4D.x, y= _map4D.y, z= _map4D.z } )
			--"clone glowglass"					--LIST ALL OBJECTS THAT HAVE TRUE FLAG .ONBOARD THUS LIST CLONED ROOMS
			if _tw[1] == "b" or _tw[1] == "bo" or _tw[1] == "bro" then							--EITHER SINGLE CMD TRAP
				--R# && LAYERS CLONING WILL ALLOW FOR NO STORAGE CHANGES - STAYING WITH CURRENT .oBag OBJS NOW ALSO ROOMS
				--LIST CLONE OBJS;		R#:		LABEL:	LAYER: #
				local _onAU, _i = nil, nil
				local _inRM = nil
				local _tblOBJS, _tbl = {},{}
				if _tw[1] == "b" then			--LIST ALL THE OBJECTS THAT HAVE CLONED ROOMS WITHIN
					for x =1, #tMap.auLeg do
						if tMap.auLeg[ x ].ONBOARD then								--CONTAINER FOUND
							_tbl = tRetro:tblClone( tMap.auLeg[ x ] )
							table.insert( _tblOBJS, _tbl )														--BANKING THE OBJECT
						end
					end
					for x =1, #tMap.rms[ tMap.rms.idx ].rObj do
						if tMap.rms[ tMap.rms.idx ].rObj[ x ].ONBOARD then	--CONTAINER FOUND
							_tbl = tRetro:tblClone( tMap.rms[ tMap.rms.idx ].rObj[ x ] )
							table.insert( _tblOBJS, _tbl )														--BANKING THE OBJECT
						end
					end
				elseif _tw[1] == "bo" then	--LIST OBJS IF CLONED ROOMS WITHIN
					_onAU, _i = tRetro:objAuEXISTS( _tw[ _iObj ] )
					if not _onAU then
						_inRM, _i = tMap:objRmEXISTS( _tw[ _iObj ] )
					end
					if _onAU then
						_tbl = tRetro:tblClone( tMap.auLeg[ _i ] )
						table.insert( _tblOBJS, _tbl )		--BANKING THE OBJECT
					elseif _inRM then
						_tbl = tRetro:tblClone( tMap.rms[ tMap.rms.idx ].rObj[ _i ] )
						table.insert( _tblOBJS, _tbl )		--BANKING THE OBJECT
					end
				elseif _tw[1] == "bro" then
					if _iR >0 then

					end
				end
				--ECHO DATA TO USER IF WE HAVE ANYTHING
				--local _line = "ROOM #:			LAND LAYER:			LABEL:\n"
				--LABEL WILL NEED TO DROP OUT WHEN LIST REACHES A SPECIFIC SIZE OF 17 LINES*2
				local _ln, _rm, _ll, _label, _lText = nil,nil,nil,nil,nil
				table.insert( tPortHole.eccoDisplayBuff, "LINE#, R#, LAND-LAYER#, & LABEL\n" )
				for x =1, #_tblOBJS do													--MAY HAVE MORE THAN ONE CLONE ROOM OBJ
					for y =1, #_tblOBJS[ x ].oBag do							--GOING THROUGH THE LIST OF CLONED ITEMS
						_ln = tostring( x ) ..".".. string.rep( " ", 4- #tostring( x ) .."." ) 
						_rm = _tblOBJS[ x ].oBag[ y ].rRoomNum			--BORROW ROOM # DATA
						_ll = tostring( _tblOBJS[ x ].oBag[ y ].rLandLayer )	--BORROW LAND LAYER DATA
						--if #_tblOBJS[ x ].oBag < 17 then
						_label = _tblOBJS[ x ].oBag[ y ].rLabel			--BORROW LABEL DATA
						_lText = _rm .. string.rep( " ", 15 - #_rm )	--CREATE DATA LINE FOR USER TO READ
						_lText = _lText .. _ll .. string.rep( " ", 15 - #_ll )
						_lText = _lText .. _label .."\n" --string.rep( " ", 40 - #_label ) .."\n"
						table.insert( tPortHole.eccoDisplayBuff, _lText )
						tPortHole.eccoDisplayBuff.GO = true
					end
				end
				-- *** "clone ll # CLIPBOARD" ***			--OBJ NOW HAS .ONBOARD FLAG TO SEPERATE ROOMS FROM OBJS IN OBJ	
			elseif _tw[3] == "ll" and _obj then
				--local _bool, _iRm = false, nil
				while _iNum ~= 0 do		--PROCESS MULTIPLE LAYERS OR NO-LOOP JUST PASS-THROUGH
					for iWalk = 1, #tMap.rms do
						if tMap.rms[ iWalk ].rLandLayer == tonumber( _tw[ _iNum ] ) then	--MATCH LAND-LAYER #
							_tbl = tRetro:tblClone( tMap.rms[ iWalk ] )					--CLONE CURRENT R#
							--_tbl.ONBOARD = true
							if _inRM then
								_EXISTS = false
								for y =1, #tMap.rms[ iWalk ].rObj[ _i ].oBag do		--AVOID DUPLICATE ROOMS
									if tMap.rms[ iWalk ].rObj[ _i ].oBag[ y ].rRoomNum == _tbl.rRoomNum then	--self.rms.idx
										_EXISTS = true
									end
								end
								tMap.rms[ self.rms.idx ].rObj[ _i ].ONBOARD = true
								if not _EXISTS then table.insert( tMap.rms[ self.rms.idx ].rObj[ _i ].oBag, _tbl ) end
							elseif _onAU then
								_EXISTS = false
								for y =1, #tMap.auLeg[ _i ].oBag do				--AVOID DUPLICATE ROOMS
									if tMap.auLeg[ _i ].oBag[ y ].rRoomNum == _tbl.rRoomNum then
										_EXISTS = true
									end
								end
								tMap.auLeg[ _i ].ONBOARD = true				--SOURCE CONTAINER OBJ FLAGGED
								if not _EXISTS then table.insert( tMap.auLeg[ _i ].oBag, _tbl ) end
							end
						end
					end	
					_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iNum )	

					if _iNum > 0 then
						_num = tonumber( _tw[_iNum] )
					end
				end

				-- *** "clone R# R# R# R# OBJ" ***
			elseif isRoomNum( _tw[ _iR ] ) and _obj then	--ONE R# && OBJECT EXISTS
				while _iR ~= 0 do
					--CLONE LAYER INTO TARGET OBJECTS
					_EXISTS, _,_, _iRm = isRmInSTORY( _tw[ _iR ] )
					--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
					if _EXISTS then
						_tbl = tRetro:tblClone( tMap.rms[ _iRm ] )			--CLONE CURRENT R#
						_tbl.ONBOARD = true
					end
					if _inRM then
						table.insert( tMap.rms[ self.rms.idx ].rObj[ _i ].oBag, _tbl )
					elseif _onAU then
						table.insert( tMap.auLeg[ _i ].oBag, _tbl )
					end
					_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iR )
				end
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
			--	*** "paste OBJ/" ***
		elseif _cmd == "paste" then
			--"paste"										*** LIST OBJECTS THAT HAVE TRUE FLAG .ONBOARD THUS LIST CLONED ROOMS ***
			--"paste #LINE"							WOULD PASTE OVER THE CURRENT ROOM
			--"paste #LINE RM DIRT"			PASTE CLONED ROOM IN CURRENT R# DIRT ADD-ON
			--"paste #LINE RM R6"				PASTE CLONED ROOM ONTO ROOM #6
			local _num, _obj = nil ,nil
			local _onAU, _inRM, _i, _label = false, false, 0, nil
			if _iNum > 0 then
				_num = tonumber( _tw[_iNum] )
			end
			if _iObj > 0 then
				_inRM, _i, _label = tRetro:objRmEXISTS( _tw[ _iObj ], nil )
				if not _inRM then
					_onAU, _i, _label = tRetro:objAuEXISTS( _tw[ _iObj ], nil )
				end
				if _inRM then _obj = _label end
				if _onAU then _obj = _label end
			end
			--_map4D = tMap.rms[ tMap.rms.idx ].rMap4D
			--_isMAP4D, _i4D = isMXYZinSTORY( _map4D )
			if _tw[1] == "b" then				--"paste"
				--LIST ALL OBJECTS WITHIN .ONBOARD
				fu = nil	
			elseif _iObj > 0 then			--WERE ARE INSIDE THE PASTE CMD...CODE CHANGED AND LIKELY BROKEN AGAIN
				--local _EXISTS = false
				if _iNum > 0 then		--OBJECTS AND OR NUMBERS
					_num = tonumber( _tw[_iNum] )
					if _onAU and tMap.auLeg[ _i ].oBag[ _num ] then						--LINE NUMBER REFERENCE SOURCE COPY
						_tbl = tRetro:tblClone( tMap.auLeg[ _i ].oBag[ _num ] )
						_tbl.ONBOARD = false
					elseif _inRM and tMap.rms[ _i ].oBag[ _num ] then				--LINE NUMBER REFERENCE SOURCE COPY
						_tbl = tRetro:tblClone( tMap.rms[ _i ].oBag[ _num ] )
						_tbl.ONBOARD = false
					end
					if _iD > 0 and _tbl.rRoomNum then					--DIRT	NEXT R#, NEXT MAP4D
						--UPDATE R# AND MAP4D - NEW ROOM OR EXISTING ROOM
						_tbl.rMap4D = tRetro:tblClone( tMap.rms[ tMap.rms.idx ].rMap4D )
						_tbl.rRoomNum, _tbl.rMap4D = tRetro:nextRoomNum( tMap.rms[ tMap.rms.idx ].rRoomNum, _tw[_iD], _tbl.rMap4D )			--NEXT AVAILABLE R# IN CURRENT MAP LEVEL
						_tbl.rRoomNum = "R" .. _tbl.rRoomNum	--CHANGE TO PROPER R#
						_isMAP4D, _i4D = isMXYZinSTORY( _tbl.rMap4D )
						_tbl.rLandLayer = tMap.rms[ tMap.rms.idx ].rLandLayer
						--table.insert( tMap.rms, _tbl )
						if _isMAP4D then
							table.remove( tMap.rms, _i4D )
							table.insert( tMap.rms, _tbl )
							runCmdJumpRm( _tbl.rRoomNum, true, nil )	--_autoBuild
						else			--PUT THE ROOM IN THE STORY
							table.insert( tMap.rms, _tbl )
							runCmdJumpRm( _tbl.rRoomNum, true, nil )
						end
						_EXISTS = true
					elseif _tbl.rRoomNum then									--MULTIVERSE-DIRT DIRECTION
						_iB,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_,_, _idx = idxEccoCmdControl( _tw, _idx )
						if _iB >0 and _tw[ _iB ] == "+m" then
							--_EXISTS, _map4D2, idx, _rRoomNum
							_isMAP4D, _tbl, _i4D = tRetro:nextRoomMap4D( _tbl, _tw[ _iB ] )--, _rmExitNum )
							_map4D = tMap.rms[ tMap.rms.idx ].rMap4D
							--_isMAP4D, _i4D = isMXYZinSTORY( { m= _map4D.m +1, x= _map4D.x, y= _map4D.y, z= _map4D.z } )
							if _isMAP4D then
								runCmdJumpRm( tMap.rms[ _i4D ].rRoomNum, _autoBuild, nil )
							elseif not _isMAP4D then	--CREATE THE ROOM?
							end
							_EXISTS = true
						end
					end
					return false	--_EXISTS
					--SELECTION OF SOURCE 
				end		--NOT DIRT FALL-BACK TO CURRENT-ROOM
				return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
			end

		elseif _cmd == "join" then					--	*** JOIN OBJS AND OR ROOMS ***
			--JOIN 1st DEFAULT VALUES, ALSO OBJECT WILL BE TRANSFERING CLONED TRIP-WIRES IN MASS
			local _masterRM = false		--TOGGLE WHEN MASTER ROOM GIVEN
			local _num = nil
			local _iRm = nil
			local _rmsEXIST = {}	--, _nonSeltbl = { idx = 1 },{}
			local _onAU, _inRM, _i, _label = false, nil, 0, nil
			local _landLayer = nil
			if _iR > 0 then
				_,_,_, _iRm = isRmInSTORY( _tw[ _iR ] )		--
				--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
			end
			if _iNum > 0 then
				_num = tonumber( _tw[_iNum] )
			end
			if _iObj > 0 then
				_inRM, _i, _label = tRetro:objRmEXISTS( _tw[ _iObj ], nil )
				if not _inRM then
					_onAU, _i, _label = tRetro:objAuEXISTS( _tw[ _iObj ], nil )
				end
				if _inRM then _objSrc = _label end
				if _onAU then _objSrc = _label end
			end
			_map4D = tMap.rms[ tMap.rms.idx ].rMap4D
			_isMAP4D, _i4D = isMXYZinSTORY( _map4D )
			if _tw[1] == "b" then							--SINGLE CMD FEEDBACK SYNTAX TO USER
				fu = nil
			elseif string.find( _tw[1], "bo", 1 ) then				--JOIN OBJECTS
				--WE ARE MAKING STORAGE CHANGES TO ALL ROOMS THAT APPLY OR OBJS
				while _iObj > 0 do							--OBJECT LOOP - DUMP
					_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iObj )
					_objSrc = _tw[ _iObj ]
				end

			elseif string.find( _tw[1], "bb", 1 ) 
			or string.find( _tw[1], "br", 1 ) or string.find( _tw[1], "b#", 1 ) then
				--ROOM OR LL #S FORK, HOLD YOUR ENERGY
				--"br".."b#" THEN .."##" OR .."rr" WITH OR WITHOUT EXTRA "b" FOR ll
				--NEED A TBL LIST OF KNOWN GOOD R# FROM JOIN CMD
				local _EXISTS, _iRm = false, 0
				local _masterNum = nil
				-- *** MASTER ROOM 1st *** OR LL TARGET IN STORY TABLE
				if _iR > 0 then		--LEADING R# MAYBE THE ONLY R#
					_EXISTS,_,_, _iRm = isRmInSTORY( _tw[ _iR ] )
					--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
					_masterNum = string.match( _tw[ _iR ], "-%d+" ) or string.match( _tw[ _iR ], "%d+" )
					--table.insert( _rmsEXIST, _masterNum )
					_masterLayer = tMap.rms[ _iRm ].rLandLayer
					_masterLabel = tMap.rms[ _iRm ].rLabel
					_masterRM = true
					_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iR or _iNum )
					while _iR > 0 do		--ADD OTHER R#
						if _iR > 0 then
							_EXISTS,_,_, _iRm = isRmInSTORY( _tw[ _iR ] )
							--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
							if _EXISTS then
								table.insert( _rmsEXIST, string.match( _tw[ _iR ], "-%d+" ) or string.match( _tw[ _iR ], "%d+" ) )	--R# MASTER ROOM EXISTS	_tw[ _iR ]
							end	
						end
						_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iR or _iNum )
					end
					if #_rmsEXIST > 1 then														--CHECK EVERY ROOM IN MAP
						for iWalk =1, #tMap.rms do										--WALK THE MAP
							for iExit =1, #tMap.rms[ iWalk ].rExits do	--CHECK EVERY EXIT
								local _num = string.match( tMap.rms[ iWalk ].rExits[ iExit ], "-%d+" ) or string.match( tMap.rms[ iWalk ].rExits[ iExit ], "%d+" )
								for iJoin =1, #_rmsEXIST do									--LIST OF ROOMS TO JOIN
									if _num == _rmsEXIST[ iJoin ] then				--MATCH TO JOIN R#s
										tMap.rms[ iWalk ].rExits[ iExit ] = string.match( tMap.rms[ iWalk ].rExits[ iExit ], "%a+" ) .._masterNum
									end
								end
							end
						end					-- *** NOTICE WE HAVE NOT UPDATED THE TRIPWIRE CONTENT OF JOIN ROOMS YET!!! ***
						for iWalk =1, #tMap.rms do										--WALK THE MAP
							for iJoin =1, #_rmsEXIST do
								local _num = string.match( tMap.rms[ iWalk ].rRoomNum, "-%d+" ) or string.match( tMap.rms[ iWalk ].rRoomNum, "%d+" )
								if "R".. _rmsEXIST[ iJoin ] == tMap.rms[ iWalk ].rRoomNum then
									--tMap.rms[ iWalk ].rRoomNum	= "R".._masterNum	--LASTLY WE CHANGE THE R#s OF JOINT ROOM SPACE,
									tMap.rms[ iWalk ].rLandLayer = _masterLayer
									tMap.rms[ iWalk ].rLabel = _masterLabel
								end
							end
						end
					end
					--_rmsEXIST = {}
				end
				if _iNum > 0 then
					fu = nil
				end
				return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
			end

		elseif _cmd == "+" or _cmd == "++" or _cmd == "create" or _cmd == "del" or _cmd == "delete"
		or _cmd == "-" or _cmd == "unhide" or _cmd == "hide" or _cmd == "untake" or _cmd == "+exits"
		or _cmd == "delrm" or ( _cmd == "-exits" or _cmd == "delexits" ) then
			local _MOVES, _MOVEUD = false, false
			while _idx ~= 0 do
				if _iObj +1 == _iBool and _iObj ~= 0 and _iBool ~= 0 then
					_MOVES = true
					if _tw[ _iBool +1 ] == 'true' or _tw[ _iBool +1 ] == 'TRUE' then
						_MOVEUD = true
					else
						_MOVEUD = false
					end
				else
					_MOVES = false
				end
				if _iNum + 1 == _iObj and _iNum ~= 0 then
					runCmdObj( _cmd, _tw[ _iNum ], _tw[ _iObj ], nil, _MOVES, _MOVEUD )
					_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iObj or _iNum )
				elseif _iObj ~= 0 then
					runCmdObj( _cmd, 1, _tw[ _iObj ], nil, _MOVES, _MOVEUD )
					_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iObj )
				elseif _iR ~= 0 then
					tRetro:rmDel( _tw[ _iR ] )		--DELETE ROOMS
					_,_,_,_iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iR )
				elseif _iD ~= 0 and ( _cmd == "-exits" or _cmd == "delexits" ) then
					tMap.rms[ tMap.rms.idx ].rExits = tRetro:rmDelExit( tMap.rms[ tMap.rms.idx ].rExits, _tw[ _iD ] )		--DELETE EXITS
					_,_,_,_iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iD )
				elseif  _cmd == "+exits" then
					local _exit = nil
					if _iD > 0 and _iNum > 0 then
						_exit = _tw[ _iD ] .. _tw[ _iNum ]
					elseif _iD > 0 and _iR > 0 then
						_exit = _tw[ _iD ] .. string.match( _tw[ _iR ], "-%d+" ) or string.match( _tw[ _iR ], "%d+" )
					elseif _iD > 0 then
						_exit = _tw[ _iD ]
					else
						return false
					end
					tMap.rms[ tMap.rms.idx ].rExits = tRetro:rmAddExit( tMap.rms[ tMap.rms.idx ].rExits, _exit )		--ADD EXITS
					_,_,_,_iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iD )
				end
				--_iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime, _bCMD,_pCMD,_cCMD, _cmd, _idx
			end
			return false
		elseif _cmd == "rtw" or _cmd == "+rtw"		--"+rtw" IS FOR TW INJECTION INTO MANY OR ALL OF MAP!
		or _cmd == "+tw" or _cmd == "++tw" or _cmd == "-tw" then
			setTW( _tw, _cmd )--not tMap.hDataLOCKED and
			_idx = #_tw
			return false
		elseif ( _cmd == "olabel" or _cmd == "rename"  ) then
			local _iObj2 = nil
			_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iObj )
			if _iNum +1 == _iObj2 and _iNum ~= 0 then		--#+1 == OBJECT
				tRetro:objRename( _tw[ _iObj ], _tw[ _iNum ], _tw[ _iObj2 ] )
			elseif _iNum == 0 and _iObj2 > 0 then					--NO #=0 OBJ >0
				tRetro:objRename( _tw[ _iObj ], 1, _tw[ _iObj2 ] )
			end
			return false
		elseif _cmd == "omove" then		--ALLOW OBJECTS TO MOVE FROM CURRENT ROOM TO OTHER ROOM OR PLAYER CARRY
			_mapCHANGED = moveObjInMap( _tw )
			return _mapCHANGED
		elseif _cmd == "rmlabel" and  _iObj ~= 0 then
			--_SUCCESS = 
			tRetro:rmlabel( "rm", _tw[ _iObj ] )
			return false
		elseif _cmd == "setplayerstart" then			--if #_cmd == 0 then --_iR ~= 0 or _iD ~= 0 or
			--LOOP THE GROUPS INSIDE TW AS ADAPTIVE PARSING & PASS ALONG CHUNK BEFORE NEXT c or d etc
			if _cmd == "setplayerstart" and _iR ~= 0 then
				tMap.hPlayerStart = _tw[ _iR ]
			elseif _cmd == "setplayerstart" and _iNum ~= 0 then
				tMap.hPlayerStart = "R".. _tw[ _iNum ]
			else
				tMap.hPlayerStart = "R0"	--FALLBACK RANDOM FUN
				--tRetro:playerstart( tMap.rms[ tMap.rms.idx ].rRoomNum )		--FALLBACK TO LOCAL IN-ROOM
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif ( _cmd == "lock" or _cmd == "unlock" ) then -- not tMap.hDataLOCKED and
			--TRIPWIRE DO THE UNLOCKING & BUILD-MODE CAN LOCK UP OBJECTS QUICKLY
			local _bool = false
			_iObj = string.find( _tw[1],"o", _idx ) or 0		--IF IT'S NOT AN OBJECT IT'S THE ROOM
			local _onAU, _iAu = false, 0
			local _inRM, _iRm = false, 0
			if _iObj ~= 0 then
				_onAU, _iAu = tRetro:objAuEXISTS( _tw[ _iObj ] )
				_inRM, _iRm = tRetro:objRmEXISTS( _tw[ _iObj ] )
			end
			local _iB2 = string.find( _tw[1],"b", _iB ) or 0
			local _iR = string.find( _tw[1],"r", _iB ) or 0
			if _iB2 ~= 0 then
				_cmd2 = _tw[ _iB2 +1 ]
			elseif _iR ~= 0 then
				_cmd2 = _tw[ _iR +1 ]
			end
			if _cmd == "lock" then
				_bool = true
				if _iObj ~= 0 then
					if _inRM then
						tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].objLOCKED = _bool
					elseif _onAU then
						tMap.auLeg[ _iAu ].objLOCKED = _bool
					end
				elseif _cmd2 == "room" then
					tMap.rms[ tMap.rms.idx ].rLOCKED = _bool
				elseif _iR ~= 0 then		
					local _bEXISTS,_,_, _i = isRmInSTORY( _cmd2 )			--CHECK FOR VALID R# WITHIN MAP
					--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
					if _bEXISTS then
						tMap.rms[ _i ].rLOCKED = _bool
					end
				end
			elseif _cmd == "unlock" then
				if _iObj ~= 0 then
					if _inRM then
						tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].objLOCKED = _bool
					elseif _onAU then
						tMap.auLeg[ _iAu ].objLOCKED = _bool
					end
				elseif _cmd2 == "room" then
					tMap.rms[ tMap.rms.idx ].rLOCKED = _bool
				elseif _iR ~= 0 then		
					local _bEXISTS,_,_, _i = isRmInSTORY( _cmd2 )			--CHECK FOR VALID R# WITHIN MAP
					--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
					if _bEXISTS then
						tMap.rms[ _i ].rLOCKED = _bool
					end
				end
			end
			if #tMap.tw == 0 then tMap.tw = _tw end	--PICKUP THE MULTI TW
			return true

		elseif _SUDO and _cmd == "timer" then
			local _onAU, _iAu = false, 0
			local _inRM, _iRm = false, 0
			if _cmd == "timer" and _iTime ~= 0 then
				local _isTIME, _hour, _min, _sec, _dec = isTime( _tw[ _iTime ] )
				if _iObj ~= 0 then
					_onAU, _iAu = tRetro:objAuEXISTS( _tw[ _iObj ] )
					_inRM, _iRm = tRetro:objRmEXISTS( _tw[ _iObj ] )
				elseif _iObj== 0 and ( _tw[ _iTime ] == "00:00:00:0"  or _tw[ _iTime ] == "00:00:00:0" ) then	--TIMER USED AS RESET ROOM TO ZERO
					tMap:ticToc( true )	--RESET TIME ZEROED-OUT
					return true
				end
				local _twTimeAdjust = ""
				if ( tMap.rmHours +_hour ) <10 then
					_twTimeAdjust = "0".. tostring( tMap.rmHours +_hour )
				else
					_twTimeAdjust = tostring( tMap.rmHours +_hour )
				end
				if ( tMap.rmMinutes +_min ) <10 then
					_twTimeAdjust = _twTimeAdjust ..":0".. tostring( tMap.rmMinutes +_min )
				else
					_twTimeAdjust = _twTimeAdjust ..":".. tostring( tMap.rmMinutes +_min )
				end
				if ( tMap.rmSeconds +_sec ) <10 then
					_twTimeAdjust = _twTimeAdjust ..":0".. tostring( tMap.rmSeconds +_sec )
				else
					_twTimeAdjust = _twTimeAdjust ..":".. tostring( tMap.rmSeconds +_sec )
				end
				_twTimeAdjust = _twTimeAdjust ..":".. tostring( tMap.rmFraction +_dec )
				_tw[ _iTime ] = _twTimeAdjust
				if _inRM then
					table.insert( tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].tripWire, _tw )
					table.insert( tPortHole.ghosts[ tMap.rms.idx ].rObj[ _iRm ].tripWire, _tw )
				elseif _onAU then
					table.insert( tMap.auLeg[ _iAu ].tripWire, _tw )
				elseif not _inRM and not _onAU then	--TIMER WITHOUT OBJECT GOES INTO ROOM TW THEATER
					table.insert( tMap.rms[ tMap.rms.idx ].rTripWire, _tw )
					table.insert( tPortHole.ghosts[ tMap.rms.idx ].rTripWire, _tw )
				end
				return true
			elseif _cmd == "timer" and _iTime == 0 then
				return true
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _SUDO and _cmd == "repeat" then
			local _onAU, _iAu = false, 0
			local _inRM, _iRm = false, 0
			local _iTime2 = 0
			local _cmd2 = nil
			local _trim = string.find( _tw[1],"T", 1 ) or 0
			_,_,_, _,_, _,_iObj, _iTime2,_, _,_,_, _, _idx = idxEccoCmdControl( _iTime +1, _idx )
			if _cmd == "timer" and _iTime ~= 0 then
				local _isTIME, _hour, _min, _sec, _dec = isTime( _tw[ _iTime ] )
				if _iObj ~= 0 then
					_onAU, _iAu = tRetro:objAuEXISTS( _tw[ _iObj ] )
					_inRM, _iRm = tRetro:objRmEXISTS( _tw[ _iObj ] )
				elseif _iObj== 0 and ( _tw[ _iTime ] == "00:00:00:0"  or _tw[ _iTime ] == "00:00:00:0" ) then	--TIMER USED AS RESET ROOM TO ZERO
					tMap:ticToc( true )	--RESET TIME ZEROED-OUT
					return false
				end
				local _twTimeAdjust = ""
				if ( tMap.rmHours +_hour ) <10 then
					_twTimeAdjust = "0".. tostring( tMap.rmHours +_hour )
				else
					_twTimeAdjust = tostring( tMap.rmHours +_hour )
				end
				if ( tMap.rmMinutes +_min ) <10 then
					_twTimeAdjust = _twTimeAdjust ..":0".. tostring( tMap.rmMinutes +_min )
				else
					_twTimeAdjust = _twTimeAdjust ..":".. tostring( tMap.rmMinutes +_min )
				end
				if ( tMap.rmSeconds +_sec ) <10 then
					_twTimeAdjust = _twTimeAdjust ..":0".. tostring( tMap.rmSeconds +_sec )
				else
					_twTimeAdjust = _twTimeAdjust ..":".. tostring( tMap.rmSeconds +_sec )
				end
				_twTimeAdjust = _twTimeAdjust ..":".. tostring( tMap.rmFraction +_dec )
				_tw[ _iTime ] = _twTimeAdjust
				if _inRM then
					table.insert( tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].tripWire, _tw )
					table.insert( tPortHole.ghosts[ tMap.rms.idx ].rObj[ _iRm ].tripWire, _tw )
				elseif _onAU then
					table.insert( tMap.auLeg[ _iAu ].tripWire, _tw )
				elseif not _inRM and not _onAU then	--TIMER WITHOUT OBJECT GOES INTO ROOM TW THEATER
					table.insert( tMap.rms[ tMap.rms.idx ].rTripWire, _tw )
					table.insert( tPortHole.ghosts[ tMap.rms.idx ].rTripWire, _tw )
				end
				return true
			elseif _cmd == "timer" and _iTime == 0 then
				
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
			--_,_,_, _,_, _,_, _iTime,_iBool, _,_,_, _, _ = idxEccoCmdControl( _tw, _idx )
			--fu = nil
		end
		tMap.keyLogDROPIT = true
		---------------------------------------------------------
		-- PLAY CMD BLOCK
		---------------------------------------------------------
	elseif _pCMD or _SUDO then				--CUSTOM CMD "from" LEADS SENTENCE		--ex. from fridge take milk 2 eggs
		--_runGHOST = true
		local _objA = nil
		if not tMap.hDataLOCKED and _cmd == "bb" then	--TYPED >> CMD CONTROL SORTING BEGINS HERE
			tPortHole:bb()		--BUILD-MODE ON IS TRUE, PLAY-MODE IS FALSE
			tMap.keyLogDROPIT = true
			--return _SUCCESS		--REMOVING TAKE AND DROP FROM HERE or _cmd == "take" or _cmd == "drop"
		elseif _cmd == "playerstart" then
			tMap.keyLogDROPIT = true			--NOT RECORDING THIS DATA, THUS WILL NEVER REACH THE FILE WITH SAVE
			if #tMap.hPlayerStart >0 then
				_EXISTS, _, _map4D, _idx = isRmInSTORY( tMap.hPlayerStart )
				--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
				if _EXISTS then

					tRetro:switchRoom( tMap.rms[ _idx ].rMap4D )
				end
				tMap.keylog = ""						--WE DON'T WANT THIS CMD RECORDED
				return false
			else
				return false
			end
		elseif _cmd == "load" then		--"load author filename R#"
			if #_tw == 2 then							--SINGLE CMD AND ROOM EXISTS
				if #tMap.hPlayerStart > 0 then
					_EXISTS,_, _map4D, _idx = isRmInSTORY( tMap.hPlayerStart )
					--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
					if _EXISTS then 
						tRetro:switchRoom( _map4D )
					else											--WHERE IS OUR FALL BACK TO LOAD DATA ON SINGLE LOAD?
						tMap.deadTYPIST = eventFileLoad( tMap.hAuthor, tMap.eventsA[ tMap.eventsA.idx ] )
					end
				end
				tMap.keyLogDROPIT = true		--NOT RECORDING THIS DATA, THUS WILL NEVER REACH THE FILE WITH SAVE
				--tMap.keylog = ""					--SINGLE LOAD CMD ISN'T TO BECOME APART OF DEAD-TYPIST MEANING ON-FILE
			elseif #_tw >2 then						--_tw[3] COULD BE AUTHOR OR FILENAME SO LETS CHECK THE AUTHORS 1st
				local _auEXISTS, _auIdx = isAuthor( _tw[3] )
				local _fileEXISTS, _fIdx = false, 0
				local _A = true
				if not _auEXISTS then
					_fileEXISTS, _fIdx = isFile( _A, _tw[3] )	--true is eventsA data
				elseif _auEXISTS then
					_fileEXISTS, _fIdx = isFile( _A, _tw[4] )
				end
				--local _SUCCESS = false
				if _auEXISTS and _fileEXISTS then
					tMap.deadTYPIST = eventFileLoad( tMap.hAuthor, tMap.eventsA[ _fIdx ] )				--LOCAL AUTHOR & [fileName]
					tMap.eventsA.idx = _fIdx		--UPDATE INDEX
				elseif tMap.authors[ _auIdx ] == tMap.hAuthor and _fileEXISTS then
					tMap.deadTYPIST = eventFileLoad( tMap.hAuthor, tMap.eventsA[ _fIdx ] )
					tMap.eventsA.idx = _fIdx		--UPDATE INDEX
				elseif _auEXISTS and not _fileEXISTS and tMap.authors[ _auIdx ] ~= tMap.hAuthor then	--LOAD UP DIFFERENT AUTHOR INTO .eventsB AND SEARCH FOR FILE
					--POPULATE tMap.eventsB
					--setAuthRootPath( "AU", tMap.authors[ _auIdx ], nil )-- _fileName )
					tMap.eventsB = listAuEvents( tMap.authors[ _auIdx ] )	--"AUS"
					tMap.eventsB.idx = _auIdx
					_fileEXISTS, _fIdx = isFile( false, _tw[4] )
					if _fileEXISTS then
						tMap.eventsA = tMap.eventsB					--SWAP ABOUT TABLES
						tMap.deadTYPIST = eventFileLoad( tMap.hAuthor, tMap.eventsA[ _fIdx ] )
					end
				end
				if _iR > 0 and tMap.deadTYPIST then
					if tMap.hDeadTypist[ #tMap.hDeadTypist ] == "bb" then
						table.insert( tMap.hDeadTypist, #tMap.hDeadTypist, "setplayerstart " .._tw[ _iR ] )			--DROP IN R# 2nd LAST LINE
					else
						table.insert( tMap.hDeadTypist, "setplayerstart " .._tw[ _iR ] )
					end
				elseif _iNum > 0 and tMap.deadTYPIST then
					if tMap.hDeadTypist[#tMap.hDeadTypist] == "bb" then
						table.insert( tMap.hDeadTypist, #tMap.hDeadTypist, "setplayerstart " .._tw[ _iNum ] )
					else
						table.insert( tMap.hDeadTypist, "setplayerstart " .._tw[ _iNum ] )
					end
				end
			end
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		elseif _cmd == "look" or _cmd == "read" or _cmd == "touch" or _cmd == "sit" or _cmd == "stand" or _cmd == "enter" then
			return true
		elseif _cmd == "fill" or _cmd == "empty" then	--TARGET NEST OBJECT LIKE FRIDGE	--_cmd == "rename"_cmd == "from" or
			_objA = _tw[ _iObj ]
			local _scrTbl, _dstTbl = nil, nil				--fridge, eggs
			local _num = 1
			_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, math.max( _iC, _iP ) +1 )
			while _idx ~= 0 and _idx <= #_tw do	--[1]											--LOOP THROUGH THE TRIPWIRE
				if _iNum + 1 == _iObj then
					_num = _tw[ _iNum ] or 1
				else
					_num = 1
				end
				_BonAUN, _BiAuN, _,	_AonAU, _AiAu = tRetro:objAuEXISTS( _tw[ _iObj ], _objA )
				if _BonAUN and _cmd == "empty" then	--NEST BLOCKS WE TAKE AWAY MATERIAL AS DEFAULT FLOW
					_scrTbl = tMap.auLeg			--A CARRIES NESTED B
					_scrTbl.idx = _AiAu
					_scrTbl[ _AiAu ].oBag.idx = _BiAuN
					if not _scrTbl.ONBOARD then
						_scrTbl =	tRetro:moveItem( true, _scrTbl, nil, _num, _cmd )	--[ _AiAu ].oBag[ _BiAuN ]
						--else
						--return false									--PROTECT CLONED ROOMS FROM BEING EMPTIED OR FILLED
					end
				elseif not _BonAUN and _cmd == "empty" then
					_BinRMN, _BiRmN, _, _AinRM, _AiRm = tRetro:objRmEXISTS( _tw[ _iObj ], _objA )
					if _BinRMN then										--MATCH THE INDEX IN ROOM AND ROOM NEST
						_scrTbl =	tMap.rms[ tMap.rms.idx ].rObj
						_scrTbl.idx = _AiRm
						_scrTbl[ _AiRm ].oBag.idx = _BiRmN
						if not _scrTbl.ONBOARD then
							_scrTbl = tRetro:moveItem( true, _scrTbl, nil, _num, _cmd )
							--else
							--return false								--PROTECT CLONED ROOMS FROM BEING EMPTIED OR FILLED
						end
					end																-- *** NON NESTED MOVE TABLES ***
				end
				if ( not _BonAUN and not _BinRMN ) or _cmd == "fill" then
					_BinRM, _BiRm = tRetro:objRmEXISTS( _tw[ _iObj ] )	
					if _BinRM then										--egg
						_scrTbl = tMap.rms[ tMap.rms.idx ].rObj[ _BiRm ]
					end
					if not _BinRM then								--egg
						_BonAU, _BiAu = tRetro:objAuEXISTS( _tw[ _iObj ] )
						if _BonAU then									--LOOKING FOR INDIVIDUAL OBJ EXISTS
							_scrTbl = tMap.auLeg[ _BiAu ]
						end
					end
					_AonAU, _AiAu = tRetro:objAuEXISTS( _objA )
					if _AonAU then
						_dstTbl = tMap.auLeg[ _AiAu ]
					end
					if not _AonAU then
						_AinRM, _AiRm = tRetro:objRmEXISTS( _objA )
						if _AinRM then
							_dstTbl = tMap.rms[ tMap.rms.idx ].rObj[ _AiRm ]
						end
					end
					if type( _scrTbl ) == "table" and not _scrTbl.ONBOARD then
						_scrTbl, _dstTbl = tRetro:moveItem( false, _scrTbl, _dstTbl, _num, _cmd )
					end
				end
				_,_,_, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iObj )
			end
			return false													--IF TRUE THEN WE LOOSE OUR LEFT OVER COUNT
		elseif ( _cmd == "eat" or _cmd == "drink" or _cmd == "consume" or _cmd == "take" or _cmd == "drop" or _cmd == "place" ) then
			local _obj2 = nil -- Internal check
			_iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _bCMD,_pCMD,_cCMD, _, _idx = idxEccoCmdControl( _tw, 1 )
			if _cCMD then
				if _iC +1 <= #_tw then		--"from" or _cmd2 == "with" or _cmd2 == "of" or _cmd2 == "into"
					_obj2 = _tw[ _iC +1 ]
				end
			end
			while _idx ~= 0 do
				if _iNum + 1 == _iObj and _iNum ~= 0 then
					runCmdObj( _cmd, _tw[ _iNum ], _tw[ _iObj ], _obj2 )
				else
					runCmdObj( _cmd, 1, _tw[ _iObj ], _obj2 )
				end
				if _iC >0 and _idx == _iC then return true end	--CUT OFF
				_iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _bCMD,_pCMD,_cCMD, _cmd2, _idx = idxEccoCmdControl( _tw, _iObj )
			end
			removeDeadCount()
			return true
		elseif _cmd == "open" or _cmd == "close" then
			local _onAU, _inRM = true, true
			if _iObj ~= 0 then
				while _onAU or _inRM do
					_onAU, _iAu = tRetro:objAuEXISTS( _tw[ _iObj ] )
					_inRM, _iRm = tRetro:objRmEXISTS( _tw[ _iObj ] )
					if _onAU and not tMap.auLeg[ _iAu ].objLOCKED then
						if _cmd == "open" then
							tMap.auLeg[ _iAu ].objOPENED = true
							tPortHole.eccoDisplayBuff.GO = true
						elseif _cmd == "close" then
							tMap.auLeg[ _iAu ].objOPENED = false
						end
					end		--BOTH CAN BE PROCESSED IF BOTH FOUND
					if _inRM and not tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].objLOCKED then
						if _cmd == "open" then
							tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].objOPENED = true
							tPortHole.eccoDisplayBuff.GO = true
						elseif _cmd == "close" then
							tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].objOPENED = false
						end
					end
					if _iObj < #_tw then
						_iObj = _iObj + 1
					else
						_onAU, _inRM = false, false
					end
				end
				return true
			end
			return true	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE

		elseif _cmd == "help" then						--GIVE FEEDBACK TO USER
			return false	--AVOID .keylogDROPIT & NO GHOSTING NEEDED THUS FALSE
		end
		--tMap.keyLogDROPIT = true		--NOT LOGGING CMDS THAT FAILED TO RUN
		---------------------------------------------------------
		-- CUSTOM CMD BLOCK - BLOCK FOR HELPING "from","with","of","into" TO TRANSLATE INTO ALREADY WRITTEN CODE
		---------------------------------------------------------
	elseif _cCMD then
		--"from fridge take milk"
		--"from fridge take 2 eggs 4 bacon"
		--"take 2 eggs 4 bacon from fridge"
		return false
	end
	--tMap.keyLogDROPIT = true		--NOT LOGGING CMDS THAT FAILED TO RUN
end

function trimFwdTW( _tw )		--MODIFY TW TABLE AS NEW TABLE
	local _BOOL = false
	local _objsCloneABLE = false
	local _count = 1
	local _split = string.find( _tw[1], "T", 1 ) or 0
	local _tbl = tRetro:tblClone( _tw )						--INDEPENDANT COPY!
	if _split >0 then
		for x =1, _split +1 do
			table.remove( _tbl, 1 )
		end
		_BOOL = runTWaction( _tbl, true )	--TRIMMED TW INTO ACTION	
		return _BOOL
	end
	return false
end

--DOES NOT RUN IN BUILDING MODE NOR WHEN DEAD-TYPIST IS BUSY
--GOING TO BRING GHOSTS BACK AS WE DO NEED THAT *NIX 3rd LEG
function rmTWchk( _tw )			-- *** PROCESS ALL CURRENT-RM TW & OBJS[OBJS] AGAINST USER-TYPED ***
	local _idx = tPortHole.ghosts.idx
	local _a = 2							--COUNT STARTS AT 2
	local _GO = true
	--rHIDDEN & rLOCKED
	if tPortHole.ghosts[ _idx ].rTWrmLIVE and not tPortHole.ghosts[ _idx ].rHIDDEN then
		for iTW = 1, #tPortHole.ghosts[ _idx ].rTripWire do
			while _a <= #_tw and _GO do
				if tPortHole.ghosts[ _idx ].rTripWire[ iTW ][ _a ] == _tw[ _a ] then	--FALL THROUGH
					if _a == #_tw then		--ARE WE AT THE END OF A RUN & _GO
						trimFwdTW( tPortHole.ghosts[ _idx ].rTripWire[ iTW ] )
					end
				else
					_GO = false				--FALL BACK
				end
				_a = _a +1
			end										-- *** NESTED TW TIMING! THAT'S WHERE MILK CAN GO BAD IN FRIDGE MORE SLOWLY... ***
			_a = 2
			_GO = true
			--end
		end
	end
	_a = 2
	_GO = true
	for iObj =1, #tPortHole.ghosts[ _idx ].rObj do
		if tPortHole.ghosts[ _idx ].rObj[ iObj ].tripWireLIVE then -- and not  tPortHole.ghosts[ _idx ].rObj[ iObj ].objHIDDEN
			for iTW =1, #tPortHole.ghosts[ _idx ].rObj[ iObj ].tripWire do
				while _a <= #_tw and _GO do		--DATA WALK
					if tPortHole.ghosts[ _idx ].rObj[ iObj ].tripWire[ iTW ][ _a ] == _tw[ _a ] then
						if _a == #_tw then		--ARE WE AT THE END OF A RUN & _GO
							trimFwdTW( tPortHole.ghosts[ _idx ].rObj[ iObj ].tripWire[ iTW ] )
						end
					else
						_GO = false		--FALL BACK
					end
					_a = _a +1
				end
				_a = 2
				_GO = true
			end
			_a = 2
			_GO = true
			for iBag =1, #tPortHole.ghosts[ _idx ].rObj[ iObj ].oBag do
				--.oBag[] IS NESTED OBJ[ IN OBJ ]
				while _a <= #_tw and _GO do		--DATA WALK
					--if  tPortHole.ghosts[ _idx ].rObj[ iObj ].oBag[ iBag ].tripWire[ 1 ] == _tw[ 1 ] then
					if tPortHole.ghosts[ _idx ].rObj[ iObj ].oBag[ iBag ].tripWire[ iTW ][ _a ] == _tw[ _a ] then
						if _a == #_tw then		--oBag LOOP INTO SELF FUNCTION LIKE FRACTAL BUT THAT MEANS TBL FEED!
							trimFwdTW( tPortHole.ghosts[ _idx ].rObj[ iObj ].oBag[ iBag ].tripWire[ iTW ] )
						end
					else
						_GO = false		--FALL BACK
					end
					_a = _a +1
				end
				_a = 2
				_GO = true
			end
			_a = 2
			_GO = true
		end
	end
	if #tMap.auLeg >0 then		--CHECK TYPED AGAINST PER-OBJ TWS
		for _iObj =1, #tMap.auLeg do
			if #tMap.auLeg[ _iObj ].tripWire >0 then
				for iTW =1, #tMap.auLeg[ _iObj ].tripWire do
					while _a <= #_tw and _GO do		--DATA WALK
						if tMap.auLeg[ _iObj ].tripWire[ iTW ][ _a ] == _tw[ _a ] then
							if _a == #_tw then		--ARE WE AT THE END OF A RUN & _GO
								trimFwdTW( tMap.auLeg[ _iObj ].tripWire[ iTW ] )
							end
						else
							_GO = false		--FALL BACK
						end
						_a = _a +1
					end
					_a = 2
					_GO = true
				end
			end			
		end
	end
end

function allTWtimerChk()				--CHECK RUN ROOM & OBJS TRIPWIRE TIMERS
	--NOT RUNNING TIMER ON THE OBJS THAT ARE INSIDE A CONTAINER OBJ
	--allTWtimerChk
	local _currentTime = ""
	local _bFLAG = false
	if tMap.rmHours < 10 then			--HOURS
		_currentTime = _currentTime .."0"
	end
	_currentTime = _currentTime .. tostring( tMap.rmHours ) ..":"
	if tMap.rmMinutes < 10 then		--MINUTES
		_currentTime = _currentTime .."0"
	end
	_currentTime = _currentTime .. tostring( tMap.rmMinutes ) ..":"
	if tMap.rmSeconds < 10 then		--SECONDS
		_currentTime = _currentTime .."0" 
	end
	_currentTime = _currentTime .. tostring( tMap.rmSeconds ) ..":"
	_currentTime = _currentTime .. tostring( tMap.rmFraction )	--DECIMAL 0-9 1/10th A SECOND

	local _iInRm = tPortHole.ghosts.idx
	-- *** LIVE PLAY-MODE ONLY ***
	--RANDOM RM CHECK UNTIL ALL RMS DONE WOULD BE BEST, BUT FOR NOW WE WILL JUST SWEEP THROUGH
	for iRm = 1, #tPortHole.ghosts do
		if iRm == _iInRm and tPortHole.ghosts[ _iInRm ].rTWrmLIVE and #tPortHole.ghosts[ _iInRm ].rTripWire >0 then
			for iTW = 1, #tPortHole.ghosts[ _iInRm ].rTripWire do
				if ( tPortHole.ghosts[ _iInRm ].rTripWire[ iTW ][1] == "b:oT" or tPortHole.ghosts[ _iInRm ].rTripWire[ iTW ][1] == "b:T" )
				and tPortHole.ghosts[ _iInRm ].rTripWire[ iTW ][2] == "timer"
				and _currentTime == tPortHole.ghosts[ _iInRm ].rTripWire[ iTW ][3] then	--trimFwdTW(  tPortHole.ghosts.rTripWire[ iRm ][3] ) then
					tMap.oMoveRm = iRm
					_bFLAG = trimFwdTW( tPortHole.ghosts[ _iInRm ].rTripWire[ iTW ] )
--				else	--NON-TIMER USER TYPED
				end
			end		-- *** NESTED TW TIMING! THAT'S WHERE MILK CAN GO BAD IN FRIDGE AND OUTSIDE OF FRIDGE ***
		end
		for iObj =1, #tPortHole.ghosts[ iRm ].rObj do
			if tPortHole.ghosts[ iRm ].rObj[ iObj ].MOVES then
				for iTW =1, #tPortHole.ghosts[ iRm ].rObj[ iObj ].tripWire do
					if tPortHole.ghosts[ iRm ].rObj[ iObj ].tripWire[ iTW ][1] == "b:T"
					and tPortHole.ghosts[ iRm ].rObj[ iObj ].tripWire[ iTW ][2] == "timer"
					and _currentTime == tPortHole.ghosts[ iRm ].rObj[ iObj ].tripWire[ iTW ][3] then	--trimFwdTW(  tPortHole.ghosts.rTripWire[ iRm ][3] ) then
						tMap.oMoveRm = iRm
						_bFLAG = trimFwdTW( tPortHole.ghosts[ iRm ].rObj[ iObj ].tripWire[ iTW ] )
					end
				end
			end
		end
	end
	if #tMap.auLeg >0 then		--CHECK TYPED AGAINST PER-OBJ TWS
		for _iObj =1, #tMap.auLeg do
			if #tMap.auLeg[ _iObj ].tripWire >0 then
				for iTW =1, #tMap.auLeg[ _iObj ].tripWire do
					if ( tMap.auLeg[ _iObj ].tripWire[ iTW ][1] == "b:oT" or tMap.auLeg[ _iObj ].tripWire[ iTW ][1] == "b:T" )
					and tMap.auLeg[ _iObj ].tripWire[ iTW ][2] == "timer"
					and _currentTime == tMap.auLeg[ _iObj ].tripWire[ iTW ][3] then
						_bFLAG = trimFwdTW( tMap.auLeg[ _iObj ].tripWire[ iTW ] )
					end
				end
			end			
		end
	end
	--SWEEP ENTIRE MAP WITH .MOVES & .MOVEUD
	return _bFLAG		--HELP UPDATE DISPLAY
end

function addGhostTW()
	--GHOST HAS TO COME BACK AS A 3rd LEG
	tPortHole.ghosts = tRetro:tblClone( tMap.rms )
end

	function addTime( _tStep, _tFrom )	--true, _hour, _min, _sec, _dec
		local _TIMEs, _hourS, _minS, _secS, _decS = isTime( _tStep )	--STEP/WALK
		local _TIMEf, _hourF, _minF, _secF, _decF = isTime( _tFrom )	--FROM THIS POINT
		_hourF = tMap.rmHours + _hourF + _hourS or 0			--STARTING TIME
		_minF = tMap.rmMinutes + _minF + _minS or 0
		_secF = tMap.rmSeconds + _secF + _secS or 0
		_decF = tMap.rmFraction + _decF + _decS or 0
		--isTime() ABSTRACT TIME AND TIME ARE THE SAME TO FUNCTION, MATHFLOOR FOR DEALING WITH THAT ABSTRACT
		if _decF > 9 then
			_secF = _secF + 1 + math.floor( (_decF-9)/10 )
			_decF = 0
		end
		if _secF > 59 then
			_minF = _minF + 1 + math.floor( (_secF-59)/60 )
			_secF = 0
		end
		if _minF > 59 then
			_hourF = _hourF + 1 + math.floor( (_minF-59)/60 )
			_minF = 0
		end
		if _hourF > 24 then
			_hourF = _hourF -24
		elseif _hourF == 24 then
			_hourF = 0
		end
		local _time = ""
		if _hourF <= 9 then _time = _time .."0".. _hourF else _time = _time .. _hourF end
		_time = _time ..":"
		if _minF <= 9 then _time = _time .."0".. _minF else _time = _time .. _minF end
		_time = _time ..":"
		if _secF <= 9 then _time = _time .."0".. _secF else _time = _time .. _secF end
		_time = _time ..":" .. _decF
		return _time
	end

	function isBuildCMD( _word )
		if not string.match( _word, "%d+" ) then	--IF NOT A NUMBER
			for b =1, #tRetro.buildCmds do
				if string.lower( _word ) == string.lower( tRetro.buildCmds[ b ] ) then
					--sortTW( _word, "cmd" )
					return true
				end
			end
		end
		return false
	end

	function isPlayCMD( _word )
		if not string.match( _word, "%d+" ) and #tRetro.playCmds >0 then				-- 4 == PLAY MODE ALWAYS PROCESSES
			for b =1, #tRetro.playCmds do
				if string.lower( _word ) == string.lower( tRetro.playCmds[ b ] ) then
					--sortTW( _word, "cmd" )
					return true
				end
			end
		end
		return false
	end

	function isCustomCMD( _word )
		if not string.match( _word, "%d+" ) and #tRetro.hCCmds > 0 then
			for b =1, #tRetro.hCCmds do													--CUSTOM CMDS
				if _word == tRetro.hCCmds[ b ] then								--CASE SENSITIVE USEFUL FOR STORY
					return true
				end
			end
		end
		return false
	end

	function isTime( _word )	--true, _hour, _min, _sec, _dec
		local _iTime = string.find( _word, ":", 1 ) or 0
		local _iNum = string.find( _word, "%d+", 1 ) or 0
		local _hour, _min, _sec, _dec = 0,0,0,0
		--23:59:59 OR 23:59:59:9 SO NOW ANY TEXT WITH ":" CAN BE CALLED TIME
		if _iNum < _iTime and _iNum ~= 0 and _iTime ~= 0 then
			_hour = tonumber( string.match( _word, "%d+", _iNum ) ) or 0
			_iTime = string.find( _word, ":", _iNum +1 ) or 0
			_min = tonumber( string.match( _word, "%d+", _iTime +1 ) ) or 0
			_iTime = string.find( _word, ":", _iTime +1 ) or 0
			_sec = tonumber( string.match( _word, "%d+", _iTime +1 ) ) or 0
			_iTime = string.find( _word, ":", _iTime +1 ) or 0
			_dec = tonumber( string.match( _word, "%d+", _iTime +1 ) ) or 0
			return true, _hour, _min, _sec, _dec
		end
		return false
	end

	function isBOOL( _word )
		if _word == "true" or _word == "TRUE" or _word == "false" or _word == "FALSE" then
			return true
		end
		return false
	end
	function isDice( _word )	--DIRT SINGLE IS MULTI CHARACTERS AND NOW DICE NEEDS TO BE RE-CODED
		_word = string.lower( _word )
		local _iNumDice, _iLetter, _iDiceSize = 0,0,0
		_iNumDice = string.find( _word, "%d+", 1 ) or 0
		_iLetter = string.find( _word, "%a", 1 ) or 0
		_iDiceSize = string.find( _word, "%d+", _iNumDice +1 ) or 0
		--WE NEED TO KNOW HOW MANY DICE ARE BEING USED
		if _iLetter < _iNumDice and _iLetter ~= 0 and _iNumDice ~= 0 then		--SINGLE DICE FOUND
			return true, 1, string.match( _word, "%d+", _iNumDice )
		elseif _iNumDice < _iLetter and _iLetter < _iDiceSize
		and _iNumDice ~= 0 and string.match( _word, "d", _iLetter ) == "d" and _iDiceSize ~= 0 then				--MULTI DICE FOUND
			return true, string.match( _word, "%d+", _iNumDice ), string.match( _word, "%d+", _iDiceSize )	--return true, #dice, diceSize
		end
		return false
	end

	function isNum( _word )
		if string.match(_word,"%d+") and not string.match(_word,"%a") then
			return true
		end
		return false
	end

	function isRoomNum( _word )
		_word = string.upper( _word )
		if string.match( _word,"-%d+" ) or string.match( _word,"%d+" ) then           --WE HAVE FOUND A NUMBER
			if string.match( _word,"^%a" ) == "R" then  --ONE OF MANY %a+ vs ^%a being 1st character
				return true
			end
		end
		return false
	end

	function isRmInSTORY( _rNum )		--isMXYZinSTORY( map4D )
		local _num = ( string.match( _rNum,"-%d+" ) or string.match( _rNum,"%d+" ) ) or "0"
		if _num == "0" then
			return false, 0--, 0,0,0,0
		elseif #_num >0 then
			for idx =1, #tMap.rms do --#tMap.allRms do
				if ( "R" .. _num ) == tMap.rms[ idx ].rRoomNum then
					--RETURN MXYZ TO HELP DIRT GET ON WITH OLD MAP MOVEMENTS LIKE YEARS AGO
					return true, _num, tMap.rms[ idx ].rMap4D, idx
					--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
					--,tMap.rms[ idx ].rMap4D.m,tMap.rms[ idx ].rMap4D.x,tMap.rms[ idx ].rMap4D.y,tMap.rms[ idx ].rMap4D.z
				end
			end
		end
		return false,nil,nil, 0--, 0,0,0,0
	end

	function isDIRT( _word )		--RETURN COMBO SINGLE DIRT	--local _tbl = { "N","S","E","W","U","D" }
		_word = string.upper( _word )
		local _N,_S,_W,_E,_D,_U = false,false,false, false,false,false
		local _count = 0
		local _singleDIRT, _multiDIRT, _dirtNUM = false, false, false
		local _rNum = nil
		if string.find( _word ,"N" ) then
			_N = true
			_count = _count +1
		elseif string.find( _word ,"S" ) then
			_S = true
			_count = _count +1
		end
		if string.find( _word ,"E" ) then
			_E = true
			_count = _count +1
		elseif string.find( _word ,"W" ) then
			_W = true
			_count = _count +1
		end
		if string.find( _word ,"U" ) then
			_U = true
			_count = _count +1
		elseif string.find( _word ,"D" ) then
			_D = true
			_count = _count +1
		end
		local _char = string.match( _word,"%a" ) or ""
		local _chars = string.match( _word,"%a+" ) or ""
		local _REPEATED = false
		local _repeated = nil
		if _chars > _char then
			_repeated = string.rep( _char, #_chars ) or nil
			if _repeated == _chars then _REPEATED = true end
		end

		local _num = string.match( _word,"%d+" ) or 0
		--MULTI-DIRT
		if #_word > 1 then					
			if string.rep( _char, #_word ) == _word then
				_multiDIRT = true
				_count = #_word
			elseif ( _word == _num .. _char or _word == _char .. _num
				or _word == _num .. _chars or _word == _chars .. _num )
			and not _REPEATED and #_chars == _count then
				_dirtNUM = true
				_count = tonumber( _num )
			end
		end
		--else
		if not _multiDIRT and not _dirtNUM
		and #_word == _count and ( _N or _S or _E or _W or _U or _D ) then	--SINGLE DIRT
			_singleDIRT = true
			_count = 1
		end
		--end
		local _DIRT = false
		if _singleDIRT or _dirtNUM or _multiDIRT then
			_DIRT = true
		end
		return _DIRT, _word, _singleDIRT, _dirtNUM, _multiDIRT,  _N,_S,_W,_E,_D,_U, _count, _rNum
	end

	function isInExit( _tbl, _exit )
		for a =1, #_tbl do
			if _tbl[a] == _exit then
				return true
			end
		end
		return false
	end

--( _singleDIRT, _multiDIRT, _dirtNUM, _dirt, _N,_S,_W,_E,_D,_U, _exitLoops )
	function isExitInRm( _dirt, _exitLoops )				--RETURN IN-ROOM EXIST FOR MULTI-DIRT OR DIRT#
		--NOTICE SINGLE-DIRT CAN NOW BE MULTI-CHARACTER WIDE NSD,NW,SE,UW...
		local _iRm = tMap.rms.idx
		local _firstExitIdx = 0
		local _lastExitIdx = 0
		local _loopCount = 0
		if _dirt and #tMap.rms[ _iRm ].rExits >0 then
			for b =1, #tMap.rms[ _iRm ].rExits do
				if string.match( _dirt,"%a+" ) == string.match( tMap.rms[ _iRm ].rExits[ b ],"%a+" ) then		--SINGLE CHAR "SED","NE"
					_loopCount = _loopCount +1
					if _firstExitIdx == 0 then
						_firstExitIdx = b
						_lastExitIdx = b
					else
						_lastExitIdx = b
					end
				end
			end
		end
		if _lastExitIdx > 0 then
			if _exitLoops == _lastExitIdx then
				return true, _firstExitIdx, _lastExitIdx, _exitLoops -_loopCount		--RETURN THE EXIST INDEX IN THE ROOM
			end
		end
		return false, _firstExitIdx, _lastExitIdx, 0
	end

	function isMXYZinSTORY( _map4D )
		for idx =1, #tMap.rms do
			if tMap.rms[ idx ].rMap4D.m == _map4D.m and tMap.rms[ idx ].rMap4D.x == _map4D.x 
			and tMap.rms[ idx ].rMap4D.y == _map4D.y and tMap.rms[ idx ].rMap4D.z == _map4D.z then
				return true, idx, tMap.rms[ idx ].rRoomNum
			end
		end
		return false, nil,nil
	end

	function charTrim( _label )		--NOT IN ACTION YET...
		local _iLast = string.find( _label, "s",#_label ) or 0	--string.find( _label, "ies",#_label -2 ) --or string.find( _label, "es",#_label -1 ) 
		if _iLast > 0 then
			return string.sub( _label, 1, _iLast -1 )
		end
	end

	function idxEccoCmdControl( _tw, _idx )
		local _iB,_iP,_iC, _iD,_iR, _iNum,_iObj,_iTime, _iBool = 0,0,0, 0,0, 0,0, 0,0	--_iObj2
		local _cmd = ""
		local _bCMD, _pCMD, _cCMD = false, false, false
		local _iCmdHigh = 0
		_iB = string.find( _tw[1],"b", _idx ) or 0
		_iB = notSunCycle( _iB )
		_iP = string.find( _tw[1],"p", _idx ) or 0
		_iP = notSunCycle( _iP )
		_iC = string.find( _tw[1],"c", _idx ) or 0
		_iC = notSunCycle( _iC )
		_iD = string.find( _tw[1],"d", _idx ) or 0
		_iD = notSunCycle( _iD )
		_iR = string.find( _tw[1],"r", _idx ) or 0
		_iR = notSunCycle( _iR )
		_iTime = string.find( _tw[1],":", _idx ) or 0	--TIME NO LONGER A NUMBER
		_iTime = notSunCycle( _iTime )

		_iObj = string.find( _tw[1],"o", _idx ) or 0	--ZERO OTHER WISE MATH.MAX PICKS UP THE FALLBACK
		_iObj = notSunCycle( _iObj )
		_iNum = string.find( _tw[1],"#", _idx ) or 0
		_iNum = notSunCycle( _iNum )
		--MISSING "x" WHICH WAS DICE
		_iBool = string.find( _tw[1],"&", _idx ) or 0
		_iBool = notSunCycle( _iBool )
		if _iC > 0 then
			_cmd = _tw[ _iC ]
			_cCMD = true
			_iCmdHigh = _iC
		end
		if _iP > 0 then
			_cmd = _tw[ _iP ]
			_pCMD = true
			_iCmdHigh = _iP
		end
		if _iB > 0 then
			_cmd = _tw[ _iB ]
			_bCMD = true
			_iCmdHigh = _iB
		end
		return _iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime, _iBool, _bCMD,_pCMD,_cCMD, _cmd, math.max( _iCmdHigh, _iD,_iR, _iNum,_iObj, _iTime )
	end

	function twReNameWalk( _tbl, _oldLabel, _newLabel  )	-- *** UPDATE OBJ LABEL IN ALL TWS ***
		--local _idx = tMap.rms.idx
		if type( _tbl ) == "table" then
			if _tbl.label == _oldLabel then _tbl.label = _newLabel end
			for x = 1, #_tbl.tripWire do
				for iWalk = 1, #_tbl.tripWire[ x ] do
					if _oldLabel == _tbl.tripWire[ x ][ iWalk ] then
						_tbl.tripWire[ x ][ iWalk ] = _newLabel
					end
				end
			end
		end
		return _tbl
	end
	--if _autoBuild == "inRm" then
	--	if #_tUpdateObj.tripWire > 0 then
	--		for x=1, #_tUpdateObj.tripWire do
	--			for iWalk=1, #_tUpdateObj.tripWire[ x ] do
	--				if _oldWord == _tUpdateObj.tripWire[ x ][ iWalk ] then		--WORD MATCH SWAP
	--					_tUpdateObj.tripWire[ x ][ iWalk ] = _newWord
	--				end
	--			end
	--		end
	--	end
	--elseif _autoBuild == "onAu" then
	--	if #_tUpdateObj.tripWire > 0 then
	--		for x=1, #_tUpdateObj.tripWire do
	--			for iWalk=1, #_tUpdateObj.tripWire[ x ] do
	--				if _oldWord == _tUpdateObj.tripWire[ x ][ iWalk ] then		--WORD MATCH SWAP
	--					_tUpdateObj.tripWire[ x ][ iWalk ] = _newWord
	--				end
	--			end
	--		end
	--	end
	--end
	function moveObjInMap( _tw )		--tRetro:moveItem( _bNEST, _scrTbl, _dstTbl, _count, _cmd )
		local _iB,_iP,_iC, _iD,_iR, _iNum,_iObj, _iTime,_iBool, _bCMD,_pCMD,_cCMD, _cmd, _idx = idxEccoCmdControl( _tw, 1 )
		--LOOP ENTIRE MAP AND CALL EVERY OBJECT WITHOUT LEADING TW CMD!
		local _iNum2 = 0
		local _ = 0
		_,_,_,_,_, _iNum2 = idxEccoCmdControl( _tw, _iNum )		--DEFAULT IS 99/100
		local _percentObjs = 0
		if _iNum == 0 then
			_percentObjs = 1
		elseif _iNum ~= 0 then
			_percentObjs = _tw[ _iNum ]/100
		end
		_percentObjs = tonumber( _percentObjs )
		local _percentAction = _tw[ _iNum2 ]
		if _iNum2 == 0 then
			_percentAction = 99
		elseif _iNum2 ~= 0 then
			_percentAction = _tw[ _iNum2 ]/100
		end
		_percentAction = tonumber( _percentAction )

		--NEED LOCATION OF OBJ WITHIN O-MOVE-RM FOR COUNT
		local _AOBJ, _iAObj = tRetro:objRmEXISTS( _tw[ _iObj ], nil, tMap.oMoveRm )
		local _iRndExitA = math.random( 1, #tMap.rms[ tMap.oMoveRm ].rExits )
		local _NEST = false
		local _count = 0
		if _AOBJ and _iRndExitA ~= 0 then
			_count = math.floor( tMap.rms[ tMap.oMoveRm ].rObj[ _iAObj ].count * _percentObjs )
			--WE HAVE AN EXIT SO WE NEED TO KNOW DIRT AND ROOM NUMBER *** SOURCE ***
			local _rmNumB = string.match( tMap.rms[ tMap.oMoveRm ].rExits[ _iRndExitA ], "-%d+" ) or string.match( tMap.rms[ tMap.oMoveRm ].rExits[ _iRndExitA ], "%d+" )
			local _dirt = string.match( tMap.rms[ tMap.oMoveRm ].rExits[ _iRndExitA ], "%a+" )
			-- *** DESTINATION ***
			local _BRM, _,_, _idstRmB = isRmInSTORY( _rmNumB )		--DOES THIS ROOM EXIST?
			local _BOBJ, _iBObj = tRetro:objRmEXISTS( _tw[ _iObj ], nil, _idstRmB )
			local _GOEXIT = false
			--DESTINATION OBJ MEANS WE NEED TO SEE IF SAME OBJ-B EXISTS IN ROOM-B
			if _BRM and _BOBJ then
				if #_dirt > 1 and tMap.rms[ _idstRmB ].rObj[ _iBObj ].MOVEUD then
					if "U" == string.match( _dirt, "%a" ) or "D" == string.match( _dirt, "%a" ) then
						_GOEXIT = true
					end
				elseif #_dirt == 1 then
					_GOEXIT = true
				end
				--ACTION % WISE MATH FOR SURE WE ARE MOVING OBJ
				if _GOEXIT and math.random( 1,100 ) <= _percentAction then
					tMap.rms[ tMap.oMoveRm ].rObj[ _iAObj ].count = tMap.rms[ tMap.oMoveRm ].rObj[ _iAObj ].count -_count
					tMap.rms[ _idstRmB ].rObj[ _iBObj ].count = tMap.rms[ _idstRmB ].rObj[ _iBObj ].count +_count
					return true
				end
			elseif _BRM and not _BOBJ then
				if math.random( 1,100 ) <= _percentAction then
					tMap.rms[ tMap.oMoveRm ].rObj[ _iAObj ].count = tMap.rms[ tMap.oMoveRm ].rObj[ _iAObj ].count -_count
					local _tbl = tRetro:tblClone( tMap.rms[ tMap.oMoveRm ].rObj[ _iAObj ] )
					_tbl.count = _count
					table.insert( tMap.rms[ _idstRmB ].rObj, _tbl )
					return true
				end
			end
		end
		return false
	end

	function runCmd( _word )
		if _word == "menu" then
			tMenu:walk("mroom")			--DEFAULT MENU3 VIEW - ROOM 1st
			return true
--	elseif _word == "bb" then		--MAKE ALL THE ROOMS LIVE, SWITCH TO PLAY MODE
--		tPortHole:bb()
--		return true
			--elseif _word == "open" then
			--return true
		end
		return false
	end

	function runAddCCmd( _cmd )				--KUSTOM CMD ADDITION TO STORY
		local _bCMD = isBuildCMD( _cmd )
		local _pCMD = isPlayCMD( _cmd )
		local _cCMD = isCustomCMD( _cmd )
		if not _bCMD and not _pCMD and not _cCMD then
			table.insert( tRetro.hCCmds, _cmd )
		end
	end

--function runDelExit( _tw, _tblRoom, _tblExits )
--	local _,_,_, _iD,_iR, _,_, _, _,_,_, _, _idx = idxEccoCmdControl( _tw, 1 )
--	if _tw[1] == "b" then
--		_tblRoom = {}
--		_iD = 0
--	end
--	while _iD ~= 0 do
--		--local _dirtNum = _tw[ _iD ]
--		for a = 1, #_tblRoom do	--tMap.rms[ tMap.rms.idx ].rExits
--			if _tw[ _iD ] == _tblRoom[ a ] then	--tMap.rms[ tMap.rms.idx ].rExits
--				table.remove( _tblRoom, a )				--tMap.rms[ tMap.rms.idx ].rExits
--				a =1
--			end
--		end
--		_,_,_, _iD,_iR, _,_, _, _,_,_, _, _idx = idxEccoCmdControl( _tw, _iD )
--	end
--	return _map4DRoom
--end

	function runCmdRoom( _tw )	--NOT GETTING USED MUCH
		if _tw[1] == "cr" then
			if ( _tw[2] == "enter" or _tw[2] == "goto" ) and isRoomNum( _tw[3] ) then
				sortTW( _tw[3], "room" )
				--tMap.allRms.bRESET = true
				--tRetro:foo( _tw[3] )
			end
		elseif _tw[1] == "copy" and isRoomNum( _tw[3] ) then
			sortTW( _tw[3], "room" )
			tRetro:copy( _tw[2] )
		end
	end

	function runCmdObj( _cmd, _num, _objA, _objB, _MOVES, _MOVEUD )	--
		local _bFLAG = false
		local _UNTAKE = false
		if _objB then
			local _obj2CMD = isCustomCMD( _objB ) or isBuildCMD( _objB ) or isPlayCMD( _objB )
		end
		if _cmd == "+" or _cmd == "create" then							--IN-ROOM
			_bFLAG = tRetro:objCrt( _objA, tonumber( _num ), _UNTAKE, "inRM", _MOVES, _MOVEUD )	--NO # FALLS BACK TO 1
		elseif _cmd == "++" or _cmd == "+create" then				--ON-AUTHOR
			_bFLAG = tRetro:objCrt( _objA, tonumber( _num ), false, "onAU", _MOVES, _MOVEUD )
		elseif _cmd == "untake" or _cmd == "notake" then
			_bFLAG = tRetro:objCrt( _objA, tonumber( _num ), true, "inRM", _MOVES, _MOVEUD )
		elseif _cmd == "hide" then
			tRetro:objHide( _objA, true )				--.objHIDDEN true IF IT EXISTS
		elseif _cmd == "unhide" then
			tRetro:objHide( _objA, false )				--FALSE MEANS UNHIDE OBJ MATCH
		elseif _cmd == "-" or _cmd == "del" or _cmd == "delete" then
			_bFLAG = tRetro:objDelInRoom( _objA, tonumber( _num ) )
		elseif _cmd == "--" or _cmd == "-del" or _cmd == "-delete" then
			_bFLAG = tRetro:objDelOnAuthor( _objA, tonumber( _num ) )
		elseif _cmd == "take" then
			_bFLAG = tRetro:objTake( _objA, tonumber( _num ), _objB )		--_bFLAG return needs looking into more
		elseif _cmd == "place" or _cmd == "drop" then
			_bFLAG = tRetro:objDrop( _objA, tonumber( _num ), _objB )
		elseif _cmd == "rename" then
			_bFLAG = tRetro:objRename( _objA, tonumber( _num ), _objB )
			return _bFLAG, 3
		elseif _cmd == "eat" or _cmd == "drink" or _cmd == "consume" then	
			_bFLAG = tRetro:objConsume( _objA, tonumber( _num ) or 1 )
			return _bFLAG
			--local gITM, _iGhost = _table:objGhostEXISTS( _obj )
		elseif _cmd == "rmlabel" then
			_bFLAG = tRetro:rmlabel( "rm", _obj )			--_obj IS TARGET DATA LABEL SWAP
		elseif _cmd == "olabel" then
			_bFLAG = tRetro:rename( _objA, _num or 1, _objB )
		elseif _cmd == "on" or _objB == "on" then
			if _objB == "on" then
				_bFLAG = tRetro:objOnOff( _objB, true )
				if _obj2CMD then return true, 3 end
			else
				_bFLAG = tRetro:objOnOff( _objA, true )
			end
		elseif _cmd == "off" or _objB == "off" then
			if _objB == "off" then
				_bFLAG = tRetro:objOnOff( _objB, false )
				if _obj2CMD then return true, 3 end
			else
				_bFLAG = tRetro:objOnOff( _objA, false )
			end
		elseif _cmd == "lock" then	--DOING LOCK/UNLOCK JOB
			--PROVE THAT OBJ IS OBJ -OR- OBJ NOT CMD
			_bFLAG = tRetro:objLock( _obj or _objB, true )		--if .objLOCKED
		elseif _cmd == "unlock" then	--DOING LOCK/UNLOCK JOB
			--LOCATE THE ROOM OR OBJECT TO UNLOCK
			_bFLAG = tRetro:objLock( _obj or _objB, false )		--if .objLOCKED
			--FAILED OPEN MEANS TO SEND FEED BACK ON TW FOR THE SAKE OF HINT TO UNLOCK OBJECT
			--elseif _cmd == "close" then
			--PROVE THAT OBJ IS OBJ -OR- OBJ NOT CMD
			--_bFLAG = tRetro:objLock( _obj or _objB, false )
		end
		if _bFLAG then
			return true --, 2		--A CMD SUCCESS
		elseif not _bFLAG then
			if _objB then
				return false --, 3
			else
				return false --, 2
			end
		end
	end

	function runCmdDirt( _path, _SUDO )	--DO NOT TOUCH, PERFECTLY SMOOTH WITHOUT DIRT ISSUES
		--return _DIRT, _word, _singleDIRT, _dirtNUM, _multiDIRT,  _N,_S,_W,_E,_D,_U, _count, _rNum
		local _DIRT, _dirt, _singleDIRT, _dirtNUM, _dupliDIRT, _N,_S,_W,_E,_D,_U, _exitLoops, _rNum = isDIRT( _path )
		if _DIRT then
			local _rmIdxA, _rmIdxB = tMap.rms.idx, nil
			local _rmNumA, _rmNumB = string.match( tMap.rms[ _rmIdxA ].rRoomNum,"-%d+" ) or string.match( tMap.rms[ _rmIdxA ].rRoomNum,"%d+" ), nil
			local _mapB = tRetro:tblClone( tMap.rms[ _rmIdxA ].rMap4D )
			--C IS OUR 3rd LEG FOR +M ROOMS AS WE ARE STEARING WITH MAP4D AND NOT DIRT
			--local _mapEXISTSC, _rmNumC, _rmIdxC = false, nil, nil
			--local _mapC = tRetro:tblClone( tMap.rms[ _rmIdxA ].rMap4D )
			local _dirtMirror = nil
			local _EXITA, _EXITB = false, false
			local _mapEXISTSB = false
			local _exitCounted, _exitNumDiff = 0,0
			local _m = 0
			local _dirtA = string.match( _dirt,"%a+" )
			--local _M = false
			if _dupliDIRT then
				_dirtA = string.match( _dirt,"%a" )		--TRIM OFF DUPLICATES
			end
			--WORKING THE MULTI-EXITS SITUATION
--		if _dirtNUM or _dupliDIRT and _exitLoops >0 then
--			_m = _exitLoops -1
--		end
			_mapEXISTSB, _rmNumB, _mapB, _rmIdxB = tRetro:nextRoomNum( _rmNumA, _mapB, _m, _N,_S,_W,_E,_D,_U )
			--3rd LEG C SHOULDN'T JUST BE ADJUSTING MAP4D BUT ALSO FALLBACK TO USER-DIRT INSTRUCTIONS
			if not _mapEXISTSB and #tMap.rms[ _rmIdxA ].rExits >0 and not _SUDO then
				_mapB = tRetro:tblClone( tMap.rms[ _rmIdxA ].rMap4D )
				--DOES DIRT MATCH TARGET EXIT?
				local _count = 1
				local _exitNum = nil
				for a =1, #tMap.rms[ _rmIdxA ].rExits do
					if _dirtA == string.match( tMap.rms[ _rmIdxA ].rExits[ a ],"%a" ) then
						if _count == _exitLoops then
							_exitNum = string.match( tMap.rms[ _rmIdxA ].rExits[a],"-%d+" ) or string.match( tMap.rms[ _rmIdxA ].rExits[a],"%d+" )
							break
						else
							_count = _count +1
						end
					end
				end
				if _exitNum then
					_mapEXISTSB, _rmNumB, _mapB, _rmIdxB = isRmInSTORY( _exitNum )
				end
			end

			if not tMap.rmNOEXITS and _SUDO then
				if _mapEXISTSB then
					_EXITA, _firstExitIdx, _lastExitIdx, _exitNumDiff = isExitInRm( _dirtA .._rmNumB, _exitLoops )
					--while _exitNumDiff >0 do
					if _exitNumDiff >0 then				--TIME TO ADD SAME EXIT +m ;)
						_mapEXISTSB, _rmNumB, _mapB, _rmIdxB = tRetro:nextRoomNum( _rmNumB, _mapB, 1, false,false,false,false,false,false )
						_EXITA = false		--RESET BOOL AND LET ADDING EXIT FUNTION DO THE FILTERING OUT OF DUPLICATES
					end
				end
				if not _EXITA then		--ADD EXIT
					tMap.rms[ _rmIdxA ].rExits = tRetro:rmAddExit( tMap.rms[ _rmIdxA ].rExits, _dirtA .._rmNumB )
				end
			end
			_dirtMirror = mirrorDirt( _rmNumA, _N,_S,_W,_E,_D,_U )
			if not _mapEXISTSB and tMap.rmNOEXITS and _SUDO then		--CREATE ROOM
				tRetro:rmCreate( tMap.rms[ _rmIdxA ].rLabel, "R".. _rmNumB, _mapB, nil )
			elseif not _mapEXISTSB and _SUDO then
				tRetro:rmCreate( tMap.rms[ _rmIdxA ].rLabel, "R".. _rmNumB, _mapB, _dirtMirror )
			elseif _mapEXISTSB and not tMap.rmNOEXITS and _SUDO then		--EXIT FOR EXISTING ROOM
				tMap.rms[ _rmIdxB ].rExits = tRetro:rmAddExit( tMap.rms[ _rmIdxB ].rExits, _dirtMirror )
			end
			tRetro:switchRoom( _mapB )		--runCmdJumpRm( nil, true, _mapB )
			--return true
		end
		return false
	end

	function runAllRmLIVE( _switch )	--ALL ROOMS LIVE AND ROOM ENTERED COUNTS ZEROED
		--ALSO ACCOUNT FOR NESTED OBJS THAT ALSO *** TOGGLE LIVE***
		--tMap.hDataLOCKED = true
		for idx =1, #tMap.rms do
			--NEED TO DEAL WITH NESTED OBJECTS HERE!
			tMap.rms[ idx ].rTWrmLIVE = _switch
			tMap.rms[ idx ].rEnteredRmCount = 0
			--SWITCH-ON LIVE OBJECTS
			if #tMap.rms[ idx ].rObj >0 then
				for a =1, #tMap.rms[ idx ].rObj do
					tMap.rms[ idx ].rObj[ a ].tripWireLIVE = _switch	--TIMER & TW MATCHING
					--NESTED OBJECTS IN-ROOM
					if #tMap.rms[ idx ].rObj[ a ].oBag >0 then
						for b =1, #tMap.rms[ idx ].rObj[ a ].oBag do
							tMap.rms[ idx ].rObj[ a ].oBag[ b ].tripWireLIVE = _switch
						end
					end
				end
			end
		end
		--ALSO NEED TO SWITCH-ON LIVE OBJECTS ON THE PLAYER
		if #tMap.auLeg >0 then
			for idx =1, #tMap.auLeg do
				tMap.auLeg[ idx ].tripWireLIVE = _switch
				--NESTED OBJECTS ON-AUTHOR
				if #tMap.auLeg[ idx ].oBag >0 then
					for b =1, #tMap.auLeg[ idx ].oBag do
						tMap.auLeg[ idx ].oBag[ b ].tripWireLIVE = _switch
					end
				end
			end
		end
	end

	function runStoryLOCK( _bool )
		tMap.hDataLOCKED = _bool				--MENUS TURNS OFF AND NOT BACK ON
	end

	function removeDeadCount()			--REMOVE ANY OBJ.count == 0
		local _idx = 0
		--CLEAN UP FROM END TO FRONT
		for a = 1, #tMap.rms do
			_idx = #tMap.rms[ a ].rObj
			while _idx > 0 do		--and _idx <= #tMap.rms[ a ].rObj do
				if tMap.rms[ a ].rObj[ _idx ].count == 0 then
					table.remove( tMap.rms[ a ].rObj, _idx )
				end
				_idx = _idx -1
			end
		end
		_idx = #tMap.auLeg
		while _idx > 0 do 	-- and _idx <= #tMap.auLeg do
			if tMap.auLeg[ _idx ].count == 0 then
				table.remove( tMap.auLeg, _idx )
			end
			_idx = _idx -1
		end
	end

	function plusOne( num )
		return num +1
	end

	function plusIdx( _table )
		if _table.idx < #_table then
			return _table.idx +1
		elseif _table.idx == #_table then
			return 1
		end
	end

	function notSunCycle( _var )
		if _var ~= 0 then
			return _var +1
		else
			return _var
		end
	end

	function mirrorDirt( _pastRmNum, _N,_S,_W,_E,_D,_U )
		local _dirt = "" --string.match( _path,"%a" )
		if _N then
			_dirt = _dirt .."S"
		elseif _S then
			_dirt = _dirt .."N"
		end
		if _W then
			_dirt = _dirt .."E"
		elseif _E then
			_dirt = _dirt .."W"
		end
		if _D then
			_dirt = _dirt .."U"
		elseif _U then
			_dirt = _dirt .."D"
		end
		return _dirt .._pastRmNum
	end
--CHANGE THE TABLE TO CUT OUT HL/TARGETED OBJECT IF MENUS ON - PYTHON ASCII WORKED
--OR INSERT <mpointer obj>s FOR THE HIGHLIGHTED IN USE OBJECT - OTHER WISE HOW TO SPACE AND LOOK NORMAL
-- CURRENTLY OBJECTS ARE NOT IN SYNC SO LETS REM THIS OUT UNTIL ACTUALLY NEEDED TO BE FIXED FOR USE
	function ccatRmObj( _table )
		local _storyRoom = tMap.rms[ tMap.rms.idx ]
		local _numObj = {}
		if #_table > 0 then
			for i=1, #_table do
				local _num = ""	--(#)OBJs,*(#)OBJ,<(#)>OBJ,<*(#)>OBJ THIS KIND OF DISPLAY
				_num = tostring( _storyRoom.rObj[ i ].count )
				if tPortHole.drawMENU and _storyRoom.rObj.idx == i then
					if tPortHole.BBON and _storyRoom.rObj[ i ].objHIDDEN then
						table.insert( _numObj, "<*(".._num..")>".. _storyRoom.rObj[ i ].label )
					else
						table.insert( _numObj, "<(".._num..")>".. _storyRoom.rObj[ i ].label )
					end
				elseif tPortHole.BBON and _storyRoom.rObj[ i ].objHIDDEN then
					table.insert( _numObj, "*(".._num..")".. _storyRoom.rObj[ i ].label )
				elseif not _storyRoom.rObj[ i ].objHIDDEN then
					table.insert( _numObj, "(".._num..")".. _storyRoom.rObj[ i ].label )
				end
			end
			return table.concat( _numObj, ", " ) --NEED THAT COMMA AND SPACE NOW THAT WE HAVE
		else                                --MULTI WORD OBJECTS
			return ""
		end
	end

	function ccatAuObj( _table )
		local _numObj = {}
		if #_table > 0 then
			for i=1, #_table do		-- <HIGHLIGHTED> & *SEEING-HIDDEN
				local _num = ""	--(#)OBJs,*(#)OBJ,<(#)>OBJ,<*(#)>OBJ THIS KIND OF DISPLAY
				_num = tostring( tMap.auLeg[ i ].count )
				if tPortHole.drawMENU and tMap.auLeg.idx == i then
					--tMenu.tRmAu.menuIdx == 3 and tMenu.menuPointerIdx > 2 and i == tMenu.menuPointerIdx -2 then
					if tPortHole.BBON and tMap.auLeg[ i ].objHIDDEN then
						table.insert( _numObj, "<*(".._num..")>".. tMap.auLeg[ i ].label )
					else
						table.insert( _numObj, "<(".._num..")>".. tMap.auLeg[ i ].label )
					end
				elseif tPortHole.BBON and tMap.auLeg[ i ].objHIDDEN then	--BUILD-MODE SHOW HIDDEN
					table.insert( _numObj,"*(".._num..")".. tMap.auLeg[ i ].label )
				elseif not tMap.auLeg[ i ].objHIDDEN then								--PLAY MODE FILTER HIDDEN
					table.insert( _numObj,"(".._num..")".. tMap.auLeg[ i ].label )
				end
			end
			return table.concat( _numObj, ", " ) --NEED THAT COMMA AND SPACE NOW THAT WE HAVE
		else                                --MULTI WORD OBJECTS
			return ""
		end
	end

	function ccatHidden( _table )
		local _storyRoom = tMap.rms[ tMap.rms.idx ]
		local _numObj = {}
		if #_table > 0 then
			for i=1, #_table do
				local _num = ""
				if _storyRoom.rObj[i].objHid == true then
					table.insert( _numObj, _storyRoom.rObj[i].label )
				end
			end
			return table.concat( _numObj, ", " )
		else
			return ""
		end
	end

	function cCatbb( _fill, _table )	--BRACKETS
		local _tempTbl = {}
		if #_table > 0 then
			for i =1, #_table do
				if i == _table.idx then
					table.insert( _tempTbl, "<" .. _table[ i ] .. ">" )
				else
					table.insert( _tempTbl, _table[ i ] )
				end
			end
			return table.concat( _tempTbl, _fill )
		else
			return {}
		end
	end

	function ccat( _flow, _table )
		if #_table > 0 then
			if _flow == "," then
				return table.concat( _table, ", " )
			else
				return table.concat( _table, _flow )
			end
		else
			return ""
		end
	end

	function tabTab( _char )            -- *** LINUX/UNIX TAB TAB THE CMDS ***
		local _tbl = {}
		local _tbl2 = {}
		local _num = 0
		if #tMap.hCCmds > 0 then
			for i = 1, #tMap.hCCmds do     --CUSTOM COMMAND FROM FILE HEADER
				_num = string.find( tMap.hCCmds[i], _char )
				if _num == 1 then
					table.insert( _tbl, tMap.hCCmds[i] )
					_num = 0
				end
				table.insert( _tbl2, tMap.hCCmds[i] )
			end
			_num = 0
			for i = 1, #tMap.playCmds do		--NORMAL PLAY COMMAND
				_num = string.find( tMap.playCmds[i], _char )
				if _num == 1 then
					table.insert( _tbl, tMap.playCmds[i] )
					_num = 0
				end
				table.insert( _tbl2, tMap.playCmds[i] )
			end
		end
		_num = 0
		if tPortHole.BBON then   --BUILD MODES
			for i = 1, #tMap.buildCmds do     --BUILD ENVIRONMENT COMMAND
				_num = string.find( tMap.buildCmds[i], _char )
				if _num == 1 then
					table.insert( _tbl, tMap.buildCmds[i] )
					_num = 0
				end
				table.insert( _tbl2, tMap.buildCmds[i] )
			end
		end
		if #_tbl > 0 then
			return _tbl
		else
			return _tbl2
		end
	end

	function newLineCount( _text )
		--BETTER IF WE CHECK \n < #_idx which is 170 characters wide
		local _idx, _count = 1, 1
		local _char = math.floor( #_text /113 ) +1
		if #_text > 0 then
			while _idx < #_text do
				_idx = string.find( _text,"\n", _idx ) or #_text +1
				if _idx >0 and _idx <= #_text then
					_count = _count +1
				end
				_idx = _idx +1
			end
			if _char <= _count then
				return _count
			elseif _count < _char then
				return _char
			end
		end
		return 0
	end

	function boolFLIP( _bFLAG )
		if _bFLAG then
			return false
		else
			return true
		end
	end