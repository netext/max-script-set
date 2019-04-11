makedir (GetDir #scripts + "\\tools")as string
AssetTracking_dialog_pos_x = getinisetting "$scripts\\tools\\Maxbaby.ini" "AssetTracking_pos" "pos_x" as integer
if AssetTracking_dialog_pos_x == undefined or AssetTracking_dialog_pos_x == 0 then AssetTracking_dialog_pos_x = 180
	
AssetTracking_dialog_pos_y = getinisetting "$scripts\\tools\\Maxbaby.ini" "AssetTracking_pos" "pos_y" as integer
if AssetTracking_dialog_pos_y == undefined or AssetTracking_dialog_pos_y == 0 then AssetTracking_dialog_pos_y = 80

escapeenable = true
global a,cc,ca_ary,nums
(
	a = batchRenderMgr.GetView
	nums = batchRenderMgr.numViews
)
global defaultMtltype=true,ppImportMatStr,ppImportMat,ppFuncStruct,plusplusFunc,AssetTracking,mtlConverter
global spRootPath=getdir #scripts + "\\tools"
global spInifilepath=spRootPath+"\\Maxbaby.ini"
--配置文件
struct ppImportMatStr 
(	--store the data of importing mat  记录导入材质数据
	allMatCt=0,
	selMatCt=0,
	missMatCt=0,
	matLibCt=0,
	sameMatCt=0
)
ppImportMat=ppImportMatStr()

--The functions of this scripts
--函数集
struct ppFuncStruct
(
--minus the first array from the second
--从数组一减去数组二
fn minusArr arrAll arrExclude  =
(	local a=arrAll.count
 	local b=arrExclude.count
	for i=1 to b do
	(	
		for j=arrAll.count to 1 by -1 do
		(		
			if arrAll[j]==arrExclude[i] do deleteItem arrAll j
		)
	) 
	arrAll
),
--calculate the same items
fn sameItemNum arr =
(	
	local c,i=1,j,k
	local newArr=#(),newSameArr=#()
	sort arr					--sort the array
	while i<=arr.count do
	(	
		k=0
		j=i+1
		while j<=arr.count do
		(	
			if arr[j]==arr[i] do 
			(	
				if (findItem newSameArr arr[i])==0	do 
				(	
					append newSameArr arr[i]
						--collect the same value
				)
				append newArr j		--collect the same item
				k=k+1	
			)
			j=j+1
		) 
		i=i+k+1
	)
	--return the same item numbers and the same value
	#(newArr.count,newSameArr)	
),
fn CommaNumbers numberstring divstring:"," = 
(	numCount=numberstring.count 
	 	for i = (numCount- 3) to 1 by -3 do
	 	(	numberstring = replace numberstring i 1 (numberstring[i]+divstring)
		 )
	  	numberstring
),
--Judge if it is VRay renderer
fn ifVRayRenderer =
(	local r=renderers.current as string
	if matchPattern r pattern:"V_ray*" then true
	else false
),
--Set default import mat
fn setdefaultMat mtlslot =
(	if defaultMtltype then
	(	if plusplusFunc.ifVRayRenderer() then
			meditMaterials[mtlslot] = VRayMtl name:("VRayMtl_"+mtlslot as string)
		else meditMaterials[mtlslot] = Standard name:("Standard_"+mtlslot as string)
	)
	else meditMaterials[mtlslot] = Standard name:("Standard_"+mtlslot as string)
	if defaultMatColor!=undefiend then
		meditmaterials[mtlslot].Diffuse = defaultMatColor
),
--import materials
fn importMtls mtlLibarary clicktimesV =
(			
			local tempLibNew = mtlLibarary
			local n=tempLibNew.count
			local m=24,mtlNames = #(),mtlItems=#(),tempNames=#()
			for o in 1 to n do
			(
				append mtlNames #(tempLibNew[o].name,o)
			)
			tempNames = for p in mtlNames collect (p as string)
			sort tempNames
			tempNames = for q in tempNames collect (execute q)
			tempLib = for r in tempNames collect (tempLibNew[r[2]])
			if n<m then 
			(
				for i=1 to n do meditMaterials[i]=tempLib[i]
				for i=n+1 to m do 
					setdefaultMat i
			) 
			else if n==m then
			(
				for i=1 to m do meditMaterials[i]=tempLib[i]
			)
			--if there is not enough mat slots,then the next screen
			else if n>m then
			(	timesMtl=n/m
				leaveMtl=mod n m as Integer
				if clicktimesV<timesMtl then
				(	for i=1 to m do
					meditMaterials[i]=tempLib[m*clicktimesV+i]
				)
				--import the last screen
				else if clicktimesV==timesMtl then
				(
					if leaveMtl!=0 do
					(
						for i=1 to leaveMtl do
							meditMaterials[i]=tempLib[m*clicktimesV+i]
						for i=leaveMtl+1  to m do 
							setdefaultMat i
					)
					if leaveMtl==0 do 
					(	importMtls mtlLibarary 0
					--	for i=1 to m do meditMaterials[i]=tempLib[m*clicktimesV+i]
						clicktimesV=0
					)
								
				)
				clicktimesV+=1
				--turn the mouse click listen to 0
				if clicktimesV>timesMtl do clicktimesV=0
			)
			clicktimesV 
),
--clean editor
fn cleanMedit mat =
(	MatEditor.Open()
	plusplusFunc.saveEptScene()
	if classof mat == material then
	(	ppImportMat=ppImportMatStr()
		for i in 1 to meditmaterials.count do meditmaterials[i]=mat name:(mat as string +"_"+i as string)
	)
),
--get missing map materials
fn getMissingmapMats =
(	fn get_names name a = append a name
	local missingmapMats=#()
	for i in scenematerials do
	(	tempFN=#()	
		enumerateFiles i get_names tempFN #missing
		if tempFN.count!=0 then
			append missingmapMats i
	)
	missingmapMats
),
fn getSceneMats =
(	
	--get scene materials
	cls=#()
	cnt=#()
	for i in scenematerials do
	(
		tempCls=(classof i) as string
		idx=finditem cls tempCls
		if idx == 0 then (
			append cls tempCls
			cnt[cls.count]=1
		)
		else (
			if cnt[idx]==undefined then cnt[idx]=1
			else cnt[idx]+=1
		)
	)
	for c in 1 to cls.count do cls[c]+=":"+cnt[c] as string
	sort cls
	cls
),
--Judge if the node was hidden or frozen
fn notHiddenOrFrozen obj = not (obj.isHidden or obj.isFrozen),
fn saveEptScene =
(	--refesh the materials 这是MAX的一个BUG，有时候场景中材质不会刷新，可以用这个搞定
	theFile = (GetDir #Scene + "\\uitool_temp.max") --define the file name
	saveNodes #() theFile --save no objects in the file
	deleteFile theFile --delete it again
),
fn matAndObjOps idx =
(		case idx of 
			(	1: (	--选择没有材质的物体
					noMtlObjs=#()
					for i in objects where notHiddenOrFrozen i do
					(	if i.material==undefined then
							(	
								if (isKindof i geometryclass and (iskindof i targetobject)==false) then append noMtlObjs i
								else try if (isKindof i shape) then ( if i.render_renderable then  append noMtlObjs i) catch()
							)
					)
					if noMtlObjs.count != 0 then
					(	select noMtlObjs
					)
					else AssetTracking.setpatch.caption ="没有找到符合条件的物体 ！"
				)
				2: --导入所有材质
				(	if sceneMaterials.count!=0 then (
					MatEditor.Open()
					ppImportMat.allMatCt=plusplusFunc.importMtls sceneMaterials ppImportMat.allMatCt
					)
					else AssetTracking.setpatch.caption ="场景中没有材质！"
				)
				3: --导入选择材质
				(	selectedMtls=#()
					for i in selection do
						if i.material!=undefined then
							if  (findItem selectedMtls i.material)==0 then
								append selectedMtls i.material	--collect mat of seleted objects
					if selectedMtls.count==0 then AssetTracking.setpatch.caption ="没有选择物体或选择物体没有材质！"
					else	
					(	MatEditor.Open()
						ppImportMat.selMatCt=plusplusFunc.importMtls selectedMtls ppImportMat.selMatCt
					)
				)
				4:  --导入同名材质
				(
					allMtls=for i in sceneMaterials  collect i.name	
					theSameMtls=(plusplusFunc.sameItemNum allMtls)[2]
					m=theSameMtls.count
					if m==0 then AssetTracking.setpatch.caption ="没有同名材质！"
					else
					(	MatEditor.Open()
						tempMtlLib=#()
						for i=1 to m do
							for j in sceneMaterials do
								if j.name==theSameMtls[i] then
										append tempMtlLib j
					ppImportMat.sameMatCt=plusplusFunc.importMtls tempMtlLib  ppImportMat.sameMatCt
					)
				)
				5: (	--导入丢失材质
					plusplusFunc.saveEptScene()
					missmapmats=plusplusFunc.getMissingmapMats()
					if missmapmats.count==0 then
						AssetTracking.setpatch.caption ="场景中没有丢失贴图的材质！"
					else 
					(	MatEditor.Open()
						ppImportMat.missMatCt=plusplusFunc.importMtls missmapmats ppImportMat.missMatCt
					)
				)
				default : OK
			)
),
--获取配色方案
fn getUIcol = 
(
	spUIColors=#()
	idx = getinisetting spInifilepath "Color" "Index"
	if idx == "0" then
	(
		--链接字
		spUIColors[1] = color 255 255 255
		--背景色
		spUIColors[2] = color 56 56 56
		--文本颜色
		spUIColors[3] = color 200 192 122
		--导航底色
		spUIColors[4] = color 67 67 78
	)
	else 
	(
		colstr = getinisetting spInifilepath "Color" ("Color"+idx)
		cols = filterString colstr "|"
		if cols.count == 12 then
			for i in 1 to 4 do 
			(	
				j = 1 + 3 * ( i - 1 )
				spUIcolors[i] = color (cols[j] as float) (cols[j+1] as float) (cols[j+2] as float)
			)
		else 
		(	
			setinisetting spInifilepath "Color" "Index" "0"
			plusplusFunc.getUIcol()
		)
	)
	spUIColors
)
)--end struct
plusplusFunc=ppFuncStruct()

try (DestroyDialog AssetTracking) catch()

rollout AssetTracking "模型整理器V1.9  BY:3dheima.com" width:336 height:408
(
	local sepStrs=""
	local listID = 1
	--材质分类存储
	local sepcMatCt=#(),sepcMat=#()
	--Treeview datas
	local theColors = plusplusFunc.getUIcol()
	local textNodes=#() 
	--script files
	local itemsFile=#(undefined)
	local clickStdmat=0,clickVraymat=0,clickSpemat=0,sceneObjs=#(),selectedMtls=#()
	dotNetControl tv "System.Windows.Forms.TreeView" pos:[8,32] width:160 height:280
	dotNetControl pb1 "Windows.Forms.Progressbar" pos:[8,320] width:320 height:24
	button setpatch "应用设置" pos:[112,344] width:216 height:56
	edittext file_path "" pos:[29,8] width:235 height:20
	checkbutton get_path "..." pos:[8,8] width:24 height:20 toolTip:"右击自定义设置路径"
	checkbox chk_Asset1 "删除相机" pos:[176,224] width:75 height:16 checked:false
	checkbox chk_Asset2 "删除灯光" pos:[256,224] width:75 height:16 checked:false
	checkbox chk_Asset5 "清理垃圾" pos:[256,56] width:75 height:16 checked:true
	checkbox chk_Asset6 "清除缓存" pos:[176,56] width:75 height:16 checked:true
	checkbox chk_Asset7 "删除元素" pos:[176,32] width:75 height:16 checked:true
	checkbox chk_Asset8 "毫米场景" pos:[256,104] width:75 height:16 checked:true
	checkbox chk_Asset9 "删除任务" pos:[256,80] width:75 height:16 checked:true
	checkbox chk_Asset10 "材质线框" pos:[256,32] width:80 height:16 checked:true
	checkbox chk_Asset11 "一个视图" pos:[256,128] width:75 height:16 checked:true
	checkbox chk_Asset12 "修改材质" pos:[176,80] width:75 height:16 checked:true
	checkbox chk_Assetsave "提示保存" pos:[176,176] width:75 height:16 checked:false
	checkbox chk_Asset13 "塌陷成组" pos:[256,200] width:75 height:16 checked:false
	checkbox chk_Asset14 "轴心局中" pos:[176,152] width:75 height:16 checked:true
	checkbox chk_groupFirst "群组优先" pos:[256,152] width:75 height:16 checked:true
	checkbox chk_Asset15 "收集贴图" pos:[176,104] width:75 height:16 checked:true
	checkbox chk_Asset16 "RAR打包" pos:[256,176] width:75 height:16 checked:false
	checkbox chk_Asset17 "同名合并" pos:[176,200] width:75 height:16 checked:false
	checkbox chk_Asset18 "跟踪显示" pos:[176,128] width:75 height:16 checked:true
	checkbox chk_Asset19 "标准材质转VRAY材质" pos:[176,248] width:152 height:16 checked:false
	checkbox chk_Asset20 "丢失贴图" pos:[176,272] width:75 height:16 checked:false
	checkbox chk_Asset21 "丢失Dlls" pos:[256,272] width:75 height:16 checked:false
	checkbutton btnName "加文件名" pos:[265,8] width:64 height:21
	button Akeypackage "手动打包" pos:[0,200] width:1 height:1
	edittext edtwinrar "" pos:[208,292] width:120 height:20
	button btnrar "RAR" pos:[176,292] width:32 height:20
	button btn4 "打开模型位置" pos:[8,344] width:96 height:56
	local savefilepath= ""
	local mapfiles=#()
	local sPath = (sysInfo.systemdir + "\\PackageRun.vbs")
	local maps_in_scene = usedMaps()
	local max_ini_file = getMAXIniFile()
	local get_last_open_file = getinisetting max_ini_file "FileList""File1"
	local path_of_file = getFilenamePath get_last_open_file
	local vr = renderers.current --读取当前渲染器 --读取当前VRAY渲染器
	
	fn notHiddenOrFrozen obj = not (obj.isHidden or obj.isFrozen)
	
	fn closeAllGroups obj =
	(
		sourceObj = for i in obj where isOpenGroupHead i collect i
		if sourceObj.count != 0 then for o in sourceObj do setGroupOpen o false else return true
		for j in 1 to sourceObj.count do closeAllGroups sourceObj
	)
	fn openAllGroups obj =
	(
		sourceObj = for i in obj where not isOpenGroupHead i collect i
		if sourceObj.count != 0 then for o in sourceObj do setGroupOpen o true else return true
		for j in 1 to sourceObj.count do openAllGroups sourceObj
	)
	
	--modify vraymtl
	--Judge if it is VRay renderer
	fn fl_ifVRayRenderer =
	(	local r=renderers.current as string
		if matchPattern r pattern:"V_ray*" then true
		else false
	)
	--minus the first array from the second
	fn fl_minusArr arrAll arrExclude  =
	(	local a=arrAll.count
 		local b=arrExclude.count
		for i=1 to b do
		(	
			for j=arrAll.count to 1 by -1 do
			(		
				if arrAll[j]==arrExclude[i] do deleteItem arrAll j
			)
		) 
		arrAll
	)

	--Convert materials:
	--Convert standard to vraymtl
	fn fl_StandardToVRayMtl origMtl = 
	(
		local r=VRayMtl()
		r.name=origMtl.name +"_Convert"
	
		if origMtl.bumpMap != undefined then
		(
			r.texmap_bump=origMtl.bumpMap
			r.texmap_bump_on=origMtl.bumpMapEnable
			r.texmap_bump_multiplier=origMtl.bumpMapAmount
		)
 
 		if origMtl.displacementMap != undefined then
		(	r.texmap_displacement=origMtl.displacementMap
			r.texmap_displacement_on=origMtl.displacementMapEnable
			r.texmap_displacement_multiplier=origMtl.displacementMapAmount
		)
	
		r.diffuse=origMtl.diffuse
		if origMtl.diffuseMap != undefined then
		(
			r.texmap_diffuse=origMtl.diffuseMap
			r.texmap_diffuse_on=origMtl.diffuseMapEnable
			r.texmap_diffuse_multiplier=origMtl.diffuseMapAmount
		)
	
		if origMtl.opacityMap != undefined then
		(
			r.texmap_opacity=origMtl.opacityMap
			r.texmap_opacity_on=origMtl.opacityMapEnable
			r.texmap_opacity_multiplier=origMtl.opacityMapAmount
		)
	
		r
	)
	--Create VRayMtl
	fn fl_CreateVRaymtl origMtl =
	(	if classof origMtl == Standardmaterial then origMtl = fl_StandardToVRayMtl origMtl
		if classof origMtl == Multimaterial then
		(	num = getNumSubMtls origMtl
			for i=1 to num do (
			setSubMtl origMtl i (fl_CreateVRaymtl (getSubMtl origMtl i))
			)
		)
		origMtl
	)
	fn fl_AllStandardToVraymtl convertobjs mtlLibrary =
	(	local tempMtl ,tempObjs=#()
		for i in mtlLibrary do
		(	tempMtl = fl_CreateVRaymtl i
			for o in convertobjs do
			(	if o.material==i then
				( 	o.material = tempMtl
					append tempObjs o
				)
			)
			convertobjs = fl_minusArr convertobjs tempObjs 
			tempObjs=#()
		)
	)
	-----CONN
	fn Version =
	(
	theVersionName = case ((maxVersion())[1]/1000) of
	(
	2: #max2
	3: #max3
	4: #max4
	5: #max5
	6: #max6
	7: #max7
	8: #max8
	9: #max9
	10: #max2008
	11: #max2009
	12: #max2010
	)
	)
----------
	fn setRenderResolution width height =
	(
		if (renderSceneDialog.isOpen()) then 
		(
			renderHeight = height
			renderWidth = width
			renderSceneDialog.update()	
		)			
		else 
		(
			renderHeight = height
			renderWidth = width
		)
	)
	
	fn copy_map sel dir up:undefined = (	----------//收集贴图 ,更新贴图
		for i in sel do (
			for v in usedmaps i do copyfile v (dir+"\\"+ filenamefromPath v )	--//复制使用中的贴图到指定
			if up != undefined and  i.material != undefined do (	
				local ss = getClassInstances bitmaptexture target:i.material
				for o in ss do o.filename = (dir+"\\"+ filenamefromPath o.filename )	--//复制后更新材质路径
		
			)
		)
	)
	
	fn addmap mapfile =
	(
		local mapfileN=mapfile as name
		local index = (finditem mapfiles mapfileN)
		if index == 0 do append mapfiles mapfileN
	)
	
	fn copybitmap old_files new_patch =
	(
		for f in old_files do 
		(
			filename = filenameFromPath f
			newfile = (new_patch + "\\" + filename)
			copyFile f newfile 
		)
	)
	
	fn mergeM = ----合并同名材质
	(	print ("mergeSameNameMatStart: "+localTime)
		baseM=#() --没有同名的材质
		baseMN=#()--没有同名的材质的名字
		noUseM=#()--除baseM外的同名的材质
		sm=scenematerials
		if sm.count>1 do(--if scene have no material do nothing
		baseM[1]=sm[1]
		baseMn[1]=sm[1].name
		numM=sm.count
		for i=2 to numM do --找出场景中没有同名的所有材质（同名的只取第一个）
		(
			mc=sm[i].name
			itm=findItem baseMn mc
			if itm == 0 then (append baseM sm[i];append baseMN sm[i].name) else append noUseM sm[i]
		)
		print ("analyse Scenematerial: "+localTime)
		numB=baseM.count
		geo=geometry as array
		numG=geo.count
		
		if noUseM.count>0 do for i=1 to numG do --合并同名材质
		(
			try( 
				ib=findItem baseMN (geo[i].material.name)
				if geo[i].material !=baseM[ib] do geo[i].material=baseM[ib] 
			   )	catch continue
		)
		print ("merge sameNameMat:     "+localTime)
		numNO=noUseM.count
		for m=1 to numNo do deleteItem sm (findItem sm noUseM[m])--删除多余材质
		print ("finished:              "+localTime)
		)--end if sm.count>1
	)--end mergeM
	
	--颜色转换
	fn getColFromArgb clr =
	(
		(DotnetClass "System.Drawing.Color").FromArgb 255 clr.r clr.g clr.b
	)
	--初始化列表
	fn initTreeView =
	(
		--是否显示左边的层级线
		tv.ShowLines = false
		--链接字的颜色
		tv.ForeColor = getColFromArgb theColors[1]	
		--背景色
		tv.BackColor = getColFromArgb theColors[2]	
		
		tv.Height = 280
		tv.Width = 160
		--按钮文本高度
		tv.ItemHeight = 16 
		--左边缩进
		tv.Indent=12 
		--边框形式，可以把 None 改成 Fixed3D 或者 FixedSingle
		tv.BorderStyle=(dotNetClass "System.Windows.Forms.BorderStyle").None 
	)
	--设置文本颜色
	fn refeshColor = if textNodes.count!=0 then for t in textNodes do t.ForeColor =getColFromArgb theColors[3]
	--用于主界面设置－－颜色设置项
	fn refeshUIColor =
	(
		--链接字的颜色
		tv.ForeColor = getColFromArgb theColors[1]
		tv.BackColor = getColFromArgb theColors[2]
		refeshColor()
	)
	fn refeshInfo =
	(	--刷新场景信息
		tv.Nodes.Clear()
		tv.BeginUpdate()
		tv.Nodes.add ""
		tv.Nodes.add "刷新场景信息"
		tv.Nodes.add sepStrs
		textNodes=#()
		noMtlObjsNum=0
		for i in objects do -- collect no materail objects
		(	if i.material==undefined then
			(	
				if (isKindof i geometryclass and (iskindof i targetobject)==false) then noMtlObjsNum+=1
				else try if (isKindof i shape)  then ( if i.render_renderable then noMtlObjsNum+=1) catch()
			)
		)
		tv.Nodes.add ("没材质物体:"+plusplusFunc.commaNumbers (noMtlObjsNum as string))
		--材质信息
		allMtls = for i in sceneMaterials collect i.name	--collect all the name of scene mat
		allMtlsNum = allMtls.count
		sameMtls=(plusplusFunc.sameItemNum allMtls)[1]
		tv.Nodes.add ("所有材质:"+plusplusFunc.commaNumbers (allMtlsNum as string))
		selectedMtls=#()--选择物体材质
		for i in selection do
			if i.material!=undefined then
				if  (findItem selectedMtls i.material)==0 then
					append selectedMtls i.material	--collect mat of seleted objects
		tv.Nodes.add ("选择物体材质:"+plusplusFunc.commaNumbers (selectedMtls.count as string))
		tv.Nodes.add ("同名材质:"+plusplusFunc.commaNumbers (sameMtls as string))
		missmapmats = (plusplusFunc.getMissingmapMats()).count
		tv.Nodes.add ("丢失贴图:"+plusplusFunc.commaNumbers (missmapmats as string))
		--具体材质类型
		if allMtlsNum!=0 then (
			tv.Nodes.add sepStrs  --空行
			matTypes=plusplusFunc.getSceneMats()
			for s in matTypes do
			(
				append sepcMat s
				append sepcMatCt 0
				tv.Nodes.add s
			)
		)
		refeshColor()
		tv.EndUpdate()
	)
	fn pressLink s nd =
	(	--单击第S屏第idx个链接
		idx=nd.index+1
		case s of
		(	1: 
			(	case idx of 
				(
					1: ()
					2: refeshInfo()
					4: plusplusFunc.matAndObjOps 1 --选择没有材质的物体
					5: plusplusFunc.matAndObjOps 2 --导入所有材质
					6: plusplusFunc.matAndObjOps 3 --导入选择材质
					7: plusplusFunc.matAndObjOps 4 --导入同名材质
					8: plusplusFunc.matAndObjOps 5 --导入丢失材质
					default: --导入特定材质
					(	totalId=tv.nodes.count
						if idx >=10 and idx <= totalId then
						(	str=nd.text
							str1=filterString str ":"
							cls=execute str1[1]
							matNum=execute str1[2]
							mats=for i in scenematerials where classof i == cls collect i
							if mats.count!=0 and mats.count==matNum then 
							(	MatEditor.Open()
								tempidx=finditem sepcMat str
								sepcMatCt[tempidx]=plusplusFunc.importMtls mats sepcMatCt[tempidx]
							)
							else refeshInfo()
						) --end if
					)--end default
				)--end case
			)
			default: ()
		)
	)
	
	on AssetTracking open do
	(
		--字符乱码，by SITT
		sstart = createFile (getDir #StartupScripts + "\\zh-cn.ms")
		Format "--字符乱码，by SITT\n(DotNetClass \"System.Windows.Forms.Application\").CurrentCulture = dotnetObject \"System.Globalization.CultureInfo\" \"zh-cn\"" to:sstart
		close sstart
		--
		initTreeView()
		refeshInfo()
		pb1.style = pb1.style.continuous
		pb1.backColor = (dotNetClass "System.Drawing.Color").darkGray
		pb1.foreColor = (dotNetClass "System.Drawing.Color").limegreen
		try file_path.text = if getfilenamepath maxFilePath == "" then "场景没有保存,找不到路径!" else getfilenamepath maxFilepath + "maps" catch()
		edtwinrar.text = "C:\Program Files\WinRAR\WinRAR.exe"
	)
	on AssetTracking close do
	(
		setinisetting "$scripts\\tools\\Maxbaby.ini" "AssetTracking_pos" "pos_x" ((GetDialogPos AssetTracking).x as string)
		setinisetting "$scripts\\tools\\Maxbaby.ini" "AssetTracking_pos" "pos_y" ((GetDialogPos AssetTracking).y as string)
	)
	on tv NodeMouseClick arg do
	(
		pressLink listID arg.Node
	)
	on setpatch pressed do
	(
		try (
		max select all --全选场景中物体
		pb1.value = 5
		setpatch.caption ="全选场景中物体" --完成显示状态文字
		
		-----塌陷成组
		if chk_Asset13.state then (
		setpatch.caption ="塌陷成组" --完成显示状态文字
		if selection.count==0 then
		(
		setpatch.caption ="你什么都没选！！！"
		)
		else
		(
		converttopoly $
		max group explode
		sel=(selection as array)
		mtl=#()
		append mtl sel[1].material
	
		for e in sel do
		(
		n=0
		for m in mtl do
		(
		try
		(
		if e.material==m then
		(
		n+=1
		)
		)catch()
		)
		if n==0 then
		(
		append  mtl e.material 
		)
		)
		progressstart "按材质塌陷中:"
		for e=1 to mtl.count do
		(
		progressupdate (100.0 * e / mtl.count)
		ef=#()
		for s = 1 to selection.count do 
		(
		if selection[s].material==mtl[e] then
		(
		append ef selection[s]
		)
		)
	
		for n=1 to ef.count do
		(
		try
		(
		polyop.attach ef[1] ef[n+1]
		)catch()
		)
	    
		)
		converttomesh $
		progressEnd()
		group selection name:(uniquename "塌陷后成组物体") select:true
		)
		)
		-----塌陷成组
		pb1.value = 10
		
		-----物体居中对齐
		if chk_Asset14.state then (
		setpatch.caption ="物体居中对齐" --完成显示状态文字
		if selection.count == 0 then setpatch.caption ="请先选择物体！"
		else 
		(	
			undo on (
			if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			for i in selectObj do CenterPivot i 
			)--end undo on
		)
		)
		-----物体居中对齐
		pb1.value = 15
		
		-----场景材质修改
		if chk_Asset12.state then (
		setpatch.caption ="场景材质修改" --完成显示状态文字
		if fl_ifVRayRenderer() then
		(
	    for v in (getClassInstances VrayMtl) do 
		(
			v.reflection_subdivs = 8
			v.reflection_maxDepth = 5
			v.reflect_minRate = -1
			v.reflect_maxRate = -1
			v.reflection_useInterpolation = off
			v.refraction_subdivs = 8
			v.refraction_maxDepth = 5
			v.refract_minRate = -1
			v.refract_maxRate = -1
			v.refraction_useInterpolation = off
		)
		for r in (getClassInstances RaytraceMaterial) do 
		(
			r.Ambient_Color_On = off
			r.Transparency_Color_On = off
			r.Luminosity_Color_On = off
			r.Options___Raytrace_Objects_in_Glass = off
			r.Options___Raytrace_Atmospherics_in_Glass = off
			r.Enable_Raytraced_Reflections = off
			r.Enable_Raytraced_Refractions = off
			r.Options___Self_Reflect_Refract = off
			r.Options___Reflect_Refract_Material_ID_s = off
			r.Options___Raytrace_Atmospherics = off
			r.Reflect_Color_On = 0
			format "findMaterial %\n" r.name
		)
		for m in (getClassInstances VrayMtl) do 
		(
			m.texmap_displacement_on = off
			m.texmap_displacement_multiplier = 100
			m.texmap_displacement = undefined
			m.texmap_displacement_on = on
		)
		for s in (getClassInstances Standardmaterial) do
		(
			s.displacementMapAmount = 100
			s.displacementMap = undefined
			s.displacementMapEnable = off
		)
		(
		a = sceneMaterials
		n = a.count
		for i=1 to n do 
		(
			---  if classof  a[i] == RaytraceMaterial 	 then  a[i] = standard()
			  if classof  a[i] == Standardmaterial AND classof  a[i].reflectionmap == Raytrace
			  then  a[i].reflectionmap = undefined
			  	  if classof  a[i] == Standardmaterial AND classof  a[i].diffusemap == Raytrace
			  then  a[i].diffusemap = undefined
			  if classof  a[i] == Arch___Design__mi AND classof  a[i].refl_color_map == Raytrace
			  then  a[i].refl_color_map = undefined
			  if classof  a[i] == Multimaterial do
			  (
				  J = a[i].numsubs
				   for k=1 to J do 
				  	  if classof  a[i][k] == Standardmaterial AND classof  a[i][k].reflectionmap == Raytrace
			  then  a[i][k].reflectionmap = undefined
				  )		
			  if classof  a[i] == Multimaterial do
			  (
				  J = a[i].numsubs
				   for k=1 to J do 
				  	  if classof  a[i][k] == Standardmaterial AND classof  a[i][k].diffusemap == Raytrace
			  then  a[i][k].diffusemap = undefined
				  )			  
		)
		)
		)
		else messagebox "当前渲染器不是VRay渲染器，无法设置【修改材质】请调整下先！" beep:false
	    )
		-----场景材质修改
		pb1.value = 20
		
		if (displaysafeframes==true) do (displaysafeframes=false) --开启关闭安全框
		setRenderResolution 500 500 --设置尺寸 500x500
		unfreeze objects --解除冻结的物体
		pb1.value = 25
		setpatch.caption ="设置尺寸 500x500" --完成显示状态文字
		
		-----显示一个视图
		if chk_Asset11.state then (
		setpatch.caption ="显示一个视图" --完成显示状态文字
		max vpt persp user --切换到透视图
		viewNum = viewport.numViews
		if viewNum !=1 then (max tool maximize) --//显示一个窗口
		viewport.setLayout #layout_1
		)
		viewport.SetRenderLevel #smoothhighlights --视图模式SMOOTH
		viewport.setShowEdgeFaces false --取消线框显示
		viewport.setGridVisibility 1 off --//清除gridline
		viewport.activeviewport = 1
		backgroundImageFilename = "" --取消背景中的贴图
		actionMan.executeAction 0 "340"  -- 取消栅格
		pb1.value = 30
		
		-----设置场景单位
		if chk_Asset8.state then (
		setpatch.caption ="设置场景单位" --完成显示状态文字
		units.MetricType =#millimeters --设置场景单位为毫米
		units.SystemType = #millimeters --设置系统单位为毫米
		)
		pb1.value = 35
		
		-----删除场景批量渲染任务
		if chk_Asset9.state then (
		setpatch.caption ="删除场景批量渲染任务" --完成显示状态文字
		nums = batchRenderMgr.numViews
		while nums > 0 do
		(
			batchRenderMgr.deleteView 1
			nums -= 1
		)
		nums = batchRenderMgr.numViews
		format "%%\n" "Views数量:" (nums as string)
		)
		pb1.value = 40
		
		-----删除场景相机
		if chk_Asset1.state then (
		setpatch.caption ="删除场景相机" --完成显示状态文字
		delete cameras
		)
		pb1.value = 45
		
		-----删除场景灯光
		if chk_Asset2.state then (
		setpatch.caption ="删除场景灯光" --完成显示状态文字
		delete lights
		)
		pb1.value = 50
		
		if chk_Asset6.state then (
		setpatch.caption ="清理环境面板/公用面板/清除LMLC缓存" --完成显示状态文字
		--关闭F10
		renderSceneDialog.close()
		--清理环境面板
		useEnvironmentMap = off
		environmentMap = undefined
		--清理公用版面
		rendShowVFB = on --打开默认帧渲染器窗口
		q = RaytraceGlobalSettings() --设定Ray渲染属性
		q.showMessages = false --关闭Ray渲染器提示
		q.showProgressDlg = false --关闭Ray渲染器进程
		rendSaveFile = false --关闭自动保存
		rendOutputFilename = "" --关闭输出路径
		rendUseNet = false --关闭联网渲染
		if fl_ifVRayRenderer() then
		(
			--清除LMLC缓存
			try vr.output_on = false catch()
			try vr.output_saveRawFile = false catch()
			try vr.output_splitgbuffer = false catch()
			try vr.output_rawFileName = "" catch()
			try vr.output_splitfilename = "" catch()
			try vr.output_splitRGB = false catch()
			try vr.output_splitAlpha = false catch()
			try vr.adv_irradmap_mode = 0 catch()
			try vr.adv_irradmap_loadFileName = "" catch()
			try vr.adv_irradmap_autoSaveFileName = "" catch()
			try vr.adv_irradmap_autoSave = false catch()
			try vr.adv_irradmap_switchToSavedMap = false catch()
			try vr.photonMap_mode = 0 catch()
			try vr.photonMap_loadFileName = "" catch()
			try vr.photonMap_autoSaveFileName = "" catch()
			try vr.photonMap_autoSave = false catch()
			try vr.photonMap_switchToSavedMap = false catch()
			try vr.lightcache_mode = 0 catch()
			try vr.lightcache_loadFileName = "" catch()
			try vr.lightcache_autoSaveFileName = "" catch()
			try vr.lightcache_autoSave = false catch()
			try vr.lightcache_switchToSavedMap = false catch()
			try vr.caustics_on = false catch()
			try vr.caustics_mode = 0 catch()
			try vr.caustics_loadFileName = "" catch()
			try vr.caustics_autoSaveFileName = "" catch()
			try vr.casutics_autoSave = false catch()
			try vr.caustics_switchToSavedMap = false catch()
			renderSceneDialog.update()
	    )
		else messagebox "当前渲染器不是VRay渲染器，无法设置【清除缓存】请调整下先！" beep:false
		)
		pb1.value = 55
		
		--删除场景中的元素
		if chk_Asset7.state then (
		setpatch.caption ="删除场景中的元素" --完成显示状态文字
		re = maxOps.GetCurRenderElementMgr() --Delete Renderelement
		re.removeallrenderelements() --Delete Renderelement
		renderSceneDialog.update() --更新F10
		)
		pb1.value = 60
		
		macros.run "Medit Tools" "clear_medit_slots" --清除材质编辑器中的材质
		setpatch.caption ="清除材质编辑器中的材质" --完成显示状态文字
		
		--材质线框颜色
		if chk_Asset10.state then (
		setpatch.caption ="材质线框颜色" --完成显示状态文字
		--get random color
			fn fl_getRandomcolor  =
			(	
				local randomcolor = random black white
				randomcolor
			)
			--minus the first array from the second
		fn fl_minusArr arrAll arrExclude  =
		(	local a=arrAll.count
	 		local b=arrExclude.count
			for i=1 to b do
			(	
				for j=arrAll.count to 1 by -1 do
				(		
					if arrAll[j]==arrExclude[i] do deleteItem arrAll j
				)
			) 
			arrAll
		)
			(	sceneObjs=#();s=sceneMaterials.count
				for i in objects do
				(	if i.material!=undefined then
						append sceneObjs i
				)
				if sceneObjs.count!=0 then
				(		max create mode
						with redraw off
						temp_objs=#()
						randomColor=fl_getRandomcolor()
						tempMtl=sceneMaterials[1]
						for j in sceneObjs where j.material==tempMtl do
						(		j.wirecolor=randomColor
								append temp_objs j
						)
						sceneObjs=fl_minusArr sceneObjs temp_objs
						temp_objs=#()
						for i=2 to s do
						(	ifMod2=mod i 2 as Integer
							if ifMod2==0 then
							(	randomColor=fl_getRandomcolor()
								tempMtl =sceneMaterials[i]
								for j in sceneObjs where j.material==tempMtl do
								(		j.wirecolor=randomColor
										append temp_objs j
								)
								sceneObjs=fl_minusArr sceneObjs temp_objs
								temp_objs=#()
							)--end  ifMod2==0
							else
							(	randomColor=white-randomColor
								tempMtl =sceneMaterials[i]
								for j in sceneObjs where j.material==tempMtl do
								(		j.wirecolor=randomColor
										append temp_objs j
								)
								sceneObjs=fl_minusArr sceneObjs temp_objs
								temp_objs=#()
							)--end 	ifMod2==1
						)--end for i=2 to s
						max views redraw
				)--end if sceneObjs.count!=0
				else setpatch.caption ="场景中没有材质！"
			)
		)
		pb1.value = 63
		
		--清理场景垃圾、XRef
		if chk_Asset5.state then (
		setpatch.caption ="清理场景垃圾、XRef" --完成显示状态文字
		xhz_num = xrefs.getXRefFileCount() 
		for i=1 to xhz_num do delete (xrefs.getXRefFile i)
		disableSceneRedraw()
		Max create mode
		freeSceneBitmaps()
		clearUndoBuffer()
		(
			t = trackviewnodes
			n = t[#Max_MotionClip_Manager]
	    try(
	            deleteTrackViewController t n.controller
	    )catch(getcurrentException())
		)
		--清除TrackViewNodes
		try(
		--numNoteTracks trackviewnodes[#max_motionClip_manager]
		while (numNoteTRacks TrackViewNodes.Max_MotionClip_Manager > 0) do
		(
			deleteNoteTrack TrackViewNodes.Max_MotionClip_Manager (getNoteTrack TrackViewNodes.Max_MotionClip_Manager 1)
		)
		)catch(getcurrentException())
		--清除Collisions
		reactor.clearStoredCollisions()
		unhide objects --显示所有物体
		gc()
		enableSceneRedraw();completeRedraw()
		---
		/*
		try(
		if selection.count != 0 then
			obj = for i in selection where notHiddenOrFrozen i and isGroupHead i collect i
		else obj = for i in objects where notHiddenOrFrozen i and isGroupHead i collect i
			openAllGroups obj
		
		SetSelectFilter 6
		max select all --全选场景中物体
		delete $ --删除所有HELPERS 物体
		if selection.count != 0 then
			obj = for i in selection where notHiddenOrFrozen i and isGroupHead i collect i
		else obj = for i in objects where notHiddenOrFrozen i and isGroupHead i collect i
			closeAllGroups obj
		SetSelectFilter 1
		)catch()
		*/
		)
		pb1.value = 65
		
		----收集贴图
		if chk_Asset15.state then (
		setpatch.caption ="第一次收集贴图" --完成显示状态文字
		path = file_path.text
		makedir (path)as string
		if path != undefined then 
		newPath = path;			
		s = getClassInstances BitmapTexture
		for i=1 to s.count do 
		(
			fileName = filenameFromPath s[i].filename
			newfile = (newPath + "\\" + filename)
			copyFile s[i].filename newfile 
			--pb1.color=green
			pb1.value=100.*i/s.count
		)
		----二次收集贴图
		local path = ""
	    path = file_path.text
		if path != undefined then 		
		savefilepath = path;
		enumeratefiles addmap
		sort mapfiles
		copybitmap mapfiles savefilepath
		setpatch.caption ="第二次收集贴图" --完成显示状态文字
		)
		pb1.value = 70
		
		file = file_path.text --预设路径
		pb1.value = 73
		setpatch.caption ="预设路径" --完成显示状态文字
		
		--路径跟踪显示
		if chk_Asset18.state then (
		setpatch.caption ="显示路径跟随管理器" --完成显示状态文字
		macros.run "Asset Tracking System" "AssetTrackingSystemShow" --显示路径跟随管理器
		)
		
		ATSOps.Refresh() --刷新
		setpatch.caption ="刷新资源跟踪器" --完成显示状态文字
		actionMan.executeAction -841213575 "2" --全选路径贴图
		setpatch.caption ="全选路径贴图" --完成显示状态文字
		--actionMan.executeAction -841213575 "0"
		ATSOps.SetPathOnSelection file CreateOutputFolder:true --自定义文件夹路径
		setpatch.caption ="自定义设置路径完成" --完成显示状态文字
		ATSOps.Refresh() --刷新
		setpatch.caption ="刷新资源跟踪器" --完成显示状态文字
		pb1.value = 75
		setpatch.caption ="自定义文件夹路径" --完成显示状态文字
		
		max select all --全选场景中物体
		setpatch.caption ="全选场景中物体" --完成显示状态文字
		
		--显示选中的物体材质
		try (
			if selection.count ==1 then
			(
				if selection[1].material != undefined then meditmaterials[medit.GetActiveMtlSlot()] = selection[1].material
				medit.UpdateMtlEditorBrackets()
				--// Brings up Material Editor
				--max mtledit;
			)
			else if selection.count > 1 then
			(
			--// Clears out the Material Editor
				defaultsFile = MeditUtilities.getDefaultsFile()
				defaultMtl = MeditUtilities.getDefaultMaterial defaultsFile
				global _meditMaterialsBeforeReset = #()
				for i in 1 to meditMaterials.count do
				(	
				append _meditMaterialsBeforeReset meditMaterials[i]
				meditMaterials[i] = defaultMtl name:(defaultMtl.localizedName + #'_' as string + i as string)
				)
			--// Makes Default Material
				matS = defaultMtl ()
				matS.name = (defaultMtl.localizedName + #'_' as string + i as string)
			
				slotcount = 1
				doneMats = #()
			--// Brings up Material Editor
				--max mtledit;
	
			--// Now put each objects material into the editor.
				for obj in selection do
					(
					mat = obj.material;
					if (mat != undefined) then
							(
								doneIt = findItem doneMats mat
								--// No repeat Materials
								if (doneIt == 0) then
								(
								setMeditMaterial slotcount mat
								slotcount += 1
								idx = doneMats.count + 1
								doneMats[idx] = mat
								)
							)
						if (slotcount > 24) then
						(
						format "Warning...all 24 material slots have been used!"
						break
						)
					)
			--// Update Material Editor
				medit.UpdateMtlEditorBrackets()
			)
			else if selection.count < 1 then
			(
			)
		)catch()
		setpatch.caption ="显示选中的物体材质" --完成显示状态文字
		ATSOps.Refresh() --刷新
		setpatch.caption ="刷新资源跟踪器" --完成显示状态文字
		MatEditor.close() --关闭材质管理器
		setpatch.caption ="关闭材质管理器" --完成显示状态文字
	    pb1.value = 80
			
		max tool zoomextents all --视图最大化显示
		pb1.value = 85
		setpatch.caption ="视图最大化显示" --完成显示状态文字
		
		----标准材质转换为VRay材质
		if chk_Asset19.state then (
		setpatch.caption ="标准材质转换为VRay材质" --完成显示状态文字
		if fl_ifVRayRenderer() then
		(	
			sceneObjs=for i in objects where i.material!=undefiend collect i
						mtlslib = for m in scenematerials where classof m == Standardmaterial or classof m == Multimaterial collect m
						if mtlslib.count != 0 then
						(
							fl_AllStandardToVraymtl sceneObjs mtlslib
						)
						else setpatch.caption ="场景中没有材质！"
			)-- end case
		else messagebox "当前渲染器不是VRay渲染器，无法设置【标准材质转换为VRay材质】请调整下先！" beep:false
		)
	    pb1.value = 90
		
		-----合并同名材质
		if chk_Asset17.state then (
		setpatch.caption ="合并同名材质" --完成显示状态文字
		mergeM()
		)
		pb1.value = 92
		
		--导入丢失贴图的材质到编辑器中
		if chk_Asset20.state then (
		setpatch.caption ="丢失贴图检查" --完成显示状态文字
		plusplusFunc.matAndObjOps 5 --丢失贴图检查
		)
		pb1.value = 94
		
		--导入丢失贴图的Dlls到编辑器中
		if chk_Asset21.state then (
		    macros.run "Medit Tools" "clear_medit_slots" --清空材质编辑器
			local ss = for i in (GetClassInstances missing_texturemap) collect (refs.dependents i)[1] --收集丢失插件材质
			messagebox ("     "+ ss.count as string +" 材质贴图Dlls丢失  \n 已经发送到材质编辑器中,请手动清除.")  beep:false
			for i in 1 to ss.count do meditMaterials[i] = ss[i] --发送到编辑器
		)
		pb1.value = 96
		
		-----WINRAR自动打包任务
		if chk_Asset16.state then (
		--WINRAR打包
		setpatch.caption ="WINRAR打包" --完成显示状态文字
		Akeypackage.pressed()
		)
		pb1.value = 98
		
		-----提示保存
		if chk_Assetsave.state then (
		setpatch.caption ="检测场景保存" --完成显示状态文字
		checkForSave() --检测场景保存
		)
		pb1.value = 100
		
		refeshInfo() --刷新列表
		setpatch.caption ="刷新列表" --完成显示状态文字
		clearSelection() --清除选中状态
		setpatch.caption ="清除选中状态" --完成显示状态文字
		setpatch.caption ="设定成功" --完成显示状态文字
		--闪屏错误
		)catch()
	)
	on get_path changed state do
	(
		refeshInfo() --刷新属性列表
	    if state then
	        (
	            file_path.text = getfilenamepath maxFilePath
			)else (
		        file_path.text = getfilenamepath maxFilePath + "maps"
		)
	)
	on get_path rightClick do
	(
		try (
		    file_path_s = getSavePath caption:"自定义设置路径" initialDir:(maxFilepath)
		    if (file_path_s != undefined) then
			file_path.text = file_path_s
		)catch()
	)
	on chk_Asset20 changed state do
	(
		if chk_Asset20.state==true then
		(
			chk_Asset21.state = false
			chk_Asset21.enabled = false
	    )
	    else
		(
			chk_Asset21.state = false
			chk_Asset21.enabled = true
		)
	)
	on chk_Asset21 changed state do
	(
		if chk_Asset21.state==true then
		(
			chk_Asset20.state = false
			chk_Asset20.enabled = false
		)
		else
		(
			chk_Asset20.state = false
			chk_Asset20.enabled = true
		)
	)
	on btnName changed state do
	(
		refeshInfo() --刷新属性列表
	    if state then
	        (
	            file_path.text = getfilenamepath maxFilePath + "maps\\" + getfilenamefile maxFileName
			)else (
		        file_path.text = getfilenamepath maxFilePath + "maps"
		)
	)
	on Akeypackage pressed do
	(
		checkForSave()  --检测文件是否有变化提示保存
		deleteFile (getfilenamepath maxFilepath + getfilenamefile maxFileName + "-" +((getlocaltime())[1] as string) + (formattedPrint (getlocaltime())[2] format: "02d") + (formattedPrint ((getlocaltime())[4]) format: "02d") + ".rar")
		
		--场景文件夹下生成一个 Archive文件夹
		makedir (getfilenamepath maxFilepath + "ModelPackage")as string 
		makedir (getfilenamepath maxFilepath + "ModelPackage\\" + "Maps")as string 
		
		--收集场景的贴图及场景文件
		for i in 1 to maps_in_scene.count do
		(
		pb1.value = 100.*i/maps_in_scene.count
		setpatch.caption = maps_in_scene[i]
		copyfile maps_in_scene[i] (getfilenamepath maxFilepath + "ModelPackage\\" + "Maps\\" + getFilenameFile maps_in_scene[i] + getFilenameType maps_in_scene[i])
		)
		copyfile get_last_open_file (getfilenamepath maxFilepath + "ModelPackage\\" + getFilenameFile get_last_open_file + getFilenameType get_last_open_file)
		
		--第二次重复收集贴图
		local path = ""
		path = getfilenamepath maxFilepath + "Maps"
		if path != undefined then 		
		savefilepath = path;
		enumeratefiles addmap
		sort mapfiles
		copybitmap mapfiles savefilepath
		
		---WINRAR打包
		sstart = createFile (sysInfo.systemdir + "\\PackageEmail.bat")
		Format "@Echo off\n" to:sstart
		Format "mode con cols=50 lines=5\n" to:sstart
		Format "color 0b\n" to:sstart
		Format "title 正在打包场景中中......请不要关闭本窗口n" to:sstart
	    su = getfilenamefile maxFileName + "-" +((getlocaltime())[1] as string) + (formattedPrint (getlocaltime())[2] format: "02d") + (formattedPrint ((getlocaltime())[4]) format: "02d")
		Format "echo 请稍后，正在打包进入中........根据文件大小决定压缩的速度\n" su to:sstart
	    rar = edtwinrar.text
	    pachout = getfilenamepath maxFilepath
		ver = Version()
		Format "\"%\" a -m5 -ep1 -o+ -ed -inul -ibck \"%%%.rar\" \"%ModelPackage\"\n" rar pachout su ver pachout to:sstart
		Format "echo 压缩打包完毕......谢谢使用.\n" su to:sstart
		lmdel = getfilenamepath maxFilepath + "ModelPackage\\"
		Format "rd \"%\" /q /s \n" lmdel to:sstart --删除tools文件夹
		dea = "%"
		Format "del %0\n" dea to:sstart
		close sstart
		
		--生成隐身运行VBS文件
		ssvbs = createFile (sysInfo.systemdir + "\\PackageRun.vbs")
		Format "On Error Resume Next\n" to:ssvbs
		Format "Set ws = CreateObject(\"Wscript.Shell\")\n" to:ssvbs
		Format "ws.run \"cmd /c PackageEmail.bat\",vbhide\n" to:ssvbs
		Format "set fso=createobject(\"scripting.filesystemobject\")\n" to:ssvbs
		Format "fso.DeleteFile WScript.ScriptFullName" to:ssvbs
		close ssvbs
		
		--执行打包任务
		shellLaunch sPath ""
	    
		--完成对话框文字
		setpatch.caption = ("提示：" + getfilenamefile maxFileName + "-" +((getlocaltime())[1] as string) + (formattedPrint (getlocaltime())[2] format: "02d") + (formattedPrint ((getlocaltime())[4]) format: "02d") + Version() + ".rar") + "       打包成功"
		if queryBox "打包正在进行中,根据MAX文件大小决定压缩速度,解压进度在电脑右下角WINRAR图标显示,是否打开文件夹查看是否已经解压完毕？" title:"提 示" then
		(
		shellLaunch (getfilenamepath maxFilepath) "" --打开模型文件夹
		)
	)
	on btnrar pressed do
	(
		try (
		winrar_path_s = (getOpenFileName caption:"查找Winrar所在位置" filename:(getDir #maxroot + "WinRAR.exe") types:"exe(*.exe)|*.exe")
		
		if (winrar_path_s != undefined) then
			edtwinrar.text = winrar_path_s
		)catch()
	)
	on btn4 pressed do
	(
		shellLaunch (if getfilenamepath maxFilePath == "" then "undefined" else getfilenamepath maxFilepath) "" --打开模型文件夹
		)
)
createDialog AssetTracking pos:[AssetTracking_dialog_pos_x, AssetTracking_dialog_pos_y] style:#(#style_toolwindow, #style_sysmenu)