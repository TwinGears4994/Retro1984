--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
function funcInject3( _table, _target )
	if _target == "reset" then
		function _table:reset()									--tMenu:reset()
			--ASSIGNING COLOUR FROM PORTHOLE - CHANGE ALL IN DRAW FILE!!!
			self.text = tPortHole.green						--tMenu.text
			self.text2 = tPortHole.white					--tMenu.text2
			self.text3 = tPortHole.skyblue				--tMenu.text3
			self.hlText = tPortHole.orange				--tMenu.hlText
			self.hlTextActive = tPortHole.yellow 	--or white	--tMenu.hlTextActive
			self.Brace = tPortHole.skyblue				--tMenu.Brace
			self.hlBrace = tPortHole.orange				--tMenu.hlBrace
			self.hlBraceActive = tPortHole.yellow	--tMenu.hlBraceActive
			self.drawMenuON = false
			--			self.addLineON = false
			--			self.editLineON = false
			self.menuPointerIdx = 0 							--COLOUR HIGHTLIGHT SELECTED
			self.tRmAu = { menuIdx = 1, --idx = 1, tMenu.tRmAu.menuIdx
				textList = { "ROOM-THEATER","IN-ROOM OBJ","ON-AUTHOR OBJ","STORY" }	}
			self.tMenuPOTT = { menuIdx = 1, --tMenu.tMenuPOTT.menuIdx	tMenu.tMenuPOTT.mLIST
				mLIST = true, --LISTS ALL OBJECTS, TO HONE INTO A SINGLE OBJECT FOR CHANGES
				textList = { "PARTS LIST","OBJECTS","TW-ACTION","TW-REACTION" }	}
			--MIGHT NEED A <Reset> for rolling back OBJS to basic, or just Delete
			self.tMenuACEDOXcmds = { menuIdx = 6,
				textList = { "Add","Copy","Edit","Delete","Return","eXit" },
				addLineON =false, editLineON =false, copyLineON =false,
				delLineON =false }--, reOrderLineON =false } --, turnedON =false }
			self.tEditLine = { location =11, cap =false, multi =1, "N","S","E","W","U","D", idx =1 }	--6 POSITIONS #TBL
			self.tw = { idx =1, "CUSTOM-CMD","BLD-CMD","CMD-USER","DIRT","NUMBER","ROOM#","STORY",
				twTemp = {},--TRANSLATED TWs
				twAction ={ iCmdB =0, iCmdC =0, iCmdP =0, iRm =0, iStory =0, iDirt =0, iNum =0 },
				twReAction ={ iCmdB =0, iCmdC =0, iCmdP =0, iRm =0, iStory =0, iDirt =0, iNum =0 }
				}
			--self.tMenuTW = { menuIdx =1, textList = { "CMD","#","OBJ","R#","FILE","DIRT" } }
		end
	elseif _target == "switch" then
		function _table:switch( _tw )
			if _tw == "mroom" then
				--self.tRmAu.menuIdx = 1
				self.drawMenuON = true
			end
		end
	elseif _target == "eccoACEDOXbools" then
		function _table:eccoACEDOXbools()
			if self.tMenuACEDOXcmds.editLineON
			or self.tMenuACEDOXcmds.addLineON
			or self.tMenuACEDOXcmds.copyLineON
			or self.tMenuACEDOXcmds.delLineON then
			--or self.tMenuACEDOXcmds.reOrderLineON then
				return true
			else
				return false
			end
		end
	elseif _target == "resetACEDOXbools" then
		function _table:resetACEDOXbools()
			self.tMenuACEDOXcmds.editLineON = false
			self.tMenuACEDOXcmds.addLineON = false
			self.tMenuACEDOXcmds.copyLineON = false
			self.tMenuACEDOXcmds.delLineON = false
			--self.tMenuACEDOXcmds.reOrderLineON = false
			--self.tMenuACEDOXcmds.turnedON = false	--HELP EDIT WORK AS SMOOTH AS <RETURN> FOR SELECTING MENUS-LINE
			self.tMenuACEDOXcmds.menuIdx = 6
		end
	elseif _target == "addLineON" then	--IN USE
		function _table:addLineON()
			self:resetACEDOXbools()
			self.tMenuACEDOXcmds.menuIdx = 1
			self.tMenuACEDOXcmds.addLineON = true
		end
	elseif _target == "copyLineON" then	--not offical yet
		function _table:copyLineON()
			self:resetACEDOXbools()
			self.tMenuACEDOXcmds.menuIdx = 2
			self.tMenuACEDOXcmds.copyLineON = true
		end
	elseif _target == "editLineON" then		--IN USE
		function _table:editLineON()
			self:resetACEDOXbools()
			self.tMenuACEDOXcmds.menuIdx = 3
			self.tMenuACEDOXcmds.editLineON = true
			--self.tMenuACEDOXcmds.turnedON = true	--EMPOWERING <RETURN> THUS (dt)
		end
	elseif _target == "delLineON" then	--IN USE
		function _table:delLineON()
			self:resetACEDOXbools()
			self.tMenuACEDOXcmds.menuIdx = 4
			self.tMenuACEDOXcmds.delLineON = true
		end
	--elseif _target == "reOrderLineON" then	--not offical yet
		--function _table:reOrderLineON()
			--self:resetACEDOXbools()
			--self.tMenuACEDOXcmds.menuIdx = 5
			--self.tMenuACEDOXcmds.reOrderLineON = true
		--end
	elseif  _target == "delMenusMPointer" then	--not offical yet
		function _table:delMenusMPointer( _menus )
			if self.drawMenuON and _menus >2 then
				if _menus == 11 then --11
					if self.menuPointerIdx == 3 then end
				end
			end
		end
	end
