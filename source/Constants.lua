--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
(13 Month BUILT-IN CALENDAR WOULD BE NICE)
Larger Consciousness System Text Adventure Style with Remote Viewing Number Storage
"Retro1984 - Event PlayBk ReCorder" as my fun idea of an Educational Retro-Terminal for
evidental History with lowest memory cost not unlike a RV# metal plate if it couldn't rust...
Source code will fit on a floppy 3.5" floppy disk, and so far this is true.
Coding started the day after a kid ran out onto the road in front of me traveling
to pick up my wife from her graveyard shift. You want more! Dig through the RV#s
and if you are at all lucky i will have the story data ready at some point as evidence!
**************************************************************************************************
*											NOTICE-LAW-OF-WORD-&-SIGNS-ARE-AS-FOLLOWS															 *
* This source-code/software CAN-NOT-BE-TAXED, nor the mapped events/source-code data				 *
* CAN-NOT-BE-TAXED. Unless the CANADA-GOVERNMENTS is willing to pay damages to the 					 *
* harm done	to i (Brian) in the past, where RV# events clearly show GOVERN-MENT-AGENTS  		 *
* HAVE-CAUSED-HARM exist many many times over - Again look into the Remote-Viewing #s.  		 *
* I have worked 7-days a week for years freely, no pay to show the world what kind					 *
* of water corruption exist on land. Without the LCS allowing for others to look back				 *
* at actual events as if bookmarks in time, all this coding would have been a waste of time! *
* Thank you LCS for your existance and patience as a teacher. May the IN-GOD-WE-TRUST				 *
* (Grant Of Dominion) come to end its corrupt waring business model in earths future. May		 *
* people of any planet live sanity with love, without war, without pretending to need				 *
* war for the sake of making moneys, so unloving FICTIONS can go fishing on a dead planet.	 *
**************************************************************************************************
NOTICE: Art folder/directory contain copyright art by Chuck, which is i Brian T.Wilcox UCc1-308 since the mid or late 1980's, which may ONLY be used within this source code/program archive supplied by myself. Again email above if needed...
NOTICE: NO-DOG-LATIN-USED-WITHIN-GNU-LICENSE, means this license has no current or commonly use CODE-SYNTAX-OF-LEGAL-CORRUPTION; thus can be applied Lawfully regardless of any FOREIGN-CORRUPTION;
For more information about GLOSSA/ASL, pg 665-666 of 17th Edition of "The Chicago Manual of Style", Section 11, Subsection 128 [ 11.128 ]
program(s) /source code is authors python code remake with Love2D code 2019-2026. with the exception of files in /fonts - that's not the authors creation.

LICENSE;
This source code is free software code in files:
main.lua and files in source
folder/directory ending in .lua namely;
conf.lua, main.lua, RVnumbers.lua, Art.lua, Constants.lua, Keyboard.lua, Menus.lua,
StateMachine.lua, Booleen.lua, Draw.lua, Loops.lua, Shape.lua, TA-cmds.lua,
Colour.lua, Filesystem.lua, Memory.lua, Sound.lua

you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, version 3.
This source code is distributed in the hope that it will be useful,
but WITHOUT-ANY-WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS-FOR-A-PARTICULAR-PURPOSE. See the GNU General Public License for
more details.
You have received a copy of the GNU General Public License along with this source code.

tMap.deadTypist.idx		--AUTOBUILD OUR 
tMap.tw
]]

reVision = "A.3.025"
--  SCREEN SIZE & TESTING SCREEN SIZE - thus must scale
love.graphics.setDefaultFilter( "nearest", "nearest" )
love.window.setFullscreen( false, "desktop" )  --DEFAULT true RUNNING MODE FOR THIS EDUCATIONAL GAME
love.window.setTitle( "Retro1984 - An Event PlayBack Recorder - RV# EVIDENTIAL DATA TEXT-ADVENTURE STYLE - " .. reVision )
love.window.display = 1	--SCREEN # TO DISPLAY ON...
love.hasDeprecationOutput( false )
dtCounter = love.timer.getDelta()   --can't seem to work dt without this one liner
-- *** GLOBAL STORAGE TABLE ***
tPortHole = {}   --FOR OUR SCREEN SIZES TO BE MORE PORTABLE
tMap = {}
tMenu = {}
--TIME TO SEPERATE ALL THE BUILD IN FUCTIONS ETC FROM THE MAPS STORAGE SETTING
tRetro = { libRVnums = { idx =0 ,
	"0C18-DE38","F015-EEBF","DF76-C79F",	--1st TABLET FOUND
	"2066-1F3D","1FC3-F386","2EB0-260E",	--2nd TABLET FOUND
	--3rd TABLET ETC...
	"7154-99A0","C90F-3B50","525D-2044","054B-FBED",
	"1DAC-35F0","907C-F31F","FAF9-A5B3","BB25-6458","34E3-0934","B04A-86B5","97AC-D30C","90D7-58D4",
	"A56A-53E4","CE26-132C","405A-4954","D139-AB26","237D-C965","A06F-D2E7",
	"CD4D-8696","830D-0901","1594-823B","6AF3-4CED",	--END OF GRAPHICAL SNAPSHOT
	"3RCF-FT11","65FF-A545","980D-8A53",
	"2F4B-8D2E","E360-35AD","79B4-0E1B","0E4B-9C46","A80D-D3D6","774F-25BA","7F98-174E","786B-0A8F",
	"09F1-2F95","CE7B-A432","BE77-2357","E944-4547","9138-F125","A645-E15B","5C0C-BDF5","C9FE-1C66",
	"F6D7-C7C4","E9F8-E7D8","6AA7-148D","F1C8-B5FB","752D-4A96","9B9D-4B88","53B1-5CE4","C831-CD05",
	"FB4F-6946","F494-85A2","01DB-F784","197C-A7DF","3736-60D5","2A2C-BBFF","1961-C467",
	"42B2-AE53","0E98-10A0","8561-AAA2","8C36-B401","1EBB-2614","5F6E-9EFB","E14F-0F59","407F-0E95",
	"587F-4F10","8E32-1418","A8D1-A997","B368-DCFD","5DD8-31E9","3705-E4BE","4FBF-7589",
	--DMG
	"VU25-MIA7",
	--BL
	"G7N3-L2H8","1306-9731",
	--FF
	"K4A6-M3X8" } }