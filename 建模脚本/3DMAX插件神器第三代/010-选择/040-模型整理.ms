global rightcus,moxingguanli
escapeenable = true
global a,cc,ca_ary,nums
(
	a = batchRenderMgr.GetView
	nums = batchRenderMgr.numViews
)
global msefile = getFilenamePath (getSourceFileName()) + "Maxmxzl.ini"
	
chk_1 = getinisetting msefile "Set_parameters" "chk_1" as integer
if chk_1 == undefined or chk_1 == 0 then chk_1 = 1
	
chk_2 = getinisetting msefile "Set_parameters" "chk_2" as integer
if chk_2 == undefined or chk_2 == 0 then chk_2 = 1
	
chk_3 = getinisetting msefile "Set_parameters" "chk_3" as integer
if chk_3 == undefined or chk_3 == 0 then chk_3 = 1
	
chk_4 = getinisetting msefile "Set_parameters" "chk_4" as integer
if chk_4 == undefined or chk_4 == 0 then chk_4 = 1
	
chk_5 = getinisetting msefile "Set_parameters" "chk_5" as integer
if chk_5 == undefined or chk_5 == 0 then chk_5 = 1
	
chk_6 = getinisetting msefile "Set_parameters" "chk_6" as integer
if chk_6 == undefined or chk_6 == 0 then chk_6 = 1
	
chk_7 = getinisetting msefile "Set_parameters" "chk_7" as integer
if chk_7 == undefined or chk_7 == 0 then chk_7 = 1
	
chk_8 = getinisetting msefile "Set_parameters" "chk_8" as integer
if chk_8 == undefined or chk_8 == 0 then chk_8 = 1
	
chk_9 = getinisetting msefile "Set_parameters" "chk_9" as integer
if chk_9 == undefined or chk_9 == 0 then chk_9 = 1
	
chk_10 = getinisetting msefile "Set_parameters" "chk_10" as integer
if chk_10 == undefined or chk_10 == 0 then chk_10 = 1
	
chk_11 = getinisetting msefile "Set_parameters" "chk_11" as integer
if chk_11 == undefined or chk_11 == 0 then chk_11 = 1
	
chk_12 = getinisetting msefile "Set_parameters" "chk_12" as integer
if chk_12 == undefined or chk_12 == 0 then chk_12 = 1
	
chk_13 = getinisetting msefile "Set_parameters" "chk_13" as integer
if chk_13 == undefined or chk_13 == 0 then chk_13 = 1
	
chk_14 = getinisetting msefile "Set_parameters" "chk_14" as integer
if chk_14 == undefined or chk_14 == 0 then chk_14 = 1
	
chk_15 = getinisetting msefile "Set_parameters" "chk_15" as integer
if chk_15 == undefined or chk_15 == 0 then chk_15 = 1

chk_16 = getinisetting msefile "Set_parameters" "chk_16" as integer
if chk_16 == undefined or chk_16 == 0 then chk_16 = 1
	
chk_17 = getinisetting msefile "Set_parameters" "chk_17" as integer
if chk_17 == undefined or chk_17 == 0 then chk_17 = 1
	
chk_18 = getinisetting msefile "Set_parameters" "chk_18" as integer
if chk_18 == undefined or chk_18 == 0 then chk_18 = 1
	
chk_19 = getinisetting msefile "Set_parameters" "chk_19" as integer
if chk_19 == undefined or chk_19 == 0 then chk_19 = 1
	
chk_20 = getinisetting msefile "Set_parameters" "chk_20" as integer
if chk_20 == undefined or chk_20 == 0 then chk_20 = 1