end

function menuListsFLIP( _TRUE )
	if _TRUE then
		tMenu.tMenuPOTT.mLIST = false
	else
		tMenu.tMenuPOTT.mLIST = true
	end
	--	if not tMenu.tMenuObjs.mOBJS or not tMenu.tMenuTWs.mTWS then end
end

function hasValue( _flow, _table )	--HELP MENU LABELING IF NO VALUE FOUND
	if #_table == 0 then
		return ""
	elseif _flow == "text" then	--OR NUMBERS
		return _table
	elseif _flow == "catRmOBJ" then
		return ccatRmObj( _table )
	elseif _flow == "catOnAuOBJ" then
		return ccatAuObj( _table )
	elseif _flow == "catHide" then
		return ccatHidden( _table )
	elseif _flow == "ccat" then
		return ccat( ",", _table )
	elseif _flow == "cCatbb" then
		return cCatbb( ",", _table )
--	elseif _flow == "bool" then
--		if _table then return "TRUE" else return "FALSE" end
	end
end

function mPointerBOOL( _word, _dataBOOL, _sLOCK, _rLOCK )
	if tMenu.tMenuACEDOXcmds.addLineON and not _sLOCK then	--_rLOCK OPTIONS
		tMenu:editLineON()
	elseif tMenu.tMenuACEDOXcmds.editLineON and not _sLOCK then	--"e" SAME AS <ARROWS>
		if _word == "left" or _word == "right" then
			_dataBOOL = boolFLIP( _dataBOOL )
		elseif _word == "return" then
			tMenu:resetACEDOXbools()
		end
	elseif tMenu.tMenuACEDOXcmds.delLineON and not _sLOCK then
		_dataBOOL = false
		tMenu:resetACEDOXbools()		--SET DEFAULT AND MOVING ALONG
	end
	return _dataBOOL
end

