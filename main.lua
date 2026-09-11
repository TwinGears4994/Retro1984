--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
math.randomseed( os.time() )    --RATHER IMPORTANT
utf8 = require("utf8")

function love.load( arg )
  if arg[ #arg ] == "-debug" then         --debugger for ZeroBrane
    require("mobdebug").start()
  end
  require 'source.Constants'
  require 'source.StateMachine'
  require 'source.Filesystem'
  require 'source.Memory'
  require 'source.Loops'   --funcInject2() lives here
  require 'source.Draw'
  require 'source.Keyboard'
  require 'source.TA-cmds'
	require 'source.Menus'
	require 'source.Sound'
	require 'RVnumbers'
	--fPortHoldInject MEMORY CONTAINER LOOP THROUGH SUB-FUNCTIONS
	fPortHoleInject( tPortHole,"setGUIvars" )
	tPortHole:setGUIvars()
	
	--fPortHoleInject( tPortHole, "objGhostUpdate" )
	fPortHoleInject( tPortHole, "runRndCommPicker" )
	--fPortHoleInject( tPortHole, "listOPENEDobj" )
	fPortHoleInject( tPortHole, "bb" )								--build mode shifting about
	fPortHoleInject( tPortHole, "updateBdrColour" )
	
  --POPULATE SOUND STORAGE CONTAINERS - July 2026 RE-CODING
	
	-- tMap BUILT-IN FUNCTIONS
	funcMapInject( tMap, "setStoryMap" )		--CARRIES AUTHORS 3rd-LEG FROM MAP TO MAP
	funcMapInject( tMap, "setNewMap" )
	funcMapInject( tMap, "ticToc" )		--funcInject2
	funcMapInject( tMap, "objlistOPENED" )
	
	-- tRetro BUILD-IN FUNCTIONS
	funcInject( tRetro, "setPlayCmds" )
	funcInject( tRetro, "setBuildCmds" )
	funcInject( tRetro, "setCustomCmds" )
	
	--tRetro:setStoryMap()		--THIS REALLY SHOULD BE IN THE STATE-MACHINE
	tRetro:setBuildCmds()
	tRetro:setPlayCmds()
	tRetro:setCustomCmds()

--	funcInject( tRetro, "reSetRooms" )			--JUST FOR tRetro.rms
	
  funcInject( tRetro, "rmCreate" )						--*
	funcInject( tRetro, "rmNumEXISTS" )				--*
	funcInject( tRetro, "rmDel" )							--
	funcInject( tRetro, "rmAddExit" )					--ADDING EXIT TO TABLE EXITS
	funcInject( tRetro, "rmDelExit" )					--DELETE EXIT FROM TABLE EXITS
--	funcInject( tRetro, "rmZeroRndNearist" )		--
	funcInject( tRetro, "rmlabel" )						--ROOM LABEL
	funcInject( tRetro, "nextRoomMap4D" )			--*
	funcInject( tRetro, "nextRoomNum" )				--*
	funcInject( tRetro, "switchRoom" )					--*
	funcInject( tRetro, "valPlus" )
	funcInject( tRetro, "tblAvg" )
	funcInject( tRetro, "tblClone" )						--GOOGLE AI HELP CODE TO MAKE SEPERATE TABLE YET COPY OF
	funcInject( tRetro, "tblMapCompare" )
	funcInject( tRetro, "objRmEXISTS" )					--* ROOM OBJECT CHECK
	funcInject( tRetro, "objAuEXISTS" )					--* ON-AUTHOR OBJ
	funcInject( tRetro, "objCrt" )							--ON-AUTHOR & IN-ROOM
	funcInject( tRetro, "objCrtInObj" )				--CREATE OR MOVE AN OBJECT INSIDE AND OBJECT
	funcInject( tRetro, "objTakeFromObj" )				--DELETE OBJECT INSIDE ANOTHER OBJECT
	funcInject( tRetro, "moveItem" )						--FEB 25th we try to bring back moving tables around
	funcInject( tRetro, "objHide" )							--IF OBJ IN ROOM WE DON'T BOTHER WITH ON-AUTHOR...
	funcInject( tRetro, "objDelInRoom" )
	funcInject( tRetro, "objDelOnAuthor" )
	funcInject( tRetro, "objIdxChk" )					--*RESET ANY OBJECT INDEX COUNT
	funcInject( tRetro, "objOnOff" )						--* OBJECTS ON/OFF
  funcInject( tRetro, "objLock" )
	funcInject( tRetro, "objConsume" )					--*
	funcInject( tRetro, "objRename" )					--* rename # obj1 obj2
	funcInject( tRetro, "objTake" )						--*
	funcInject( tRetro, "objDrop" )						--*
	--funcInject( tRetro, "objlistOPENED" )
	funcInject( tRetro, "playerstart" )			--SETS THE PLAYERS START ROOM IF ONE HASN'T JUMPED INTO THE STORY FROM ANOTHER WAY...
	funcInject( tRetro, "setAu" )							--RE-ASSIGN AUTHOR
--	funcInject( tRetro, "objClose" )						--
--	funcInject( tRetro, "objOpen" )						--RETURNS true IF OBJ UNLOCKED ELSE false
  --funcInject( tRetro, "objGlue" )						--NOT IN PLAY NOW
	--tRetro:reset()													--POPULATE TABLE
	--MENUS NOW HAVE THEIR OWN FILE AND MEMORY STORAGE & FUNCTION
	funcInject3( tMenu, "reset" )					
	funcInject3( tMenu, "switch" )					--tMenu.switch
	tMenu:reset()														--POPULATE TABLE
	funcInject3( tMenu, "eccoACEDOXbools" )
	funcInject3( tMenu, "resetACEDOXbools" )
	--funcInject3( tMenu, "addLineON" )
	--funcInject3( tMenu, "editLineON" )
	--funcInject3( tMenu, "copyLineON" )
	--funcInject3( tMenu, "delLineON" )
	--funcInject3( tMenu, "reOrderLineON" )
	funcInject3( tMenu, "delMenusMPointer" )
  --require 'RVnumbers'	--TABLE OF USED REMOTE VIEWING NUMBERS BY ALL AUTHORS WHO CONSENT TO HAVING A NUMBER TO TARGET STORY WITH
  --  love.audio.setVolume(.7)  --.7
  ----  music:setVolume(.5)
  -- *** FONT SETUP ***
  --gameFont = love.graphics.newFont( 'fonts/DejaVuSans.ttf', tPortHole.fontPixSize )
--  gameFontB = love.graphics.newFont( 'fonts/DejaVuSans-Bold.ttf', tPortHole.fontPixSize )
--  love.graphics.setFont( gameFontB )
  --love.keyboard.setTextInput(true)
end

function love:update()  				-- *** TIMING FOR SPEECH LIVES HERE - NARRATOR CAN BE INTURUPTED :) ***
  local dt = love.timer.getDelta()
  if tSM.idxLoop == 0 then 			loop0()                     	--CREATE FILE STORAGE IF NEED BE
  elseif tSM.idxLoop == 1 then 	loop1()												--AUTHORS
  elseif tSM.idxLoop == 2 then 	loop2()												--EVENTS
  elseif tSM.idxLoop == 3 then 	loop3( dt )										--LCS-TA FRONT END
  end