rcmenu rightcus
(
	menuitem resetcus "推荐选择项目"
	menuitem rncus "取消所有选择"
	
	on resetcus picked do
	(
		moxingguanli.chk1.state = true
		moxingguanli.chk2.state = true
		moxingguanli.chk3.state = true
		moxingguanli.chk4.state = true
		moxingguanli.chk5.state = true
		moxingguanli.chk6.state = true
		moxingguanli.chk7.state = false
		moxingguanli.chk8.state = true
		moxingguanli.chk9.state = true
		moxingguanli.chk10.state = true
		moxingguanli.chk11.state = true
		moxingguanli.chk12.state = true
		moxingguanli.chk13.state = true
		moxingguanli.chk14.state = true
		moxingguanli.chk15.state = true
		moxingguanli.chk16.state = false
		moxingguanli.chk17.state = false
		moxingguanli.chk18.state = false
		moxingguanli.chk19.state = false
		moxingguanli.chk20.state = false
		setinisetting msefile "Set_parameters" "chk_1" (moxingguanli.chk1.state as string)
		setinisetting msefile "Set_parameters" "chk_2" (moxingguanli.chk2.state as string)
		setinisetting msefile "Set_parameters" "chk_3" (moxingguanli.chk3.state as string)
		setinisetting msefile "Set_parameters" "chk_4" (moxingguanli.chk4.state as string)
		setinisetting msefile "Set_parameters" "chk_5" (moxingguanli.chk5.state as string)
		setinisetting msefile "Set_parameters" "chk_6" (moxingguanli.chk6.state as string)
		setinisetting msefile "Set_parameters" "chk_7" (moxingguanli.chk7.state as string)
		setinisetting msefile "Set_parameters" "chk_8" (moxingguanli.chk8.state as string)
		setinisetting msefile "Set_parameters" "chk_9" (moxingguanli.chk9.state as string)
		setinisetting msefile "Set_parameters" "chk_10" (moxingguanli.chk10.state as string)
		setinisetting msefile "Set_parameters" "chk_11" (moxingguanli.chk11.state as string)
		setinisetting msefile "Set_parameters" "chk_12" (moxingguanli.chk12.state as string)
		setinisetting msefile "Set_parameters" "chk_13" (moxingguanli.chk13.state as string)
		setinisetting msefile "Set_parameters" "chk_14" (moxingguanli.chk14.state as string)
		setinisetting msefile "Set_parameters" "chk_15" (moxingguanli.chk15.state as string)
		setinisetting msefile "Set_parameters" "chk_16" (moxingguanli.chk16.state as string)
		setinisetting msefile "Set_parameters" "chk_17" (moxingguanli.chk17.state as string)
		setinisetting msefile "Set_parameters" "chk_18" (moxingguanli.chk18.state as string)
		setinisetting msefile "Set_parameters" "chk_19" (moxingguanli.chk19.state as string)
		setinisetting msefile "Set_parameters" "chk_20" (moxingguanli.chk20.state as string)
	)
	on rncus picked do
	(
		moxingguanli.chk1.state = false
		moxingguanli.chk2.state = false
		moxingguanli.chk3.state = false
		moxingguanli.chk4.state = false
		moxingguanli.chk5.state = false
		moxingguanli.chk6.state = false
		moxingguanli.chk7.state = false
		moxingguanli.chk8.state = false
		moxingguanli.chk9.state = false
		moxingguanli.chk10.state = false
		moxingguanli.chk11.state = false
		moxingguanli.chk12.state = false
		moxingguanli.chk13.state = false
		moxingguanli.chk14.state = false
		moxingguanli.chk15.state = false
		moxingguanli.chk16.state = false
		moxingguanli.chk17.state = false
		moxingguanli.chk18.state = false
		moxingguanli.chk19.state = false
		moxingguanli.chk20.state = false
		setinisetting msefile "Set_parameters" "chk_1" (moxingguanli.chk1.state as string)
		setinisetting msefile "Set_parameters" "chk_2" (moxingguanli.chk2.state as string)
		setinisetting msefile "Set_parameters" "chk_3" (moxingguanli.chk3.state as string)
		setinisetting msefile "Set_parameters" "chk_4" (moxingguanli.chk4.state as string)
		setinisetting msefile "Set_parameters" "chk_5" (moxingguanli.chk5.state as string)
		setinisetting msefile "Set_parameters" "chk_6" (moxingguanli.chk6.state as string)
		setinisetting msefile "Set_parameters" "chk_7" (moxingguanli.chk7.state as string)
		setinisetting msefile "Set_parameters" "chk_8" (moxingguanli.chk8.state as string)
		setinisetting msefile "Set_parameters" "chk_9" (moxingguanli.chk9.state as string)
		setinisetting msefile "Set_parameters" "chk_10" (moxingguanli.chk10.state as string)
		setinisetting msefile "Set_parameters" "chk_11" (moxingguanli.chk11.state as string)
		setinisetting msefile "Set_parameters" "chk_12" (moxingguanli.chk12.state as string)
		setinisetting msefile "Set_parameters" "chk_13" (moxingguanli.chk13.state as string)
		setinisetting msefile "Set_parameters" "chk_14" (moxingguanli.chk14.state as string)
		setinisetting msefile "Set_parameters" "chk_15" (moxingguanli.chk15.state as string)
		setinisetting msefile "Set_parameters" "chk_16" (moxingguanli.chk16.state as string)
		setinisetting msefile "Set_parameters" "chk_17" (moxingguanli.chk17.state as string)
		setinisetting msefile "Set_parameters" "chk_18" (moxingguanli.chk18.state as string)
		setinisetting msefile "Set_parameters" "chk_19" (moxingguanli.chk19.state as string)
		setinisetting msefile "Set_parameters" "chk_20" (moxingguanli.chk20.state as string)
	)
)

