rollout modelout "复制穿越" width:160 height:140
(
	button btn1 "第1步选要点击的模型" pos:[5,10] width:150 height:38
	button btn2 "第2步场景里粘贴模型" pos:[5,60] width:150 height:38
	button LIGHT_BTN "黑马穿越神器" pos:[20,100] width:120 height:38 enabled:false border:false
	
	fn getFilesFromObjects objs =
(

  
	local mats = makeUniqueArray (for o in objs where (o.material !=undefined) collect o.material)
	local totalFiles = #()
	for m in mats do
	(
		
		for b in getClassInstances bitmapTex target:m where b.filename != undefined do
		(
			if (doesFileExist b.filename ==false )then (b.filename=mapPaths.getFullFilePath b.filename)
			if (doesFileExist b.filename ==false )then ()else(appendIfUnique totalFiles b.filename)
		)
	)
  
	totalFiles
)
	on btn1 pressed do
	(
		thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
		thecopypastefile = "\anodes\pastefile.max" --this is the filename to save as...
		thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
		
		--1先检测anodes目录存在不，不存在就自动建设一个。
		savemaxfpath=thecopypastedir+"\anodes\\"
		if((dotNetclass "System.IO.Directory").Exists SavemaxfPath) then () else(MakeDir(SavemaxfPath))
		
		
		if $ != undefined 
		then(
			
		--2，检测anodes里有没有东西，如果有东西先删除。
		files = getFiles (savemaxfpath+"\\*.*")
		for f in files do (deletefile f)
		--3，开始复制模型
		saveNodes $ thecopypastestring
		--4，把模型需要的贴图，代理，光渔网 都复制到anodes里去。
		
		aa=getFilesFromObjects selection
	
		for k in aa do 
		(
			copyfile k (savemaxfpath+(filenameFromPath k))
			
			)
		--5,复制光渔网
		for obj in selection where ((IsKindOf obj Target_Light) or (IsKindOf obj Free_Light)or (IsKindOf obj Vrayies)) do
			(
			  
				try (
					if (doesFileExist obj.ies_file ==false )then (obj.ies_file=mapPaths.getFullFilePath obj.ies_file)
					if (doesFileExist obj.ies_file ==false )then ()else(copyfile obj.ies_file (savemaxfpath+(filenameFromPath obj.ies_file) ))
					
					
					)
				catch(
					if (doesFileExist obj.webFile ==false )then (obj.webFile=mapPaths.getFullFilePath obj.webFile)
					if (doesFileExist obj.webFile ==false )then ()else(copyfile obj.webFile (savemaxfpath+(filenameFromPath obj.webFile) ))
					
					
					
					)
				
			)
		--复制代理文件
		
		for DL in selection where (IsKindof DL vrayproxy) do
			(
			   if (doesFileExist DL.filename ==false )then (DL.filename=mapPaths.getFullFilePath DL.filename)
			   if (doesFileExist DL.filename ==false )then ()else(copyfile DL.filename (savemaxfpath+(filenameFromPath DL.filename))	)
		       
				
				)
			
			
			) --this saves ("copies") the objects as a file
		else(
			  messagebox "你没选中要保存出去的物体！"
			)
	
			
	)
	on btn2 pressed do
	(
		thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
		thecopypastefile = "\anodes\pastefile.max" --this is the filename to save as...
		thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
		savemaxfpath=thecopypastedir+"\anodes\\"
		--先复制贴图等东西到现在做的场景里去
		--1检测模型是否保存
		if maxFilePath =="" then (messagebox "请先保存你的MAX文件，同时贴图会复制到和MAX文件一起的文件夹里")
		else(
		--2开始复制东西
		files = getFiles (savemaxfpath+"\\*.*")
		for f in files where getFilenameType f !=".max" do 
		(copyfile f (maxfilepath+(filenameFromPath f))
		)
		--再复制模型过去。
		mergemaxfile (thecopypastedir + thecopypastefile) #select --this merges ("pastes") and selects objects from file
	)
		
		
	)
)
createdialog modelout style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
