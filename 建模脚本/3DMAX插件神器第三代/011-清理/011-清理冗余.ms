try destroyDialog convert2Poly2Mesh catch() 
fn getInstancesHead arr = 
(
	aInstanceHead = #()
	for i in arr do
	(
		if InstanceMgr.GetInstances i &arrTempIns > 0 then
		(
			arrTempTrueIns = for j in arrTempIns where (areNodesInstances i j) collect j
			--sort arrTempTrueIns
			appendIfUnique aInstanceHead arrTempTrueIns[1]
		)
	)
	return aInstanceHead
)
fn getInstanceObj obj=
(
	InstanceMgr.GetInstances obj &arrTempIns
	arrTempTrueIns = for i in arrTempIns where (areNodesInstances obj i) collect i
	return arrTempTrueIns
)
fn CalcStartTime = 
(
	global startTime = timestamp()	
)
fn CalcEndTime =
(
	global endTime = timestamp()
	format "转化耗时%秒\n" ((endTime - startTime)/1000.0)
)
fn Fn_removeMissingPlugins = 
(
	-- get list of missing plugin classes
	local myStringStream = stringStream ""
	apropos "*missing*" to:myStringStream
	seek myStringStream 0
	missingPluginsClasses = #()
	while not (eof myStringStream) do 
	(
		local theLine = readLine myStringStream
		tk = filterString theLine " "
		if tk.count == 4 then 
		(
			local pluginClassName = tk[1]
			try 
			(
				local val = (execute pluginClassName)
				local theSuperClass = superClassOf val
				-- Alternative: check for .classID == #(-1,0)
				if theSuperClass==MAXWrapper or theSuperClass==node or theSuperClass==material or theSuperClass==MAXWrapperNonRefTarg then 
				(
					append missingPluginsClasses val
					-- format "%: %\n" c val
				) 
				else 
				(
					-- format "Skipping % (%)\n" val theSuperClass
				)
			)
			catch 
			(
				format "Cannot use % for searching missing plugins.\n" pluginClassName
			)
		)
		else 
		(
			-- format "Incorrect string found in missing plugin name list: %\n" tk
		)
	)
	-- now search for instances of those missing plugins
	local pluginCount = 0
	local foundMissing = #()
	for n=1 to missingPluginsClasses.count do 
	(
		local theMissingClass = missingPluginsClasses[n]
		local missingClassInstance = getClassInstances theMissingClass
		if missingClassInstance.count > 0 then 
		(
			-- format "%: Found % instances of %: %\n" n missingClassInstance.count theMissingClass missingClassInstance
			for i=1 to missingClassInstance.count do 
			(
				-- get current class
				myClass = classOf theMissingClass
				append foundMissing myClass
				-- get list of all subclasses
				allClasses = myClass.classes
				for k=1 to allClasses.count do 
				(
					-- search for useful replacement
					if allClasses[k].creatable then 
					(
						-- create new instance of default (first) class
						newInst = createInstance allClasses[k]
						try 
						(
							-- replace all instances (requires 3ds Max 2008+ or AVG extensions)
							q = replaceInstances missingClassInstance[i] newInst
							pluginCount += 1
							-- and exit for k loop
							exit
						)
						catch 
						(
							format "Error replacing %\n" missingClassInstance[i]
							format "Exception: %\n" (getCurrentException())
						)
					)
				)
				-- todo: what happens if NO useful replacement was found?
			)
		)
	)
	if pluginCount > 0 then 
	(
		-- produce summary message for user
		local messageString = "Replaced "
		append messageString (pluginCount as string)
		append messageString " missing plugin(s) with default objects:\n"
		
		append messageString "使用默认对象替换了 "
		append messageString (pluginCount as string)
		append messageString " 个丢失的插件:\n"
		for theMissing in foundMissing do (
			append messageString "\t"
			append messageString (theMissing as string)
			append messageString "\n"
		)
		append messageString "\nUSE RESULT WITH CAUTION!\nSAVE TO A DIFFERENT FILE NAME!\n清除插件后可能导致文件异常\n请将文件另存以确保数据安全"
		messageBox messageString /*title:"MrClean: remove missing Plugins"*/
		--print foundMissing
	)
	else 
	(
		messageBox "No missing plugins found\n没有找到丢失的插件" /*title:"MrClean: remove missing Plugins"*/
	)
)
rollout convert2Poly2Mesh "消除超大Mesh物体" width:168
(
	group ""
	(
		--button btn1 "选择的物体　" width:106 height:24 offset:[0,-8] align:#center
		--button btn2 "场景中物体　" width:106 height:24 offset:[0,-5] align:#center

		--groupbox grp "" width:106 height:7 offset:[0,-6] align:#center
		
		button btn3 "清理丢失插件"  width:156 height:24 offset:[0,-10] align:#center
		button btn4 "清理冗余数据"  width:156 height:24 offset:[0,-5] align:#center
		groupbox grp "" width:156 height:7 offset:[0,-6] align:#center
		hyperLink hypsina "黑马帮你解决max小烦恼" address:"http://3dheima.com" align:#center offset:[1,0] color:green
	)
	
	
	on btn3 pressed do
	(
		try Fn_removeMissingPlugins() catch()
	)
	on btn4 pressed do
	(
		local IsClean1 = false
		local IsClean2 = false
		--瘦身
		try (t=trackviewnodes;n=t[#Anim_Layer_Control_Manager];deleteTrackViewController t n.controller;gc()) catch(IsClean1 = true)
		try (t=trackviewnodes;n=t[#Max_MotionClip_Manager];deleteTrackViewController t n.controller;gc()) catch(IsClean2 = true)
		gc()
		if IsClean1 and IsClean2 do messagebox "文件良好,无需清理!" beep:off
	)
	
)

createDialog convert2Poly2Mesh
