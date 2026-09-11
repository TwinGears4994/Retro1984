--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
function chkRVnumFStoReport()	--"DUMY-FILE" FOLDER FOR TESTING
	local _MATCH = false
	local _report = {}
	local _filename, _rvNum = nil,nil
	for a =1, #tMap.eventsA do
		_filename, _rvNum = isFileNameRV( tMap.eventsA[a] )
		if #_rvNum >0 then
			for b =1, #tRetro.libRVnums do
				if tRetro.libRVnums[b] == tMap.eventsA[a] then
					_MATCH = true
				end
			end
		end
		if #_rvNum >0 and not _MATCH then
			table.insert( _report, tMap.eventsA[a] )
		end
		_MATCH = false
	end
	--FEEDBACK ON-SCREEN TO USER
	if #_report >0 then
		table.insert( tPortHole.eccoDisplayBuff, " *** Extra RV#s in filesytem found:" )
		for c =1, #_report do
			table.insert( tPortHole.eccoDisplayBuff, " ".. _report[c] )
		end
		table.insert( tPortHole.eccoDisplayBuff, " & could be sent to TwinGears@gmail.com *** " )
	end
end

function newRVnum()
	--OTHER PLANETS WITH SAME CORRUPT ISSUES WILL MAKE RV# TO WHAT EVER WORKS BEST FOR THEM
	local _tbl36 = { "0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F", --HEX16
		"G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z" }
	local _word = ""
	while _word == "" do
		for i =1, 8 do
			--if tStory.RVnums.holdAu == 242 then
			_word = _word .. _tbl36[ math.random( 1, 36 ) ]
			--end
		end
			--_word = string.sub( _word, 1, #_word -1 )
			--LETS CHECK AND MAKE SURE IT'S NOT APART OF OUR LIBRARY OF RV# CURRENTLY...
		if #tRetro.RVnums >0 then
			for a =1, #tRetro.RVnums do
				if tRetro.RVnums[ a ] == _word then
					_word = ""
					break
				end
			end
		end
	end
	table.insert( tMap.RVnumsChoice, _word )
	tMap.RVnums.idx = #tRetro.RVnumsChoice
end

function curency()
	local num = 0
	local text = ""
	while #newNum1 < 3 do
		num = math.random(1,16)
	end
	return
end