function mPointerCount( _char, _word, _dataCount, _sLOCK, _rLOCK )
	if tMenu.tMenuACEDOXcmds.addLineON then
			_dataCount = 0
			_char = ""
			tMenu:editLineON()
		elseif tMenu.tMenuACEDOXcmds.delLineON then
			_dataCount = 0
			_char = ""
			tMenu:resetACEDOXbools()
		elseif tMenu.tMenuACEDOXcmds.editLineON and _word == "down" then	--MATCH MULTI<SEL> MENU FLOW
			if _dataCount > 0 then
				_dataCount = tonumber( _dataCount ) -1
			end
		elseif tMenu.tMenuACEDOXcmds.editLineON and _word == "up" then
			_dataCount = tonumber( _dataCount +1 )
		elseif tMenu.tMenuACEDOXcmds.editLineON and string.match( _char,"%d" )  then
			_dataCount = tonumber( _dataCount .. _char )
		elseif tMenu.tMenuACEDOXcmds.editLineON and _word == "backspace" then
			local _text = tostring( _dataCount )
			if _dataCount >1 then
				_dataCount = string.sub( _dataCount, 1, #tostring(_dataCount) -1 )
				_dataCount = tonumber( _dataCount )
			end
		elseif tMenu.tMenuACEDOXcmds.editLineON and _word == "return" then
			tMenu:resetACEDOXbools()
		end
	return _dataCount, ""
end

function mPointerText( _char, _word,  _dataText, _sLOCK, _rLOCK )	--EDIT CMD BOOL
	if tMenu.tMenuACEDOXcmds.addLineON and not _rLOCK and not _sLOCK then	--_rLOCK OPTIONS
		tMenu:editLineON()
	elseif tMenu.tMenuACEDOXcmds.editLineON  and not _rLOCK and not _sLOCK then	--"e" SAME AS <ARROWS>
		if #_char >0 then
			_dataText = _dataText .. _char
		elseif _word == "backspace" and #_dataText >0 then
			_dataText = string.sub( _dataText, 1, #_dataText -1 )
		elseif _word == "return" then
			tMenu:resetACEDOXbools()
		end
	elseif tMenu.tMenuACEDOXcmds.delLineON  and not _rLOCK and not _sLOCK then
		_dataText = ""
		tMenu:editLineON()
	end
	return _dataText
end

function mPointerExits( _word )	--DIRT .. EXIST-CHOICE
--	if tMap.allRms.bRESET then
	tRetro:updateAllRms() --true )
--	end
	if tMenu.tMenuACEDOXcmds.addLineON and not _rLOCK and not _sLOCK then	--_rLOCK OPTIONS
			tMenu:editLineON()
	elseif tMenu.tMenuACEDOXcmds.editLineON and not _rLOCK and not _sLOCK then	--"e" SAME AS <ARROWS>
		--NEXT BLOCK TO BE BEYOND BOOL AS #IDX SHIFT
		if _word == "down" then
			if tMap.allRms.idx >1 then
				tMap.allRms.idx = tMap.allRms.idx -1
			end
		elseif _word == "up" then
			if tMap.allRms.idx < #tMap.allRms then
				tMap.allRms.idx = tMap.allRms.idx +1
			end
		end
	end
end

function mPointerDirt( _word )		--DIRT .. EXIST-CHOICE
	if tMenu.tMenuACEDOXcmds.addLineON and not _rLOCK and not _sLOCK then	--_rLOCK OPTIONS
		tMenu:editLineON()
	elseif tMenu.tMenuACEDOXcmds.editLineON  and not _rLOCK and not _sLOCK then	--"e" SAME AS <ARROWS>
		if tMenu.tEditLine.bUP then	--DIRT SIDE OF FUTURE EXIST ASSIGNMENT
			--LEFT RIGHT tMenu.tEditLine.idx
			if _word == "down" then
				if tMenu.tEditLine.idx >1 then
					tMenu.tEditLine.idx = tMenu.tEditLine.idx -1
				end
			elseif _word == "up" then
				if tMenu.tEditLine.idx < #tMenu.tEditLine then
					tMenu.tEditLine.idx = tMenu.tEditLine.idx +1
				end
			end
		end
	end
end

function spinTables( _word, _sLOCK, _rLOCK )		--ALL THIS TO WORK AN EXIST POOL
	local _storyRoom = tMap.rms[ tMap.rms.idx ]
	local _tEditLine = tMenu.tEditLine
	--_tRms = tMap.rms
	local _tAllrms = tMap.allRms
	local _anyCMD = tMenu:eccoACEDOXbools()
	local _idX = _storyRoom.rExits.idx
	local _acedox = tMenu.tMenuACEDOXcmds
	if not _anyCMD then						--NO CMDS RUNNING
		--WHAT TABLE ARE WE WORKING WITH WHEN EDIT & RETURN
		if _word == "left" and _storyRoom.rExits.idx > 1 then		--ACTS AS BOOL, UP SCALABLE
			_storyRoom.rExits.idx = _storyRoom.rExits.idx -1
		elseif _word == "right" and _storyRoom.rExits.idx < #_storyRoom.rExits then
			_storyRoom.rExits.idx = _storyRoom.rExits.idx +1
		elseif _word == "return" then									--SELECT THE CURRENT EXIST TO BE CHANGED
			--SPIN WILL NEED TO PROVE CURRENT EXIST INDEX MATCH {DIRT,R#,,...}
			--TAKE EXIST SELECTION, MATCH UP DIRT INDEX AND ROOM IF IT EXISTS
			if #_storyRoom.rExits >0 and isExit( _storyRoom.rExits[ _idX ] ) then
--				local _exit = ""
--				_, _exit = isExit( _storyRoom.rExits[ _idX ] )
--				updateExitIdxs( _exit )
				tMenu:editLineON()
				--_acedox.turnedON = false
			end
		end
	elseif _acedox.delLineON then											--DELETE CMD
		--NEED CODE TO DELETE SELECTED EXIST HERE STILL
		tRetro:updateAllRms()
		tMenu:resetACEDOXbools()
	elseif _acedox.addLineON then											--ADD CMD - CREATE EMPTY VARIABLE IN TARGET TABLE
		table.insert( _storyRoom.rExits, "" )
		_storyRoom.rExits.idx = #_storyRoom.rExits
		--tMap.allRms.bRESET = true
		tRetro:updateAllRms()
		tMenu:editLineON()	--SWITCHING OVER TO EDITING THIS BLANK TABLE
	elseif _acedox.editLineON then										--EDIT CMD
		if _word == "left" and _tEditLine.multi == 2 then		--ACTS AS BOOL, UP SCALABLE
			_tEditLine.multi = 1
		elseif _word == "right" and _tEditLine.multi == 1 then
			_tEditLine.multi = 2
		elseif _word == "up" then
			if _tEditLine.multi == 1 then								--DIRT SELECTION
				if _tEditLine.idx < #_tEditLine then
					_tEditLine.idx = _tEditLine.idx +1
				end
			elseif _tEditLine.multi == 2 then		--ALL-ROOM # SIDE OF FUTURE EXIST ASSIGNMENT
				if _tAllrms.idx < #_tAllrms then
					_tAllrms.idx = _tAllrms.idx +1
				end
			end
		elseif _word == "down" then
			if _tEditLine.multi == 1 then
				if _tEditLine.idx >1 then
					_tEditLine.idx = _tEditLine.idx -1
				end
			elseif _tEditLine.multi == 2 then
				if _tAllrms.idx >1 then
					_tAllrms.idx = _tAllrms.idx -1
				end
			end
		elseif _word == "return" then
			--tRetro:updateAllRms()
			if _tEditLine.idx >0 and _tAllrms.idx >0 then
				_storyRoom.rExits[ _idX ] = _tEditLine[ _tEditLine.idx ] .. string.sub( _tAllrms[ _tAllrms.idx ], 2 )	--REMOVING "R" FROM R#
			else
				table.remove( _storyRoom.rExits, _storyRoom.rExits.idx )
				_storyRoom.rExits.idx = #_storyRoom.rExits
			end
			
			tMenu:resetACEDOXbools()
		end
	end
end

function location11( _word, _char )			--"ROOM-THEATER","PARTS LIST"
	local _storyRoom = tMap.rms[ tMap.rms.idx ]
	local _mPointer = tMenu.menuPointerIdx
	local _acedox = tMenu.tMenuACEDOXcmds
	local _sLOCK = tMap.hDataLOCKED
	local _rLOCK = _storyRoom.rDataLOCKED
	if _mPointer == 3 and _acedox.addLineON and not _rLOCK then		--ADD-ON
		tMap.rms[_rmIdx ].rLabel = ""
		tMenu:editLineON()
	elseif _mPointer == 3 and _acedox.editLineON and not _rLOCK then	--EDIT-ON
		_storyRoom.rLabel = 
		mPointerText( _char, _word, _storyRoom.rLabel, _sLOCK, _rLOCK )
	elseif _mPointer == 3 and _acedox.delLineON and not _rLOCK then		--DELETE-ON
		_storyRoom.rLabel = ""
		tMenu:resetACEDOXbools()
		
	elseif _mPointer == 4 and _acedox.addLineON and not _rLOCK then		--ADD-ON
		_storyRoom.rAuthor = ""
		tMenu:editLineON()
	elseif _mPointer == 4 and _acedox.editLineON and not _rLOCK then	--EDIT-ON
		_storyRoom.rAuthor =
		mPointerText( _char, _word, _storyRoom.rAuthor, _sLOCK, _rLOCK )
	elseif _mPointer == 4 and _acedox.delLineON and not _rLOCK then		--DELETE-ON
		_storyRoom.rAuthor = ""
		tMenu:resetACEDOXbools()
		
	elseif _mPointer == 5 and _acedox.addLineON and not _rLOCK then		--ADD-ON
		_storyRoom.rRoomNum = ""
		tMenu:editLineON()
	elseif _mPointer == 5 and _acedox.editLineON and not _rLOCK then	--EDIT-ON
		if #_char >0 or #_word >0 then
			local _stripedR =  string.sub( _storyRoom.rRoomNum, 2, #_storyRoom.rRoomNum )
			_storyRoom.rRoomNum, _char = 
			mPointerCount( _char, _word, tonumber( _stripedR ), _sLOCK, _rLOCK )
			_storyRoom.rRoomNum = "R" .. _storyRoom.rRoomNum
		end
	elseif _mPointer == 5 and _acedox.delLineON and not _rLOCK then		--DELETE-ON
		_storyRoom.rRoomNum = ""
		tMenu:resetACEDOXbools()
	--local _tSingleRm = tMap.rms[ tMap.rms.idx ]
	elseif _mPointer == 6 and not _rLOCK then		--CHOOSE FROM DIRT LIST & STORY R# TARGET
		local _idX = _storyRoom.rExits.idx
		spinTables( _word, _sLOCK, _rLOCK )
		--UPDATING WHERE SPINTABLES MISSES - NEED LONG FORMAT
		if _acedox.editLineON then
			if _tEditLine.multi ==1 then		--UPDATE CURRENT CHANGES
				_storyRoom.rExits[ _idX ] =
				"<".. tMenu.tEditLine[ tMenu.tEditLine.idx ] ..">"
				.. string.sub( tMap.allRms[ tMap.allRms.idx ], 2, #tMap.allRms[ tMap.allRms.idx ] )
			elseif _tEditLine.multi ==2 then
				_storyRoom.rExits[ _idX ] =
				tMenu.tEditLine[ tMenu.tEditLine.idx ] .."<"
				.. string.sub( tMap.allRms[ tMap.allRms.idx ], 2, #tMap.allRms[ tMap.allRms.idx ] ) ..">"
			end
		end
	
	elseif _mPointer == 7 and not _rLOCK then	--ROOM TIMER - NOT OBJECT TIMER
		_storyRoom.rTimer, _char =
		mPointerCount( _char, _word, _storyRoom.rTimer, _sLOCK, _rLOCK )
		
	elseif _mPointer == 8 and not _rLOCK then
		_storyRoom.rCountDOWN = mPointerBOOL( _word, _storyRoom.rCountDOWN, _sLOCK, _rLOCK )
		
	elseif _mPointer == 9 and not _rLOCK then --	.rLandLayerLock
		_storyRoom.rLandLayerLock, _char =
		mPointerCount( _char, _word, _storyRoom.rLandLayerLock, _sLOCK, _rLOCK )
		
	elseif _mPointer == 10 and not _rLOCK then --	_storyRoom.rEnteredRmNum
		_storyRoom.rEnteredRmNum, _char =
		mPointerCount( _char, _word, _storyRoom.rEnteredRmNum, _sLOCK, _rLOCK )
		
	elseif _mPointer == 11 and not _rLOCK then --	_storyRoom.rMap4D
		_storyRoom.rMap4D.m, _char =
		mPointerCount( _char, _word, _storyRoom.rMap4D.m, _sLOCK, _rLOCK )
		
	elseif _mPointer == 12 and not _sLOCK then		--STORY LOCK CONTROLS ROOM LOCK
		_storyRoom.rDataLOCKED = mPointerBOOL( _word, _storyRoom.rDataLOCKED, _sLOCK, _rLOCK )
	end
end

function location12( _word, _char )			--"ROOM-THEATER","PARTS LIST"
	local _rmIdx = tMap.rms.idx
	local _mPointer = tMenu.menuPointerIdx
	local _acedox = tMenu.tMenuACEDOXcmds
	local _sLOCK = tMap.hDataLOCKED
	local _rLOCK = _storyRoom.rDataLOCKED
	--local _anyCMD = tMenu:eccoACEDOXbools()
	if _mPointer == 3 and _acedox.addLineON and not _rLOCK then
		
	end
end
--HERE WE HAVE TRIPWIRES THAT ARE BUILT INTO THE ROOM - THUS ROOM-THEATER
function location14( _word, _char )			--"ROOM-THEATER","TW-REACTION"
	local _rmIdx = tMap.rms.idx
	local _mPointer = tMenu.menuPointerIdx
	local _acedox = tMenu.tMenuACEDOXcmds
	local _sLOCK = tMap.hDataLOCKED
	local _rLOCK = _storyRoom.rDataLOCKED
	--local _anyCMD = tMenu:eccoACEDOXbools()
	if _mPointer == 3 and _acedox.addLineON and not _rLOCK then
		
	end
end
--HERE WE ARE WORKING ON EITHER IN-ROOM OR ON-AUTHOR PARTS OF SPECIFIC OBJECT(S)
function location2131( _word, _char, _inROOM )				--"IN-ROOM OBJ","PARTS LIST"
	local _storyRoom = tMap.rms[ tMap.rms.idx ]
	local _objs = _storyRoom.rObj			--"ON-AUTHOR","PARTS LIST"
	local _iObj	=	_storyRoom.rObj.idx
	if not _inROOM then
		_objs = tMap.user3rdLeg
		_iObj	=	tMap.user3rdLeg.idx
	end
	local _mPointer = tMenu.menuPointerIdx
	local _acedox = tMenu.tMenuACEDOXcmds
	local _sLOCK = tMap.hDataLOCKED
	local _rLOCK = _storyRoom.rDataLOCKED
	local _anyCMD = tMenu:eccoACEDOXbools()
	if _word == "return" then
		tMenu:resetACEDOXbools()
	elseif _mPointer == 3 and _acedox.addLineON and not _rLOCK then	--delLineON
		--LEFT & RIGHT CHANGE OBJECT
		if _inROOM then
			tRetro:objCrt( "widget", false, 1, "inRM" )
		elseif not _inROOM then
			tRetro:objCrt( "widget", false, 1, "inRM" )
		end
		tMenu:resetACEDOXbools()
		--tMenu:editLineON()
	elseif _mPointer == 3 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].label = mPointerText( _char, _word, _objs[ _iObj ].label, _sLOCK, _rLOCK )
	elseif _mPointer >= 3 and _acedox.delLineON and not _rLOCK then
		if _inROOM and _mPointer -2 <= #_storyRoom.rObj then
			table.remove( _storyRoom.rObj, _storyRoom.rObj.idx )
		elseif not _inROOM and _mPointer -2 <= #tMap.user3rdLeg then
			table.remove( tMap.user3rdLeg, tMap.user3rdLeg.idx )
		end
		tRetro:objIdxChk()
		tMenu:resetACEDOXbools()
	elseif _mPointer == 3 and not _anyCMD and not _rLOCK then
		if _word == "left" and _inROOM and _iObj > 1 then
			_storyRoom.rObj.idx = _storyRoom.rObj.idx -1
		elseif _word == "left" and not _inROOM and _iObj > 1 then
			tMap.user3rdLeg.idx = tMap.user3rdLeg.idx -1
		end
		if _word == "right" and _inROOM and _iObj < #_objs then
			_storyRoom.rObj.idx = _storyRoom.rObj.idx +1
		elseif _word == "right" and not _inROOM and _iObj < #_objs then
			tMap.user3rdLeg.idx = tMap.user3rdLeg.idx +1
		end
	elseif _mPointer == 4 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].count = mPointerCount( _char, _word, _objs[ _iObj ].count, _sLOCK, _rLOCK )
	elseif _mPointer == 4 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].count = 1
		tMenu:resetACEDOXbools()
	elseif _mPointer == 5 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].pkgSize = mPointerCount( _char, _word, _objs[ _iObj ].pkgSize, _sLOCK, _rLOCK )
	elseif _mPointer == 5 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].pkgSize = 0
		tMenu:resetACEDOXbools()
	elseif _mPointer == 6 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].pkgLabel = mPointerText( _char, _word, _objs[ _iObj ].pkgLabel, _sLOCK, _rLOCK )
	elseif _mPointer == 6 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].pkgLabel = ""
		tMenu:resetACEDOXbools()
	elseif _mPointer == 7 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].objHIDDEN = mPointerBOOL( _word, _objs[ _iObj ].objHIDDEN, _sLOCK, _rLOCK )
	elseif _mPointer == 7 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].objHIDDEN = false
		tMenu:resetACEDOXbools()
	elseif _mPointer == 8 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].timer = mPointerCount( _char, _word, _objs[ _iObj ].timer, _sLOCK, _rLOCK )
	elseif _mPointer == 8 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].timer = 0
		tMenu:resetACEDOXbools()
	elseif _mPointer == 9 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].countDOWN = mPointerBOOL( _word, _objs[ _iObj ].countDOWN, _sLOCK, _rLOCK )
	elseif _mPointer == 9 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].countDOWN = false
		tMenu:resetACEDOXbools()
	elseif _mPointer == 10 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].objON = mPointerBOOL( _word, _objs[ _iObj ].objON, _sLOCK, _rLOCK )
	elseif _mPointer == 10 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].objON = false
		tMenu:resetACEDOXbools()
	elseif _mPointer == 11 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].author = mPointerText( _char, _word, _objs[ _iObj ].author, _sLOCK, _rLOCK )
	elseif _mPointer == 11 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].author = tMap.hAuthor			--FALLBACK TO STORY AUTHOR
		tMenu:resetACEDOXbools()
	elseif _mPointer == 12 and _acedox.editLineON and not _rLOCK then
		_objs[ _iObj ].cost = mPointerCount( _char, _word, _objs[ _iObj ].cost, _sLOCK, _rLOCK )
	elseif _mPointer == 12 and _acedox.delLineON and not _rLOCK then
		_objs[ _iObj ].cost = 0
		tMenu:resetACEDOXbools()
	end