---------界面 
try (DestroyDialog moxingguanli) catch()
rollout moxingguanli "模型整理器(黑马设计网3dheima.com)" width:496 height:208
(
	edittext file_path "" pos:[32,8] width:432 height:24
	button get_path "..." pos:[8,8] width:24 height:24 toolTip:"设置场景路径位置"
	checkbox chk1 "黑色线框" pos:[8,40] width:80 height:16 toolTip:"场景所有材质线框为黑色"
	checkbox chk2 "一个视图" pos:[88,40] width:80 height:16 toolTip:"视窗只显示一个,并且为顶视图+线框模式."
	checkbox chk3 "完全显示" pos:[168,40] width:80 height:16 toolTip:"完全显示场景中的物体,有BOX显示的情况下都会显示为实体."
	checkbox chk4 "重置材质" pos:[248,40] width:80 height:16 toolTip:"重置材质编辑器24个材质球为VRaymtl材质"
	checkbox chk5 "场景毫米" pos:[328,40] width:80 height:16 toolTip:"强制设置场景单位为毫米单位"
	checkbox chk6 "清理垃圾" pos:[408,40] width:80 height:16 toolTip:"清理碰撞等等垃圾,防止场景文件多大."
	checkbox chk7 "清理二维" pos:[8,64] width:80 height:16 toolTip:"清理场景中无用的二维线行."
	checkbox chk8 "收集贴图" pos:[88,64] width:80 height:16 toolTip:"收集场景材质到指定的文件夹下"
	checkbox chk9 "显示贴图" pos:[168,64] width:80 height:16 toolTip:"所有材质贴图漫反射显示"
	checkbox chk10 "材质修改" pos:[248,64] width:80 height:16 toolTip:"修复场景所有材质为默认参数,防止材质出问题."
	checkbox chk11 "参数还原" pos:[328,64] width:80 height:16 toolTip:"清空旧的参数信息.清空灯光缓存及发光贴图路径等等"
	checkbox chk12 "删除元素" pos:[408,64] width:80 height:16 toolTip:"删除场景中渲染的元素信息"
	checkbox chk13 "关闭群组" pos:[8,88] width:80 height:16 toolTip:"快速的关闭场景中所有的群组"
	checkbox chk14 "删除灯相" pos:[88,88] width:80 height:16 toolTip:"删除场景中的灯光及相机"
	checkbox chk15 "轴心居中" pos:[168,88] width:80 height:16 toolTip:"设置场景中的所有物体轴心居中"
	checkbox chk16 "合并同名" pos:[248,88] width:80 height:16 toolTip:"合并场景中有同名的材质"
	checkbox chk17 "丢失贴图" pos:[328,88] width:80 height:16 toolTip:"清理场景中丢失贴图的材质路径"
	checkbox chk18 "丢失DLL" pos:[408,88] width:80 height:16 toolTip:"清理场景丢失DLL的贴图插件"
	checkbox chk19 "清理空层" pos:[8,112] width:80 height:16 toolTip:"清理场景空层"
	checkbox chk20 "清理空物" pos:[88,112] width:80 height:16 toolTip:"清理场景空物体"
	button getMat "无位图材质载入" pos:[392,108] width:96 height:20 toolTip:"装载无位图的材质到材质编辑器上"
	button gettmmat "同名材质载入" pos:[304,108] width:87 height:20 toolTip:"装载场景中同名的材质到材质编辑器上"
	button getmissmat "丢失贴图载入" pos:[224,108] width:80 height:20 toolTip:"装载场景中丢失贴图的材质到材质编辑器上"
	button getwcmat "无材质" pos:[168,108] width:55 height:20 toolTip:"快速选择场中没有赋予材质的物体"
	button setpacth "确认以上操作" pos:[8,160] width:376 height:40 toolTip:"确认以上的操作参数"
	progressBar prg "ProgressBar" pos:[8,136] width:480 height:16
	button openFolder "打开文件夹" pos:[392,160] width:96 height:40 toolTip:"打开当前MAX场景的位置"
	checkbutton ckb_map "╋" pos:[466,8] width:24 height:24 toolTip:"路径位置快速转换"
	---
	local savefilepath= ""
	local mapfiles=#()
	


	fn openCC =
	(
		if (findString (filterString (renderers.current as string) ":")[2] "V_Ray") == undefined then 
		(
		renderarry = RendererClass.classes as array
		selrendernum = 0
		for i in 1 to renderarry.count do
		(
			if findString (renderarry[i] as string) "V_Ray" != undefined then 
			(
				selrendernum = i
				if (yesNoCancelBox "当前您的渲染器不是VRay渲染器,请指定!" title:"转换渲染器类型" beep:false ) == #yes then 
				(
					renderers.current = RendererClass.classes[i]() 
					findvrayandselvray = true
				)
				else 
				(
					findvrayandselvray = false
					try(DestroyDialog UsevalueRollout)catch()
				)
			)
		)
		if selrendernum == 0 then (findvrayandselvray = false;messageBox "no find vray ?";try(DestroyDialog UsevalueRollout)catch())
		)
		else findvrayandselvray = true
	)
	
	
	fn mergeM = ----合并同名材质
	(	
		--print ("mergeSameNameMatStart: "+localTime)
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
		--print ("analyse Scenematerial: "+localTime)
		numB=baseM.count
		geo=geometry as array
		numG=geo.count
		
		if noUseM.count>0 do for i=1 to numG do --合并同名材质
		(
			try( 
				ib=findItem baseMN (geo[i].material.name)
				if geo[i].material !=baseM[ib] do geo[i].material=baseM[ib] 
			)catch continue
		)
		--print ("merge sameNameMat:     "+localTime)
		numNO=noUseM.count
		for m=1 to numNo do deleteItem sm (findItem sm noUseM[m])--删除多余材质
		--print ("finished:              "+localTime)
		)--end if sm.count>1
	)--end mergeM
	
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
	
	fn kugegeoFilt o=
	((superclassof o==GeometryClass and classof o!=LinkComposite and not o.isTarget or superclassof o==Shape and classof o!=PolymorphicGeomshape and classof o!=LinkCompositeshape and o.baseobject.renderable)and IsValidNode o)

	fn ViewshapeFilt o=
	(o.isHiddenInVpt==false and o.isFrozen==false and superclassof o==Shape and classof o!=PolymorphicGeomshape and classof o!=LinkCompositeshape and  findItem KGL_ProxyXRefID(o.classid as string)==0 and not o.baseobject.renderable and IsValidNode o)

	--清除丢失贴图路径
	fn clearScencemissingMap = 
	(
		fn get_names name a = append a name
		delfilesname = #()
		enumerateFiles get_names delfilesname #missing
		theMaps = getClassInstances BitmapTexture
		for i in 1 to theMaps.count do
		(
			fileName = theMaps[i].filename
			if findItem delfilesname fileName != 0 then theMaps[i].filename = ""
		)
		if delfilesname.count != 0 then
		(
			print ("已为您清除" + ( delfilesname.count as string ) + "个丢失的贴图路径！")
		)
		else print "此场景没有丢失贴图！"
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
	
	fn lcl_Purge_ViewShape=
	(
		local kugeVIshape
		kugeVIshape=#()
		kugeselect=getCurrentSelection()
		thawSelection()
		clearSelection()               
		for ii in objects where ViewshapeFilt ii do
		(
			kugeAA=#()
			KL_nnnnb1=refs.dependents ii
			for lp in KL_nnnnb1 where IsValidNode lp do if kugegeoFilt lp or kugeshapeFilt lp do append kugeAA lp
			if kugeAA.count==0 do append kugeVIshape ii
		)                                             
		delete kugeVIshape     
		print ("共搜索并清除"+ kugeVIshape.count as string + "个可视图形对象")              
		kugeselect=for ji in kugeselect where IsValidNode ji collect ji
		select kugeselect
		gc light:true
	)	

	fn calcPercent val total = (
		ret = 100.0*val/total
		prg.value = ret
	)
	
	fn turnOnDiffuseMaps state = (
		coll = undefeind
		coll = objects as array
		tot = coll.count
		inc = 0
		for o in coll do(
			inc +=1
			if o.material != undefiend then (
				if (classof o.material) == standardMaterial then(
					try(
						if o.material.diffuseMap != undefined then(
							if classof (o.material.diffuseMap) == falloff then(
								if o.material.diffuseMap.map1 != undefined then(
									showTextureMap o.material o.material.diffuseMap.map1 state
								)else if o.material.diffuseMap.map2 != undefined then(
									showTextureMap o.material o.material.diffuseMap.map2 state
								)
							)else(
								showTextureMap o.material o.material.diffuseMap state
							)
						)
					)catch(
						print ("无法更新: " + o.name)
					)
				)else if (classof o.material) == VrayMtl then(
					try(
						if o.material.diffuseMap != undefined then(
							if classof (o.material.diffuseMap) == falloff then(
								if o.material.diffuseMap.map1 != undefined then(
									showTextureMap o.material o.material.diffuseMap.map1 state
								)else if o.material.diffuseMap.map2 != undefined then(
									showTextureMap o.material o.material.diffuseMap.map2 state
								)
							)else(
								showTextureMap o.material o.material.diffuseMap state
							)
						)
					)catch(
						print ("无法更新: " + o.name)
					)
				)else if (classof o.material) == Arch___Design__mi then(
					try(
						if o.material.diff_color_map != undefined then(
							if classof (o.material.diff_color_map) == falloff then(
								if o.material.diff_color_map.map1 != undefined then(
									showTextureMap o.material o.material.diff_color_map.map1 state
								)else if o.material.diff_color_map.map2 != undefined then(
									showTextureMap o.material o.material.diff_color_map.map2 state
								)
							)else(
								showTextureMap o.material o.material.diff_color_map state
							)
						)
					)catch(
						print ("无法更新: " + o.name)
					)
				)
				else if (classof o.material) == MultiMaterial then(
					for m in o.material do(
						if (classof m) == standardMaterial then(
							try(
								if m.diffuseMap != undefined then(
									if classof (m.diffuseMap) == falloff then(
										if m.diffuseMap.map1 != undefined then(
											showTextureMap m m.diffuseMap.map1 state
										)else if m.diffuseMap.map2 != undefined then(
											showTextureMap m m.diffuseMap.map2 state
										)
									)else(
										showTextureMap m m.diffuseMap state
									)
								)
							)catch(
								print (getCurrentException())
								print ("无法更新: " + o.name)
							)
						)else if (classof m) == Arch___Design__mi then(
							try(
								if m.diff_color_map != undefined then(
									if classof (m.diff_color_map) == falloff then(
										if m.diff_color_map.map1 != undefined then(
											showTextureMap m m.diff_color_map.map1 state
										)else if m.diff_color_map.map2 != undefined then(
											showTextureMap ml m.diff_color_map.map2 state
										)
									)else(
										showTextureMap m m.diff_color_map state
									)
								)
							)catch(
								print ("无法更新: " + o.name)
							)
						)else if (classof m) == VrayMtl then(
							try(
								if m.diffuseMap != undefined then(
									if classof (m.diffuseMap) == falloff then(
										if m.diffuseMap.map1 != undefined then(
											showTextureMap m m.diffuseMap.map1 state
										)else if m.diffuseMap.map2 != undefined then(
											showTextureMap m m.diffuseMap.map2 state
										)
									)else(
										showTextureMap m m.diffuseMap state
									)
								)
							)catch(
								print (getCurrentException())
								print ("无法更新: " + o.name)
							)
						)
					)
					
					
				)
			)
			calcPercent inc tot
		)
	)
	
	fn fl_ifVRayRenderer =
	(	local r=renderers.current as string
		if matchPattern r pattern:"V_ray*" then true
		else false
	)
	
	fn kugeMaterialsED kugeVC=
	(
		local lclD,mhyu,kugejmnl,kugejmn,kugematsun 
		lclD=(findItem kugeVC meditMaterials[24]) /(24 as Float)  
		for i=1 to 24 do(if i<10 then kugematsun=("0"+(i as string))
		else kugematsun=(i as string)
		meditMaterials[i]=standard name:(kugematsun+" - Default"))
		mhyu=lclD as Integer
		if lclD==mhyu and mhyu!=0 and (kugejmnl=kugeVC.count-(mhyu*24))>0 
		then(if kugejmnl>24 then kugejmn=24
		else kugejmn=kugejmnl
		for i=1 to kugejmn do meditMaterials[i]=kugeVC[(i+mhyu*24)]
		medit.SetActiveMtlSlot kugejmn true
		global KugeMETab=mhyu+1)
		else(if kugeVC.count>24 then kugejmn=24
		else kugejmn=kugeVC.count
		for i=1 to kugejmn do meditMaterials[i]=kugeVC[i]
		medit.SetActiveMtlSlot kugejmn true
		global KugeMETab=1)
		MatEditor.Open()
	)

	fn lcl_Purge_ZeroFace =
	(
		undo on(
			PU_NullOBJ=0
			KL_111=#()
			kugeselect=getCurrentSelection()
			if getCommandPanelTaskMode()!=#create do setCommandPanelTaskMode mode:#create
			thawSelection()
			clearSelection()     
			kugeZFdel=for t in geometry where((getPolygonCount t)[1]==0 and canConvertTo t Mesh)or classof t==LinkComposite collect t 
			KUgefff=for h in shapes where classof h==PolymorphicGeomshape or classof h==LinkCompositeshape collect h
			join kugeZFdel KUgefff
			for m in kugeZFdel do(if m.children!=undefined do for o in m.children do deleteItem m.children o
			if m.parent!=undefined do m.parent=undefined)
			PU_NullOBJ+=kugeZFdel.count
			for u in objects do if isGroupMember u and u.parent==undefined then(setGroupMember u false
			PU_NullOBJ+=1)
			else if isGroupHead u and u.children.count==0 do(append kugeZFdel u
			PU_NullOBJ+=1)
			delete kugeZFdel                 
			kugeselect=for ji in kugeselect where IsValidNode ji collect ji
			select kugeselect
			print ("共搜索并删除"+ PU_NullOBJ as string + "个空物体")
		)
	)

	fn lcl_Purge_NullLayer =
	(
		local  lclLA,lclLAnum
		lclLA=LayerManager.getLayer 0     
		lclLA.current=true                  
		lclLAnum=LayerManager.count	
		KL_VMNB1=lclLAnum-1              
		for u=1 to KL_VMNB1 do(xyjLA=LayerManager.getLayer (lclLAnum-u)     
		xyjLA.nodes &kugelayer                     
		if kugelayer.count==0 do LayerManager.deleteLayerByName xyjLA.name) 
		gc light:true
		print ("场景所有空层清除完毕!")
	)
	
	fn KHF_KGMaterialsED ZZ=     ----装载材质球函数,参数1输入材质集合数组;
	(
		KL_Type1=1   ----获得当前装载材质编辑器时的缺省材质类型
		lclD=(findItem ZZ meditMaterials[24])/(24 as Float)    ----检测当前材编最后一个球的材质在材质集合中的24倍序号(非整数,用来计算材质翻页):可以相等,不相等,为0
		for i=1 to 24 do(
			KL_StrN=i as string
			kugematsun=replace "00" (3-KL_StrN.count) KL_StrN.count KL_StrN
			case KL_Type1 of
			(
				1:(meditMaterials[i]=standard name:(kugematsun+" - Default"))
				2:(meditMaterials[i]=VRayMtl name:(kugematsun+" - Default"))   
				3:(meditMaterials[i]=Architectural name:(kugematsun+" - Default")) 
			)
		)                               -----根据输入参数类型,首先复位掉材编为各种类型的默认材质球;
		mhyu=lclD as Integer                             -----或得非整数序号数的对应整数,这两个值相等表示他们只能是0和24的倍数(这样他们才不会有余数);
		if lclD==mhyu and mhyu!=0 and (kugejmnl=ZZ.count-(mhyu*24))>0    ----这里同时满足三个条件才会翻后面的页:1.材质24的24倍序号数为整数,即此数必须是24的倍数;2.材质24必须被包含在材质集合数组;3.材质数组的数量必须大于当前24倍级
		then(if kugejmnl>24 then kugejmn=24
		else kugejmn=kugejmnl                             ---计算当前34倍级需要装载的材质球数量;
		for i=1 to kugejmn do meditMaterials[i]=ZZ[(i+mhyu*24)]     ----逐个装载
		medit.SetActiveMtlSlot kugejmn true        -----激活最后一个装载材质球;
		global KG_MEditTabNum=mhyu+1)            -----输出当前材质编辑器所处屏数的全局变量
		else(if ZZ.count>24 then kugejmn=24
		else kugejmn=ZZ.count
		for i=1 to kugejmn do meditMaterials[i]=ZZ[i]   ----因为是第一页,所以直接对应加载即可;
		medit.SetActiveMtlSlot kugejmn true
		global KG_MEditTabNum=1)                   -----输出当前材质编辑器所处屏数的全局变量
		MatEditor.Open()
		gc light:true
	)
	
	fn lcl_ME_fillNoneBitmap =
	(
		KL_lclar=#()
		for o in objects where isProperty o "Material" and o.Material!=undefined  do if (findItem KL_lclar o.material)==0 do append KL_lclar o.material 
		Kl_NoneBit=for m in KL_lclar where(usedMaps m).count==0 collect m     -----这个函数直接收集联合指定材质的所有位图对象;
		if Kl_NoneBit.count>0 do(KHF_KGMaterialsED Kl_NoneBit 
		messageBox ((Kl_NoneBit.count as string)+"个无位图材质--第"+(KG_MEditTabNum as string)+"屏"))
	)
	
	fn lcl_ME_fillHomonMat=
	(
		lcl5=0
		kugellgeo=for i in objects where kugegeoFilt i and i.Material!=undefined collect i 
		FlclMat=#()                    
		FlclMatnam=#()                  
		for o in kugellgeo where (findItem FlclMat o.material)==0 do append FlclMat o.material
		for o in kugellgeo where (findItem FlclMatnam o.material.name)==0 do append FlclMatnam o.material.name 
		lclMEarray=#()        
		for s=1 to FlclMatnam.count do(lcltemp=#()   
		for h in FlclMat where h.name==FlclMatnam[s] do append lcltemp h
		if lcltemp.count>1 do(lcl5+=1 
		join lclMEarray lcltemp))  
		if lclMEarray.count>0 do
		(
			kugeMaterialsED lclMEarray              
			messageBox ("当前场景共有"+(lcl5 as string)+"种同名材质----当前处于第"+(KugeMETab as string)+"屏")
		)
	)
	
	fn lcl_ME_fillMiBitmap =
	(
		lclMEarray=#()
		if environmentMap!=undefined and useEnvironmentMap do append lclMEarray environmentMap
		fn kugemapFN kugemap lclMEarrayB=(if (finditem lclMEarrayB kugemap)==0 do append lclMEarrayB kugemap)
		kugellgeo=for i in objects where kugegeoFilt i and i.Material!=undefined collect i 
		FlclMat=#()                                  
		for o in kugellgeo where (findItem FlclMat o.material)==0 do append FlclMat o.material
		for KI in FlclMat do(lclMEarrayB=#()
		enumeratefiles KI kugemapFN lclMEarrayB #missing 
		if lclMEarrayB.count>0 and (finditem lclMEarray KI)==0 do append lclMEarray KI)
		if lclMEarray.count>0 do
		(
			kugeMaterialsED lclMEarray              
			messageBox ("当前场景共有"+(lclMEarray.count as string)+"种丢失位图材质----当前处于第"+(KugeMETab as string)+"屏")
		)
	)
	
	fn Groupfiltrate vvvaaa addsdsd=           
	(
		local lcl_groupcol,kugegroup,lvlcount
		lcl_groupcol=#()
		kugegroup=#yes
		for pp in vvvaaa where isGroupMember pp and not isOpenGroupMember pp do
		(
			if (lvlcount=findItem lcl_groupcol pp.parent)== 0 then(append lcl_groupcol pp.parent
			append lcl_groupcol 1)
			else lcl_groupcol[lvlcount+1]+=1)
			for y=1 to lcl_groupcol.count by 2 do(if lcl_groupcol[y].children.count!=lcl_groupcol[y+1] do
			(
				kugegroup=yesNoCancelBox"新选择集中将包含有部分组,选择操作:\n是:整个选择.\n否:取消选择.\n取消:退出操作!"title:"部分组对象选择警告"
				exit
			)
		)
		if kugegroup==#yes do
		(
			thawSelection()
			select vvvaaa
			if addsdsd==true do for yy in selection do(if yy.isFrozen==true do unfreeze yy doLayer:true
			if yy.isHiddenInVpt==true do unhide yy doLayer:true))
			if kugegroup==#no do(thawSelection()
			clearSelection()
		)
	)
		
	fn lcl_Purge_NoneMatObj=
	(
		undo on(
			kugeAA=for ii in objects where kugegeoFilt ii and ii.material==undefined collect ii  
			Groupfiltrate kugeAA true
		)
	)
	
	on moxingguanli open do
	(
		try openCC() catch() --转换vray
		try file_path.text = if getfilenamepath maxFilePath == "" then "场景没有保存,找不到路径!" else getfilenamepath maxFilepath catch()
		
		chk_1 = getinisetting msefile "Set_parameters" "chk_1"
		if chk_1 == ""
		then (chk_1 = (false as BooleanClass)) else 
		chk1.checked = (chk_1 as BooleanClass)
			
		chk_2 = getinisetting msefile "Set_parameters" "chk_2"
		if chk_2 == ""
		then (chk_2 = (false as BooleanClass)) else 
		chk2.checked = (chk_2 as BooleanClass)
			
		chk_3 = getinisetting msefile "Set_parameters" "chk_3"
		if chk_3 == ""
		then (chk_3 = (false as BooleanClass)) else 
		chk3.checked = (chk_3 as BooleanClass)
			
		chk_4 = getinisetting msefile "Set_parameters" "chk_4"
		if chk_4 == ""
		then (chk_4 = (false as BooleanClass)) else 
		chk4.checked = (chk_4 as BooleanClass)
			
		chk_5 = getinisetting msefile "Set_parameters" "chk_5"
		if chk_5 == ""
		then (chk_5 = (false as BooleanClass)) else 
		chk5.checked = (chk_5 as BooleanClass)
			
		chk_6 = getinisetting msefile "Set_parameters" "chk_6"
		if chk_6 == ""
		then (chk_6 = (false as BooleanClass)) else 
		chk6.checked = (chk_6 as BooleanClass)
			
		chk_7 = getinisetting msefile "Set_parameters" "chk_7"
		if chk_7 == ""
		then (chk_7 = (false as BooleanClass)) else 
		chk7.checked = (chk_7 as BooleanClass)
			
		chk_8 = getinisetting msefile "Set_parameters" "chk_8"
		if chk_8 == ""
		then (chk_8 = (false as BooleanClass)) else 
		chk8.checked = (chk_8 as BooleanClass)
			
		chk_9 = getinisetting msefile "Set_parameters" "chk_9"
		if chk_9 == ""
		then (chk_9 = (false as BooleanClass)) else 
		chk9.checked = (chk_9 as BooleanClass)
			
		chk_10 = getinisetting msefile "Set_parameters" "chk_10"
		if chk_10 == ""
		then (chk_10 = (false as BooleanClass)) else 
		chk10.checked = (chk_10 as BooleanClass)
			
		chk_11 = getinisetting msefile "Set_parameters" "chk_11"
		if chk_11 == ""
		then (chk_11 = (false as BooleanClass)) else 
		chk11.checked = (chk_11 as BooleanClass)
			
		chk_12 = getinisetting msefile "Set_parameters" "chk_12"
		if chk_12 == ""
		then (chk_12 = (false as BooleanClass)) else 
		chk12.checked = (chk_12 as BooleanClass)
			
		chk_13 = getinisetting msefile "Set_parameters" "chk_13"
		if chk_13 == ""
		then (chk_13 = (false as BooleanClass)) else 
		chk13.checked = (chk_13 as BooleanClass)
			
		chk_14 = getinisetting msefile "Set_parameters" "chk_14"
		if chk_14 == ""
		then (chk_14 = (false as BooleanClass)) else 
		chk14.checked = (chk_14 as BooleanClass)
			
		chk_15 = getinisetting msefile "Set_parameters" "chk_15"
		if chk_15 == ""
		then (chk_15 = (false as BooleanClass)) else 
		chk15.checked = (chk_15 as BooleanClass)
			
		chk_16 = getinisetting msefile "Set_parameters" "chk_16"
		if chk_16 == ""
		then (chk_16 = (false as BooleanClass)) else 
		chk16.checked = (chk_16 as BooleanClass)
			
		chk_17 = getinisetting msefile "Set_parameters" "chk_17"
		if chk_17 == ""
		then (chk_17 = (false as BooleanClass)) else 
		chk17.checked = (chk_17 as BooleanClass)
			
		chk_18 = getinisetting msefile "Set_parameters" "chk_18"
		if chk_18 == ""
		then (chk_18 = (false as BooleanClass)) else 
		chk18.checked = (chk_18 as BooleanClass)
			
		chk_19 = getinisetting msefile "Set_parameters" "chk_19"
		if chk_19 == ""
		then (chk_19 = (false as BooleanClass)) else 
		chk19.checked = (chk_19 as BooleanClass)
			
		chk_20 = getinisetting msefile "Set_parameters" "chk_20"
		if chk_20 == ""
		then (chk_20 = (false as BooleanClass)) else 
		chk20.checked = (chk_20 as BooleanClass)
	)
	on moxingguanli rbuttondown mousehitpoint do
	(
		popupmenu rightcus
	)
	on get_path pressed do
	(
		try (
		    file_path_s = getSavePath caption:"自定义设置路径" initialDir:(maxFilepath)
		    if (file_path_s != undefined) then
			file_path.text = file_path_s
		)catch()
	)
	on chk1 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_1" (chk1.state as string)
		chk1.state = state
	)
	on chk2 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_2" (chk2.state as string)
		chk2.state = state
	)
	on chk3 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_3" (chk3.state as string)
		chk3.state = state
	)
	on chk4 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_4" (chk4.state as string)
		chk4.state = state
	)
	on chk5 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_5" (chk5.state as string)
		chk5.state = state
	)
	on chk6 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_6" (chk6.state as string)
		chk6.state = state
	)
	on chk7 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_7" (chk7.state as string)
		chk7.state = state
	)
	on chk8 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_8" (chk8.state as string)
		chk8.state = state
	)
	on chk9 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_9" (chk9.state as string)
		chk9.state = state
	)
	on chk10 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_10" (chk10.state as string)
		chk10.state = state
	)
	on chk11 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_11" (chk11.state as string)
		chk11.state = state
	)
	on chk12 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_12" (chk12.state as string)
		chk12.state = state
	)
	on chk13 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_13" (chk13.state as string)
		chk13.state = state
	)
	on chk14 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_14" (chk14.state as string)
		chk14.state = state
	)
	on chk15 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_15" (chk15.state as string)
		chk15.state = state
	)
	on chk16 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_16" (chk16.state as string)
		chk16.state = state
	)
	on chk17 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_17" (chk17.state as string)
		chk17.state = state
	)
	on chk18 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_18" (chk18.state as string)
		chk18.state = state
	)
	on chk19 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_19" (chk19.state as string)
		chk19.state = state
	)
	on chk20 changed state do
	(
		setinisetting msefile "Set_parameters" "chk_20" (chk20.state as string)
		chk20.state = state
	)
	on getMat pressed do
	(
		try (lcl_ME_fillNoneBitmap())catch()
	)
	on gettmmat pressed do
	(
		try (lcl_ME_fillHomonMat())catch()
	)
	on getmissmat pressed do
	(
		try (lcl_ME_fillMiBitmap())catch()
	)
	on getwcmat pressed do
	(
		try (lcl_Purge_NoneMatObj())catch()
	)
	on setpacth pressed do
	(
	
			if chk1.state then (
				try (
					for o in objects where kugegeoFilt o do o.wireColor=black
				)catch()
			)
			if chk2.state then (
				max vpt persp user --切换到透视图
				viewNum = viewport.numViews
				if viewNum !=1 then (max tool maximize) --//显示一个窗口
				viewport.setLayout #layout_1
				viewport.SetRenderLevel #wireFrame --视图模式SMOOTH
				viewport.setShowEdgeFaces false --取消线框显示
				viewport.setGridVisibility 1 off --//清除gridline
				viewport.activeviewport = 1
				backgroundImageFilename = "" --取消背景中的贴图
				actionMan.executeAction 0 "340"  -- 取消栅格
			)
			if chk3.state then (
				try (
					unfreeze objects --显示所有冻结物体
					unhide objects --显示所有物体
					max unhide all
					for i in objects do
					(	
						i.boxMode = false
						i.backFaceCull = false
						i.vertexTicks = false
						i.showTrajectory = false
						i.ignoreExtents = false
						i.showFrozenInGray = true
						i.showVertexColors = false
						i.allEdges = false
					)
				)catch()
			)
			if chk4.state then (
				try (
					for i=1 to MeditMaterials.count do 
					(
						MeditMaterials[i] = VRayMtl ()
						if i < 10  then MeditMaterials[i].Name = "0" +(i as string) +  " - 材质" else MeditMaterials[i].Name = (i as string) +  " - 材质"  
						--setMtlMeditFlags MeditMaterials[i] #{2..3} 
						--max mtledit
					)
				)catch()
			)
			if chk5.state then (
				try (
					units.MetricType =#millimeters --设置场景单位为毫米
					units.SystemType = #millimeters --设置系统单位为毫米
				)catch()
			)
			if chk6.state then (
				try (
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
					gc()
					enableSceneRedraw();completeRedraw()
				)catch()
			)
			if chk7.state then (
				try (lcl_Purge_ViewShape())catch()
			)
			if chk8.state then (
				try (
					local path = ""
					path = file_path.text
					if path != undefined then 		
					savefilepath = path;
					enumeratefiles addmap
					sort mapfiles
					copybitmap mapfiles savefilepath
					file = file_path.text --预设路径
					macros.run "Asset Tracking System" "AssetTrackingSystemShow" --显示路径跟随管理器
					ATSOps.Refresh() --刷新
					actionMan.executeAction -841213575 "2" --全选路径贴图
					ATSOps.SetPathOnSelection file CreateOutputFolder:true --自定义文件夹路径
					ATSOps.Refresh() --刷新
				)catch()
			)
			if chk9.state then (
				try (turnOnDiffuseMaps on)catch()
			)
			if chk10.state then (
				if fl_ifVRayRenderer() then
				(
					try (
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
						for mat in sceneMaterials do
						(
							if classOf mat == standardmaterial do
							if classOf mat.reflectionMap == Raytrace do
							(
								mat.reflectionMap = VRayMap ()
							)
							
							if classOf mat.refractionMap == Raytrace do
							(
								mat.refractionMap = VRayMap ()
							)
							
							if classOf mat == MultiMaterial do
							(
								for submat in mat.materialList do
								if classOf submat.reflectionMap == Raytrace do
								(
									submat.reflectionMap = VRayMap ()
								)
								
								if classOf submat.refractionMap == Raytrace do
								(
									submat.refractionMap = VRayMap ()
								)
							)
							
							if classOf mat == Blend do
							(
								if classof mat.map1.reflectionMap == Raytrace do
								(
									mat.map1.reflectionMap = VRayMap ()
								)
								
								if classof mat.map1.refractionMap == Raytrace do
								(
									mat.map1.refractionMap = VRayMap ()
								)
								
								if classof mat.map2.reflectionMap == Raytrace do
								(
									mat.map2.reflectionMap = VRayMap ()
								)
								
								if classof mat.map2.refractionMap == Raytrace do
								(
									mat.map2.refractionMap = VRayMap ()
								)
							)
						)
					)catch()
				)
				else messageBox "当前渲染器不是VRay渲染器,请调整一下"
			)
			if chk11.state then (
				try (
					nums = batchRenderMgr.numViews
					while nums > 0 do
					(
						batchRenderMgr.deleteView 1
						nums -= 1
					)
					nums = batchRenderMgr.numViews
					format "%%\n" "Views数量:" (nums as string)
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
						try renderers.current.output_on = false catch()
						try renderers.current.output_saveRawFile = false catch()
						try renderers.current.output_splitgbuffer = false catch()
						try renderers.current.output_rawFileName = "" catch()
						try renderers.current.output_splitfilename = "" catch()
						try renderers.current.output_splitRGB = false catch()
						try renderers.current.output_splitAlpha = false catch()
						try renderers.current.adv_irradmap_mode = 0 catch()
						try renderers.current.adv_irradmap_loadFileName = "" catch()
						try renderers.current.adv_irradmap_autoSaveFileName = "" catch()
						try renderers.current.adv_irradmap_autoSave = false catch()
						try renderers.current.adv_irradmap_switchToSavedMap = false catch()
						try renderers.current.photonMap_mode = 0 catch()
						try renderers.current.photonMap_loadFileName = "" catch()
						try renderers.current.photonMap_autoSaveFileName = "" catch()
						try renderers.current.photonMap_autoSave = false catch()
						try renderers.current.photonMap_switchToSavedMap = false catch()
						try renderers.current.lightcache_mode = 0 catch()
						try renderers.current.lightcache_loadFileName = "" catch()
						try renderers.current.lightcache_autoSaveFileName = "" catch()
						try renderers.current.lightcache_autoSave = false catch()
						try renderers.current.lightcache_switchToSavedMap = false catch()
						try renderers.current.caustics_on = false catch()
						try renderers.current.caustics_mode = 0 catch()
						try renderers.current.caustics_loadFileName = "" catch()
						try renderers.current.caustics_autoSaveFileName = "" catch()
						try renderers.current.casutics_autoSave = false catch()
						try renderers.current.caustics_switchToSavedMap = false catch()
						renderSceneDialog.update()
					)
					else messageBox "当前渲染器不是VRay渲染器,请调整一下"
				)catch()
			)
			if chk12.state then (
				try (
					re = maxOps.GetCurRenderElementMgr() --Delete Renderelement
					re.removeallrenderelements() --Delete Renderelement
					renderSceneDialog.update() --更新F10
				)catch()
			)
			if chk13.state then (
				try(
					if selection.count != 0 then
						obj = for i in selection where notHiddenOrFrozen i and isGroupHead i collect i
					else obj = for i in objects where notHiddenOrFrozen i and isGroupHead i collect i
						closeAllGroups obj
				)catch()
			)
			if chk14.state then (
				try (
					delete cameras
					delete lights
				)catch()
			)
			if chk15.state then (
				try (for i in objects do CenterPivot i)catch()
			)
			if chk16.state then (
				try (mergeM())catch()
			)
			if chk17.state then (
				try (clearScencemissingMap())catch()
			)
			if chk18.state then (
				macros.run "Medit Tools" "clear_medit_slots" --清空材质编辑器
				local ss = for i in (GetClassInstances missing_texturemap) collect (refs.dependents i)[1] --收集丢失插件材质
				messageBox (" "+ ss.count as string +" 材质贴图Dlls丢失  \n 已经发送到材质编辑器中,请手动清除.")  beep:false
				for i in 1 to ss.count do meditMaterials[i] = ss[i] --发送到编辑器
			)
			if chk19.state then (
				try (lcl_Purge_NullLayer())catch()
			)
			if chk20.state then (
				try (lcl_Purge_ZeroFace())catch()
			)
			prg.color=random black white
			prg.value = 100
		)	
	
	on openFolder pressed do
	(
		shellLaunch (if getfilenamepath maxFilePath == "" then "undefined" else getfilenamepath maxFilepath) "" --打开模型文件夹
	)
	on ckb_map changed state do
	(
	    if state then
		(
			file_path.text = getfilenamepath maxFilePath + "maps"
		)else (
			file_path.text = getfilenamepath maxFilePath
		)
	)
)
createdialog moxingguanli pos:mouse.screenpos style:#(#style_toolwindow,#style_sysmenu) 


