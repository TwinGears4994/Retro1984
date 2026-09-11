--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
--dir = love.filesystem.getSaveDirectory( ) .. "/"
--t.identity = "SWoE"
--file = love.filesystem.file("ScoreBoard.retro84")   --file:open("r") didn't error! file:write & file:close
function isFileNameRV( _fileName )	--9 CHARACTERS LONG WITH "-" AS 5 CHARACTER
	local _nineLONG = false
	local _dashFIVE = false
	local _ = ""
	if _fileName and #_fileName == 9 then
		_nineLONG = true
	end
	if _fileName and string.find( _fileName, "-", 1 ) == 5 then
		_dashFIVE = true
	end
	if not _fileName then
		return _,_		--FAILED FILENAME
	elseif _nineLONG and _dashFIVE then
		return _, _fileName
	else
		return _fileName, _
	end
end

function isAuthor( _author )
	for a =1, #tMap.authors do
		if tMap.authors[ a ] == _author then
			return true, a
		end
	end
	return false, 0
end

function isFile( _A, _filename )
	if not _A then
		for b =1, #tMap.eventsB do
			if tMap.eventsB[ b ] == _filename then
				return true, b
			end
		end
	else
		for a =1, #tMap.eventsA do
			if tMap.eventsA[ a ] == _filename then
				return true, a
			end
		end
	end
	return false, 0
end

function listAuthors()			--love.filesystem.getSaveDirectory()
	--setAuthRootPath( "retro84" )
  love.filesystem.setIdentity( "retro84/" )
	local _tbl = love.filesystem.getDirectoryItems( "Authors/" )
	love.filesystem.setIdentity( "retro84/Authors/" )	--FINAL PATH
	_tbl.idxA = 0		--OTHER WISE WE LOOSE OUR idxA 
	_tbl.idxB = 0		--& idxB
	return _tbl
end

function listSounds( _flow, _author, _fileName ) -- _author, _fileName )
	setAuthRootPath( _flow, _author, _fileName )
  tMap.sounds = love.filesystem.getDirectoryItems( "Sounds/" )
end

function listImages( _flow, _author, _fileName )
	setAuthRootPath( _flow, _author, _fileName )
  tMap.images = love.filesystem.getDirectoryItems( "Images/" )
end

function listVideos( _flow, _author, _fileName )
	setAuthRootPath( _flow, _author, _fileName )
  tMap.videos = love.filesystem.getDirectoryItems( "Videos/" )
end

function setAuthRootPath( _flow, _author, _fileName )	
  if _flow == "retro84" then
		love.filesystem.setIdentity( "retro84/" )					--NEW ROOT FOLDER WORKING
		local _tbl = love.filesystem.getDirectoryItems( "Authors" )		--love.filesystem.getInfo("Authors")
		if not _tbl then
			love.filesystem.createDirectory( "Authors" )		--WORKS WELL IF NO ./retro84/Authors/
		end
    love.filesystem.setIdentity( "retro84/Authors/" )	--FINAL PATH
	elseif _flow == "AU" and #_author >0 then
		love.filesystem.setIdentity( "retro84/Authors/".. _author .."/" )
	elseif _flow == "S" and #_author >0 and #_fileName >0 then
		love.filesystem.setIdentity( "retro84/Authors/".. _author .."/".. _fileName .."/Sounds/" )	
	elseif _flow == "I" and #_author >0 and #_fileName >0 then	--IMAGES / SOUNDS/ VIDEOS LIKELY WILL BE REMOVED...
		love.filesystem.setIdentity( "retro84/Authors/".. _author .."/".. _fileName .."/Images/" )
	elseif _flow == "V" and #_author >0 and #_fileName >0 then
		love.filesystem.setIdentity( "retro84/Authors/".. _author .."/".. _fileName .."/Video/" )
  elseif #_author >0 and #_fileName >0 then
    love.filesystem.setIdentity( "retro84/Authors/".. _author .."/".. _fileName .."/" )	--AUTHOR-NAME
  end
end

function createDir( _typed )
	love.filesystem.createDirectory( _typed )
end

function createFSEvent( _author, _fileName, _fnFOLDER )
	if not _fnFOLDER and #_fileName > 0 then
		setAuthRootPath( "AU", _author, _fileName )
		createDir( _fileName )
		
	end
  if #_fileName > 0 then
		setAuthRootPath( "else", _author, _fileName )
		--love.filesystem.setIdentity( "retro84/Authors/" .. _author .."/" .. _fileName )
		love.filesystem.createDirectory( "Images" )
		love.filesystem.createDirectory( "Sounds" )
		love.filesystem.createDirectory( "Videos" )
    file = love.filesystem.newFile( _fileName ..".retro84" )
    file:open( "w" )		--ONLY NEEDED FOR FILE WORK NOT DIRECTORY WORK
    file:close()				--GOING TO LEAVE THE PATH AS MAP MAY NEED TO SAVE TO DISK
  end
end