end
--AGAIN WE ARE WORKING ON EITHER IN-ROOM OR ON-AUTHOR OBJECTS
function location2232( _word, _char, _inROOM )				--"IN-ROOM OBJ","OBJECTS"
	local _storyRoom = tMap.rms[ tMap.rms.idx ]
	local _objs = _storyRoom.rObj			--"ON-AUTHOR OBJ","OBJECTS"
	local _iObj	=	_storyRoom.rObj.idx
	if not _inROOM then
		_objs = tMap.user3rdLeg
		_iObj	=	tMap.user3rdLeg.idx
	end
	local _mPointer = tMenu.menuPointerIdx
	local _acedox = tMenu.tMenuACEDOXcmds
	local _sLOCK = tMap.hDataLOCKED
	local _rLOCK = _storyRoom.rDataLOCKED
	local _anyCMD = tMenu:eccoACEDOXbools()
	if _mPointer > 2 and ( _word == "return" or _acedox.editLineON ) then
		if _inROOM and _mPointer -2 <= #_storyRoom.rObj then
			_storyRoom.rObj.idx = _mPointer -2
		elseif not _inROOM and _mPointer -2 <= #tMap.user3rdLeg then
			tMap.user3rdLeg.idx = _mPointer -2
		end
		tMenu.menuPointerIdx = 3
		tMenu.tMenuPOTT.menuIdx = 1
		tMenu:resetACEDOXbools()
	elseif _acedox.addLineON and not _rLOCK then 	--_mPointer >= 2 and
		--LEFT & RIGHT CHANGE OBJECT
		if _inROOM then
			tRetro:objCrt( "widget", false, 1, "inRM" )
		elseif not _inROOM then
			tRetro:objCrt( "widget", false, 1, "inRM" )
		end
		tMenu:resetACEDOXbools()
	elseif _mPointer >= 2 and _acedox.delLineON and not _rLOCK then
		if _inROOM and _mPointer -2 <= #_storyRoom.rObj then
			table.remove( _storyRoom.rObj, _storyRoom.rObj.idx )
		elseif not _inROOM and _mPointer -2 <= #tMap.user3rdLeg then
			table.remove( tMap.user3rdLeg, tMap.user3rdLeg.idx )
		end
		tRetro:objIdxChk()
		tMenu:resetACEDOXbools()
	end
