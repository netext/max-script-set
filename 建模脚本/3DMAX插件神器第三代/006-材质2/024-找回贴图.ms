(
/* 
	Relinking Bitmaps Script written by Colin Senner - www.colinsenner.com
	for Arnold Imaging, Kansas City, MO

	NOTE: Versions 1.13 and Higher - If "Ignore case" is selected due to the nature of 3dsmax versions 9 and lower,
		the script will execute slower.  Starting with the AVG extentions in max 2008, there is an added native string uppercase
		solution replacing stricmp and a custom function utilizing findItem, which results in faster execution.  To keep this
		script compatible I've left out the max2008 avg extentions till more people catch on to 2008.
	
	version 1.15
	- Support for finding individual maps based on path/name with fn relinkBitmapsFindBitmap
	- Added better user feedback
	- Support for finding "hiding" bitmaps in unwrap_uvw modifiers
		suggestion by Brittnell of scriptspot.com, thanks Britt.
	version 1.14
	- Support for finding Environment Background Images added
	version 1.13
	- Added "ignore case" option
	- Added USER EDITABLE VARIABLES - Allows the user to better customize the default values
*/

--****************************************************************************************--
-- USER EDITABLE VARIABLES  -  for more customized usage
	
-- turn the below to true to enable undo support for the script execution
global uev_default_Undo_on = false
-- turn the below to true to change the default setting for the Ignore Case checkbox
global uev_default_Ignore_case_on = false
-- Change the below to reflect your preferred default browsing directory instead of it always opening to C:\
--	NOTE: replace \ (back slashes) with / (forward slashes), so to change your default browsing directory from
--		So in explorer "C:\Temp" becomes "C:/Temp"
global uev_default_Browse_Directory = "C:/"
-- turn the below to false to change the default setting for Recursive Searches
global uev_default_Recursive_Search_on = true
--****************************************************************************************--
-- DO NOT MODIFY BELOW THIS LINE !!!


-- Closes the previous one if the script is run more than once
if rf != undefined then closeRolloutFloater rf

-- Rollout Definition
global rf				-- Rollout Floater - Main
global rlt_Main			-- Rollout Main    - Missing Bitmaps Window toggle
global rlt_Missing		-- Rollout Missing - holds the information about missing bitmaps
global rlt_QuickPaths   -- Rollout Quick Paths - allows the user to save and get paths stored
global rlt_Search		-- Rollout Search  - holds the search information for the user to pick where to search
global rlt_AddQuickPath	-- Rollout AddQuickPath - Rollout that allows the user to add a new quickpath

-- Variables Definition
global missingMaps=#()				-- Holds the filenames of the missingMaps - index matches missingMapsObjs
global missingMapsObjs=#()			-- Holds the objects which are missing maps - index matches missingMaps
global pathsToSearch=#()			-- Holds the paths the user wants to search
global interactiveModeOn=false		-- Holds the state of InteractiveMode
global iniFile=scriptsPath+"quickpaths.ini"	 	-- Holds the ini filename, saved in the max scripts directory

-- Function Definition
global closeRollout				-- closes rollouts gracefully
global openRollout				-- opens rollouts gracefully
global openRolloutNextTo		-- opens rollouts next to others

global relinkBitmapsFindBitmap -- function for populating the material editor with a string for missing bitmaps
global getMissingMaps			-- retreives missing maps via getClassInstances() function, used only for InteractiveMode OFF
global getMissingMapsObjs		-- retreives missing maps via enumerateFiles()    function, used only for InteractiveMode ON
global getDirsRecursive 		-- gets an array of recursive directories
global getDirectoryFiles		-- gets an array of files in directories
global getPathsToSearch			-- returns the array of all the paths the user wants to search
	
global addmapObj				-- called during enumerateFiles()
global trim_dups				-- two arrays a b, searches array a for duplicates and deletes them in both arrays a b
global trim_dupsOne				-- array a, searches array a for duplicates and deletes them
global lowercase				-- converts strings to all lowercase

global relinkMaps				-- Main function for relinking the bitmaps

global uppercase				-- Function for converting to uppercase

---------------- Functions -------------------
fn closeRollout rlt = (	if rlt.open then destroyDialog rlt )
fn openRollout rlt thewidth theheight = ( if rlt.open == false then createDialog rlt width:thewidth height:theheight )
fn openRolloutNextTo sRlt dRlt thewidth theheight = (
	if dRlt.open == false then (
		local theposx = rf.pos.x
		local theposy = rf.pos.y
		local thenewposx = (sRlt.width+27)+theposx
		createDialog dRlt width:thewidth height:theheight pos:[thenewposx,theposy]
	)	
)

fn relinkBitmapsFindBitmap theString = (
	local bmaps = for b in (getClassInstances BitmapTexture) where matchPattern b.filename pattern:("*"+theString+"*") != false collect b
	
	if bmaps.count != 0 then (
		local matEditNum = 1
		local depMatsFound = 0
		macros.run "Medit Tools" "clear_medit_slots"

		for b in bmaps do (
			for t in (refs.dependents b) where (superclassof t) == material do (
				if matEditNum < 25 then (
					medit.putMtlToMtlEditor t matEditNum
					matEditNum+=1
				)
				depMatsFound +=1
			)
		)		
		local message = "Found " + (depMatsFound as string) + " materials based on \"" + theString + "\"\n\nand loaded them into the material editor."
		if depMatsFound > 25 then message += "\nCould only load 25 materials at once, refine your search if necessary."
		if depMatsFound != 0 then messagebox message beep:false
	) else (
		messageBox "Could not find any bitmap filenames with that string." beep:false
		return false
	)
)

fn uppercase instring = ( 
	local upper, lower, outstring
	upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	lower="abcdefghijklmnopqrstuvwxyz"
	
	outstring=copy instring
	
	for i=1 to outstring.count do ( 
		j=findString lower outstring[i]
		if (j != undefined) do outstring[i]=upper[j]
	)
	outstring -- value will be returned as function result
) -- end of fn uppercase

fn getDirsRecursive root = (
	if root != "" then (
		dir_array = GetDirectories (root+"/*")

		for d in dir_array do 
			join dir_array (GetDirectories (d+"/*"))
		
		return dir_array
	)
	return undefined
)

-- Used for InteractiveMode OFF --
fn getMissingMaps = (
	local mapfiles = #()
	local mapfileN = #()
	local mBitmaps = getClassInstances BitmapTexture		-- gets all bitmapTextures in the scene
	local uvwBitmaps = getClassInstances Unwrap_UVW		-- gets all bitmapTextures in Unwrap_UVW modifiers
	
	mapfiles = mBitmaps													-- copies the array instance to "mapfiles"
	
	for m in mapfiles do (
		-- for every bitmap texture in the scene
		if (isProperty m #filename) then (
			-- that has a #filename property	
			if m.filename!=undefined and m.filename != "" then (
				-- that isn't blank
				if not (doesFileExist m.filename) then		-- if it doesn't exist, add to the array mapfileN
					append mapfileN m.filename
			)
		)
	)
	
	-- 1.15 Unwrap_UVW Modifiers Edit
	for i=1 to uvwBitmaps.count do (
		for m in uvwBitmaps[i].texMapList where classof m == BitmapTexture do (
			if not (doesFileExist m.filename) then append mapFileN m.filename
		)
	)
	----------------------------------------

	-- 1.14 Environment Background Edit
	if (not(doesFileExist(backgroundImageFilename))) then
		append mapfileN backgroundImageFilename
	----------------------------------------
	
	trim_dupsOne mapfileN
	mapfileN											-- returns the new array of only missing bitmaptextures
) 

-- Used for InteractiveMode ON --
fn getMissingMapsObjs = (
	missingMapsObjs=#()	
	missingMaps=#()
	
	-- called for enumerateFiles()
	fn addmapObjs map obj = (
		append missingMapsObjs obj							-- adds the object that has a missing map to the array missingMapsObjs
		append missingMaps map								-- adds the map    that is missing        to the array missingMaps
	)
	
	rlt_Missing.pb_interactiveModeLoading.visible = true
	
	for i = 1 to objects.count where objects[i].material != undefined do (		-- cycle through the scene objects
		rlt_Missing.pb_interactiveModeLoading.value = 100.*i/objects.count
		enumerateFiles objects[i] addmapObjs objects[i] #missing				-- find missing maps
	)

	trim_dups missingMapsObjs missingMaps					-- trim the duplicates from missingMapsObjs and also missingMaps

	rlt_Missing.pb_interactiveModeLoading.value = 0
	rlt_Missing.pb_interactiveModeLoading.visible = false
	
	--print "getMissingMapsObjs() completed"
	missingMaps										-- return the array of only missing bitmaptextures
)

-- Gets the paths the user wants to search for textures
fn getPathsToSearch = (
	local pathsToSearch = #()

	if rlt_Search.edt_manualSearch.text != "" then
		append pathsToSearch rlt_Search.edt_manualSearch.text
	
	local lsel = (rlt_QuickPaths.lst_QuickPaths.selection as array)
	if lsel.count != 0 then (
		for i = 1 to lsel.count do 
			append pathsToSearch rlt_QuickPaths.lst_QuickPaths.items[lsel[i]]
	)
	pathsToSearch
)

fn getDirectoryFiles = (
	local dir_arr = #()
	local file_arr = #()

	rlt_Search.pb_bar.value = 0
	rlt_Search.lbl_pb.caption = "Getting Directories"
	
	pathsToSearch = getPathsToSearch()
	
	if (rlt_Search.chk_recursiveSearching.checked) then (
		for i=1 to pathsToSearch.count do (
			if (local arr = getDirsRecursive pathsToSearch[i]) != undefined then join dir_arr arr
			rlt_Search.pb_bar.value = 100.*i/pathsToSearch.count
		)
	)
	join dir_arr pathsToSearch

	rlt_Search.pb_bar.value = 0
	rlt_Search.lbl_pb.caption = "Getting Files"
	
	--for d in dir_arr do (
	for i=1 to dir_arr.count do (
		if dir_arr[i].count != "\\" and dir_arr[i].count != "/" then 
			dir_arr[i] += "\\"

		try (
			local tmp_files = getFiles (dir_arr[i] + "*.*")
			if tmp_files.count != 0 then 
				join file_arr tmp_files
		)
		catch messageBox ("Could not get files from: " + dir_arr[i] + "*.*") title:"Error" beep:true	
		rlt_Search.pb_bar.value = 100.*i/dir_arr.count
	)
	rlt_Search.pb_bar.value = 0
	file_arr
)

-- Finds duplicates in array A, and deletes them in both a and b
fn trim_dups a b = (
	for i in a.count to 1 by -1 do 
		(
			idx = findItem a a[i]
			if (idx != 0) AND (idx != i) do (
				deleteItem a i
				deleteItem b i
			)
		)
	a
)

-- Finds duplicates in array A, and deletes them in in A
fn trim_dupsOne a = (
	for i in a.count to 1 by -1 do 
		(
			idx = findItem a a[i]
			if (idx != 0) AND (idx != i) do 
				deleteItem a i
		)
	a
)

-- Relinking Function 
fn relinkMaps = (
	local mapfiles = #()
	local mapfilesMissing = #()
	local file_arr_filename = #()

	st = timestamp()
	rlt_Search.lbl_pb.caption = "Getting used Bitmaps"
	local mBitmaps = getClassInstances BitmapTexture
	
	-- 1.14 Environment Background Edit
	if (not(doesFileExist(backgroundImageFilename))) then
		append mBitmaps backgroundImageFilename
	----------------------------------------

	-- 1.15 Unwrap_UVW Modifiers Edit
	local uvwBitmaps = getClassInstances Unwrap_UVW
	for i=1 to uvwBitmaps.count do (
		for m in uvwBitmaps[i].texMapList where classof m == BitmapTexture do (
			if not (doesFileExist m.filename) then append mBitmaps m.filename
		)
	)
	----------------------------------------
	
	rlt_Search.pb_bar.value = 5
	format "getClassInstances() completed in [% ms]\n" (timestamp()-st)
	
	mapfiles = mBitmaps

	st = timestamp()	
	local file_arr = getDirectoryFiles()	-- contains the paths of found files
	format "getDirectoryFiles() completed in [% ms]\n" (timestamp()-st)
	st = timestamp()
	rlt_Search.lbl_pb.caption = "Getting Missing Maps"
	local missingMaps = getMissingMaps()	-- Missing Map names
	rlt_Search.pb_bar.value = 100
	format "getMissingMaps() completed in [% ms]\n" (timestamp()-st)
	rlt_Search.pb_bar.value = 0
	
	-- stores just the filename of the missing files in the array file_arr_filename
	if not(rlt_Search.chk_ignoreCase.checked) then (
		for i in file_arr do
			append file_arr_filename (filenameFromPath i)
	) else (  -- Stores an only uppercase version of the filename
		for i in file_arr do
			append file_arr_filename (uppercase (filenameFromPath i))
	)
		
	st = timestamp()
	if (rlt_Search.chk_undoOn.checked) then ( 				-- if Undo is on
		rlt_Search.lbl_pb.caption = "Relinking..."
		undo "Relink Textures" on (
			with redraw off (
				for i=1 to mapfiles.count do (
					-- for all bitmapTextures in the scene
					if (isProperty mapfiles[i] #filename) then (
						-- that have a #filename property
						-- curFile will equal it's exact name or a full uppercase name depending on the status of the checkbox chk_ignoreCase
						if not(rlt_Search.chk_ignoreCase.checked) then
							local curFile = filenameFromPath mapfiles[i].filename
						else
							local curFile = uppercase (filenameFromPath mapfiles[i].filename)
						
						if (index = findItem file_arr_filename curFile) != 0 then 	-- check if the current file is missing
								mapfiles[i].filename = file_arr[index]		-- Relinks the current file to the found file
					)
					rlt_Search.pb_bar.value = 100.*i/mapfiles.count
				)

				-- 1.14 Environment Background Edit
				if (not(doesFileExist(backgroundImageFilename))) then (
					for i=1 to mapfiles.count do (
						if not(rlt_Search.chk_ignoreCase.checked) then
							local curFile = filenameFromPath (mapfiles[i] as string)
						else
							local curFile = uppercase (filenameFromPath (mapfiles[i] as string))					
						
						if (index = findItem file_arr_filename curFile) != 0 then
							backgroundImageFilename = file_arr[index]  -- Relink the background
					)
				)
				
				-- 1.15 Unwrap_UVW Modifiers Edit
				uvwBitmaps = getClassInstances Unwrap_UVW
				for i=1 to uvwBitmaps.count do (
					local texMapfileList = uvwBitmaps[i].texMapList
					for m=1 to texMapfileList.count where classof texMapfileList[m] == BitmapTexture and (not(doesFileExist texMapfileList[m].filename)) do (
							if not(rlt_Search.chk_ignoreCase.checked) then 
								local curFile = filenameFromPath (texMapfileList[m].filename as string)
							else
								local curFile = uppercase (filenameFromPath (texMapfileList[m].filename as string))					
						
							if (index = findItem file_arr_filename curFile) != 0 then texMapfileList[m].filename = file_arr[index]
					)
				)
				----------------------------------------

			)
		)
	)
	else if not (rlt_Search.chk_undoOn.checked) then (
		rlt_Search.lbl_pb.caption = "Relinking..."
		with redraw off (
			for i=1 to mapfiles.count do (
				if (isProperty mapfiles[i] #filename) then (
						-- curFile will equal it's exact name or a full uppercase name depending on the status of the checkbox chk_ignoreCase
						if not(rlt_Search.chk_ignoreCase.checked) then
							local curFile = filenameFromPath mapfiles[i].filename
						else
							local curFile = uppercase (filenameFromPath mapfiles[i].filename)
					
					if (index = findItem file_arr_filename curFile) != 0 then 		-- check if the current file is missing
						mapfiles[i].filename = file_arr[index]			-- Relinks the current file to the found file
				)
				rlt_Search.pb_bar.value = 100.*i/mapfiles.count
			)
			
			-- 1.14 Environment Background Edit
			if (not(doesFileExist(backgroundImageFilename))) then (
				for i=1 to mapfiles.count do (
					if not(rlt_Search.chk_ignoreCase.checked) then
						local curFile = filenameFromPath (mapfiles[i] as string)
					else
						local curFile = uppercase (filenameFromPath (mapfiles[i] as string))					
					
					if (index = findItem file_arr_filename curFile) != 0 then
						backgroundImageFilename = file_arr[index]  -- Relink the background
				)
			)
			
			-- 1.15 Unwrap_UVW Modifiers Edit
			uvwBitmaps = getClassInstances Unwrap_UVW
			for i=1 to uvwBitmaps.count do (
				local texMapfileList = uvwBitmaps[i].texMapList
				for m=1 to texMapfileList.count where classof texMapfileList[m] == BitmapTexture and (not(doesFileExist texMapfileList[m].filename)) do (
						if not(rlt_Search.chk_ignoreCase.checked) then 
							local curFile = filenameFromPath (texMapfileList[m].filename as string)
						else
							local curFile = uppercase (filenameFromPath (texMapfileList[m].filename as string))					
					
						if (index = findItem file_arr_filename curFile) != 0 then texMapfileList[m].filename = file_arr[index]
				)
			)
			----------------------------------------			
		)
	)

	format "Relink Textures() completed in [% ms]\n" (timestamp()-st)
	rlt_Search.lbl_pb.caption = "Done"
)

---------------- Rollouts -------------------

rollout rlt_Main "缺少位图窗口" (
	button btn_Find "缺少位图"

	on rlt_Main open do (
		clearListener()
		openRolloutNextTo rlt_Main rlt_Missing 450 430
	)
	
	on rlt_Main rolledUp isRolled do (
		if isRolled then rf.size.y = 457
		else rf.size.y = 420
	)
	
	on rlt_Main moved xy do 
		SetDialogPos rlt_Missing [xy.x+313, xy.y]
	
	on rlt_Main close do (
		closeRollout rlt_Missing
		closeRollout rlt_AddQuickPath
	)
	
	on btn_Find pressed do (
		if rlt_Missing.open then closeRollout rlt_Missing else openRolloutNextTo rlt_Main rlt_Missing 450 425
		rlt_Main.open = false
		rf.size.y = 420
	)
)

rollout rlt_Missing "贴图" (
	button btn_interactiveMode ""
	label lbl_doubleClickInfo ""
	label lbl_rightClickInfo ""
	progressBar pb_interactiveModeLoading color:blue visible:false
	multilistbox lst_MissingMaps "缺少贴图" width:420 height:20
	edittext edt_missingPath "" width:420
	button btnUpdate "更新" offset:[115,0]
	button btnOutputList "输出列表" offset:[175,-26]

	edittext edt_FindBitmap "寻找: " width:185 align:#left offset:[0,-23]
	button btn_FindBitmap "寻找" width:50 offset:[7,-22] height:17 enabled:false
	button btn_FindBitmapHelp "?" width:20 offset:[45,-22] height:16
	
	-- Updates the captions and buttons for interactive Mode based on it's current state
	-- calls UpdateMissingBitmaps()
	fn updateInteractiveMode = (
		if not interactiveModeOn then (
			btn_interactiveMode.caption = "互动模式研究"
			lbl_doubleClickInfo.caption = ""
			lbl_rightClickInfo.caption = "双击贴图查看其完整路径"
		)
		else (
			btn_interactiveMode.caption = "互动模式关闭"
			lbl_doubleClickInfo.caption = "点击一个贴图，它被分配到选择对象."
			lbl_rightClickInfo.caption = "双击一个贴图，它被分配到孤立的对象."
		)
		lst_MissingMaps.items = #("***** 加载丢失贴图中 *****  这可能需要一点时间...")
		rlt_Search.lbl_pb.caption = "加载位图 - 请等待..."
		rlt_Search.lbl_pb.caption = ""

		if (not rlt_Missing.open) then 
			rlt_Missing.open = true
		else
			rlt_Missing.updateMissingBitmaps()
	)

	on edt_FindBitmap changed txt do (
		if txt != "" then btn_FindBitmap.enabled = true else btn_FindBitmap.enabled = false
	)
	
	on btn_FindBitmapHelp pressed do (
		local message = ""
		message += "查找名称或路径位图\n"
		message += "\n"
		message += "   允许用户在任何文件名或路径（不区分大小写）\n"
		message += "   并填充用材料对字符串变化的材料编辑.\n"
		message += "\n"
		message += "说明:\n"
		message += "1. 类型全部或文件名或路径，然后按栏目找到\n"
		message += "2. 检查的所有材料，都依赖于你的搜索字符串材质编辑器\n"
		message += "\n"
		message += "For example:  typing \"Brick.jpg\" will populate the material editor\n"
		message += "                       with all materials with \"Brick.jpg\" in the filename\n"
		message += "\n"
		message += "For example:  typing \"bri\" will populate the material editor with all bitmaps\n"
		message += "                       with a file or pathname containing \"bri\" including \"brick.jpg\",\"redbrick.jpg\",\"brick_bump.jpg\", etc.\n"
		message += "\n"
		message += "For example:  typing \"c:\\\" will populate the material editor with all bitmaps\n"
		message += "                       that have \"c:\\\" in their path allowing you to change them manually."
		messageBox message beep:false
	)
	
	on btn_FindBitmap pressed do (
		relinkBitmapsFindBitmap edt_FindBitmap.text		
	)	
	
	on rlt_Missing open do
		updateInteractiveMode()

	on rlt_Missing resized size do (
		lst_MissingMaps.width = (rlt_Missing.width-10)
	)
		
	on rlt_Missing close do (
		rlt_Main.open = true		-- rolls up and down the rollout 
		rf.size.y = 457
	)

	on btn_interactiveMode pressed do (
		if objects.count > 250 then (
			if not(interactiveModeOn) then (
				if queryBox "互动模式可以花一点时间来加载大型场景.\n你希望启用它？" beep:false then (
					interactiveModeOn = not interactiveModeOn
					updateInteractiveMode()
				)
			)
			else (
				interactiveModeOn = not interactiveModeOn
				updateInteractiveMode()				
			)
		)
		else (
			interactiveModeOn = not interactiveModeOn
			updateInteractiveMode()
		)
	)

	on btnOutputList pressed do (
		if (f = getSaveFileName caption:"保存" filename:("C:\\"+(substring maxFileName 1 (maxFilename.count-4))+"_MissingBitmaps.txt") types:"Text(*.txt)") != undefined then (
			local mBitmaps = getClassInstances BitmapTexture		-- gets all bitmapTextures in the scene
			local mapFile = #()
		
			for m in mBitmaps do (
				-- for every bitmap texture in the scene
				if (isProperty m #filename) then (
					-- that has a #filename property	
					if m.filename != "" then (
						-- that isn't blank
						if not (doesFileExist m.filename) then		-- if it doesn't exist, add to the array mapfileN
							append mapFile m
					)
				)
			)
			-- Formatting the output of the print
			fs = openFile f mode:"w"
			for m in mapFile do format "% - %\n" m.name m.filename to:fs
			close fs
		)		
	)

	on btnUpdate pressed do
		rlt_Missing.updateMissingBitmaps()
	
	-- Function for updating the missing Bitmaps, does it differently if in Interactive Mode or not
	on rlt_Missing updateMissingBitmaps do (
		st = timestamp()
		if interactiveModeOn then 
			missingMaps = getMissingMapsObjs()		-- missingMaps stores what is displayed in the listbox for Missing Maps, InteractiveMode ON
		else
			missingMaps = getMissingMaps()			-- gets the missing maps in the scene faster via this method, InteractiveMode OFF
		
		format "updateMissingBitmaps - completed in [% ms]\n" (timestamp()-st)

		lst_MissingMaps.items = missingMaps			-- puts it in the listbox
	)

	-- if interactiveMode is on, and the user selects a map, it will select the object it is assigned to
	on lst_MissingMaps selected arg do (
		if interactiveModeOn then (
			max create mode
			clearSelection()
			for i in lst_MissingMaps.selection do (
				local obj = missingMapsObjs[i]
				
				-- Make sure the Layer is unhidden
				if not(obj.layer.on) then
					obj.layer.on = true
				
				if (isValidNode obj) then
					selectmore obj	
				else													-- Scene has Changed, update
					rlt_Missing.updateMissingBitmaps()
			)
		)
	)
	
	-- if interactiveMode is off, and the user double clicks a map, it will select the object it is assigned to and isolate it
	on lst_MissingMaps doubleClicked arg do (
		if interactiveModeOn then (
			max create mode
			local obj = missingMapsObjs[arg]
			
			-- Check if the obj is part of a group
			if obj.children.count > 0 then (
				-- Loop through the children and open them
				for o in obj.children do (
					if (isGroupHead o) then
						setGroupOpen o true					
				)
			)
		
			-- Make sure the Layer is unhidden
			if not(obj.layer.on) then
				obj.layer.on = true

			if (isValidNode obj) then (
				if Iso2Roll != undefined then 
					Iso2Roll.C2Iso.changed true -- turns off Isolation mode, if it's on
					
				macros.run "Tools" "Isolate_Selection"				
			)
			else (
				-- Scene has Changed, update
				rlt_Missing.updateMissingBitmaps()		
			)
		)
		edt_missingPath.text = lst_missingMaps.items[arg]
	)	
)

rollout rlt_QuickPaths "快速路径" (
	multilistbox lst_QuickPaths "保存路径" height:10
	button btn_selectAll "全部" width:40 height:17 align:#left
	button btn_selectNone "没有" width:40 height:17 offset:[-60,-22]
	button btn_addQuickPath "添加" width:40 height:17 align:#left offset:[170,-22]
	button btn_deleteQuickPath "删除" width:40 height:17 offset:[110,-22]
	
	fn updateSavedPaths = (
		if doesFileExist iniFile then (
			local section = getINISetting iniFile "Paths"
			local keys = #()
			
			for i = 1 to section.count do
				append keys (getINISetting iniFile "Paths" section[i])

			lst_QuickPaths.items = keys
		)
		else (
			print "INI文件不存在，创建一个"
			try
				setINISetting iniFile "QuickPaths" "Created By" "Colin Senner"
			catch (
				messageBox ("无法创建文件: "+ini文件+"!")
				return false
			)

			updateSavedPaths()
		)
	)
	
	fn remakeINIFile = (
		if doesFileExist iniFile then (
			local section = getINISetting iniFile "Paths"
			local keys = #()
			
			for i = 1 to section.count do
				append keys (getINISetting iniFile "Paths" section[i])
			
			delIniSetting iniFile "Paths"		-- Deletes all entries in the INI File
			
			for i = 1 to keys.count do
				setINISetting iniFile "Paths" (i as string) keys[i]
		)
		else
			messageBox ("文件: " +ini文件 + "不存在, 请尝试重新启动该脚本.")
	)
	
	fn updateRelinkButton = (
		if (lst_QuickPaths.selection as array).count == 0 and rlt_Search.edt_manualSearch.text == "" then (
			rlt_Search.btn_Relink.enabled = false
		)
		else
			rlt_Search.btn_Relink.enabled = true
	)
	
	on lst_QuickPaths selected arg do (
		updateRelinkButton()
	)
	
	on rlt_QuickPaths open do
		updateSavedPaths()
	
	on btn_addQuickPath pressed do (
		openRollout rlt_AddQuickPath 370 45
		updateSavedPaths()
	)	

	on btn_deleteQuickPath pressed do (
		local selectedQuickPaths = lst_QuickPaths.selection as array

		if doesFileExist iniFile then (
			local section = getINISetting iniFile "Paths"
			
			for i in selectedQuickPaths do
				delIniSetting iniFile "Paths" (i as string)
				
			remakeINIFile()
		)
		else
			messageBox ("文件: " + ini文件 + " 不存在,请尝试重新启动该脚本.")

		updateSavedPaths()
	)
	
	on btn_selectAll pressed do (
		local tmp_arr = #()
		for i = 1 to lst_QuickPaths.items.count do tmp_arr[i] = i
			lst_QuickPaths.selection = tmp_arr

		updateRelinkButton()
	)
	
	on btn_selectNone pressed do (
		lst_QuickPaths.selection = #()
		updateRelinkButton()
	)
)

rollout rlt_AddQuickPath "添加快速路径" (
	edittext edt_AddQuickPath "" width:260 offset:[0,5]
	button btn_browseAddQuickPaths "..." width:24 height:20 offset:[105,-24]
	button btn_OkAddPath "添加" width:50 height:20 offset:[149,-25]
	
	on edt_AddQuickPath entered txt do (
		btn_OkAddPath.pressed()
	)
	
	on btn_browseAddQuickPaths pressed do (
		local browseDirectory = getSavePath "Search Directory" initialDir:uev_default_Browse_Directory
		if browseDirectory != undefined then (
			edt_AddQuickPath.text = browseDirectory
		)
	)
	
	on btn_OkAddPath pressed do (
		if edt_AddQuickPath.text != "" then (
			local section = getINISetting iniFile "Paths"
			local keys = #()
			
			for i = 1 to section.count do
				append keys (getINISetting iniFile "Paths" section[i])

			setINISetting iniFile "路径" (((section.count)+1) as string) edt_AddQuickPath.text
			rlt_QuickPaths.updateSavedPaths()
			closeRollout rlt_AddQuickPath
		)
		else
			messageBox "请输入或浏览到一个新的路径添加."	
	)
)

rollout rlt_Search "位图路径搜索" (
	label lbl_manualSearchLabel "搜索目录:" align:#left
	edittext edt_manualSearch "" width:220 offset:[-10,0]
	button btn_browseSearch "浏览" offset:[110,-23]
	checkbox chk_undoOn "可撤消" checked:uev_default_Undo_on visible:false offset:[0,-21]
--	label lbl_undoOn "(注意：如果是可撤消该脚本将执行慢)"
	
	group "位图" (
		button btn_Relink "重新链接" enabled:false offset:[-70,0] width:80
		checkbox chk_recursiveSearching "循环子文件夹" checked:uev_default_Recursive_Search_on offset:[120,-32]
		checkbox chk_ignoreCase "忽略大小写" checked:uev_default_Ignore_case_on offset:[120,-4]
	)
	
	label lbl_pb "" align:#center offset:[0,15]
	label lbl_pbNum "" align:#right offset:[0,-18]
	progressbar pb_bar ""
	
	on chk_ignoreCase changed thestate do (
		-- if thestate then messageBox "忽略大小写将导致脚本执行速度较慢" beep:false
	)
	
	on btn_browseSearch pressed do (
		local browseDirectory = getSavePath "搜寻目录" initialDir:uev_default_Browse_Directory
		if browseDirectory != undefined then (
			edt_ManualSearch.text = browseDirectory
			btn_Relink.enabled = true
		)
	)

	on edt_ManualSearch changed txt do (
		if txt != "" then
			btn_Relink.enabled = true
		else if (rlt_QuickPaths.lst_QuickPaths.selection as array).count == 0 then
			btn_Relink.enabled = false
	)	
	
	on btn_Relink pressed do (
		sst = timestamp()
		if (local toSearch = getPathsToSearch()) != "" then (	
			interactiveModeOn = false
			max create mode
			RelinkMaps()
		
			rlt_Search.lbl_pb.caption = "更新丢失贴图"

			rlt_Missing.updateInteractiveMode()
			rlt_Search.lbl_pb.caption = ""
			rlt_Search.pb_bar.value = 0
		) else
			messageBox "请选择一个搜索目录" beep:false
		format "Total Time: [% ms]\n" (timestamp()-sst)
	)
)

----------------- Floaters ------------------
rf = newRolloutFloater "找贴图【黑马设计网】出品" 300 420
addRollout rlt_Main rf rolledUp:true
addRollout rlt_QuickPaths rf
addRollout rlt_Search rf
)