end

function love:draw()  --drawSymbol()  drawCard() drawEoGSB() drawPerTurnSB() --USER ON TOP OF SCOREBOARD LIKE BEFORE, drawHighLightSB( i, _x, _y )
  drawBoarder() --FEEDBACK COLOUR TO WHAT MODE WE ARE IN
  if tSM.curState == "NEW-AUTHOR" then
    drawNewAuthor( tMap.keylog )
  elseif tSM.curState == "LIST-AUTHORS" or tSM.curState == "SELECT-AUTHOR" then
    if #tMap.authors > 0 then
      drawListAuthor( tMap.authors, tMap.keylog )
    end
  elseif tSM.curState == "NEW-EVENT" then --or tSM.curState == "SELECT-EVENT" then
    drawNewEvent( tMap.keylog )
  --  elseif tSM.curState == "NEW-RV#" then
  --    drawNewRV()
  elseif tSM.curState == "LIST-EVENTS" or tSM.curState == "SELECT-EVENT" then
    if #tMap.eventsA > 0 then
      drawListEvents( tMap.eventsA, tMap.keylog )
    end
  elseif tSM.curState == "LCS-TA" then
    dRetroTerm( tMap.keylog )		--DRAW RETRO TERMINAL
	elseif tSM.curState == "MENUS" then
    dRetroTerm( tMap.keylog )
  end
end