end
--NOTE: ONLY WORKING WITH OBJECTS THAT HAVE TRIPWIRES IN THEM
function location2333( _word, _char, _inROOM )				--"IN-ROOM OBJ","TW-ACTION"
	local _storyRoom = tMap.rms[ tMap.rms.idx ]
	local _iObj	=	_storyRoom.rObj.idx	--"ON-AUTHOR OBJ","TW-ACTION"
	local _objs = _storyRoom.rObj
	if not _inROOM then
		_objs = tMap.user3rdLeg
		_iObj	=	tMap.user3rdLeg.idx
	end
	local _iTw = _objs[ _iObj ].tripWire.idx
	local _tw = _objs[ _iObj ].tripWire
	local _mPointer = tMenu.menuPointerIdx
	local _acedox = tMenu.tMenuACEDOXcmds
	local _sLOCK = tMap.hDataLOCKED
	local _rLOCK = _storyRoom.rDataLOCKED
	local _anyCMD = tMenu:eccoACEDOXbools()
	--WE NEED TO BE ABLE TO JUMP FROM ###3 <to> ###4
	if #_objs >0 then
		if not _anyCMD and not _rLOCK then
			if _word == "right" and tMenu.tMenuPOTT.menuIdx == 3 then
				tMenu.tMenuPOTT.menuIdx = 4
			end
		elseif _acedox.addLineON and not _rLOCK then
			
			tMenu:editLineON()
		end
	
	end
	
	--LETS ALLOW FOR ADDING AN OBJECT TO EXIST WHEN NO OBJECTS @ MPOINTER ==2
