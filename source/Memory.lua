    --[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
function fPortHoleInject( _table, _target )
  if _target == "setGUIvars" then    --tPortHole
    function _table:setGUIvars()     	--PYTHON PROGRAM HAD COLOURS
			self.red = {.75,0,0}				--BM: NOT SAVED
			self.purple = {78/255,5/255,80/255} --{67/255,5/255,65/255,1}
			self.pink = {.9,0,.5}
			self.orange = {.9,.5,0}  		--BM: NORMAL ROOM BUILD
			self.yellow = {.8,.8,0}   	--CHOICES AND INFORMATION ABOUT STORY FOR USER -BM: SINGLE ROOM
			self.skyblue = {.33,.65,1}
			self.blue = {0,0,.9,}     	--ALL CAPS TEXT VARIABLE PLACE HOLDERS
			self.white = {.8,.8,.8}    	--MENUS & OBJECT DATA
			self.green = {0,.8,0}    		--BM: PLAY MODE
      self.brown = {178/255,113/255,61/255}
      self.black = {0,0,0}
      self.W = love.graphics.getWidth()
      self.H = love.graphics.getHeight()
      self.boarder = 1	--math.floor( self.W *.005 ) --5% BOARDER AROUND WHAT EVER FULL-SCREEN IS
			self.xbdr = self.boarder *8		--BOARDER PADDING
			self.ybdr = self.boarder *6		--BOARDER PADDING
      self.bdrW = math.floor( self.W -( self.boarder *2 ) )   --BOARDER RECTANGLE WIDTH     --WAS 2
      self.bdrH = math.floor( self.H -( self.boarder *2 ) )   --BOARDER RECTANGLE HEIGHT    --WAS 2
      self.xColumn = math.floor( self.bdrW /6 )
      self.fontPixSize = 16
			self.yPad = 16 /7
			self.BBON = false							--AUTOMATION AFTER DEAD-TYPIST DONE IT'S JOB
      self.buildMode = 6  					--BOARDER COLOUR WINDOW NOW 1-7
			self.cmdForcast = {}					--CONTAINER FOR ALL MATCHING CMDS TO CHAR <TAB><TAB>
			self.eccoDisplayBuff = { GO = false, firstLine = 0, lastLine = 0 }	--objUNTAKE = false, 		--BUFFER UP PER-TURN OF USER FEEDBACK FROM TW ETC...
			self.eccoDisplayRndComm = { trigger = "NONE", RND = false, idx = 0 }
			-- *** RETRO-TERMINAL NOW GOING BACK TO INLINE DRAW CHANGES ***
			self.drawMENU = false
			self.x = 0
			self.y = 0
			self.xC = self.xbdr
			self.yL = self.ybdr
			self.xC2 = self.bdrW - self.xColumn - self.xbdr
			--self.textFont = love.graphics.newFont( 'fonts/DejaVuSans.ttf', tPortHole.fontPixSize )
			self.textFont = love.graphics.newFont( 'fonts/DejaVuSans-Bold.ttf', tPortHole.fontPixSize )
			love.graphics.setFont( self.textFont )
			self.ghosts = {}
		end
	elseif _target == "bb" then
		function _table:bb()
			if self.BBON then	--ON >> OFF
				self.BBON = false
				runAllRmLIVE( true )
				self.buildMode = 7	--PLAY-MODE
				removeDeadCount()		-- *** REMOVE OBJS.count == 0 FROM TABLES ***
				addGhostTW()				-- *** GHOSTS ARE BACK AGAIN ***
				tMap:ticToc( true, "00:00:00:0" )--RESET THE ROOM TIME TO ZEROS
			else							--OFF >> ON
				self.BBON = true
				runAllRmLIVE( false )
				self.buildMode = 6	--BUILDING-MODE NEW FALLBACK TO WHITE AS ALL DONE
			end
		end
	elseif _target == "updateBdrColour" then		--PER-SECOND ROTATION UPDATE
		function _table:updateBdrColour( tbl )		--tMap.cmdsKeyLog
			--{ BB, SPLAYSTART, MAPLOCK, EVENT, RV, --AU, RMLEVEL }
			if self.BBON then
				--ROTATE UP THE POSSIBLE BUILD MODE COLOUR CODE
				self.buildMode = self.buildMode +1
				if self.buildMode >= 6 then self.buildMode = 1 end	--RESET FROM WHITE TO RED
				--MAKE SURE NEW COLOUR MODE ISN'T ALREADY SOLVED - ONLY 1 CHOICE PER-SECOND
--				if tbl.BB and self.buildMode == 1 then self.buildMode = self.buildMode +1
--				elseif tbl.SPLAYSTART and self.buildMode == 2 then self.buildMode = self.buildMode +1
--				elseif tbl.MAPLOCK and self.buildMode == 3 then self.buildMode = self.buildMode +1
--				elseif tbl.EVENT and self.buildMode == 4 then self.buildMode = self.buildMode +1
--				elseif tbl.RV and self.buildMode == 5 then self.buildMode = self.buildMode +1
--				end
			else
				self.buildMode = 7
			end
		end
	elseif _target == "runRndCommPicker" then
		function _table:runRndCommPicker()
			local _rnd = 0
			for i =1, #tPortHole.eccoDisplayRndComm do
				if tPortHole.eccoDisplayRndComm.trigger == tPortHole.eccoDisplayRndComm[ i ][1] then
					_rnd = math.random( 2, #tPortHole.eccoDisplayRndComm[ i ] )
					table.insert( tPortHole.eccoDisplayBuff,1, tPortHole.eccoDisplayRndComm[ i ][ _rnd ])
					self.eccoDisplayRndComm.RND = false
					--return true
				end
			end
			self.eccoDisplayRndComm.RND = false
			--return false
		end
	end
end

function funcMapInject( _table, _target )		--{ tMap }
	if _target == "setStoryMap" then	-- *** PARENT STORY CONTAINER ***
    function _table:setStoryMap()   --tMap:reset()
			--KEYBOARD
      self.tabTAB = false			--GOT TO HAVE THAT *NIX CMD COMPLETION TERMINAL FEEL
      self.plusED = false			--HELPING DEAL WITH +# OR +CHAR SCREWUPS BETWEEN THE KEYBOARD & CHAIR
			self.plusED2 = false
			--FILE SYSTEM
			self.eventsA = { idx = 0 } 			--POPULATE FROM AUTHORS STORIES
			self.eventsB = { idx = 0 } 			--tMenu.menuPointerIdx WITH drawListEvents()
      self.authors = { idxA = 0, idxB = 0 } --POPULATE FROM AUTHORS DIRECTORY
			--self.sounds = {}				--PER-MAP USEFUL FOR USER <TAB><TAB> HELP LATER ON
			--self.images = {}				--PER-MAP
			--self.videos = {}				--PER-MAP
			self.fileName = ""			--HAS FILE EXTENTION
			--TIMING
			self.rmDeltaTime = 0
			self.oneSEC = false			--ALLOW OUR BOARDER COLOURS TO CHANGE COLOUR PER-SECOND
			self.oneTenthSEC = false
			--MAP
			self.same = { CMD = false }	--{ {},{},{} }
			--self.typeDeadFast = { avg = .1 -.02, perLINE = false, idx =0, perLineSTOP = false }		--CURRENT SYSTEM PER-SECOND CLOSER SHAVE
			self.rmNOEXITS = false
			--self.tw = {}		--TYPED >> TW CMD STRUCTURE FOR USER WITHIN STORY - REMOVED NEST			
      self.masterFileName = "Master File"
			self.auLeg = { idx = 0, label = "ROOT-2046YellowEyeBowl" }	--was .hPlayerCarry
			self.oMoveRm = 0		--STORE THE ROOM WHERE TW IS WORKING FROM
		end
	elseif _target == "setNewMap" then
		function _table:setNewMap( _author, _fileName )		--ALL MEMORY BEST BE IN PLACE BEFORE WE RUN THIS!
			self.rms = { idx =1, mIdx =0, label = "ROOT-2046YellowEyeBowl" }
			self.hLevel = 1000					--PER-FLOOR PLACE HOLDER
			self.keyLogDROPIT = false		--tMap.keyLogDROPIT
			--self.cmdsKeyLog = { BB = false, SPLAYSTART = false, MAPLOCK = false, 
				--EVENT = false, RV = false, AU = false, RMLEVEL = false } --PSTART
			self.deadTYPIST = false		--DEAD-TYPIST TOOLBOX
			self.hDeadTypist = { idx =1, iChar =1 }	--NOT RE-TYPING ALL THESE SEPERATE PREP FOR TESTING, SHOULD HAVE DONE THIS YEARS AGO
			self.hDataLOCKED = false		--IF TURNS ON THEN OFF WE SHOULD CREATE A COPY OF OLD FILE../wDATE OR VERSION
			self.hAuthor = _author or ""
			self.hRVnum = ""						--DOESN'T GET CREATED ON NEXT LINE RETURN! THUS NIL
			self.hEventName, self.hRVnum = isFileNameRV( _fileName ) or isFileNameRV( self.fileName )
			if not self.hRVnum then self.hRVnum = "" end	--STILL NEED THIS WORK AROUND! STRANGE...
			self.hPlayerStart = "0"				--NOW JUST ROOM MAP INDEX - FASTER & SIMPLER
			self.tKeyLogHistory = { idx = 0, bUP = false }	--CMD LINE HISTORY AS EXPECTED TO LIMITED DEGREE
			self.keylog = ""    				--TEMP STORAGE FOR USER KEYSTROKES
			self.eventsB = { idx = 0 }	--tMenu.menuPointerIdx WITH drawListEvents()
			self.RVnums = { idx = 0, choices = {} }		--SIDELINE STORAGE OF GENERATED #s
		end
	elseif _target == "ticToc" then
    function _table:ticToc( _reSET, _setTime )
			--os.date('%H:%M:%S')	--ONLY NEED TO ADD THE FRACTION OF A SECOND AND WE ARE ON TRACK
			if _reSET then
				self.rmFraction = 0			--tMap.rmFraction
				self.rmSeconds = 0			--tMap.rmSeconds
				self.rmMinutes = 0			--tMap.rmMinutes
				self.rmHours = 0				--tMap.rmHours
			elseif _setTime then
				local _SUCCESS, _hour, _min, _sec, _dec = isTime( _setTime )
				if _SUCCESS then
					self.rmHours = _hour
					self.rmMinutes = _min
					self.rmSeconds = _sec
					self.rmFraction = _dec
				end
			else	--COUNTING 1/10th OF A SECOND AT A TIME
				if self.rmHours == 23 and self.rmMinutes == 59 and self.rmSeconds == 59 and self.rmFraction == 9 then
					self.rmFraction = 0
					self.rmSeconds = 0
					self.rmMinutes = 0 			--math.floor( tMap.roomTime/60 )
					self.rmHours = 0
				elseif self.rmMinutes == 59 and self.rmSeconds == 59 and self.rmFraction == 9 then
					self.rmFraction = 0
					self.rmSeconds = 0
					self.rmMinutes = 0 			--math.floor( tMap.roomTime/60 )
					self.rmHours = self.rmHours +1
				elseif self.rmSeconds == 59 and self.rmFraction == 9 then
					self.rmFraction = 0
					self.rmSeconds = 0
					self.rmMinutes = self.rmMinutes +1 --math.floor( tMap.roomTime/60 )
				elseif self.rmFraction == 9 then
					self.rmFraction = 0
					self.rmSeconds = self.rmSeconds +1
					self.oneSEC = true
				else
					self.rmFraction = self.rmFraction +1
				end
			end
		end
	elseif _target == "objlistOPENED" then
		--ROTATE THROUGH ALL OPENED-OBJS FOR BUFFER DISPLAY .. \n or [[ ]] for multi \n
		function _table:objlistOPENED()
			local _line = ""
			if #self.rms[ self.rms.idx ].rObj > 0 then
				for a =1, #self.rms[ self.rms.idx ].rObj do
					if self.rms[ self.rms.idx ].rObj[ a ].objOPENED and self.rms[ self.rms.idx ].rObj[ a ].displayOPENED then
						_line = "(".. self.rms[ self.rms.idx ].rObj[ a ].count ..")".. self.rms[ self.rms.idx ].rObj[ a ].label .." <OPENED>: "--\n"
						if #self.rms[ self.rms.idx ].rObj[ a ].oBag >0 then
							for b =1, #self.rms[ self.rms.idx ].rObj[ a ].oBag do
								_line = _line .."(".. tostring( self.rms[ self.rms.idx ].rObj[ a ].oBag[b].count ) ..")"
								if b < #self.rms[ self.rms.idx ].rObj[ a ].oBag then
									_line = _line .. tostring( self.rms[ self.rms.idx ].rObj[ a ].oBag[b].label ) ..", "--\n"
								elseif b == #self.rms[ self.rms.idx ].rObj[ a ].oBag then
									_line = _line .. tostring( self.rms[ self.rms.idx ].rObj[ a ].oBag[b].label ) .."\n"
								end
							end
						else
							_line = _line .."\n"
						end
						table.insert( tPortHole.eccoDisplayBuff, _line )
						tPortHole.eccoDisplayBuff.GO = true
						--return _line
					end
				end
				tPortHole.eccoDisplayBuff.GO = false
			end
		end
	end
end

function funcInject( _table, _target )	--{ tRetro }
	if _target == "setPlayCmds" then
		function _table:setPlayCmds()
			--ADD THE CUSTOM CMDS THAT ARE PLAYING COMMANDS - KEEP COPY SEPERATE FOR EASY SAVING TO FILE
      self.playCmds = { idx =0,"take","place","drop","eat","drink","consume",
			"on","off","open","close","help","unpack","pack",
			"fill","empty",					--PLACE OBJ INSIDE OBJ
			"bb",--"press","push","pull", --"increase","decrease",
			"look","read","playerstart",
			"sit","stand","enter","touch",
			"defend","attack",
			"load"	--"load TwinGears@gmail.com filename r#"
				--"d4","d6","d8","d10","d12","d20", DICE ROLLING CAN'T USE "D" AS IN DOWN
				} --"say","all" 
		end
	elseif _target == "setBuildCmds" then
		function _table:setBuildCmds()
			--SEPERATING BUILD COMMANDS FROM PLAYING COMMANDS
      self.buildCmds = { idx =0,
			"clrtxt","cleartext",		--CLEAN THE TEXT TO USE AREA
			"author",
			"setplayerstart",
			"delrm",			--DELETE ROOM
			"rvnum","+rvnum",
			"maplock",							--ONLY CASE SENSITIVE CMD THUS AGAIN SHOWS INTENTION TO LOCK
			"maplabel",
			--"menu",--"mobj","mtw","mroom",	-- *** MENUS: OBJECTS, TRIPWIRE, ROOMS ***
			"rmlevel",
			"rmnum",								--RE-ASSIGN R# VALUE /w noexits loops, STITCH INTO MAP FROM CHANGED R# VIEWPOINT
			"rmlabel",
			"olabel",
			"omove",								--GIVE TWs THE ABILITY TO HAVE ROOM OBJS MOVE ROOMS ETC
			"rename",
			"save",									--LOAD SHOULD BE PLAY CMD
			"+m","-m",							--CREATE A PARALLEL ROOM OF TARGET/LOCAL ROOM
			"map","mxyz",						--map # # # #
			"noexits",							--IN-LINE WITH OTHER CMDS OR GLOBAL BOOL?
			"+exits",								--
			"-exits","delexits",							--DELETE EXIT
			"+","create",	--"in",		--CREATE IN-ROOM
			"++","+create",					--CREATE OBJECT ON-AUTHOR
			"untake","notake",  		--CREATE IN-ROOM OBJECT THAT CAN'T BE TAKEN
			"unhide", "hide",
			"-","del","delete",  		--del cc smoke; del obj obj ;del r100 r101; del n; del nn; del nnn
			"playsound",
			"cleanmapexits",
			"rtw","+rtw",						--+rtw R# R# OR ALL IN MAP BY DEFAULT
			"+tw","++tw",						--TW ADDITION IN-ROOM & ON-AUTHOR
			"-tw","-rtw",						--MATCH 2 SAME TW ACTIONS AND TARGET TO DELETE WITH OBJECT KEY
			"repeat",
			"unlock","lock",				--TOGGLE THE BOOL OF ROOM OR OBJECTS
			"ccmd",               	--ADD CUSTOM COMMANDS
			"samecmd",							--WE NEED TO GROUP CMD TOGETHER, REDUCE TW DUPLICATES
			"comm",--"true",				--CMD FOR COMMENTS TO BE ADDED AFTER "TW"
			"room",					--WHY?
			"copy","clone","paste",	--ROOM & OBJ TO BE STORED
			"join",									--R#... OR LL #...
			"timer",--"duration",
			"health",
			"ll"					--LANDLAYERLOCK =#
			--"resetRoomTimer"	--DEAD-TYPIST "rtw timer 00:20:00:0 TW timer 00:00:00:0"
				--"-rm"		--ALREADY HAVE A DELETE THAT DOES ALL!?
				--"from","with","of","into"	--MOVED FROM CCMD TO PLAY CMD
				--"--","-del","-delete",	--del N# AS ROOM EXIST
				--"echo",									--SHORTER THAN COMMENT
				--"groupRND",--"rndtrue","rndfalse",
				--NONE OBJ CMDS LEFT IN BUILD CMDS
				--"live","liveon","storyliveon","storylive","reset",
				--"liveoff","storyliveoff", --bb MODE IN PLAY LIKELY SO NO ACCESS TO THESE CMDS
				--"rmliveon","rmlive","rmliveoff",
			}
		end
	elseif _target == "setCustomCmds" then
		function _table:setCustomCmds()
			self.hCCmds = { idx = 0 }		--CUSTOM COMMANDS LOADED FROM FILE STORY HEADER
		end
		-- *** ROOM CHANGES ***
  elseif _target == "rmCreate" then
    function _table:rmCreate( _labelLastLoction, _rNum, _map4D, _exit )
			--FORWARDING OUR EXIT INTO CREATION OF ROOM NOW...
			local _tbl = { --rmNOWtime = false --@ tMap.rms.rNOWtime
      rAuthor = self.hAuthor,
      rRoomNum = _rNum,     --DEFAULT R1 meaning ground level
      rMap4D = _map4D,
      rLabel = _labelLastLoction or "NEW-ROOM",
      rExits = { idx = 0 }, --IDX CAN HELP DRAW WHERE WE HAVE BEEN AS A PLAYER
			--NON JUMP-IN WOULD TRIGGER THE IDX UPON ENTERING ROOM IF MIRROR EXISTS FROM PATH BACK
      --rStory = {},
      rObj = { idx = 0, label = "ROOT-2046YellowEyeBowl" },
			rHIDDEN = false,			--JUST LIKE OBJECT, ROOM CAN'T BE DELETED _hideGLUE
      --rObjHidden = {},
			rLandLayer = 1,				--WILL ALLOW MAP PATTERN CLONING OF LAYERS 
			rCountDOWN = false,		--COUNT DOWN OR UP
			rON = false,
			rLOCKED = false,
			rOPENED = false,
			--PER-ROOM TRIGGER +dt == .rTimer
			rTimer = 0,						--MATCH IN ALL ROOM dt +tMap.roomTime
			--rTWtimerLIVE = false,
			rTWrmLIVE = false,
			rEnteredRmTWnum = 1,		--AS IN SETTING FOR ROOM
			rEnteredRmCount = 0,
			rDataLOCKED = false, 		--THIS ROOM CAN'T BE CHANGED
			--rComments = {},
      rTripWire = { idx =0 }, --RUN-ONCE THEATER ROOM TRIPWIRES ETC  rNOWtime = true,
			rHealth = 4000,
			rHz = 1600,							--HOW DO BUGS WORK IN 1600Hz ENVIRONMENT
			--rImage = "",						--IMAGE SOUND & VIDEO
			--rSound = "",						--ALL NOW INSIDE THE EVENT FOLDER/DIRECTORY
			--rVideo = "",
			ONBOARD = false					--ITEM WITHIN A CONTAINER
			}
			if _exit then
				table.insert( _tbl.rExits, _exit )
			end
      table.insert( tMap.rms, _tbl )
    end
	elseif _target == "rmNumEXISTS" then
    function _table:rmNumEXISTS( _rmNum ) --, _dirt )
			for i =1, #tMap.rms do --rRoomNum
				if _rmNum == tMap.rms[ i ].rRoomNum then
					return true, i, tMap.rms[ i ].rMap4D	--, string.match( _rmNum,"-%d+" ) or string.match( _rmNum,"%d+" )
				end
			end
			return false, nil		--, nil
		end
	elseif _target == "rmDel" then --NOT JUST DELETE LIST OF ROOMS
		function _table:rmDel( _rNum )
			local _currentRmNum = tMap.rms[ tMap.rms.idx ].rRoomNum
			local _EXISTS
			local _GO = true
			local _idx = 1
			while _GO do
				if _rNum == tMap.rms[ _idx ].rRoomNum then
					table.remove( tMap.rms, _idx )
					_idx = 1
				else
					_idx = _idx +1
				end
				if _idx == #tMap.rms then
					break
					--_GO = false
				end
			end
			_EXISTS,_,_, _idx = isRmInSTORY( _currentRmNum )
			--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
			if _EXISTS then
				tMap.rms.idx = _idx
			else
				tMap.rms.idx = #tMap.rms
			end
		end
	elseif _target == "rmAddExit" then --NOT JUST DELETE LIST OF ROOMS
    function _table:rmAddExit( _tblOldExits, _exit )
			local _FOUND = false
			for a = 1, #_tblOldExits do
				if _tblOldExits[ a ] == _exit then
					_FOUND = true
				end
			end
			if not _FOUND then
				table.insert( _tblOldExits, _exit )
			end
			return _tblOldExits
		end
	elseif _target == "rmDelExit" then --NOT JUST DELETE LIST OF ROOMS
    function _table:rmDelExit( _tblOldExits, _exit )
			for a = 1, #_tblOldExits do
				if _tblOldExits[ a ] == _exit then
					table.remove( _tblOldExits.rExits, a )
					return true
				end
			end
			return _tblOldExits
		end
			--elseif _target == "rmZeroRndNearist" then --RESET NEAREST IF NO 0,0,0,0 EXISTS...
				--function _table:rmZeroRndNearist( _tbl )
		--			local _FOUND = false
		--			while not _FOUND do
		--				for i =1, #tMap.rms do --rRoomNum
		--					if _rmNum == tMap.rms[ i ].rRoomNum then
		--						--return true, i, tMap.rms[ i ].rMap4D	--, string.match( _rmNum,"-%d+" ) or string.match( _rmNum,"%d+" )
		--					end
		--				end
		--			return false, nil		--, nil
				--end
	elseif _target == "rmlabel" then
		function _table:rmlabel( _location, _label )
			if _location == "rm" then
				tMap.rms[ tMap.rms.idx ].rLabel = _label
				return true
			end
			return false
		end
	elseif _target == "nextRoomMap4D" then
    function _table:nextRoomMap4D( _map4D, _m, _N,_S,_W,_E,_D,_U )--, _rmExitNum )
			local _EXISTS, _rmIdx, _rRoomNum = false, nil, nil
			_map4D = self:tblClone( _map4D )
			if _N then _map4D.x = _map4D.x +1 end
			if _S then _map4D.x = _map4D.x -1 end
			if _E then _map4D.y = _map4D.y +1 end
			if _W then _map4D.y = _map4D.y -1 end
			if _U then _map4D.z = _map4D.z +1 end
			if _D then _map4D.z = _map4D.z -1 end
			if _m then _map4D.m = _map4D.m + _m end		--MIGHT AS WELL ALLOW FOR IT TO BE A NUMBER CHANGE
			_EXISTS, _rmIdx, _rRoomNum = isMXYZinSTORY( _map4D )
			return _EXISTS, _map4D, _rmIdx, _rRoomNum
		end
	elseif _target == "nextRoomNum" then
    function _table:nextRoomNum( _rmNum,_map4D,_m,_N,_S,_W,_E,_D,_U )	--EXIT CHECK AGAINST MXYZ
			local _rmEXISTS = false						--map4D COMES IN CLONED ALREADY
			local _mapEXISTS = false
			local _rmIdxD = nil
			local _rmIdxM = nil
			local _mapRmNum = nil
			local _nextRmNum = nil
			_rmNum = string.match( _rmNum, "-%d+" ) or string.match( _rmNum, "%d+" ) or nil
			--UPDATE THE MAP4D POSITIONING
			if _m ~= 0 or _map4D then					--BUMP +M
				if _m ~= 0 and _map4D then			--NEED MAP4D TO GO WITH THIS
					_mapEXISTS, _map4D, _rmIdxM, _mapRmNum = self:nextRoomMap4D( _map4D, _m,_N,_S,_W,_E,_D,_U )--, _rmExitNum )
				elseif _map4D then
					_mapEXISTS, _map4D, _rmIdxM, _mapRmNum = self:nextRoomMap4D( _map4D, 0,_N,_S,_W,_E,_D,_U )--, _rmExitNum )		--EXIT CHECK AGAINST MXYZ
				end
			end
			--ADJUST THE ROOM NUMBER
			if _rmNum then	--and _dirt 
				_rmNum = tonumber( _rmNum )
				if _D and _rmNum > 0 and _rmNum < tMap.hLevel then
					_rmNum = -( _rmNum +tMap.hLevel )
				elseif _D then
					_rmNum = _rmNum -tMap.hLevel
				elseif _U then
					_rmNum = _rmNum +tMap.hLevel
				end
				if _rmNum == 0 then _rmNum = 1 end
				for a =1, #tMap.rms do
					if tMap.rms[ a ].rRoomNum == "R".. _rmNum then
						if _rmNum < 0 then _rmNum = _rmNum -1 end
						if _rmNum > 0 then _rmNum = _rmNum +1 end
					end
				end
			end
			if _mapEXISTS then										--MAP DATA LEADS 1st AS NEXTROOM!
				return _mapEXISTS, string.match( _mapRmNum, "-%d+" ) or string.match( _mapRmNum, "%d+" ), _map4D, _rmIdxM
			else																	--NEXT DATA RETURN
				return _mapEXISTS, tostring( _rmNum ), _map4D, _rmIdxM
			end
    end
	elseif _target == "switchRoom" then
		function _table:switchRoom( _map4D )
			local _rmInSTORY, _idx,_= isMXYZinSTORY( _map4D )
			if _rmInSTORY and not tMap.rms[ _idx ].rLOCKED then
				tMap.rms.idx = _idx		-- *** WE HAVE ENTERED THE ROOM +1 ***
				tMap.rms[ _idx ].rEnteredRmCount = plusOne( tMap.rms[ _idx ].rEnteredRmCount )
				tMap:ticToc( true, "00:00:00:0" )
				tPortHole.eccoDisplayBuff.GO = true
				return true
			end
			return false
		end
	elseif _target == "valPlus" then
		function _table:valPlus( _val, _count )
			return _val + _count
		end
	elseif _target == "tblAvg" then
		function _table:tblAvg( _tbl )
			local _add = 0
			if #_tbl > 1 then
				for x =1, #_tbl do
					_add = _add + _tbl[ x ]
				end
				return _add / #_tbl
			end
		end
	elseif _target == "tblClone" then
		function _table:tblClone( _tbl )	--GOOGLE AI HELP, ONLY BLOCK OF CODE THAT'S NOT ME!
			if type( _tbl ) ~= 'table' then
				return _tbl
			end
			local copy = {}
			for k, v in pairs( _tbl ) do
				copy[k] = self:tblClone(v)
			end
			return copy
		end
	elseif _target == "tblMapCompare" then	--{}=={}
		function _table:tblMapCompare( _tblA, _tblB )
			if _tblA.m == _tblB.m and _tblA.x == _tblB.x and _tblA.y == _tblB.y and _tblA.z == _tblB.z then
				return true
			else
				return false
			end
		end
	-- *** OBJECT TRACKING - 1st DOES OBJ EXIST IN EITHER LOCATION? ***
	elseif _target == "objRmEXISTS" then		--OBJECT IN THE ROOM?
		function _table:objRmEXISTS( _objB,_objA, _rmIdx )	--OBJA fridge, Egg in Eggs, cookie in Cookies match
			if not _rmIdx then _rmIdx = tMap.rms.idx end
			if _objA == nil then
				_objA = "" --end
			--if #tMap.rms[ tMap.rms.idx ].rObj >0 then
				if #_objA == 0 and #_objB >0 then	--ONLY LOOKING FOR B-OBJ, THEIR IS NO A
					for _iB =1, #tMap.rms[ _rmIdx ].rObj do
						if ( tMap.rms[ _rmIdx ].rObj[ _iB ].label == _objB
						or tMap.rms[ _rmIdx ].rObj[ _iB ].label == _objB .. "s" ) then
							--return false, 0, "", false, _iA, tMap.auLeg[ _iA ].label	--B RETURNS ON B RAIL
							return true, _iB, tMap.rms[ _rmIdx ].rObj[ _iB ].label, false,0,""	--B RETURNS ON OBJ-A RAILWAY, A CHEAT FOR OLD CODE
						end
					end
				end
			else
				if #_objB >0 then	--A AND B MUST EXIST LOOP	-- #_objA > 0 and
					for _iA =1, #tMap.rms[ _rmIdx ].rObj do
						if #tMap.rms[ _rmIdx ].rObj[ _iA ].oBag >0 then
							for _iB =1, #tMap.rms[ _rmIdx ].rObj[ _iA ].oBag do
								if ( tMap.rms[ _rmIdx ].rObj[ _iA ].label == _objA 										--A LOCKIN
								or tMap.rms[ _rmIdx ].rObj[ _iA ].label == _objA .."s" )
								and ( tMap.rms[ _rmIdx ].rObj[ _iA ].oBag[ _iB ].label == _objB .."s"	--B LOCKIN
								or tMap.rms[ _rmIdx ].rObj[ _iA ].oBag[ _iB ].label == _objB ) then
								--_objA = tMap.auLeg[ _iA ].label	--MISSING DATA FOUND
									return true, _iB, tMap.rms[ _rmIdx ].rObj[ _iA ].oBag[ _iB ].label, true, _iA, tMap.rms[ _rmIdx ].rObj[ _iA ].label
								end
							end
						end
					end
				end
			end
			return false,0,"", false,0,""
		end
	elseif _target == "objAuEXISTS" then	--OBJECT ON PERSON/USER B-OBJ EVERY TIME, A-OBJ MAYBE
		function _table:objAuEXISTS( _objB, _objA )	--Egg in Eggs, cookie in Cookies match
			if _objA == nil then
				_objA = ""	--end
				if #_objA == 0 and #_objB >0 then	--ONLY LOOKING FOR B-OBJ, THEIR IS NO A
					for _iB =1, #tMap.auLeg do
						if ( tMap.auLeg[ _iB ].label == _objB
						or tMap.auLeg[ _iB ].label == _objB .. "s" ) then
							--return false, 0, "", false, _iA, tMap.auLeg[ _iA ].label	--B RETURNS ON B RAIL
							return true, _iB, tMap.auLeg[ _iB ].label, false,0,""	--B RETURNS ON OBJ-A RAILWAY, A CHEAT FOR OLD CODE
						end
					end
				end
			else
				if #_objB >0 then	--A AND B MUST EXIST LOOP	--#_objA > 0 and
					for _iA =1, #tMap.auLeg do
						if #tMap.auLeg[ _iA ].oBag >0 then
							for _iB =1, #tMap.auLeg[ _iA ].oBag do
								if ( tMap.auLeg[ _iA ].label == _objA 										--A LOCKIN
								or tMap.auLeg[ _iA ].label == _objA .."s" )
								and ( tMap.auLeg[ _iA ].oBag[ _iB ].label == _objB .."s"	--B LOCKIN
								or tMap.auLeg[ _iA ].oBag[ _iB ].label == _objB ) then
									--_objA = tMap.auLeg[ _iA ].label	--MISSING DATA FOUND
									return true, _iB, tMap.auLeg[ _iA ].oBag[ _iB ].label, true, _iA, tMap.auLeg[ _iA ].label
								end
							end
						end
					end
				end
			end
			return false,0,"", false,0,""
		end
		-- *** CMDS & OBJECTS ***
  elseif _target == "objCrt" then  --CREATE OBJECT OnPerson
    function _table:objCrt( _obj, _count, _unTAKE, _flow, _MOVES, _MOVEUD )
			local _onAU, _iObj = self:objAuEXISTS( _obj )
			local _inRM, _iRm = self:objRmEXISTS( _obj )
			local _bTBL = false
			local _tbl = {}
			if _onAU then
				tMap.auLeg[ _iObj ].objUNTAKE = _unTAKE or false
				tMap.auLeg[ _iObj ].count = tMap.auLeg[ _iObj ].count + _count
				return true
			elseif _inRM then
				--UPDATE HIDE AND COUNT OF OBJECT
				tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].objUNTAKE = _unTAKE or false
				tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].count = tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].count + _count or 1  --STARTING NUMBER OR TOTAL
				return true
			else
				_bTBL = true
				_tbl = {					
					label = _obj,
					count = _count or 1,  --OBJ(S) TOTAL
					pkgSize = 1,											--COUNT/PACKAGE SIZE, OR SCHOOL OF FISH SIZE?
					pkgLabel = "",										--PACKAGE LABEL
					objHIDDEN = false,
					objUNTAKE = _unTAKE or false,
					timer = 0,												--IN SECONDS AGAINST _storyRoom.rTimer
					tripWireLIVE = false,							--EVERY OBJECT CAN BE LIVE OR DEAD - TIMER
					countDOWN = false,								--COUNTING UP OR DOWN
					objON = false,
					objLOCKED = false,
					author = self.hAuthor,  					--OR self.authors[ index ]
					cost = 0,													--HOW MUCH COST OF FRIDGE ITEMS?
					tripWire = { idx = 0 },						--INSIDE TRIPWIRE image = "", --COLOUR & SHAPES sound = "" 
					health = 4000,										--MAX CHARGE
					Hz = 8,														--OTHERS MIGHT THINK LEVELS
					image = "", 											--NOT LIKELY TO LAST AFTER TW CONNECTS OF THIS ARE RUNABLE
					sound = "",
					MOVES = _MOVES or false,					--OBJECT CAN MOVE
					MOVEUD = _MOVEUD or false,				--OBJECT CAN MOVE UP AND DOWN ROOMS
					ONBOARD = false,									--ROOMS NOW INSIDE OBJECT FLAG
					oBag = { idx = 0 },								--BAG IS CONTAINER FOR ROOMS & OBJECT
					objOPENED = false,
					displayOPENED = true,
					}
			end	
			if _bTBL and _flow == "onAU" then
        table.insert( tMap.auLeg, _tbl  )
				--tMap.auLeg.idx = #tMap.auLeg
        return true
			elseif _bTBL and _flow == "inRM" then
        table.insert( tMap.rms[ tMap.rms.idx ].rObj, _tbl  )
				--tMap.rms[ tMap.rms.idx ].rObj.idx = #tMap.rms[ tMap.rms.idx ].rObj
        return true
      end
    end
	elseif _target == "objCrtInObj" then
		--OBJ CARRIES OBJ IN .oOpen = {}
		function _table:objCrtInObj( _objA, _count, _objB )	--FOCUSED ON OBJ-B
			local _idx = tMap.rms.idx
			local _zeroOut = 0																--math.min() or .max()
			local _BonAUN, _BiAuN, _,			_AonAU, _AiAu = self:objAuEXISTS( _objB, _objA )	--NOT USING "s" FEEDBACK HERE
			local _BinRMN, _BiRmN, _tick, _AinRM, _AiRm = self:objRmEXISTS( _objB, _objA )
			local _BonAU, _BiAu = self:objAuEXISTS( _objB )		--OBJ-B MIGHT ALSO BE ELSE WHERE
			local _BinRM, _BiRm = self:objRmEXISTS( _objB )
			if not _BonAUN and not _BinRMN then								--OBJ-B NOT NESTED
				_AonAU, _AiAu, _ = self:objAuEXISTS( _objA )
				_AinRM, _AiRm, _ = self:objRmEXISTS( _objA )
			end
			local _tbl = {}								--CLONE OBJ2 TABLE
			if _AonAU and ( _BonAU and not tMap.auLeg[ _BiAu ].objUNTAKE ) then
				_zeroOut = tMap.auLeg[ _BiAu ].count - _count
				if _BonAUN then							--NESTED
					if _zeroOut <= 0 then
						tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count = 
						tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count + tMap.auLeg[ _BiAu ].count
						table.remove( tMap.auLeg, _BiAu )
					elseif _zeroOut >0 then
						tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count =	--COUNT VALID >0
						tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count + _count
						tMap.auLeg[ _BiAu ].count = _zeroOut
					end
				elseif not _BonAUN then
					_tbl = tMap:tblClone( tMap.auLeg[ _BiAu ] )
					if _zeroOut <= 0 then
						table.insert( tMap.auLeg[ _AiAu ].oBag, _tbl )
						table.remove( tMap.auLeg, _BiAu )
					elseif _zeroOut >0 then
						_tbl.count = _count
						table.insert( tMap.auLeg[ _AiAu ].oBag, _tbl )
						tMap.auLeg[ _BiAu ].count = _zeroOut
					end
				end
				return true
			--A-AU & B-RM SPLIT NEST
			elseif _AonAU and ( _BinRM and not tMap.rms[ _idx ].rObj[ _BiRm ].objUNTAKE ) then
				_zeroOut = tMap.rms[ _idx ].rObj[ _BiRm ].count - _count
				if _BonAUN then			--NESTED
					if _zeroOut <= 0 then
						tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count =
						tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count + tMap.rms[ _idx ].rObj[ _BiRm ].count
						table.remove( tMap.rms[ _idx ].rObj, _BiRm )
					elseif _zeroOut >0 then
						tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count =	--COUNT VALID >0
						tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count + _count
						tMap.rms[ _idx ].rObj[ _BiRm ].count = _zeroOut
					end
				elseif not _BonAUN then	--
					_tbl = tMap:tblClone( tMap.rms[ _idx ].rObj[ _BiRm ] )
					if _zeroOut <= 0 then
						table.insert( tMap.auLeg[ _AiAu ].oBag, _tbl )
						table.remove( tMap.rms[ _idx ].rObj, _BiRm )
					elseif _zeroOut >0 then
						_tbl.count = _count
						table.insert( tMap.auLeg[ _AiAu ].oBag, _tbl )
						tMap.rms[ _idx ].rObj[ _BiRm ].count = _zeroOut
					end
				end
				return true
			--A-RM & B-AU SPLIT NEST
			elseif _AinRM and ( _BonAU and not tMap.rms[ _idx ].rObj[ _BiRm ].objUNTAKE ) then
				_zeroOut = tMap.auLeg[ _BiAu ].count - _count
				if _BinRMN then			--NESTED
					if _zeroOut <= 0 then
						tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count =
						tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count + tMap.auLeg[ _BiAu ].count
						table.remove( tMap.rms[ _idx ].rObj, _BiRm )
					elseif _zeroOut >0 then
						tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count =	--COUNT VALID >0
						tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count + _count
						tMap.auLeg[ _BiAu ].count = _zeroOut
					end
				elseif not _BinRMN then	--
					_tbl = tMap:tblClone( tMap.auLeg[ _BiAu ] )
					if _zeroOut <= 0 then
						table.insert( tMap.rms[ _idx ].rObj[ _AiRm ].oBag, _tbl )
						table.remove( tMap.auLeg, _BiAu )
					elseif _zeroOut >0 then
						_tbl.count = _count
						table.insert( tMap.rms[ _idx ].rObj[ _AiRm ].oBag, _tbl )
						tMap.auLeg[ _BiAu ].count = _zeroOut
					end
				end
				return true
			--A-RM & B-RM SPLIT NEST
			elseif _AinRM and ( _BinRM and not tMap.rms[ _idx ].rObj[ _BiRm ].objUNTAKE ) then
				_zeroOut = tMap.rms[ _idx ].rObj[ _BiRm ].count - _count
				if _BinRMN then			--NESTED
					if _zeroOut <= 0 then
						tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count =
						tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count + tMap.rms[ _idx ].rObj[ _BiRm ].count
						table.remove( tMap.rms[ _idx ].rObj, _BiRm )
					elseif _zeroOut >0 then
						tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count =
						tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count + _count
						tMap.rms[ _idx ].rObj[ _BiRm ].count = _zeroOut
					end
				elseif not _BinRMN then	--
					_tbl = tMap:tblClone( tMap.rms[ _idx ].rObj[ _BiRm ] )
					if _zeroOut <= 0 then
						table.insert( tMap.rms[ _idx ].rObj[ _AiRm ].oBag, _tbl )
						table.remove( tMap.rms[ _idx ].rObj, _BiRm )
					elseif _zeroOut >0 then
						_tbl.count = _count
						table.insert( tMap.rms[ _idx ].rObj[ _AiRm ].oBag, _tbl )
						tMap.rms[ _idx ].rObj[ _BiRm ].count = _zeroOut
					end
				end
				return true
			end
			return false
		end
	elseif _target == "objTakeFromObj" then
		--OBJ CARRIES OBJ IN .oOpen = {}
		function _table:objTakeFromObj( _objA, _count, _objB )
			local _idx = tMap.rms.idx
			local _zeroOut = 0
			--LOCATE ALL OBJECTS, INCLUDING NESTED OBJ2 WITHIN OBJ
			local _AonAU, _AiAu, _, _BonAUN, _BiAuN = self:objAuEXISTS( _objB, _objA )	--NOT USING "s" FEEDBACK HERE
			local _AinRM, _AiRm, _tick, _BinRMN, _BiRmN = self:objRmEXISTS( _objB, _objA )
			--LOCATE OBJ2 IN-ROOM OR ON-AUTHOR
			local _BonAU, _BiAu = self:objAuEXISTS( _objB )
			local _BinRM, _BiRm = self:objRmEXISTS( _objB )
			if not _BonAUN and not _BinRMN then
				_AonAU, _AiAu, _ = self:objAuEXISTS( _objA )
				_AinRM, _AiRm, _ = self:objRmEXISTS( _objA )
			end
			local _tbl = {}																	--CLONE OBJ2 TABLE
			if _AonAU and _BonAUN then											--FRIDGE CONTAINS EGGS
				if tMap.auLeg[ _AiAu ].objOPENED		--FRIDGE
				and not tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].objUNTAKE then--EGGS IN FRIDGE
					_zeroOut = tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count - _count	--EGGS.COUNT DEMANDED ON FRIDGE
					if _BonAU then									--EGGS OF FRIDGE && EGGS ON-AUTHOR
						if _zeroOut <= 0 then											--COUNT >= _count WHAT WAS ASKED FOR
							tMap.auLeg[ _BiAu ].count = tMap.auLeg[ _BiAu ].count + tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count
							table.remove( tMap.auLeg[ _AiAu ].oBag, _BiAuN )--DELETE NEST EGGS
						elseif _zeroOut >0 then										--_count VALID VALUE
							tMap.auLeg[ _BiAu ].count = tMap.auLeg[ _BiAu ].count + _count
							tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count = _zeroOut
						end
						return true
					elseif not _BonAU then					--CLONE CHANGE STORE DATA
						_tbl = tMap:tblClone( tMap.auLeg[ _AiAu ].oBag[ _BiAuN ] )--CLONE
						if _zeroOut <= 0 then											--BORROW COUNT VALUE
							_tbl.count = tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count
							table.insert( tMap.auLeg, _tbl )						--NO CHANGE NEEDED DATA MOVED
							table.remove( tMap.auLeg[ _AiAu ].oBag, _BiAuN )											--REMOVE NEST SOURCE EGGS
						elseif _zeroOut >0 then										--COUNT IS VALID
							_tbl.count = _count											--CORRECT TABLES COUNT VALUE
							table.insert( tMap.auLeg, _tbl )	--MOVE TABLE
							tMap.auLeg[ _AiAu ].oBag[ _BiAuN ].count = _zeroOut	--REMAINDER VALUE ASSIGNED
						end
						return true
					end
				end
				--LETS COPY OVER SAME NOW TO THE RM && RM DEAL
			elseif _AinRM and _BinRMN then
				if tMap.rms[ _idx ].rObj[ _AiRm ].objOPENED		--FRIDGE
				and not tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].objUNTAKE then--EGGS IN FRIDGE
					_zeroOut = tMap.rms[ _idx ].rObj[ _AiRm ].oBag[ _BiRmN ].count - _count	--EGGS.COUNT DEMANDED ON FRIDGE
					if _BonRM then									--EGGS OF FRIDGE && EGGS ON-AUTHOR
						if _zeroOut <= 0 then											--COUNT >= _count WHAT WAS ASKED FOR
							tMap.rms[ _idx ].rObj[ _BiRm ].count =			--TRASFER COUNT OF NEST EGGS TO EGGS
							tMap.rms[ _idx ].rObj[ _BiRm ].count + tMap.rms[ _idx ].rObj[ _BiRm ].oBag[ _BiRmN ].count
							table.remove( tMap.rms[ _idx ].rObj[ _BiRm ].oBag, _BiRmN )--DELETE NEST EGGS
						elseif _zeroOut >0 then										--_count VALID VALUE
							tMap.rms[ _idx ].rObj[ _BiRm ].count = tMap.rms[ _idx ].rObj[ _BiRm ].count + _count
							tMap.rms[ _idx ].rObj[ _BiRm ].oBag[ _BiRmN ].count = _zeroOut
						end
						return true
					elseif not _BonRM then					--CLONE CHANGE STORE DATA
						_tbl = tMap:tblClone( tMap.auLeg[ _AiRm ].oBag[ _BiAuN ] )--CLONE
						if _zeroOut <= 0 then											--BORROW COUNT VALUE
							_tbl.count = tMap.rms[ _idx ].rObj[ _BiRm ].oBag[ _BiRmN ].count
							table.insert( tMap.rms[ _idx ].rObj, _tbl )						--NO CHANGE NEEDED DATA MOVED
							table.remove( tMap.rms[ _idx ].rObj[ _BiRm ].oBag, _BiRmN )											--REMOVE NEST SOURCE EGGS
						elseif _zeroOut >0 then										--COUNT IS VALID
							_tbl.count = _count											--CORRECT TABLES COUNT VALUE
							table.insert( tMap.rms[ _idx ].rObj, _tbl )	--MOVE TABLE
							tMap.rms[ _idx ].rObj[ _BiRm ].oBag[ _BiRmN ].count = _zeroOut	--REMAINDER VALUE ASSIGNED
						end
						return true
					end
				end
			end
			return false
		end
		
	elseif _target == "moveItem" then		--DEFAULT FLOW TAKING ITEM FROM FRIDGE NEST
		function _table:moveItem( _bNEST, _scrTbl, _dstTbl, _count, _cmd )
			_count = tonumber( _count )
			--CHECK FOR "ROOT" WILL LET US KNOW WHERE DESTINATION TAKE table.insert AS ROOT OR .oBag
			local _zeroOut = 0
			local _tbl = self:tblClone( _scrTbl )	--[ _scrTbl.idx ]
			if _bNEST then		-- *** ASSUME FLOW WHERE NEST IS TAKE SOURCE TARGET ***
				local _iNest = _scrTbl[ _scrTbl.idx ].oBag.idx	--READABILITY ADJUSTMENT
				_tbl = self:tblClone( _scrTbl[ _scrTbl.idx ].oBag[ _iNest ] )
				if not _scrTbl[ _scrTbl.idx ].oBag[ _iNest ].objUNTAKE and 
				not _scrTbl[ _scrTbl.idx ].oBag[ _iNest ].objLOCKED then
					_zeroOut = _scrTbl[ _scrTbl.idx ].oBag[ _iNest ].count - _count
					if type( _dstTbl) ~= 'table' and _scrTbl.label == "ROOT-2046YellowEyeBowl" then 	--SOURCE ONLY SELF.DISTINATION
						for x =1, #_scrTbl do		--DOES OBJECT EXIST IN SOURCE TABLE?
							if _tbl.label == _scrTbl[ x ].label then	--ROOT LEVEL SEARCHING
								if _zeroOut <= 0 then
									_scrTbl[ x ].count = _scrTbl[ x ].count + _tbl.count
									table.remove( _scrTbl[ _scrTbl.idx ].oBag, _iNest )
								elseif _zeroOut > 0 then
									_scrTbl[ x ].count = _scrTbl[ x ].count + _count
									_scrTbl[ _scrTbl.idx ].oBag[ _iNest ].count = _zeroOut
								end
								return _scrTbl
							end
						end
						--OBJECT DOESN'T EXIST IN SCR *** FALL-THROUGH ***
						if _zeroOut <= 0 then		
							table.remove( _scrTbl[ _scrTbl.idx ].oBag, _iNest )
						elseif _zeroOut > 0 then
							_scrTbl[ _scrTbl.idx ].oBag[ _iNest ].count = _zeroOut
							_tbl.count = _count
						end
						table.insert( _scrTbl, _tbl )
						return _scrTbl
					end
				end
			elseif not _bNEST and not _scrTbl.objUNTAKE and not _scrTbl.objLOCKED then
				_zeroOut = _scrTbl.count - _count		--[ _scrTbl.idx ]
				--_tbl = self:tblClone( _scrTbl )	--[ _scrTbl.idx ]
				if type( _dstTbl ) ~= 'table' then		--SCORCE TO SCORCE
					foo = nil
				elseif #_dstTbl.oBag >0 then
					for x =1, #_dstTbl.oBag do
						if _tbl.label == _dstTbl.oBag[ x ].label then	--ROOT LEVEL SEARCHING
							if _zeroOut <= 0 then
								_scrTbl.count = 0		-- *** CLEAN UP "0"s AFTER runTWaction() ***
								table.insert( _dstTbl, _tbl )
							elseif _zeroOut > 0 then
								--_tbl.count = _count
								_scrTbl.count = _zeroOut
								_dstTbl.oBag[ x ].count = _dstTbl.oBag[ x ].count + _count
							end
							return _scrTbl, _dstTbl
						end
					end
				end
				--SAME OBJECT FALSE EXIST *** FALL-THROUGH ***
				if _zeroOut <= 0 then
					_scrTbl.count = 0		-- *** CLEAN UP ZERO-OUTS AFTER runTWaction() ***
				elseif _zeroOut > 0 then
					_tbl.count = _count
					_scrTbl.count = _zeroOut
				end
				table.insert( _dstTbl.oBag, _tbl )
				return _scrTbl, _dstTbl
			end
			return nil, nil
		end
	elseif _target == "objHide" then
		function _table:objHide( _obj, _bool )
			local _inRM, _iRm = self:objRmEXISTS( _obj, nil )
			if _inRM then
				tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].objHIDDEN = _bool
				return true
			end
			local _onAU, _iAu = self:objAuEXISTS( _obj, nil )
			if _onAU then
				tMap.auLeg[ _iAu ].objHIDDEN = _bool
				return true
			end
			return false
		end
	elseif _target == "objDelInRoom" then   --PLAY MODE NO DELETE OPTION
    function _table:objDelInRoom( _obj, _count )
			local _inRM, _iRm = self:objRmEXISTS( _obj, "" )
			local _idx = tMap.rms.idx
			if _inRM and not tMap.rms[ _idx ].rObj[ _iRm ].objUNTAKE then												--CAN ONLY REMOVE OBJ WHEN PRESENT
				tMap.rms[ _idx ].rObj[ _iRm ].count = tMap.rms[ _idx ].rObj[ _iRm ].count - _count
				if tMap.rms[ _idx ].rObj[ _iRm ].count <=0 then
					table.remove( tMap.rms[ _idx ].rObj, _iRm )
					return true
				end
      end
			return false
    end
  elseif _target == "objDelOnAuthor" then  --PLAY MODE NO DELETE OPTION
    function _table:objDelOnAuthor( _obj, _count )
			local _onAU, _AiAu = self:objAuEXISTS( _obj )
			if _onAU and not tMap.auLeg[ _iAu ].objUNTAKE then												--CAN ONLY REMOVE OBJ WHEN PRESENT
				tMap.auLeg[ _iAu ].count = tMap.auLeg[ _iAu ].count - _count
				if tMap.auLeg[ _iAu ].count <=0 then
					table.remove( tMap.auLeg, _iAu )
					return true
				end
      end
			return false
    end
	elseif _target == "objIdxChk" then		--SHOULD BE INDEX-RESET-HIGH
		function _table:objIdxChk()
			if tMap.rms[ tMap.rms.idx ].rObj.idx > #tMap.rms[ tMap.rms.idx ].rObj then
				tMap.rms[ tMap.rms.idx ].rObj.idx = #tMap.rms[ tMap.rms.idx ].rObj
			end
			if tMap.auLeg.idx > #tMap.auLeg then
				tMap.auLeg.idx = #tMap.auLeg
			end
		end
	elseif _target == "objOnOff" then
		function _table:objOnOff( _obj, _bool )
			--SEARCH FOR OBJECT ON-AUTHOR 1st, THEN IN-ROOM
			local _onAU, _iAu = self:objAuEXISTS( _obj )
			local _inRM, _iRm = self:objRmEXISTS( _obj )
			if _onAU then
				tMap.auLeg[ _iAu ].objON = _bool
				return true
			elseif _inRM then
				tMap.rms[ tMap.rms.idx ].rObj[ _iRm ].objON = _bool
				return true
			end
			return false
		end
	elseif _target == "objLock" then
		function _table:objLock( _obj, _LOCKED )
			local _idx = tMap.rms.idx
			local _onAU, _iAuRm = self:objAuEXISTS( _obj )
			local _inRM = false
			if not _onAU then
				_inRM, _iAuRm = self:objRmEXISTS( _obj )
			end
			if _onAU then		--WORKING ON THE AUTHOR 1ST AS IT'S THEIR PERSPECTIVE
				tMap.auLeg[ _iAuRm ].objLOCKED = _LOCKED
				return true
			elseif _inRM then
				tMap.rms[ _idx ].rObj[ _iAuRm ].objLOCKED = _LOCKED
				return true
			end
			return false
		end
	elseif _target == "objConsume" then   --WORKS - VERY COOL
    function _table:objConsume( _obj, _count )
			--local _bFLAG = false	:objDelInRoom( _obj, _count ) & :objDelOnAuthor( _obj, _count )
      local _idx = tMap.rms.idx
			local _onAU, _iAu = self:objAuEXISTS( _obj )
			local _inRM, _iRm = self:objRmEXISTS( _obj )
			local _zeroOut = 0
			local remainCount = 0
			local _tbl = {}
			if _inRM and ( tMap.rms[ _idx ].rObj[ _iRm ].objUNTAKE
			or tMap.rms[ _idx ].rObj[ _iRm ].objHIDDEN ) then	--TURN FLAG OFF IF IN-ROOM HIDDEN OBJECT
				_inRM = false
			end
			if _onAU and ( tMap.auLeg[ _iAu ].objUNTAKE	--UNTAKE MEANS NOT AT ALL
			or tMap.auLeg[ _iAu ].objHIDDEN ) then			--AND THAT GOES FOR HIDDEN ITEMS ALSO
				_onAU = false
			end
			--(PMR WAY) CONSUME IN PERSONAL SPACE 1st ON-AUTHOR
			--2nd IN-CONTAINER (OPENED) ON-AUTHOR
			--3rd IN-CONTAINER (OPENED) IN-ROOM
			--4th IN-ROOM
			if _onAU then --and _inRM then
				_zeroOut = tMap.auLeg[ _iAu ].count - _count		--ADJUSTMENT
				if _zeroOut <= 0 then
					table.remove( tMap.auLeg, _iAu )
				elseif _zeroOut > 0 then
					tMap.auLeg[ _iAu ].count = _zeroOut
				end
				return true
			elseif not _onAU then	--CHECKING OBJS AS CONTAINERS
				if #tMap.auLeg >0 then
					for a =1, #tMap.auLeg do
						--if #tMap.auLeg.oBag >0 then
						for b =1, #tMap.auLeg[ a ].oBag do
							if tMap.auLeg[ a ].objOPENED and tMap.auLeg[ a ].oBag[ b ].label == _obj then
								_zeroOut = tMap.auLeg[ a ].oBag[ b ].count -_count
								if _zeroOut <= 0 then
									table.remove( tMap.auLeg[ a ].oBag, b )
								elseif _zeroOut > 0 then
									tMap.auLeg[ a ].oBag[ b ].count = _zeroOut
								end
								return true
							end
						end
					end
				end
			end
			if not _inRM then
				if #tMap.rms[ _idx ].rObj >0 then
					for a =1, #tMap.rms[ _idx ].rObj do
						for b =1, #tMap.rms[ _idx ].rObj[ a ].oBag do
							if tMap.rms[ _idx ].rObj[ a ].objOPENED
							and tMap.rms[ _idx ].rObj[ a ].oBag[ b ].label == _obj then
								_zeroOut = tMap.rms[ _idx ].rObj[ a ].oBag[ b ].count - _count
								if _zeroOut <= 0 then
									table.remove( tMap.rms[ _idx ].rObj[ a ].oBag, b )
								elseif _zeroOut > 0 then
									tMap.rms[ _idx ].rObj[ a ].oBag[ b ].count = _zeroOut
								end
								return true
							end
						end
					end
				end
			elseif _inRM then
				_zeroOut = tMap.rms[ _idx ].rObj[ _iRm ].count - _count
				--if _zeroOut <= 0 then
					--table.remove( tMap.rms[ _idx ].rObj[ _iRm ] )
				--elseif
				--if _zeroOut > 0 then
				tMap.rms[ _idx ].rObj[ _iRm ].count = _zeroOut
				--end
				return true
			end
    end
	elseif _target == "objRename" then		--rename # obj1 obj2
		function _table:objRename( _obj1, _num, _obj2 )	--OBJ1 WILL BECOME TARGET TABLE
			local _idx = tMap.rms.idx
			local _bFLAG = false
			local _tbl = {}		--mirrorTable( TBL ) IS A COPY BUT SEPERATE
			local _ObjOneEXISTS, _iAuRm = self:objAuEXISTS( _obj1 )		--ON-AUTHOR CHECK OBJ1
			local _ObjTwoEXISTS, _iAuRm2 = self:objAuEXISTS( _obj2 )		--ON-AUTHOR CHECK OBJ2
			local _objOne = "onAu"
			local _objTwo = "onAu"
			local _zeroOut = 0
			if _obj1 ~= _obj2 then
				if _ObjOneEXISTS then
					_tbl = self:tblClone( tMap.auLeg[ _iAuRm ] )						--INDEPENDANT COPY!
				elseif not _ObjOneEXISTS then 
					_ObjOneEXISTS, _iAuRm = self:objRmEXISTS( _obj1 )			--IN-ROOM CHECK OBJ1
					if _ObjOneEXISTS then
						_tbl = self:tblClone( tMap.rms[ _idx ].rObj[ _iAuRm ] )			--INDEPENDANT COPY!
						_objOne = "inRm"
					else
						return false																								--WITHOUT OBJ WE ARE DONE HERE
					end
				end
				if _ObjOneEXISTS then		--and not _ObjTwoEXISTS 												--IN-ROOM CHECK OBJ2
					_zeroOut = _tbl.count -_num
					_ObjTwoEXISTS, _iAuRm2 = self:objRmEXISTS( _obj2, "" )
					if _ObjTwoEXISTS then _objTwo = "inRm" end
				--end
					if _zeroOut <= 0 then
						if _ObjOneEXISTS and not _ObjTwoEXISTS then
							if _objOne == "inRm" then
								--tMap.rms[ _idx ].rObj[ _iAuRm ].label = _obj2
								--FOLLOW UP WITH *** OBJ2 NAME CHANGE MATCHING PER TW ***, FROM GHOST-TRAP OBJ1 OR OBJ1
								tMap.rms[ _idx ].rObj[ _iAuRm ] = twReNameWalk( tMap.rms[ _idx ].rObj[ _iAuRm ], _obj1, _obj2   )
								--tMap.rms[ _idx ].rObj[ _iAuRm ] = twReNameWalk( _objOne, _tbl.label, tMap.rms[ _idx ].rObj[ _iAuRm ] )		--LABEL OBJECT TABLE
							elseif _objOne == "onAu" then
								tMap.auLeg[ _iAuRm ].label = _obj2
								--FOLLOW UP WITH *** OBJ2 NAME CHANGE MATCHING PER TW ***, FROM GHOST-TRAP OBJ1 OR OBJ1
								tMap.auLeg[ _iAuRm ] = twReNameWalk( tMap.auLeg[ _iAuRm ], _obj1, _obj2  )
							end
						elseif _ObjOneEXISTS and _ObjTwoEXISTS then
							if _objTwo == "inRm" then
								tMap.rms[ _idx ].rObj[ _iAuRm2 ].count = tMap.rms[ _idx ].rObj[ _iAuRm2 ].count + _tbl.count
								--FOLLOW UP WITH *** OBJ2 NAME CHANGE MATCHING PER TW ***, FROM GHOST-TRAP OBJ1 OR OBJ1
								tMap.rms[ _idx ].rObj[ _iAuRm2 ] = twReNameWalk( tMap.rms[ _idx ].rObj[ _iAuRm2 ], _obj1, _obj2  )		--LABEL OBJECT TABLE
							elseif _objTwo == "onAu" then
								tMap.auLeg[ _iAuRm2 ].count = tMap.auLeg[ _iAuRm2 ].count + _tbl.count
								--FOLLOW UP WITH *** OBJ2 NAME CHANGE MATCHING PER TW ***, FROM GHOST-TRAP OBJ1 OR OBJ1
								tMap.auLeg[ _iAuRm2 ] = twReNameWalk( tMap.auLeg[ _iAuRm2 ], _obj1, _obj2  )
							end
							if _objOne == "inRm" then
								table.remove( tMap.rms[ _idx ].rObj, _iAuRm )
							elseif _objOne == "onAu" then
								table.remove( tMap.auLeg, _iAuRm )
							end
						end
						return true
					elseif _zeroOut > 0 then
						if not _ObjTwoEXISTS then
							if _objOne == "inRm" then
								tMap.rms[ _idx ].rObj[ _iAuRm ].count = _zeroOut
							elseif _objOne == "onAu" then
								tMap.auLeg[ _iAuRm ].count = _zeroOut
							end
							_tbl.count = _num
							--_tbl.label = _obj2
							_tbl = twReNameWalk( _tbl, _obj1, _obj2  )
							table.insert( tMap.rms[ _idx ].rObj, _tbl )
							--tMap.rms[ _idx ].rObj[ #tMap.rms[ _idx ].rObj ].count = _num
							--tMap.rms[ _idx ].rObj[ #tMap.rms[ _idx ].rObj ].label = _obj2	--WILL AFFECT THE GHOST-TRAP
							--FOLLOW UP WITH *** OBJ2 NAME CHANGE MATCHING PER TW ***, FROM GHOST-TRAP OBJ1 OR OBJ1
							--tMap.rms[ _idx ].rObj[ #tMap.rms[ _idx ].rObj ]
							--= twReNameWalk( _objOne, _obj1, tMap.rms[ _idx ].rObj[ #tMap.rms[ _idx ].rObj ] )		--LABEL OBJECT TABLE
						elseif _ObjTwoEXISTS then
							if _objTwo == "inRm" then
								tMap.rms[ _idx ].rObj[ _iAuRm2 ].count = tMap.rms[ _idx ].rObj[ _iAuRm2 ].count + _num
								--FOLLOW UP WITH *** OBJ2 NAME CHANGE MATCHING PER TW ***, FROM GHOST-TRAP OBJ1 OR OBJ1
								tMap.rms[ _idx ].rObj[ #tMap.rms[ _idx ].rObj ] 
								= twReNameWalk( tMap.rms[ _idx ].rObj[ #tMap.rms[ _idx ].rObj ], _obj1, _obj2 )		--LABEL OBJECT TABLE
							elseif _objTwo == "onAu" then
								tMap.auLeg[ _iAuRm2 ].count = tMap.auLeg[ _iAuRm2 ].count + _num
								--FOLLOW UP WITH *** OBJ2 NAME CHANGE MATCHING PER TW ***, FROM GHOST-TRAP OBJ1 OR OBJ1
								tMap.auLeg[ _iAuRm2 ] = twReNameWalk( tMap.auLeg[ _iAuRm2 ], _obj1, _obj2 )		--LABEL OBJECT TABLE
							end
							if _objOne == "inRm" then
								tMap.rms[ _idx ].rObj[ _iAuRm ].count = _zeroOut
							elseif _objOne == "onAu" then
								tMap.auLeg[ _iAuRm ].count = _zeroOut
							end
						end
						--FOLLOW UP WITH *** OBJ2 NAME CHANGE MATCHING PER TW ***, FROM GHOST-TRAP OBJ1 OR OBJ1
						--tMap.auLeg[ _iAuRm2 ] or tMap.rms[ _idx ].rObj = twReNameWalk( _ObjTwo, _tbl.label, tMap.auLeg[ _iAuRm2 ] or tMap.rms[ _idx ].rObj )		--LABEL OBJECT TABLE
						return true
					end
				end
				return false
			end
		end
	elseif _target == "objTake" then	--CAN OBJ BE TAKEN, SORT BOTH OBJ COUNTS
		--CHANGE TO MIRROR crtOBJinOBJ'S A & B
		function _table:objTake( _objB, _count, _objA )	--OBJA FRIDGE, OBJB IN FRIDGE, OBJA MAYBE MISSING
			if _objA == nil then _objA = "" end
			local _idx = tMap.rms.idx
			local _bFLAG = false
			local _zeroOut = 0		--ALWAYS FOCUSED ON OBJ-B
			--LOCATE ALL OBJECTS, INCLUDING NESTED OBJ2 WITHIN OBJ
			--LOCATE OBJ2 IN-ROOM OR ON-AUTHOR
			local _BonAU, _BiAu = self:objAuEXISTS( _objB )	--A = NIL 
			local _BinRM, _BiRm = self:objRmEXISTS( _objB )
			local _BonAUN, _BiAuN, _, 		_AonAU, _AiAu = self:objAuEXISTS( _objB, _objA )
			local _BinRMN, _BiRmN, _tick, _AinRM, _AiRm = self:objRmEXISTS( _objB, _objA )
			if not _BonAUN and not _BinRMN then
				_AonAU, _AiAu, _ = self:objAuEXISTS( _objA )
				_AinRM, _AiRm, _ = self:objRmEXISTS( _objA )
			end
			local _tbl = {}				--CLONE OBJ2 SOURCE TABLE
			if _BonAUN then				--NESTED 
				for a =1, #tMap.auLeg do
					if tMap.auLeg[ a ].objOPENED and tMap.auLeg[ a ].oBag >0 then
						for b =1, #tMap.auLeg[ a ].oBag do
							if tMap.auLeg[ a ].oBag[ b ].label == _objA then
								_zeroOut = tMap.auLeg[ a ].oBag[ b ].count -_count
								if _zeroOut <= 0 then
									_tbl = self:tbleClone( tMap.auLeg[ a ].oBag[ b ] )
									if _BonAU then				--WE ARE TAKING AND ITEM EXISTS ALREADY
										tMap.auLeg[ _BiAu ].count = tMap.auLeg[ _BiAu ].count + _tbl.count
									else
										table.insert( tMap.auLeg, _tbl )
										table.remove( tMap.auLeg[ a ].oBag, b )
									end
									return true
								elseif _zeroOut >0 then
									_tbl = self:tblClone( tMap.auLeg[ a ].oBag[ b ] )
									_tbl.count = _count
									table.insert( tMap.auLeg, _tbl )
									tMap.rms[ a ].oBag[ b ].count = _zeroOut
									return true
								end
							end
						end
					end
				end
			elseif _BinRMN then --and #tMap.rms[ _idx ].rObj >0
				for a =1, #tMap.rms[ _idx ].rObj do
					if tMap.rms[ _idx ].rObj[ a ].objOPENED and #tMap.rms[ _idx ].rObj[ a ].oBag >0 then
						for b =1, #tMap.rms[ _idx ].rObj[ a ].oBag do
							if tMap.rms[ _idx ].rObj[ a ].oBag[ b ].label == _objB then		--OBJ MATCHED INSIDE SOME OTHER OBJS CONTAINER
								_zeroOut = tMap.rms[ _idx ].rObj[ a ].oBag[ b ].count -_count
								if _zeroOut <= 0 then		--ALL CONTENTS EMPTIED
									_tbl = self:tblClone( tMap.rms[ _idx ].rObj[ a ].oBag[ b ] )
									if _BonAU then				--WE ARE TAKING AND ITEM EXISTS ALREADY
										tMap.auLeg[ _BiAu ].count = tMap.auLeg[ _BiAu ].count + _tbl.count
									else									--OBJ DOESN'T EXIST
										table.insert( tMap.auLeg, _tbl )
										table.remove( tMap.rms[ _idx ].rObj[ a ].oBag, b )
									end
									return true
								elseif _zeroOut >0 then	
									_tbl = self:tblClone( tMap.rms[ _idx ].rObj[ a ].oBag[ b ] )
									_tbl.count = _count
									if _BonAU then				--WE ARE TAKING AND ITEM EXISTS ALREADY
										tMap.auLeg[ _BiAu ].count = tMap.auLeg[ _BiAu ].count + _tbl.count
									else
										table.insert( tMap.auLeg, _tbl )
									end
									tMap.rms[ _idx ].rObj[ a ].oBag[ b ].count = _zeroOut		--UPDATE COUNT REMAINING
									return true
								end
							end
						end
					end
				end
			elseif _BinRM and not tMap.rms[ _idx ].rObj[ _BiRm ].objUNTAKE then
				_tbl = self:tblClone( tMap.rms[ _idx ].rObj[ _BiRm ] )		--INDEPENDANT COPY!
				_zeroOut = tMap.rms[ _idx ].rObj[ _BiRm ].count -_count
				if _zeroOut <= 0 then										--TAKING FULL COUNT OF SOURCE OBJECT
					if _BinRM and _BonAU then
						tMap.auLeg[ _BiAu ].count = tMap.auLeg[ _BiAu ].count + _tbl.count
						table.remove( tMap.rms[ _idx ].rObj, _BiRm )
					elseif _BinRM and not _BonAU then
						table.insert( tMap.auLeg, _tbl )
						table.remove( tMap.rms[ _idx ].rObj, _BiRm )
					end
				elseif _zeroOut > 0 then
					if _BinRM and _BonAU then
						tMap.rms[ _idx ].rObj[ _BiRm ].count = _zeroOut
						tMap.auLeg[ _BiAu ].count = tMap.auLeg[ _BiAu ].count + _count
					elseif _BinRM and not _BonAU then
						tMap.rms[ _idx ].rObj[ _BiRm ].count = _zeroOut
						_tbl.count = _count
						table.insert( tMap.auLeg, _tbl )
					end
				end
				return true
			end
				-- *** CHECK NESTED <OPENED> AUTHOR 1st FOR OBJ-B ***
			return false
		end
	
	elseif _target == "objDrop" then	--CAN OBJ BE TAKEN, SORT BOTH OBJ COUNTS
		function _table:objDrop( _objB, _count, _objA )
			if _objA == nil then _objA = "" end
			local _idx = tMap.rms.idx
			local _bFLAG = false
			local _tbl = {}		--ALL MONKEYS ARE THE SAME UNTIL THIS ONE MONKEY TABLE-LINK DIES
			local _BonAU, _BiAu = self:objAuEXISTS( _objB )	--A = NIL 
			local _BinRM, _BiRm = self:objRmEXISTS( _objB )
			local _BonAUN, _BiAuN, _, 		_AonAU, _AiAu = self:objAuEXISTS( _objB, _objA )
			local _BinRMN, _BiRmN, _tick, _AinRM, _AiRm = self:objRmEXISTS( _objB, _objA )
			if not _BonAUN and not _BinRMN then
				_AonAU, _AiAu, _ = self:objAuEXISTS( _objA )
				_AinRM, _AiRm, _ = self:objRmEXISTS( _objA )
			end
			local _zeroOut = 0
			--ACCOUNT FOR HIDDEN SO NO-TAKE AND NO-DROP OPTION EXISTS AGAIN AS BEFORE
			if _AonAU and not tMap.auLeg[ _AiAu ].objUNTAKE then
				_tbl = self:tblClone( tMap.auLeg[ _AiAu ] )	--COPY OF OBJECT TO BECOME DEAD-PARENT
				_zeroOut = tMap.auLeg[ _AiAu ].count -_count
				if _zeroOut <=0 then
					if _AonAU and _AinRM then
						tMap.rms[ _idx ].rObj[ _AiRm ].count = 
						tMap.rms[ _idx ].rObj[ _AiRm ].count + tMap.auLeg[ _AiAu ].count
						table.remove( tMap.auLeg, _AiAu )
					elseif _AonAU and not _AinRM then
						table.insert( tMap.rms[ _idx ].rObj, _tbl )
						table.remove( tMap.auLeg, _AiAu )
					end
				elseif _zeroOut > 0 then
					if _AinRM and _AonAU then
						tMap.auLeg[ _AiAu ].count = _zeroOut
						tMap.rms[ _idx ].rObj[ _AiRm ].count = tMap.rms[ _idx ].rObj[ _AiRm ].count + _count
					elseif _AonAU and not _AinRM then
						table.insert( tMap.rms[ _idx ].rObj, _tbl )
						_AiRm = #tMap.rms[ _idx ].rObj
						tMap.auLeg[ _AiAu ].count = _zeroOut
						tMap.rms[ _idx ].rObj[ _AiRm ].count = _count
					end
				end
				return true
			elseif not _AonAU and #tMap.auLeg >0 then		-- *** NOT onAU BUT OBJ MIGHT BE IN-CONTAINER ***
				for a=1, #tMap.auLeg do
					if #tMap.auLeg[ a ].oBag >0 and tMap.auLeg[ a ].objOPENED then
						for b=1, #tMap.auLeg[ a ].oBag do
							if tMap.auLeg[ a ].oBag[ b ].label == _objA then
								_zeroOut = tMap.auLeg[ a ].oBag[ b ].count -_count
								if _zeroOut <= 0 then
									if _AinRM then
										tMap.rms[ _idx ].rObj[ _AiRm ].count = 
										tMap.rms[ _idx ].rObj[ _AiRm ].count + tMap.auLeg[ a ].oBag[ b ].count
									else
										_tbl = self:tblClone( tMap.auLeg[ a ].oBag[ b ] )
										_tbl.count = tMap.auLeg[ a ].oBag[ b ].count
										table.insert( tMap.rms[ _idx ].rObj, _tbl )
									end
									table.remove( tMap.auLeg[ a ].oBag, b )
								elseif _zeroOut >0 then
									if _AinRM then
										tMap.rms[ _idx ].rObj[ _AiRm ].count = tMap.rms[ _idx ].rObj[ _AiRm ].count +_count
										tMap.auLeg[ a ].oBag[ b ].count = _zeroOut
									else
										_tbl = self:tblClone( tMap.auLeg[ a ].oBag[ b ] )
										_tbl.count = _count
										table.insert( tMap.rms[ _idx ].rObj, _tbl )
										tMap.auLeg[ a ].oBag[ b ].count = _zeroOut
									end
								end
								return true
							end
						end
					end
				end
			end
		return false
		end
	elseif _target == "playerstart" then
		function _table:playerstart( _rmNum )
			local _EXISTS,_, _map4D, _idx = isRmInSTORY( _rmNum )
			--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
			if _EXISTS then				--SWITCH ROOMS
				tRetro:switchRoom( _map4D )
			elseif not _EXISTS and ( tMap.hPlayerStart == "R0" or tMap.hPlayerStart == "0" ) then
				local _rndRmNum = math.random( 1, #tMap.rms )	--RANDOM ONLY AVAILABLE ROOMS
				_EXISTS,_, _map4D, _idx = isRmInSTORY( tMap.rms[ _rndRmNum ].rRoomNum )
				--_mapEXISTSB, _rmNumB, _mapB, _rmIdxB
				tRetro:switchRoom( _map4D )
			end
		end
	elseif _target == "setAu" then	--CAN OBJ BE TAKEN, SORT BOTH OBJ COUNTS
		function _table:setAu( _name )
			if #_name > 0 then
				tMap.hAuthor = _name
			end
		end
  end
end