--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
--function keyloginput( _char )
--    tStory.keylog = tStory.keylog .. _char
--end

function loop0()
  if tSM.curState == "FS-INIT" then	--l0[ tSM.idxState ]
    setAuthRootPath( "retro84" )            --"RV-Stories"
		tMap:setStoryMap()					--ONLY CMDS AND BUILD IN FUNCTIONS EXIST OTHER WISE YET
		--updateRVlibrary()						--NOW APART OF tMap:setStoryMap()
		tMap:setNewMap( nil,nil )		--ROLL OUT THE OTHER MEMORY SETTING THAT WILL BE NEEDED...
    tSM:walk( true )
  end
end

function loop1()
  if tSM.curState == "LIST-AUTHORS" then	--l1[ tSM.idxState ]
    tMap.authors = listAuthors()
    if #tMap.authors == 0 then   --NO AUTHORS - CREATE ONE
      tSM:walk( false )          --FALL BACK TO "NEW-AUTHOR"
    else
			tMap.keylog = ""
      tSM:walk( true )           --"SELECT-AUTHOR"
    end
  end
end

function loop2()
  if tSM.curState == "LIST-EVENTS" then -- and dtCounter > waitTime then l2[ tSM.idxState ]
    tMap.eventsA = listAuEvents( tMap.hAuthor )
    if #tMap.eventsA == 0 then   --NO STORY - CREATE ONE
      tSM:walk( false )          --FALLING FORWARD TO "NEW-EVENT"
    else
			tMap.keylog = ""
			--SET THE CLOCK ROOM OBJECT TIMER TO DEFAULT ON, LOAD STORY UPDATE THAT AS DEFAULT FROM FILE
      tSM:walk( true )           --"SELECT-STORIES"
			tMenu.menuPointerIdx = tMap.eventsA.idx	--tSM WALK KNOCKS THIS OUT SO SET OUR DEFAULT TO DISPLAY
    end
  end
end

function loop3( dt )
	-- *** RESET 1/10sec DELTA-TIME MINUS WHAT WAS EXTRA ***
	tMap.rmDeltaTime = tMap.rmDeltaTime + dt
	if not tMap.deadTYPIST and tMap.rmDeltaTime >= .1 then	--TIMING 1/10th SECOND
		if tMap.rmDeltaTime >1 or tMap.rmDeltaTime == 0 then	--SHOULDN'T HAPPEN BUT JUST IN CASE COMPUTER CAN'T KEEP WITH WITH 1/10th TIMING
			tMap.rmDeltaTime = 0		
		elseif tMap.rmDeltaTime > .1 then
			tMap.rmDeltaTime = tMap.rmDeltaTime -.1							--ADJUST THE DIFFERENCE
		end
		tMap.oneTenthSEC = true
		tMap:ticToc()
	end
	local _bFLAG = false
	if tSM.curState == "LCS-TA" then			--l3[ tSM.idxState ]
		--PER-SECOND FOR BOARDER UPDATE
		if tMap.oneSEC then
			tPortHole:updateBdrColour( tMap.cmdsKeyLog )	--ROTATE 1st ERROR COLOUR
			tMap.oneSEC = false
		end
		-- *** DEAD-TYPIST LOOP ***
		if tMap.deadTYPIST then
			--NEED TO CREATE OUR 1st ROOM TO GIVE MAP A STARTING POINT TO WORK WITH
			for a = 1, #tMap.hDeadTypist do		--ANIMATE OUR DEAD-TYPIST
				tMap.keylog = tMap.hDeadTypist[ a ]	--DON'T load FROM HERE, GHOST TW IN PLAY MODE AS BEFORE
				if a == 23 and tMap.fileName == "Meditation Space" then	--ADDING TIC-TOC 1980s EXERCISE TO FILE SOON
					fu = nil											--GIVING MYSELF A LINE TO TARGET IN SPECIFIC FILE BEING TESTED
				end
				if tPortHole.BBON then			--AUTOMATIC <RETURN>
					love.keypressed( "return" )		--AUTOMATED <RETURN> IF BUILD-MODE-ON & IN-FILE
				end
				if a == #tMap.hDeadTypist then	--LAST LINE TO PROCESS
					tMap.deadTYPIST = false
					tMap.hDeadTypist = { idx =1, iChar =1 }	--UNLOADING LOADED FILE DATA
					chkRVnumFStoReport()					--FEEDBACK ON-SCREEN IF RV# ISN'T IN LIBRARY
					removeDeadCount()							-- *** REMOVE OBJS.count == 0 FROM TABLES ***
					addGhostTW()									-- *** GHOSTS ARE BACK AGAIN ***
					tPortHole:bb( false )					--MAYBE ALREADY OFF AND THAT'S OKAY
				end
			end
			-- *** TIMING LOOP ***								MEANS DEAD-TYPIST HAS BEEN LOADED, RUN & RETIRED
		elseif tMap.oneTenthSEC then				-- *** 1/10th SECOND ***
			_bFLAG = allTWtimerChk()					--WHEN THE DEAD-TYPIST IS DONE *** TW-TIMER CHECK ***
			if _bFLAG or tPortHole.eccoDisplayRndComm.RND or tPortHole.eccoDisplayBuff.GO then
				removeDeadCount()
				-- *** FEED THE BUFFER FOR THE USER FEEDBACK LOOP ***
				if tPortHole.eccoDisplayRndComm.RND then
					tPortHole:runRndCommPicker()	--local _buffRND = 
				end
				--CHECK FOR OPEN OBJECTS AND ALLOW FOR IN-ROOM TEXT
				if tPortHole.eccoDisplayBuff.GO then
					tMap:objlistOPENED()					-- *** DISPLY THE OPEN HIDDEN ITEMS FOR DISPLAY WITH .."/n" ***
				end
			end
			tMap.oneTenthSEC = false
			--tPortHole:adjustRetroTerm()	--ALINE BOXES WITH CURRENT DATA	runCharWideAdjust()
			-- *** AUTOMATED DEAD-TYPIST, TIMING SPEED PER <KEY> ***
		end
		-- *** GLASSES FOR DDMT2 *** WOULD ALSO BE FROM HERE AS IN-GAME FEELING, "use OBJ" CMD
		--BEST TO ADD THE GLASSES STATE TO LOOP3 END AND DRAWSTATE LIST
  elseif tSM.curState == "MENUS" then		--l3[ tSM.idxState ]
		if tMenu.menuPointerIdx > 2 and tPortHole.drawMENU then			-- #.OBJ <LEFT> TO SPECIFIC PARTS
			tMenu.tEditLine.location = tonumber( tMenu.tRmAu.menuIdx .. tMenu.tMenuPOTT.menuIdx )
		end
	--elseif tSM.l3[ tSM.idxState ] == "GLASSES" then	--screen or screen #, extension cord on glasses
		--no wireless, retro is fine by me, thus wireless for just www on and off is better		--tMenu.tEditLine.location and 
		--STORIES DON'T NEED ONLINE, MAYBE ONE DAY THE GAME WILL ONLY NEED TO BE ONLINE FOR RV# PATTERNS, VERS AVAILABLE
	end
end