--	if _acedox.addLineON and not _rLOCK then
--		tRetro:objCrt( "widget", false, 1 )
--		_objs.idx = #_objs
--		tMenu:resetACEDOXbools()
--	elseif _word == "return" and _mPointer >= 2 then
--		if _mPointer -2 <= #_objs then
--			_objs.idx = _mPointer -2		--SYNC POINTER TO HL OBJECT
--			_mPointer = 3								--LETS PLACE THE POINTER TO 1st SELECTION OF NEW MENUS SHIFT
--			tMenu.tMenuPOTT.menuIdx = tMenu.tMenuPOTT.menuIdx -1
--		end
--		tMenu:resetACEDOXbools()
--	elseif _mPointer >= 2 and _acedox.delLineON and not _rLOCK then
--		tRetro:objDel( _objs.label, _objs.count )	--COUNT 0 TAKES OUT THE ENTIRE OBJECT
--	end
end
--NOTE: ONLY WORKING WITH OBJECTS THAT HAVE TRIPWIRES IN THEM
function location2434( _word, _char, _inROOM )				--"IN-ROOM OBJ","TW-REACTION"
	local _storyRoom = tMap.rms[ tMap.rms.idx ]
	local _iObj	=	_storyRoom.rObj.idx	--"ON-AUTHOR OBJ","TW-REACTION"
	local _objs = _storyRoom.rObj
	if not _inROOM then
		_objs = tMap.user3rdLeg
		_iObj	=	tMap.user3rdLeg.idx
	end
	local _iTw = _objs[ _iObj ].tripWire.idx
	local _tw = _objs[ _iObj ].tripWire
	local _mPointer = tMenu.menuPointerIdx
	local _acedox = tMenu.tMenuACEDOXcmds
	local _sLOCK = tMap.hDataLOCKED
	local _rLOCK = _storyRoom.rDataLOCKED
	local _anyCMD = tMenu:eccoACEDOXbools()
	--WE NEED TO BE ABLE TO JUMP FROM ###3 <to> ###4
	if #_objs >0 then
		if not _anyCMD and not _rLOCK then
			if _word == "left" and tMenu.tMenuPOTT.menuIdx == 4 then
				tMenu.tMenuPOTT.menuIdx = 3
			end
		elseif _acedox.addLineON and not _rLOCK then
			
			tMenu:editLineON()
		end
	
	end
