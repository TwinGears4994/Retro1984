--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
LETS BEGIN TO PLACE FUNCTIONS INTO TABLES, THUS AUTOMATE THE STATE MACHINE BETTER
tSM.idxLoop
tSM.idxState
tSM.curState
tSM.idxDState
tSM.curDState
tMenu.menuPointerIdx
tMenu.tMenuObjs.mOBJS
tMap.user3rdLeg.idx = tMenu.menuPointerIdx -2
tMap.rms[ tMap.rms.idx ].rObj.idx = tMenu.menuPointerIdx -2
tMap.tKeyLogHistory.idx
]]
tSM = {
  idxLoop = 0,
  curState = "FS-INIT",--"LIST-AUTHORS",   --INDEX WITHIN THE ONE OF THE abcde Loops
  idxState = 1,     --START AT "LIST-AUTHORS"
  l0 = { "FS-INIT" },
  l1 = { "NEW-AUTHOR","LIST-AUTHORS","SELECT-AUTHOR" },
  l2 = { "NEW-EVENT","LIST-EVENTS","SELECT-EVENT" },
  l3 = { "LCS-TA","MENUS","GLASSES" }
}	--MENUS NEED ALL ARROWS AND NUMBERS

function tSM:walk( _FORWARD )
	if _FORWARD then
		if self.idxLoop == 0 then
			self.idxLoop = 1
			self.idxState = 2											--NEW START POSITION
			self.curState = self.l1[ self.idxState ]	--UPDATE DRAW STATE
		elseif self.idxLoop == 1 then
			if self.idxState < #self.l1 then
				self.idxState = self.idxState +1
				self.curState = self.l1[ self.idxState ]
			else
				self.idxLoop = self.idxLoop +1
				self.idxState = 2										--NEW START POSITION
				self.curState = self.l2[ self.idxState ]
			end
		elseif self.idxLoop == 2 then
			if self.idxState < #self.l2 then
				self.idxState = self.idxState +1
				self.curState = self.l2[ self.idxState ]
			else
				self.idxLoop = self.idxLoop +1
				self.idxState = 1
				self.curState = self.l3[ self.idxState ]
			end
		elseif self.idxLoop == 3 then
			if self.idxState < #self.l3 then
				self.idxState = self.idxState +1
				self.curState = self.l3[ self.idxState ]
			end
		end
	elseif not _FORWARD then
		if self.idxState >= 2 then
			self.idxState = self.idxState -1
		elseif self.idxState == 1 and self.idxLoop >1 then
			self.idxLoop = self.idxLoop -1
		end
		if self.idxLoop == 1 then
			self.curState = self.l1[ self.idxState ]
		elseif self.idxLoop == 2 then
			self.curState = self.l2[ self.idxState ]
		elseif self.idxLoop == 3 then
			self.curState = self.l3[ self.idxState ]
		end
	end
	tMenu.menuPointerIdx = 0
end