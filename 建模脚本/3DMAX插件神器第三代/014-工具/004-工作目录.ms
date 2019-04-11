if WorkFolderPath != undefined then destroydialog WorkFolderPath 

rollout WorkFolderPath "常用工作目录【黑马设计网】出品" width:578 height:195
(
	---------------------定义变量-----------------------
	local WandoScriptFolderPath= GetDir #Scripts + "\wandotools"
	local WorkPath1= "d:"
	local WorkPath2= GetDir #Scene
	local WorkPath3 = "d:"
	local WorkPath4 = "d:"
	local WorkPath5 = "d:"
	local WorkPath6 = "d:"
	--------------------- The Fn -------------------------
	function savedate =
	(
		f=createFile("$ui\\workfolder.ini")
		format "%\n" WorkPath1 to:f
		format "%\n" WorkPath2 to: f
		format "%\n" WorkPath3 to: f
		format "%\n" WorkPath4 to: f
		format "%\n" WorkPath5 to: f
		format "%\n" WorkPath6 to:f
		close f
	)
	function loaddate =
	(
		f = openfile ("$UI\\workfolder.ini")
		if f != undefined then 
		try
		(
			WorkPath1 = readLine f;
			WorkPath2 = readLine f;
			WorkPath3 = readLine f;
			WorkPath4 = readLine f;
			WorkPath5 = readLine f;
			WorkPath6 = readLine f;
			format "%\n" WorkPath1 
			format "%\n" WorkPath2 
			format "%\n" WorkPath3 
			format "%\n" WorkPath4 
			format "%\n" WorkPath5 
			format "%\n" WorkPath6 
			close f 
		)catch()
		else  
		try( 
			f=createFile("$ui\\workfolder.ini")
			format "%\n" WorkPath1 to:f
			format "%\n" WorkPath2 to: f
			format "%\n" WorkPath3 to: f
			format "%\n" WorkPath4 to: f
			format "%\n" WorkPath5 to: f
			format "%\n" WorkPath6 to:f
			close f
			)catch()
	)
	----------------------UI------------------
	button OpenMaxRootFolder "打开MAX根目录" pos:[5,9] width:100 height:18   --max跟目录 
	button OpenScriptFolder "max 脚本目录" pos:[111,9] width:100 height:18 
	button WandoScriptFolder "wando 脚本目录" pos:[218,9] width:100 height:18 
	button OpenAutoBackFolder "AutoBack" pos:[324,9] width:70 height:18
	button btn_about "About" pos:[400,9] width:65 height:18
	
	button btn_WorkPath1 "WorkPath1" pos:[5,34] width:60 height:18 
	edittext edt_WorkPath1 "" pos:[67,33] width:400 height:18 enabled:false 
	
	button btn_WorkPath2 "WorkPath2" pos:[5,59] width:60 height:18   --max文件目录 
	edittext edt_WorkPath2 "" pos:[67,58] width:400 height:18 enabled:false
	
	
	button btn_WorkPath3 "WorkPath3" pos:[5,84] width:60 height:18 
	edittext edt_WorkPath3 "" pos:[67,83] width:400 height:18 enabled:false
	

	
	button btn_WorkPath4 "WorkPath4" pos:[5,107] width:60 height:18
	edittext edt_WorkPath4 "" pos:[67,106] width:400 height:18 enabled:false
	

	button btn_WorkPath5 "WorkPath5" pos:[5,130] width:60 height:18
	edittext edt_WorkPath5 "" pos:[67,129] width:400 height:18 enabled:false
	
	button btn_WorkPath6 "WorkPath6" pos:[5,153] width:60 height:18
	edittext edt_WorkPath6 "" pos:[67,152] width:400 height:18 enabled:false
	
	on WorkFolderPath open do
	(
		loaddate ()
		edt_WorkPath1.text = WorkPath1
		edt_WorkPath2.text = WorkPath2 
		edt_WorkPath3.text = WorkPath3
		edt_WorkPath4.text = WorkPath4
		edt_WorkPath5.text = WorkPath5
		edt_WorkPath6.text = WorkPath6 
		btn_WorkPath1.text = filenameFromPath WorkPath1
		btn_WorkPath2.text = filenameFromPath WorkPath2
		btn_WorkPath3.text = filenameFromPath WorkPath3
		btn_WorkPath4.text = filenameFromPath WorkPath4
		btn_WorkPath5.text = filenameFromPath WorkPath5
		btn_WorkPath6.text = filenameFromPath WorkPath6
	)
	on OpenMaxRootFolder pressed do
	(
		shellLaunch (GetDir #MaxRoot) ""  --打开max跟目录
	)
	on OpenScriptFolder pressed do
	(
		shellLaunch  (GetDir #Scripts) ""
	)
	on WandoScriptFolder pressed do
	(
		shellLaunch  WandoScriptFolderPath  ""
	)
	on OpenAutoBackFolder pressed do
	(
		shellLaunch  (GetDir #Autoback) ""
	)
	on btn_about pressed do
	(
		messagebox "作者：wando\n\nQQ:32431334\n\nVersion 1.0"\
		title:"关于本插件"
		shellLaunch "http://www.cgjoy.net/bbs/thread-596-1-1.html" ""
	)
	-----------------------------------------------------------------------------------------
	on btn_WorkPath1 pressed do
	(
		shellLaunch WorkPath1 ""	 
	)
	on btn_WorkPath1 rightClick do
	(
		local path
		path = getSavePath caption:"选择工作文档目录:"  initialDir:WorkPath1 
		if path != undefined then 
		(
			try(
				WorkPath1 = path
				edt_WorkPath1.text = WorkPath1
				btn_WorkPath1.text = filenameFromPath WorkPath1
				)catch() 
			savedate () 
		)
	)
--------------------------------------------------------------------------------------------
	on btn_WorkPath2 pressed do
	(
		shellLaunch  WorkPath2  ""  -- 打开max场景目录
	)
	on btn_WorkPath2 rightClick do
	(
		local path
		Path = getSavePath caption:"选择max场景目录:"  initialDir: WorkPath2
		if path != undefined then 
		(
			try(
				SetDir #Scene  path				 -- 设置max场景目录
				WorkPath2 = path
				edt_WorkPath2.text = WorkPath2 
				btn_WorkPath2.text = filenameFromPath WorkPath2
				)catch()
			savedate ()
		)
	)
--------------------------------------------------------------------------------------------
	on btn_WorkPath3 pressed do
	(
		shellLaunch  WorkPath3  ""
	)
	on btn_WorkPath3 rightClick do
	(
		local path
		path = getSavePath caption:"选择导出nif目录:"  initialDir:WorkPath3
		if path != undefined then 
		(
			try(
				WorkPath3 = path
				edt_WorkPath3.text = WorkPath3 
				btn_WorkPath3.text = filenameFromPath WorkPath3
				)catch() 
			savedate () 
		)
	)
---------------------------------------------------------------------------------------------
	on btn_WorkPath4 pressed do
	(
		shellLaunch  WorkPath4 ""
	)
	on btn_WorkPath4 rightClick do
	(
		local path
		path = getSavePath caption:"选择导出nif目录:"  initialDir:WorkPath4 
		if path != undefined then 
		(
			try(
				WorkPath4 = path
				edt_WorkPath4.text = WorkPath4 
				btn_WorkPath4.text = filenameFromPath WorkPath4
				)catch() 
			savedate () 
		)
	)
--------------------------------------------------------------------------------------------
	on btn_WorkPath5 pressed do
	(
		shellLaunch  WorkPath5   ""
	)
	on btn_WorkPath5 rightClick do
	(
		local path
		path = getSavePath caption:"选择导出nif目录:"  initialDir:WorkPath5 
		if path != undefined then 
		(
			try(
				WorkPath5 = path
				edt_WorkPath5.text = WorkPath5
				btn_WorkPath5.text = filenameFromPath WorkPath5 
				)catch() 
			savedate () 
		)
	)
--------------------------------------------------------------------------------------------
	on btn_WorkPath6 pressed do
	(
		shellLaunch  WorkPath6 ""
	)
	on btn_WorkPath6 rightClick do
	(
		local path
		path = getSavePath caption:"选择导出nif目录:"  initialDir:WorkPath6 
		if path != undefined then 
		(
			try(
				WorkPath6 = path
				edt_WorkPath6.text = WorkPath6 
				btn_WorkPath6.text = filenameFromPath WorkPath6
				)catch() 
			savedate () 
		)
	)
--------------------------------------------------------------------------------------------
)



CreateDialog WorkFolderPath 472 178 615 71