end

function location41( _word, _char )				--"STORY","PARTS LIST"
	local _storyRoom = tMap.rms[ tMap.rms.idx ]
	local _rmIdx = tMap.rms.idx
	local _mPointer = tMenu.menuPointerIdx
	local _acedox = tMenu.tMenuACEDOXcmds
	local _sLOCK = tMap.hDataLOCKED
	local _rLOCK = _storyRoom.rDataLOCKED
	if 		 _mPointer == 3 and _acedox.addLineON and not _sLOCK then					--ADD-ON
		newRVnum()						--"a" WITH <ARROWS> WOULD ALLOW US TO LOOK AT ALL RV# CREATED
		tMap.hRVnum = tMap.RVnumsChoice[ tMap.RVnumsChoice.idx ]
		tMenu:resetACEDOXbools()
	elseif _mPointer == 3 and _word == "left" then
		if tMap.RVnumsChoice.idx > 1 then
			tMap.RVnumsChoice.idx = tMap.RVnumsChoice.idx -1
			tMap.hRVnum = tMap.RVnumsChoice[ tMap.RVnumsChoice.idx ]
		else
			if #tMap.RVnumsChoice == 0 then
				tMap.hRVnum = "Type a for Add"
			end
		end
	elseif _mPointer == 3 and _word == "right" then
		if tMap.RVnumsChoice.idx < #tMap.RVnumsChoice then
			tMap.RVnumsChoice.idx = tMap.RVnumsChoice.idx +1
			tMap.hRVnum = tMap.RVnumsChoice[ tMap.RVnumsChoice.idx ]
		else
			if #tMap.RVnumsChoice == 0 then
				tMap.hRVnum = "Type a for Add"
			end
		end
	elseif _mPointer == 3 and _acedox.editLineON and not _sLOCK then				--EDIT-ON
		if #_char >0 then
			tMap.hRVnum = tMap.hRVnum .. string.upper( _char )
		elseif _word == "backspace" and #tMap.hRVnum >0 then
			tMap.hRVnum = string.sub( tMap.hRVnum, 1, #tMap.hRVnum -1 )
		elseif _word == "return" then
			if #tMap.hRVnum > 0 then
				tMenu:resetACEDOXbools()
			elseif tMap.hRVnum == "" then
				table.remove( tMap.RVnumsChoice, tMap.RVnumsChoice.idx )
				if tMap.RVnumsChoice.idx > #tMap.RVnumsChoice then
					tMap.RVnumsChoice.idx = #tMap.RVnumsChoice
				end
				tMenu:resetACEDOXbools()
			end
		end
		tMap.RVnumsChoice[ tMap.RVnumsChoice.idx ] = tMap.hRVnum	--EDIT ALSO UPDATE CHOICES
	elseif _mPointer == 3 and _acedox.delLineON and not _sLOCK then
		if #tMap.RVnumsChoice >0 then --and tMap.RVnumsChoice[ tMap.RVnumsChoice.idx ] then
			table.remove( tMap.RVnumsChoice, tMap.RVnumsChoice.idx )
		end
		if tMap.RVnumsChoice.idx > #tMap.RVnumsChoice then
			tMap.RVnumsChoice.idx = #tMap.RVnumsChoice
		end
		if #tMap.RVnumsChoice > 0 then		--NEW ASSIGNMENT
			tMap.hRVnum = tMap.RVnumsChoice[ tMap.RVnumsChoice.idx ]
		elseif #tMap.RVnumsChoice == 0 then
			tMap.hRVnum = ""
		end
		tMenu:resetACEDOXbools()
		
	elseif _mPointer == 4 and _acedox.delLineON and not _sLOCK then
		tMap.hPlayerStart = tMap.allRms[ 1 ]		--1st ROOM IN MEMORY
		tMenu:resetACEDOXbools()
	elseif _mPointer == 4 and _acedox.editLineON and not _sLOCK then				--EDIT-ON
		--MADE MISTAKE WANTING ALL THE COUNTING AVAILABLE, SHOULD ONLY LIST AVAILABLE R#
		if string.match( _char,"%d" ) then
			tMap.hPlayerStart = tMap.hPlayerStart .. _char
		elseif _word == "backspace" and #tMap.hPlayerStart >1 then
			tMap.hPlayerStart = string.sub( tMap.hPlayerStart, 1, #tMap.hPlayerStart -1 )
		elseif _word == "return" then
			if tMap.hPlayerStart == "R" then		--FALLBACK FOR LACKING NUMBER WITH EDIT
				tMap.hPlayerStart = tMap.allRms[ tMap.allRms.idx ]
			end
			tMenu:resetACEDOXbools()
		end
	elseif _mPointer == 4 and not _sLOCK then		--CHOOSE STARTING ROOM OF ROOMS
		--FIND OUT IF STARTING ROOM EXISTS IN STORY YET
		if tMap.allRms.idx == 0 and #tMap.allRms >0 then
			for i=1, #tMap.rms do	--UPDATE INDEX
				if tMap.hPlayerStart == tMap.allRms[ tMap.allRms.idx ] then
					tMap.allRms.idx = i
				end
			end
		end
		if _word == "left" then
			if tMap.allRms.idx >1 then		--DON'T SHAVE OFF THE "R" IN R#
				tMap.allRms.idx = tMap.allRms.idx -1
				tMap.hPlayerStart = tMap.allRms[ tMap.allRms.idx ]
			end
		elseif _word == "right" then
			if tMap.allRms.idx < #tMap.allRms then
				tMap.allRms.idx = tMap.allRms.idx +1
				tMap.hPlayerStart = tMap.allRms[ tMap.allRms.idx ]
			end
		end
		
	elseif _mPointer == 5 and _acedox.addLineON and not _sLOCK then	--ADD CUSTOM CMD
		runCmdCmd( { nil, "ccmd","" } )
		tMenu:editLineON()
	elseif _mPointer == 5 and _acedox.editLineON and not _sLOCK then	--EDIT CUSTOM CMD
		if _word == "return" then
			--MAKE SURE WE DON'T HAVE NEW "" CMD IN CUSTOM CMDS
			_ = runCCmdChk( true )	--true MEANS CLEAN OUT THE ""
			tMenu:resetACEDOXbools()
		elseif _word == "backspace" then
			if #tMap.hCCmds[ tMap.hCCmds.idx ] >0 then	--MUST BE 1 CHAR TO DELETE
				tMap.hCCmds[ tMap.hCCmds.idx ] = 
				string.sub( tMap.hCCmds[ tMap.hCCmds.idx ], 1, #tMap.hCCmds[ tMap.hCCmds.idx ] -1 )
			end
		elseif #_char >0 then
			tMap.hCCmds[ tMap.hCCmds.idx ] = tMap.hCCmds[ tMap.hCCmds.idx ] .. _char
		end
	elseif _mPointer == 5 and _word == "left" then
		if tMap.hCCmds.idx > 1 then
			tMap.hCCmds.idx = tMap.hCCmds.idx -1
		end
	elseif _mPointer == 5 and _word == "right" then
		if tMap.hCCmds.idx < #tMap.hCCmds then
			tMap.hCCmds.idx = tMap.hCCmds.idx +1
		end
	elseif _mPointer == 5 and _acedox.delLineON then
		table.remove( tMap.hCCmds, tMap.hCCmds.idx )
		if tMap.hCCmds.idx > #tMap.hCCmds then
			tMap.hCCmds.idx = #tMap.hCCmds
		end
		tMenu:resetACEDOXbools()
	
	elseif _mPointer == 6	and _acedox.delLineON and not _sLOCK then
		tMap.level = 1000
		tMenu:resetACEDOXbools()
	elseif _mPointer == 6	and _acedox.addLineON and not _sLOCK then
		tMenu:editLineON()
	elseif _mPointer == 6	and _acedox.editLineON and not _sLOCK then
		if _mPointer == 6 and _word == "down" then
			if tMap.level > 100 then
				tMap.level = tMap.level /10
			end
		elseif _mPointer == 6 and _word == "up" then
			if tMap.level < 10000 then
				tMap.level = tMap.level *10
			end
		end
		if _word == "return" then
			tMenu:resetACEDOXbools()
		end
		
	elseif _mPointer == 7	and _acedox.delLineON then
		tMap.hDataLOCKED = false
		tMenu:resetACEDOXbools()
	elseif _mPointer == 7	and _acedox.editLineON and not _sLOCK then
		--THIS IS WHERE ONCE THE STORY IS LOCKED - CAN'T BE CHANGED WITHOUT FILE ALTERATION
		tMap.hDataLOCKED = mPointerBOOL( _word, tMap.hDataLOCKED, _sLOCK, _rLOCK )
		--if _word == "return" then
		tMenu:resetACEDOXbools()
		--end
	end
end