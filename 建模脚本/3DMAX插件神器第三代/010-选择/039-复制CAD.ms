		
		
	

---########################################

--版本：v3.0

--时间：2016-10-24

--修改：【3d狼设计网】

--交流群：17648716

---########################################


		
	try(destroydialog pxm_CPdwg)catch()	

	rollout pxm_CPdwg "粘贴DWG" width:140 height:240

	(

		local newLayerName = "脚本管家1层"

		checkbutton cbn_paste ""  width:(pxm_CPdwg.width-6) height:20 tooltip:"Choose AutoCAD / DraftSight"

		checkbox window "导入选项" offset:[-10,0]

		checkbox chb "清除材质"  checked:true offset:[-10,0]

		checkbox colors "清除层颜色"  checked:true  offset:[-10,0]

		checkbox colorswb "白线改色"  checked:true across:2  align:#left offset:[-10,0]

		colorpicker colorNew ""  width:23 height:14 color:[8,8,8] enabled:true align:#right offset:[0,2]	

		checkbox unlinkBlocks "打散图块"  checked:true offset:[-10,0]

		checkbox oneLayer "统一图层"  checked:true offset:[-10,0]

		checkbox chk_z2Zero "Z轴归零"  checked:true offset:[-10,0]

		checkbox chk_layerName "自定义图层名：" align:#left offset:[-10,0]

		edittext edt_layerName "" width:(pxm_CPdwg.width-3) align:#center offset:[-2,0]

		button Paste "粘贴"  width:(pxm_CPdwg.width-6)

		


		

	fn RemoveMat ObjArr = for o in ObjArr do try(o.mat = undefined)catch()

	

	fn SetAccessControl inputDirectoryInfo = 

	(

		tempUserName = (DotNetClass "System.Environment").UserName

		fileSystemRights = (DotNetClass "System.Security.AccessControl.FileSystemRights").Modify

		accessControlType = (DotNetClass "System.Security.AccessControl.AccessControlType").Allow

		fileSystemAccessRule = DotNetObject "System.Security.AccessControl.FileSystemAccessRule" tempUserName fileSystemRights accessControlType 

		directorySecurity = inputDirectoryInfo.GetAccessControl()

		directorySecurity.AddAccessRule fileSystemAccessRule 

		inputDirectoryInfo.SetAccessControl directorySecurity 

	)

	

	fn GetDWG1 tp fType newestDWG:#() = 

	(

		local SearchOption = DotNetClass "System.IO.SearchOption"

		local DirInfo = DotNetObject "System.IO.DirectoryInfo" tp

		SetAccessControl DirInfo

		for o in (DirInfo.GetFiles fType) where newestDWG.count == 0 or newestDWG[2] < o.CreationTime.ToBinary() do newestDWG = #(o.FullName, o.CreationTime.ToBinary())

	)	

	

	fn dateToInt o = 

	(

		a = filterstring (getFileModDate o) "/ :"

		(a[1] as integer64) * 2678400 + (a[2] as integer64) * 8640 + (a[3] as integer64 - 1960) * 32140800 + (if (i = (a[4] as integer64)) != 12 then i else 0) * 3600 + (a[5] as integer64) * 60 + (a[6] as integer64) + (if a[7] == "PM" then 43200 else 0) 

	)


	fn GetDWG tp fType newestDWG:#() = 

	(

		try(for o in getFiles (tp + "\\" + fType) where newestDWG.count == 0 or newestDWG[2] < (i = dateToInt o) do newestDWG = #(o, (if newestDWG.count == 0 then dateToInt o else i)))catch()

		if newestDWG[1] != undefined and newestDWG.count > 0 then newestDWG[1] else GetDWG1 tp fType

		newestDWG[1]

	)

	mapped fn MakeShapeKnotZero Spl_Obj = 

	(

		iNumSplines = numSplines Spl_Obj

		aNumSegments = for i in 1 to iNumSplines collect if isClosed Spl_Obj i then numSegments Spl_Obj i else (numSegments Spl_Obj i)+1

		aKnotPointShape = #() 

		for i in 1 to iNumSplines do

		(

			aKnotPointPerSpline = for j in 1 to aNumSegments[i] collect #(getKnotPoint Spl_Obj i j,getInVec Spl_Obj i j,getOutVec Spl_Obj i j)

			append aKnotPointShape aKnotPointPerSpline

		)

		for i in 1 to iNumSplines do

			for j in 1 to aNumSegments[i] do

			(

				aKnotPointShape[i][j][1] *= [1,1,0]

				aKnotPointShape[i][j][2] *= [1,1,0]	

				aKnotPointShape[i][j][3] *= [1,1,0]

			)

		for i in 1 to iNumSplines do

			for j in 1 to aNumSegments[i] do

				(

					setKnotPoint Spl_Obj i j aKnotPointShape[i][j][1]

					setInVec Spl_Obj i j aKnotPointShape[i][j][2]

					setOutVec Spl_Obj i j aKnotPointShape[i][j][3]

				)

		updateshape Spl_Obj

	)

		

		on pxm_CPdwg open do 

		(

	

			cbn_paste.text = "AutoCAD"

			cbn_paste.state = on

			cbn_paste.highlightcolor = if cbn_paste.text == "AutoCAD" then (color 0 120 250) else (color 0 150 120)

			if chk_layerName.state then edt_layerName.enabled = true else edt_layerName.enabled = false

			edt_layerName.text="脚本管家1层"

		)		

		on cbn_paste changed state do 

		(

			cbn_paste.text = if cbn_paste.text == "AutoCAD" then "DraftSight" else "AutoCAD"; cbn_paste.state = on; cbn_paste.highlightcolor = if cbn_paste.text == "AutoCAD" then cbn_paste.highlightcolor = (color 0 120 250) else (color 0 150 140) 

		)

		on chk_layerName changed i do

		(

			if i then edt_layerName.enabled = true else edt_layerName.enabled = false

		)	

		on Paste pressed do

		(

			local dwg, imDWG, oldLays, imLays

			local allObjects = if objects.count > 0 then objects as Array else #()			

			dwg = if cbn_paste.text == "AutoCAD" then (GetDWG (sysInfo.tempdir) "*.dwg") else (GetDWG (pathconfig.normalizepath (sysInfo.tempdir + "\\DraftSight_temp\\")) "*.dwg")

			oldLays = for i = 0 to layerManager.count-1 collect (layerManager.getLayer i).name

			if dwg != undefined do (if window.checked then importFile dwg else importFile dwg #noPrompt)

				imDWG = if objects.count > 0 then objects as Array else #()

				for o in allObjects do if (i = findItem imDWG o) > 0 do deleteItem imDWG i				

				imLays = for i = 0 to layerManager.count-1 collect (layerManager.getLayer i).name

				for o in oldLays do if (i = findItem imLays o) > 0 do deleteItem imLays i

				if oneLayer.checked do 

				(

					if chk_layerName.checked then newLayerName = edt_layerName.text else newLayerName = "脚本管家1层"

					if (a = LayerManager.getLayerFromName newLayerName) != undefined then theLayer = a else (theLayer = Layermanager.newLayerFromName newLayerName)

				)				

				if chk_z2Zero.checked do try(MakeShapeKnotZero imDWG) catch ()				

				for o in imDWG do 

				(

					try(o.transform.controller = prs())catch()   																	

					if chb.checked do o.material = undefined

					if colors.checked do (o.colorbylayer = false; o.wirecolor = o.layer.wirecolor)

					if colorswb.checked and o.wirecolor == white do o.wirecolor = colorNew.color

					if oneLayer.checked do theLayer.addnode o

					if unlinkBlocks.checked do try(if classof o.parent == LinkComposite do o.parent = undefined)catch()

				)

				if unlinkBlocks.checked do for i = imDWG.count to 1 by -1 where classof imDWG[i] == LinkComposite do (delete imDWG[i]; deleteItem imDWG i)

				if oneLayer.checked do for i = layerManager.count-1 to 0 by -1 do try(LayerManager.deleteLayerByName (layerManager.getLayer i).name)catch()

				if oneLayer.checked do for lay in imLays do try(LayerManager.deleteLayerByName lay)catch()

			

		)

		

		

	)

	createDialog pxm_CPdwg 