function listAuEvents( _author )  --RETURN AN AUTHOR LIST OF STORIES
	--FILTER OUT THE FOLDERS OF Images & Sounds FROM OUR AUTHORS STORIES
	--setAuthRootPath( "retro84", _author )		--_flow, _author, _fileName
	love.filesystem.setIdentity( "retro84/Authors/" )
	local _table = love.filesystem.getDirectoryItems( _author )
	_table = sortGlossaFirst( _table )	--GLOSSA BECOME HELPFUL FOR USER TO SEE MASTER-KEY FILE
  
	--IF MASTER-FILE IS MISSING WE WILL CREATE IT
	if _table[1] ~= tMap.masterFileName then
		createFSEvent( _author, tMap.masterFileName, false )
		--FRACTAL CODE LOOP POINTING AT SELF WORKS, THAT'S FUN ONLY BECAUSE IT WORKS
		_table = listAuEvents( _author )
	end
	return _table
end

function sortGlossaFirst( _events )
	local _thirdLeg = nil
	local _count = 1
	local _a = 1
	--MASTER FILE GOES BEFORE GLOSSA FOR GOOD REASON!
	for _b = 1, #_events do	--CHECK FOLDER NAMES FOR MASTER-FILE
		if _events[ _b ] == tMap.masterFileName then	--"Master File"
			_thirdLeg = _events[ _b ]
			table.remove( _events, _b )
			table.insert( _events , _count, _thirdLeg )
			_events.idx = _count	--IDX GETS KICKED OUT WHEN NEW TABLE RETURNS OTHER WISE
			_count = _count +1
			_a = _count
			break
		end
	end
	while _a <= #_events do
		if _events[ _a ] == string.upper( _events[ _a ] ) then --and _a ~= 1 then
			_thirdLeg = _events[ _a ]
			table.remove( _events, _a )
			table.insert( _events , _count, _thirdLeg )
			if not _events.idx then _events.idx = _count end
			_count = _count +1
			_a = _count
		else
			_a = _a +1
		end
	end
	if not _events.idx then _events.idx = 1 end	--NEW-EVENT SELECTED
	return _events
end

function chkFileZero( _author, _fileName ) --CHECK IF STORY FILE EXISTS [modtime, size, type]
  setAuthRootPath( "retro84" )	--SETS UP /retro84/Authors/	--"Authors/" ..
	local _tblFolder = love.filesystem.getInfo( _author .."/".. _fileName .."/" ) or { type = "fail" }
	local _tblFile = love.filesystem.getInfo( _author .."/".. _fileName .."/".. _fileName ..".retro84" ) or { type = "fail" }
  local _fnFOLDER, _FILE = false, false
	if _tblFolder.type == "directory" then _fnFOLDER = true end
	if _tblFile.type == "file" then
		_FILE = true
		return _fnFOLDER, _FILE, _tblFile.size
	else
		return _fnFOLDER, _FILE, -1
	end
end
--WOULD LIKE TO BE ABLE TO HAVE COMMENTS PER-LINE, NOT TO BE SAVED LATER,
--BUT NOT ERROR DATA WHEN LOADING PER-LINE OF A HISTORICAL OR HELPFILE...
function eventFileLoad( _author, _fileName )
	setAuthRootPath( "else", _author, _fileName )
	local _tbl = { idx =1, iChar =1 }
	local _line = nil
	for _line in love.filesystem.lines( _fileName ..".retro84" ) do
		if #_line >0 then 	--SKIP EMPTY LINES
			table.insert( _tbl, _line )
		end
	end
	if #_tbl >0 then
		--SWITCH TO PLAY MODE
		if tPortHole.BBON then tPortHole:bb() end
		--tMap.fileName, tMap.hRVnum = isFileNameRV( _fileName )
		tMap.fileName = _fileName
		tMap:setNewMap( _author, _fileName )
		tRetro:rmCreate( _fileName,"R1",{ m =0, x =0, y =0, z =0 },nil )
		tMap:ticToc( true )	--,HH:MM:SS:DD
		tMap.hDeadTypist = _tbl
--		listSounds( "S", _author, _fileName )
--		listImages( "I", _author, _fileName )
--		listVideos( "V", _author, _fileName )
		tMap.keyLogDROPIT = true
		return true		--FEEDS tMap.deadTYPIST
	end
	return false
end

function eventFileSave( _author, _fileName )	--MISSING ANY PARTS BEFORE SAVE?
	if #tMap.tKeyLogHistory >0 and #_fileName >0 then
		--keyLogCmdCheck()
		keyLogInjectCmds()	--RUNS keyLogCmdClean()
		setAuthRootPath( "else", _author, _fileName )
		file = love.filesystem.newFile( _fileName ..".retro84","w" )--WITHOUT THE "w" IT BECOME APPEND
		file:open( "w" )			--ONLY NEEDED FOR FILE WORK NOT DIRECTORY WORK
		for a =1, #tMap.tKeyLogHistory do
			--WE ARE NOT RECORDING THE SAVE OR SINGLE LOAD CMD
			--love.filesystem.write( _fileName ..".retro84", tMap.tKeyLogHistory[ a ] .."\n" )
			love.filesystem.append( _fileName ..".retro84", tMap.tKeyLogHistory[ a ] .."\n" )
		end
		file:close()				--GOING TO LEAVE THE PATH AS MAP MAY NEED TO SAVE TO DISK
		return true
	end
	return false
end