global rdw = renderwidth
global rdh = renderheight
global rdacp = (rdw as float )/rdh
global rdscale = 1
global renderjibie = #()
global renderjidi = #()
global renderdi = #()
global renderzhong = #()
global rendergao = #()
global renderjigao = #()
global VRayjianhuaRollout,DM_VRSkyroll,VR_Sunroll,Dir_Sunroll,DM_Renderroll
global xrgz = false            --记录光子选项状态--
global xrct = false			--记录成图选项状态--
global xrcztd = false			--记录材质通道选项状态--
global xrztd = false			--记录组通道选项状态--
global xrlmtd = false			--记录六面通道选项状态--
global xryztd = false			--记录影子通道选项状态--
global savecopy = false			--记录影子通道选项状态--
global endrenderclose = false			--记录影子通道选项状态--
global rentype,DDMM,CTname,CTpath,CTtype,maxcopyfile,shd  	-----获取渲染方方式----例如区域渲染、放大框渲染
global maxfile
		

rollout shd "渲染完关机" width:162 height:99
(
	label lbl1 "渲染完毕自动关机，单击取消关机退出关机。" pos:[14,9] width:142 height:31
	button btn1 "取消关机" pos:[37,50] width:86 height:30
	on shd open do
	(	doscommand "Shutdown.exe -s -t 60")
	on btn1 pressed do
	(
		doscommand "shutdown -a" 
		DestroyDialog shd
	)
)

-- global endrender=false --当值为FALSE时 可正常流程泻染 当为TRUE时 中止渲染流程
global rentype = getrendertype()           ----------------获取渲染类型---

try (destroydialog DM_Renderroll) catch()
--start FN 功能 -----------------------------------------------------
fn resetvray =  --重置Vray渲染器
	(
		renderers.current = Default_Scanline_Renderer() 
		renderers.current = Vray()
		renderers.current.filter_on = false   --关闭抗锯齿
		renderers.current.gi_on = true
		renderers.current.gi_primary_type = 0
		renderers.current.gi_secondary_type = 2
		renderers.current.imageSampler_type = 0                --将图像采样模式改为“fix”
		renderers.current.gi_irradmap_minRate = -5
	 	renderers.current.gi_irradmap_maxRate = -4
	 	renderers.current.gi_irradmap_subdivs = 20
	 	renderers.current.gi_irradmap_interpSamples = 20
	 	renderers.current.system_raycaster_memLimit = 12000
	)
	
---------------------关灯哈哈有点笨的方法不管那么多先用到再说-------------------------
	fn guandeng =
(
		a=(for i in lights where classof i != targetobject collect i)
        for i in a where classof i == VRayIES do
        (i.enabled=false 
	      hide i)
        for i in a where classof i == vraysun do 
        (i.enabled=false
          hide i)
        for i in a where classof i == VRayLight do 
        (i.on=false
	      hide i)
        for i in a where classof i == VRayAmbientLight do
        (i.enabled=false
         hide i)
        for i in a where i.isHiddenInVpt==false do 
        (i.on=false 
	     hide i
	     )
)
-----------------------------------------end-------------------------------------------
---------------------开灯哈哈有点笨的方法不管那么多先用到再说  *加了记忆功能看来这个没有了*--------------------------
	fn kaideng =
(
	a=(for i in lights where classof i != targetobject collect i)
for i in a where classof i == VRayIES do
(i.enabled=true
	hide i)
for i in a where classof i == vraysun do 
(i.enabled=true
    hide i)
for i in a where classof i == VRayLight do 
(i.on=true
	hide i)
for i in a where classof i == VRayAmbientLight do
(i.enabled=true
    hide i)
for i in a where i.isHiddenInVpt==false do 
(i.on=true )
for i in lights do i.isHidden =off 
)
-----------------------------------------end-------------------------------------------
 --这段代码飞浪哥的
 fn saveEptScene =
(--refesh the materials 这是MAX的一个BUG，有时候场景中材质不会刷新，可以用这个搞定
 theFile = (GetDir #Scene + "\\feilangtool_temp.max") --define the file name
 saveNodes #() theFile --save no objects in the file
 deleteFile theFile --delete it again
)
-----------------------------------vr相机通道用------------------------------------
fn xw_vrcm=(
	cccccc=viewport.getCamera()--------------------这个针对lwf流程时的vr相机
	if classof cccccc==VRayPhysicalCamera then
	(cccccc.f_number=2
	 cccccc.vignetting=false
	 cccccc.whiteBalance= color 255 255 255
     cccccc.shutter_speed=140
	)
	 --------useenvironmentmap=off
	)	
-------------------------材质转换把所有的材质转成standard材质并加自发光color随机-------
fn ranmtlcolor mat =
(
	if classof mat == standardmaterial then
    (colorrandom=random black white
	mat.Diffuse =colorrandom
	mat.diffuseMap = undefined
	mat.selfIllumAmount=100
	mat.reflectionMapEnable = off
	mat.refractionMapEnable = off
	mat.diffuseMapEnable = off
	mat.bumpMapEnable = off
	mat.opacity = 100
	mat.specularLevelMapEnable = off
	mat.specularLevel = 0
	)
	else
	if (classof mat==vraymtl)or (classof mat==vrayoverridemtl)or(classof mat==vray2sidedmtl)or (classof mat==vraymtlwrapper)or (classof mat==Multimaterial)or (classof mat==vrayblendmtl)  then
	(   colorrandom=random black white
		b=for a in objects where a.material==mat collect a
		b.material=Standardmaterial Diffuse:colorrandom selfIllumAmount:100
	)
	else
	if classof mat==multimaterial then
		for j=1 to mat.count do
		(
            if (classof mat[j]==vraymtl) or (classof mat[j]==vrayoverridemtl) or (classof mat[j]==vray2sidedmtl)or (classof mat[j]==vraymtlwrapper)or (classof mat[j]==Multimaterial) then
			(
				mat[j]=standard()
			)
		        ranmtlcolor mat[j]
		)			
	else
		if classof mat==topbottom then
			(if (classof mat.topMaterial==vraymtl)or (classof mat.topMaterial==vrayoverridemtl)or (classof mat.topMaterial==vray2sidedmtl)or (classof mat.topMaterial==vraymtlwrapper)or(classof mat.topMaterial==Multimaterial) then
				(
					mat.topMaterial = standard()
					)
			if (classof mat.bottomMaterial==vraymtl)or (classof mat.bottomMaterial==vrayoverridemtl)or (classof mat.bottomMaterial==vray2sidedmtl)or (classof mat.bottomMaterial==vraymtlwrapper)or(classof mat.bottomMaterial==Multimaterial) then
			(
				mat.bottomMaterial =standard()
				)
			ranmtlcolor mat.topMaterial
		    ranmtlcolor mat.bottomMaterial 
			)
	else
		if classof mat==blend then
		   (if (classof mat.map1==vraymtl)or (classof mat.map1==vrayoverridemtl)or (classof mat.map1==vray2sidedmtl)or (classof mat.map1==vraymtlwrapper)or(classof mat.map1==Multimaterial) then
			 (mat.map1 =standard()) 
		    if (classof mat.map2==vraymtl)or (classof mat.map2==vrayoverridemtl)or (classof mat.map2==vray2sidedmtl)or (classof mat.map2==vraymtlwrapper)or(classof mat.map2==Multimaterial) then
			 (mat.map2 =standard()) 			   
			ranmtlcolor mat.map1
		    ranmtlcolor mat.map2 
		   )
	)
fn xw_cztd =(
	saveEptScene() ---------------------------刷新场景中的材质------------------
	undo on
	(
	xw_vrcm ()
	guandeng ()-------关灯函数
	renderers.current.options_reflectionRefraction =off
	renderers.current.options_lights =off
	renderers.current.environment_gi_map_on =off
	renderers.current.gi_on=off
	renderers.current.options_dontRenderImage =off
	for i in scenematerials do ranmtlcolor i
	)
)
----------------------------------组通道-------------------------------------------------------------------
fn xw_tktd =(
	undo on(
	guandeng()
	xw_vrcm()
	renderers.current.options_reflectionRefraction =off
	renderers.current.options_lights =off
	renderers.current.environment_gi_map_on =off
	renderers.current.gi_on=off
	-----for i in objects where isgrouphead i do setgroupopen i false  --关闭场景中所有的组
	grouptou=(for i in objects where isgrouphead i collect i)----找到所有的组
    c=(for a in grouptou where not isgroupmember a collect a)-----找到最外层的组
for aa in c do
	(                                            -------在最外层的组当中循环
	setgroupopen aa false ---关闭外层组
	colorrandom=random black white                           ------随机色
	select aa
	try (selection.material=standardmaterial name:aa.name Diffuse:colorrandom selfIllumAmount:100) catch()--付材质
	clearSelection()
    )
select grouptou ----下面是针对没有在组内的物体
max select invert
for i in selection do(
	colorrandom=random black white
	if (superclassof i==GeometryClass) or (superclassof i==shape) then 
i.material=standardmaterial name:i.name Diffuse:colorrandom selfIllumAmount:100
)
clearSelection()
)
            )
---------------------------影子通道VR渲染器设定和灯光设定-------------------------------------------
/* fn xw_yztd = (
	undo on(
	guandeng()
	xw_vrcm()
	renderers.current.options_reflectionRefraction =off
	renderers.current.options_lights =on
	renderers.current.environment_gi_map_on =off
	renderers.current.gi_on=off
	renderers.current.options_overrideMtl_on=on
    renderers.current.options_overrideMtl_mtl=vraymtl name:"yztd" diffuse:(color 255 255 255)
	zg=(for i in lights where (classof i==TargetDirectionallight)or(classof i==targetSpot)or(classof i==VRaySun) collect i)
		for c in zg do
		(if (classof c==TargetDirectionallight) or (classof c==targetSpot) then
			(
			if (distance (c.pos) (c.target.pos))>50000 and c.shadowgenerator==VRayShadow then --自动找到主光（当主光的主点与目标点大于50米 且打开了阴影的时候 ）
			print c.name
-- 			c.name = "zg"
		    c.isHidden=off
		    c.on=true
            c.multiplier=5.0
            c.rgb=color 255 255 255
		    c.shadowColor=red
		    c.lightAffectsShadow =on
			)
			else 
			(if classof c==VRaySun then 
-- 			c.name="zg"
			c.isHidden=off
		    c.enabled=true
		    c.turbidity=2.0
		    c.intensity_multiplier=0.1
			)
			)
			)
) */
------------------------------------------------面通道-----------------------------------------------------------
fn xw_matd = (
	undo on(
	guandeng()
	xw_vrcm()
	renderers.current.options_reflectionRefraction =off
	renderers.current.options_lights =on
	renderers.current.environment_gi_map_on =off
	renderers.current.gi_on=off
	renderers.current.options_overrideMtl_on=on
    renderers.current.options_overrideMtl_mtl=vraymtl name:"mtd" diffuse:(color 255 255 255)
			
shang=TargetDirectionallight pos:[0,0,500000] rgb:(color 255 0 0)  name:"shang"  target:(targetObject pos:[0,0,0]) overShoot:on
			shang.baseObject.castShadows = off
xia=TargetDirectionallight pos:[0,0,-500000] rgb:(color 0 255 255)  name:"xia"  target:(targetObject pos:[0,0,0]) overShoot:on
			shang.baseObject.castShadows = off
zuo=TargetDirectionallight pos:[-500000,0,0] rgb:(color 0 255 0)  name:"zuo"  target:(targetObject pos:[0,0,0]) overShoot:on
			shang.baseObject.castShadows = off
you=TargetDirectionallight pos:[500000,0,0] rgb:(color 0 0 255)  name:"you"  target:(targetObject pos:[0,0,0]) overShoot:on
			shang.baseObject.castShadows = off
qian=TargetDirectionallight pos:[0,500000,0] rgb:(color 255 255 0)  name:"qian"  target:(targetObject pos:[0,0,0]) overShoot:on
			shang.baseObject.castShadows = off
hou=TargetDirectionallight pos:[0,-500000,0] rgb:(color 255 0 255)  name:"qian"  target:(targetObject pos:[0,0,0]) overShoot:on
			shang.baseObject.castShadows = off 
)
)
	
fn rendGZ =
	(
		renderers.current.gi_on = on
-- 	renderwidth = DM_Renderroll.spn343_width.value * 0.25   -- 没认上------------------------
-- 	renderheight =	DM_Renderroll.spn344_height.value * 0.25  -- 没认上------------------------
	rdw = DM_Renderroll.spn343_width.value
	rdh = DM_Renderroll.spn344_height.value
	renderwidth = rdw * 0.25
	renderheight = rdh * 0.25
	undo on(
				 
			 if (DM_Renderroll.ckb79_animationtype.state == true)
			then(
					renderers.current.adv_irradmap_mode = 4
					renderers.current.lightcache_mode = 1
					rendNThFrame = DM_Renderroll.spn366_gezhen.value
				)
			else(
					renderers.current.adv_irradmap_mode = 0  --------------光子调用为single frame (单帧) 
					renderers.current.lightcache_mode = 0
				)
				 
				 renderers.current.adv_irradmap_autoSave =on --开起保存光子
				 renderers.current.adv_irradmap_switchToSavedMap = on	---------打开自动调用光子
			)
		renderers.current.options_dontRenderImage = on 	-----------------不渲染最后图像

		 renderers.current.adv_irradmap_autoSaveFileName = (DM_Renderroll.edt18_GZpath.text+".vrmap")---设置光子的保存路径
		 renderers.current.gi_irradmap_showCalcPhase = on   ------打开跑光子时的显示
		 renderers.current.gi_irradmap_showDirectLight = on   -------光子分部显示打开 这种解释看来只有自己懂哈哈
	 try(
			renderers.current.lightcache_dontDelete=on
			renderers.current.lightcache_autoSave=on
			renderers.current.lightcache_switchToSavedMap=on
			renderers.current.lightcache_autoSaveFileName=(DM_Renderroll.edt18_GZpath.text+".vrlmap")
		)catch()
		renderSceneDialog.update()
	
	)
	
fn rendCT =
	(
		rdw = DM_Renderroll.spn343_width.value
		rdh = DM_Renderroll.spn344_height.value
		 renderers.current.options_dontRenderImage = false
	     -------------------------------------------------  光照贴图设置
		undo on(
					renderers.current.adv_irradmap_loadFileName = (DM_Renderroll.edt18_GZpath.text+".vrmap")
					renderers.current.adv_irradmap_mode = 2
					 try
						(
						 renderers.current.lightcache_loadFileName=(DM_Renderroll.edt18_GZpath.text+".vrlmap")
						 renderers.current.lightcache_mode=2
						)catch()
				)
		if (DM_Renderroll.ckb79_animationtype.state == true)
			then(rendNThFrame = 1)
		
		rendOutputFilename = DM_Renderroll.edt19_CTpath.text
		renderwidth = rdw * 1
		renderheight = rdh * 1
		renderSceneDialog.update()
	
	)
	
fn savecopyfile = 
	(
		maxfile = maxFilePath+maxfilename
		maxcopyfile = getfilenamepath maxfile +  getfilenamefile maxfile + "_DM副本.max"
		saveMaxFile maxcopyfile
	)	
	
fn DM_render =
(
	rdw = DM_Renderroll.spn343_width.value
	rdh = DM_Renderroll.spn344_height.value
	renderwidth = rdw * 1
	renderheight = rdh * 1
	renderSceneDialog.commit()  	----------渲染设置刷新设置-----------------
	 rentype = getrendertype()   	-----获取渲染方方式----例如区域渲染、放大框渲染
	 DDMM = DM_Renderroll.edt19_CTpath.text     
	 CTname=getfilenamefile DDMM
	CTpath=getfilenamepath DDMM
	CTtype=getFilenameType DDMM
 	if xrgz == true and xrct == true
		then (
			rendSaveFile = false
			rendGZ()
			max quick render
			max undo
			
			rendSaveFile = true
			rendCT()
			max quick render
			
			try
				(
					renderers.current.adv_irradmap_mode= 0
					renderers.current.lightcache_mode=0
					renderers.current.lightcache_switchToSavedMap=off
					renderers.current.adv_irradmap_switchToSavedMap = off
				)catch()			
			max undo)
	if xrgz == true and xrct == false
		then(
			rendGZ()
			max quick render
			max undo
			)
	if xrct == true  and  xrgz == false
		then(
			rendSaveFile = true
			rendCT()
			max quick render
			
			max undo
			)
	if savecopy == true then
	(
		savecopyfile()
	)
			
	if xrcztd == true then
	(
		xw_cztd()                                                               
		render camera  outputwidth:renderwidth  outputheight:renderheight  vfb: true  outputfile:(CTpath+CTname+"_cztd"+CTtype)  renderType:rentype
		max undo
	)
	if xrztd == true then
	(
		xw_tktd()
		render camera  outputwidth:renderwidth  outputheight:renderheight   vfb: true outputfile:(CTpath+CTname+"_Ztd"+CTtype)  renderType:rentype
		max undo	
	)
	if xrlmtd == true then
	(
		xw_matd()
		render camera  outputwidth:renderwidth  outputheight:renderheight   vfb: true outputfile:(CTpath+CTname+"_lmtd"+CTtype)  renderType:rentype
		max undo
	)
	
	if endrenderclose == true then
	
	(
		createdialog shd pos:[(sysInfo.desktopSize[1]*0.08),(sysInfo.desktopSize[2]*0.08)]
	)
	
)

fn returnframe = 
	(
		renderers.current.adv_irradmap_mode = 0
		renderers.current.adv_irradmap_autoSave = false--开起保存光子
		renderers.current.adv_irradmap_switchToSavedMap = false	---------打开自动调用光子
		renderers.current.lightcache_mode = 0
		renderers.current.lightcache_autoSave=false
		renderers.current.lightcache_switchToSavedMap=false
		
		)
--end FN 功能 

rollout DM_Renderroll "DM_VRay渲染助手" width:200 height:715
(
	--start隐藏窗口
	Timer hidewindow "" pos:[13,7] width:24 height:24 interval:400 active:true -- 反映时间可在此调节
	-- 输出尺寸
	GroupBox grp108_size "渲染尺寸" pos:[2,3] width:196 height:70 enabled:false
	spinner spn343_width "宽" pos:[23,24] width:63 height:16 range:[1,90000,500] type:#integer scale:1
	spinner spn344_height "高" pos:[105,24] width:63 height:16 range:[1,90000,500] type:#integer scale:1
	checkbutton ckb63_lock "L" pos:[172,22] width:20 height:20 enabled:true checked:true
	dropdownList ddl64_sizescale "" pos:[123,47] width:70 height:22 items:#("4", "2", "1", "1/2", "1/4", "1/8") selection:3
	label lbl141 "缩放比例：" pos:[53,50] width:70 height:19
	
	--渲染设置
	
	dropdownList ddl68_renderjibie "" pos:[98,96] width:95 height:22 items:#("极低", "低", "中", "高", "极高", "VRay参数简化") selection:6
	label lbl153 "级别：" pos:[56,99] width:41 height:19
	button btn295 "VRay" pos:[9,96] width:40 height:22 toolTip:"重置VRay渲染器，参数为最初测试参数！"
	GroupBox grp119 "渲染质量" pos:[2,75] width:196 height:48 enabled:false
	GroupBox grp120 "渲染个性化" pos:[2,354] width:196 height:246 enabled:false
	checkbox chk259_fanshe "反射" pos:[5,397] width:47 height:16 checked:true
	checkbox chk260_mohu "模糊" pos:[53,397] width:47 height:16 checked:true
	checkbox chk261_texiao "特效" pos:[101,371] width:47 height:16 checked:true
	checkbox chk262_daqi "大气" pos:[148,371] width:47 height:16 checked:true
	checkbox chk263_rendhide "渲隐" pos:[5,371] width:47 height:16
	checkbox chk264_kuaizhao "快照" pos:[53,371] width:47 height:16
	checkbox chk265_zhihuan "置换" pos:[101,397] width:47 height:16 checked:true
	checkbox chk266_VFB "VFB" pos:[148,397] width:47 height:16
	checkbox chk267_360quanjing "360全景图" pos:[101,452] width:93 height:17
	checkbox chk492_GI_AO "GI-AO" pos:[17,416] width:49 height:16
	button btn333_AOset "" pos:[67,416] width:25 height:16 toolTip:"AO设置"
	checkbox chk268_AOmap "AO贴图模拟" pos:[101,414] width:93 height:17
	colorPicker cp61_sumocolor "" pos:[64,434] width:27 height:17 color:(color 200 200 200)
	GroupBox grp121 "" pos:[4,467] width:192 height:7
	checkbox chk269_paichu "智能排除" pos:[101,433] width:93 height:17
	checkbox chk271_sumo "素模" pos:[17,434] width:47 height:16
	checkbox chk432_uselightcahe "灯光缓存" pos:[5,453] width:80 height:15
	GroupBox grp122 "" pos:[4,384] width:192 height:7
	checkbox chk272_TDmaterial "材质" pos:[5,477] width:47 height:16
	checkbox chk273_TDgroup "组" pos:[54,477] width:37 height:16
	checkbox chk302_TD6face "六面" pos:[101,477] width:46 height:16
	checkbox chk303_TDshadow "影子" pos:[148,477] width:47 height:16 enabled:false
	GroupBox grp138 "" pos:[4,490] width:192 height:7
	checkbox chk321_chengtu "成图" pos:[53,522] width:45 height:16
	checkbox chk322_guangzi "光子" pos:[6,522] width:47 height:16
	checkbutton ckb79_animationtype "动画模式" pos:[6,499] width:86 height:20 highlightColor:(color 255 100 0)
	spinner spn366_gezhen "隔帧" pos:[115,501] width:76 height:16 enabled:false range:[1,10000,1] type:#integer scale:1
	button btn268_Render "测试渲染" pos:[99,628] width:86 height:29 toolTip:"测试渲染"
	checkbutton ckb33 "" pos:[6,628] width:8 height:29 enabled:false highlightColor:(color 200 120 0) checked:true
	checkbutton ckb34 "" pos:[186,628] width:8 height:29 enabled:false highlightColor:(color 200 120 0) checked:true
	
	--效果控制
	GroupBox grp145 "效果控制" pos:[2,179] width:196 height:173 enabled:false
	slider sld13_GIbaohedu "GI色彩饱和度" pos:[13,198] width:180 height:44 range:[0,5,1] type:#float ticks:50
	slider sld14_GIduibidu "GI对比度" pos:[13,248] width:180 height:44 range:[0,5,1] type:#float ticks:50
	slider sld15_baoguang "曝光调整" pos:[13,298] width:180 height:44 enabled:false range:[0,2,1] type:#float ticks:50
	checkbox chk413_usebaoguang "" pos:[78,299] width:16 height:16
	spinner spn382_baoguang "" pos:[129,299] width:56 height:16 enabled:false range:[0,2,1] scale:0.01
	spinner spn383_GIduibidu "" pos:[129,248] width:56 height:16 range:[0,5,3.2025] scale:0.01
	spinner spn384_GIbaohedu "" pos:[129,197] width:56 height:16 range:[0,5,1] scale:0.01
	
	--灯光系统
	GroupBox grp241 "灯光系统" pos:[2,128] width:196 height:48 enabled:false
	dropdownList ddl103_lightsystem "" pos:[98,147] width:95 height:22 items:#("自动灯光", "HDRI模板", "用户自打灯") selection:3
	label lbl188 "灯光系统：" pos:[31,150] width:66 height:19
	GroupBox grp296 "" pos:[2,653] width:196 height:32
	
	--工具面板
	button btn370_renderyuansu "Ele" pos:[5,662] width:20 height:20 toolTip:" 渲染元素"
	button btn371_showlastframe "VF" pos:[26,662] width:20 height:20 toolTip:"显示最后渲染图像"
	button btn844 "Ma" pos:[47,662] width:20 height:20 toolTip:"打开材质编辑器"
	button btn845 "Ee" pos:[68,662] width:20 height:20 toolTip:"打开环境面板"
	button btn372_author "DM" pos:[175,662] width:20 height:20 toolTip:""
	edittext edt18_GZpath "" pos:[3,540] width:162 height:17 readOnly:true
	button btn619_GZpath "GZ" pos:[167,540] width:25 height:17 toolTip:"光子路径设置"
	edittext edt19_CTpath "" pos:[3,578] width:162 height:17 readOnly:true
	button btn620_CTpath "CT" pos:[168,579] width:24 height:17 toolTip:"成图路径设置"
	checkbox chk1397_CTsave "存图" pos:[6,560] width:47 height:16
	button btn1261_specialrender "最终渲染" pos:[16,628] width:82 height:29 toolTip:"光子+成图+各种通道渲染+渲染完关机(组合或者是任意一项)"
	button btn242_clearset "清除设置" pos:[103,520] width:87 height:18
	button btn25 "RS" pos:[89,662] width:20 height:20 toolTip:"打开渲染设置面板"
	checkbox chk221_savecopymax "MAX存副本" pos:[6,603] width:82 height:15
	checkbox chk245_rendendclosecp "渲染完关机" pos:[103,603] width:92 height:16
	
	local SUMOovmtl = vraymtl name:"SUMOoverridemtl" Diffuse:(color 200 200 200)
	
	
	
	
	on DM_Renderroll open do
	(
		spn343_width.value = rdw 
		spn344_height.value = rdh
		--------效果控制----------
		sld13_GIbaohedu.value = renderers.current.gi_saturation
		spn384_GIbaohedu.value = renderers.current.gi_saturation
		sld14_GIduibidu.value = renderers.current.gi_contrast
		spn383_GIduibidu.value = renderers.current.gi_contrast
		sld15_baoguang.value = renderers.current.colorMapping_brightMult
		spn382_baoguang.value = renderers.current.colorMapping_brightMult
		-------个性化-------
		chk263_rendhide.state = rendhidden
		chk261_texiao.state = renderEffects
		chk262_daqi.state = rendAtmosphere
		--VRay
		chk259_fanshe.state = renderers.current.options_reflectionRefraction
		chk260_mohu.state = renderers.current.options_glossyEffects
		chk265_zhihuan.state = renderers.current .options_displacement
		chk266_VFB.state = renderers.current.output_on
		if (chk266_VFB.state ==on)
		then (chk264_kuaizhao.enabled=false
				btn371_showlastframe.caption = "V")
	  	else (chk264_kuaizhao.enabled = true
				btn371_showlastframe.caption = "R")
		chk492_GI_AO.state = renderers.current.gi_ao_on
		--素模
		try (if(renderers.current.options_overrideMtl_on == true)
		then(if (renderers.current.options_overrideMtl_mtl.name == "SUMOoverridemtl")
			then(chk271_sumo.state = on 
					chk268_AOmap.enabled = false )else()))catch()
		--智能排除
		try(if (renderers.current.excludeListOverrideMtl.count != 0)then(chk269_paichu.state = true)else())catch()
		--AO贴图模拟
		try (if(renderers.current.options_overrideMtl_on == true)
			then(if (renderers.current.options_overrideMtl_mtl.name == "AOoverridemtl")
				then(chk268_AOmap.state = on
					chk271_sumo.enabled = false)else()))catch()
		--灯光缓存
		try(if (renderers.current.gi_secondary_type == 3)then(chk432_uselightcahe.state = true)else())catch()
			--360全景
		try(if(renderers.current.camera_type == 1)then(chk267_360quanjing.state = on)else())catch()
			--动画模式
		renderSceneDialog.update()
		try(
			if rendTimeType != 1
			then (ckb79_animationtype.state = on
					spn366_gezhen.enabled = on
					)
				else (ckb79_animationtype.state = off
					spn366_gezhen.enabled = off
					)
					)catch()
		  -- 光子路径
		local GZLJ = renderers.current.adv_irradmap_autoSaveFileName
		  try (edt18_GZpath.text = getfilenamepath GZLJ + getfilenamefile GZLJ )catch()
			try (renderers.current.adv_irradmap_loadFileName = renderers.current.adv_irradmap_autoSaveFileName)catch()
		  --成图路径
	    try (edt19_CTpath.text = rendOutputFilename)catch()
		--存图
		 chk1397_CTsave.state = rendSaveFile
		--隔帧
		spn366_gezhen.value = rendNThFrame 
					
	)
	on DM_Renderroll moved pos do
	(
		if ((getdialogpos DM_Renderroll)[2] < 1 ) then setdialogpos DM_Renderroll [(getdialogpos DM_Renderroll)[1],-715]  ---当窗口拖动到顶边时隐藏界面。（也就是面版的Y轴到顶边时就设定Y轴位置为隐藏窗口的高度，为什么是-690而不是-600因为面版边框和要留出的多少有关。）
	)
	on hidewindow tick do
	(
		if (getdialogpos DM_Renderroll)[2] < 0 
		then  ---如果面版Y轴<0 （判断面版处于隐藏状态）
			(
				if ( mouse.screenpos[1] as integer >= (getdialogpos DM_Renderroll)[1] and mouse.screenpos[1] as integer <= ((getdialogpos DM_Renderroll)[1] + 240 ) and mouse.screenpos[2] as integer <= 1 )   --当鼠标经过隐藏界面留出部份时。。。
				then setdialogpos DM_Renderroll [(getdialogpos DM_Renderroll)[1],1]  --面版位置显示
			) 
		else  ---如果面版为显示状态则。。。
			(
				if (getdialogpos DM_Renderroll)[2] == 1 do  --判断面版正处在隐藏后唤出的状态。。（Y轴为1时，也就是说如果面版被拖到屏幕中不靠顶的话下面的动作无效）
				(
					if ( mouse.screenpos[1] as integer <= (getdialogpos DM_Renderroll)[1] or mouse.screenpos[1] as integer >= ((getdialogpos DM_Renderroll)[1] + 240 ) or mouse.screenpos[2] as integer >= 510 )  --如果鼠标超出面版范围后。。。
					then setdialogpos DM_Renderroll [(getdialogpos DM_Renderroll)[1],-715]  --面版又隐藏起来

				)
			) 
	)
	on spn343_width changed val do
	(
		
		if ckb63_lock.state == true
		then (spn344_height.value =  spn343_width.value  / rdacp  )
		else
		( 
			rdacp =(spn343_width.value as float ) / spn344_height.value
		)	
	)
	on spn344_height changed val do
	(
		
		if ckb63_lock.state == true
		then (spn343_width.value =  spn344_height.value  * rdacp )
		else
		( 
			rdacp = (spn343_width.value as float ) / spn344_height.value
		)	
	)
	on ddl64_sizescale selected sel do
	(
		case sel of 
		(
		1:(rdscale = 4)
		2:(rdscale = 2)
		3:(rdscale = 1)            
		4:(rdscale = 0.5)          
		5:(rdscale = 0.25)         
		6:(rdscale = 0.125)        
		Default:rdscale = 1
		)
	)
	on ddl68_renderjibie selected sel do
	(
		
			-------------------------------------------------------------------
			append renderjidi 	"renderers.current.imageSampler_type = 0"
			append renderjidi	"renderers.current.filter_on = off "                   --关闭抗锯齿
			append renderjidi	"renderers.current.gi_irradmap_minRate = -6"
			append renderjidi	"renderers.current.gi_irradmap_maxRate = -6"
			append renderjidi	"renderers.current.gi_irradmap_subdivs = 20"
			append renderjidi	"renderers.current.gi_irradmap_interpSamples = 20"
			append renderjidi	"renderers.current.lightcache_subdivs=100"
			append renderjidi	"renderers.current.dmcgi_subdivs=5"
			
			-----------------------------------------------------------------------
			append renderdi		"renderers.current.imageSampler_type = 0"
			append renderdi		"renderers.current.filter_on = off  "                  --关闭抗锯齿
			append renderdi		"renderers.current.gi_irradmap_minRate = -5"
			append renderdi		"renderers.current.gi_irradmap_maxRate = -4"
			append renderdi		"renderers.current.gi_irradmap_subdivs = 20"
			append renderdi		"renderers.current.gi_irradmap_interpSamples = 20"
			append renderdi		"renderers.current.lightcache_subdivs=200"
			append renderdi		"renderers.current.dmcgi_subdivs=8"
				
			-----------------------------------------------------------------------
			append renderzhong		"renderers.current.imageSampler_type = 2"
			append renderzhong		"renderers.current.filter_on = on   "                 --抗锯齿
			append renderzhong		"renderers.current.filter_kernel = Area()"
			append renderzhong		"renderers.current.gi_irradmap_minRate = -3	"
			append renderzhong		"renderers.current.gi_irradmap_maxRate = -2"
			append renderzhong		"renderers.current.gi_irradmap_subdivs = 50"
			append renderzhong		"renderers.current.gi_irradmap_interpSamples = 40"
			append renderzhong		"renderers.current.lightcache_subdivs=1200"
			append renderzhong		"renderers.current.dmcgi_subdivs=10"
			
			-----------------------------------------------------------------------
			append rendergao		"renderers.current.imageSampler_type = 1"
			append rendergao		"renderers.current.filter_on = on   "                --抗锯齿
			append rendergao		"renderers.current.filter_kernel = Catmull_Rom()"
			append rendergao		"renderers.current.gi_irradmap_minRate = -3	"
			append rendergao		"renderers.current.gi_irradmap_maxRate = -1"
			append rendergao		"renderers.current.gi_irradmap_subdivs = 50"
			append rendergao		"renderers.current.gi_irradmap_interpSamples = 80"
			append rendergao		"renderers.current.lightcache_subdivs=1500"
			append rendergao		"renderers.current.dmcgi_subdivs=12"
			
			-----------------------------------------------------------------------
			append  renderjigao		"renderers.current.imageSampler_type = 1"
			append  renderjigao		"renderers.current.filter_on = on    "                --抗锯齿
			append  renderjigao		"renderers.current.filter_kernel = Catmull_Rom()"
			append  renderjigao		"renderers.current.gi_irradmap_minRate = -3	"
			append  renderjigao		"renderers.current.gi_irradmap_maxRate = 0"
			append  renderjigao		"renderers.current.gi_irradmap_subdivs = 50"
			append  renderjigao		"renderers.current.gi_irradmap_interpSamples = 80"
			append  renderjigao		"renderers.current.lightcache_subdivs=2000"
			append  renderjigao		"renderers.current.dmcgi_subdivs=15"
			
			case sel of
			(	
				1: (renderjibie = renderjidi;try (destroyDialog VRayjianhuaRollout)catch())
				2: (renderjibie = renderdi;try (destroyDialog VRayjianhuaRollout)catch() )
				3: (renderjibie = renderzhong;try (destroyDialog VRayjianhuaRollout)catch() )
				4: (renderjibie = rendergao;try (destroyDialog VRayjianhuaRollout)catch() )
				5: (renderjibie = renderjigao;try (destroyDialog VRayjianhuaRollout)catch() )
				6: (
					try (filein (getdir #scripts + "\DM Tools\\DM_VRay 简化1.0.mse"))catch(messagebox "没有找到VRay参数简化脚本" title:"DM温馨提示！")
					)
				Default:6
			)
			if ddl68_renderjibie.selection != 6
			then (
					for f in renderjibie do(try execute f catch())
					)
			else()
			renderSceneDialog.update()
		
	)
	on btn295 pressed do
	(
		if queryBox "确定要初始化VRay吗？\n是：初始化！\n否：不初始化！" title:"DM温馨提示！"
			then(resetvray())else()
	)
	on chk259_fanshe changed state do
	(
		renderers.current.options_reflectionRefraction = chk259_fanshe.state
	)
	on chk260_mohu changed state do
	(
		renderers.current.options_glossyEffects = chk260_mohu.state
	)
	on chk261_texiao changed state do
	(
	renderEffects =chk261_texiao.state
	renderSceneDialog.update()
	)
	on chk262_daqi changed state do
	(
		rendAtmosphere = chk262_daqi.state
		renderSceneDialog.update()
	)
	on chk263_rendhide changed state do
	(
		rendhidden = chk263_rendhide.state 
		renderSceneDialog.update()
	)
	on chk264_kuaizhao changed state do
	(
	if (state == on)
	then (
	     chk266_VFB.enabled = false
	     )
	else (
	     chk266_VFB.enabled = true
	     )
	)
	on chk265_zhihuan changed state do
	(
		renderers.current .options_displacement = chk265_zhihuan.state
	)
	on chk266_VFB changed state do
	(
		if (chk266_VFB.state ==on)
		then (chk264_kuaizhao.enabled=false
			 btn371_showlastframe.caption = "VF")
	      	else (chk264_kuaizhao.enabled = true
				 btn371_showlastframe.caption = "RL")
		try ( renderers.current.output_on = chk266_VFB.state ) catch()
	)
	on chk267_360quanjing changed state do
	(
		if state == on 
			then (
				if queryBox "渲染360全景图，将会设置渲染尺寸的宽和高为2：1的比例！\n是：设置长宽比例。\n否：取消操作" title:"DM温馨提示！" 
				then (
					
						renderers.current.camera_type = 1
						renderers.current.camera_overrideFOV = on
						renderers.current.camera_fov = 360
						spn344_height.value  = spn343_width.value * 0.5 
					)
					else(chk267_360quanjing.state = false))
			else(
						renderers.current.camera_type = 0
						renderers.current.camera_overrideFOV = false
						renderers.current.camera_fov = 45
				)
	)
	on chk492_GI_AO changed state do
	(
		renderers.current.gi_ao_on = state
	)
	on btn333_AOset pressed do
	(
		rollout AOset "AO设置" width:200 height:100
		(
			spinner spn_AOL "灰度" pos:[59,16] width:80 height:16 range:[0,100,renderers.current.gi_ao_amount]
			spinner spn_AOR "半径" pos:[60,40] width:80 height:16 range:[0,1000,renderers.current.gi_ao_radius]
			spinner spn_AOS "细分" pos:[60,64] width:80 height:16 range:[0,100,renderers.current.gi_ao_subdivs] type:#integer
		
			on spn_AOL changed val do
				(renderers.current.gi_ao_amount = spn_AOL.value)
			on spn_AOR changed val do
				(renderers.current.gi_ao_radius = spn_AOR.value)
			on spn_AOS changed val do
				(renderers.current.gi_ao_subdivs = spn_AOS.value)
		)
		createdialog AOset
	)
	on chk268_AOmap changed state do
	(
		if AOovmtl == undefined do
			(
				AOovmtl = Standardmaterial name:"AOoverridemtl" Diffuse:(color 255 255 255) ambient:(color 255 255 255) selfIllumAmount:100
				VRDirt = VRayDirt radius:300 falloff:1 subdivs:30
				AOovmtl.diffusemap = VRDirt
				MtlDummyObj= box name:"fuckJanpan"
				MtlDummyObj.material= AOovmtl
				
			)
		if state == on 
		then 
		(
			renderers.current.options_lights=false
			renderers.current.gi_on = false
			renderers.current.options_overrideMtl_on = true       
			renderers.current.options_overrideMtl_mtl = AOovmtl
			chk271_sumo.enabled = false
		)
		else
		(
			renderers.current.options_lights=true
			renderers.current.gi_on = true
			renderers.current.options_overrideMtl_on = false      
			renderers.current.options_overrideMtl_mtl = undefined
			chk271_sumo.enabled = true
		)
		try (delete MtlDummyObj) catch()
	)
	on cp61_sumocolor changed col do
	(
		SUMOovmtl.diffuse = col
	)
	on chk269_paichu changed state do
	(	
		if state == on then
					(
						if VRexclude != undefined then()
						else
						(
							vrayObj = for o in objects where classof o.material == vraymtl collect o --收集vray材质物体
							vrayObjRefract = for i in vrayObj where \          --收集有拆射物体
							i.material.refraction != (color 0 0 0) or \   --折射COLOR不等于0的
							i.material.texmap_refraction != undefined collect i  --折射通道有贴图的
							-- vrayObjRefract.count
							-- select vrayObjRef
							stdObj = for f in objects where classof f.material == standard collect f  --收集standard材质物体
							stdObjOpacity = for j in stdObj  where \          --收集有拆射物体
							j.material.opacity != 100 or \   --折射COLOR不等于0的
							j.material.opacityMap != undefined collect j  --折射通道有贴图的
							-- stdObjOpacity.count
							-- select stdObjOpacity
							------------------------------------以下为收集判定blend材质物体
							blendObj = for f in objects where classof f.material == blend collect f    --收集场景中BLEND材质物体
							blendVrayRefract1 = for a in blendObj  where \    --收集blend.map1为vray的
							classof a.material.map1 == vraymtl \
							and (a.material.map1.refraction != (color 0 0 0) or a.material.map1.texmap_refraction != undefined) \
							collect a
							-- blendVrayRefract1.count
							blendVrayRefract2 = for b in blendObj  where \    --收集blend.map2为vray的
							classof b.material.map2 == vraymtl \
							and (b.material.map2.refraction != (color 0 0 0) or b.material.map2.texmap_refraction != undefined) \
							collect b
							-- blendVrayRefract2.count
							blendStdOpacity1 = for c in blendObj  where \     --收集blend.map1为standard的
							classof c.material.map1 == standard  \
							and (c.material.map1.opacity != 100 or c.material.map1.opacityMap != undefined) \
							collect c
							-- blendStdOpacity1.count
							blendStdOpacity2 = for d in blendObj  where \     --收集blend.map1为standard的
							classof d.material.map2 == standard  \
							and (d.material.map2.opacity != 100 or d.material.map2.opacityMap != undefined) \
							collect d
							-- blendStdOpacity2.count
							--------------------------------------------blend收集结束
							VRexclude = #() --排除物体集合
							join VRexclude vrayObjRefract
							join VRexclude stdObjOpacity
							join VRexclude blendVrayRefract1
							join VRexclude blendVrayRefract2
							join VRexclude blendStdOpacity1
							join VRexclude blendStdOpacity2
						)
						
						if VRexclude.count != 0 do
						(
							renderers.current.options_overrideMtl_on = true
							if $DMCG_qt != undefined then(append VRexclude $DMCG_qt)  --如果有球天，将球天和玻璃一起排除
							renderers.current.excludeListOverrideMtl = VRexclude
						)
					)
					else
					(
						if $DMCG_qt != undefined then (a = #($DMCG_qt)) else(a = #()) --如果有球天，没玻璃
						a = #()
						try(renderers.current.excludeListOverrideMtl = a)catch()
					)
	)
	on chk271_sumo changed state do
	(
	if SUMOovmtl == undefined do  --创建一个覆盖材质
		(
			MtlDummyObj = box name:"fuckqq" --创建一个box作为辅助物体
			MtlDummyObj.material = SUMOovmtl   --把以上VRAY材质赋予给BOX
		)
		
		--以下这堆代码用于VRay参数设置
		if state == on 
		then (renderers.current.options_overrideMtl_on = true       --打开VRay覆盖材质
				renderers.current.options_overrideMtl_mtl = SUMOovmtl        --将"ovmtl "赋予给覆盖材质
				chk268_AOmap.enabled=false
				)         
		else  (renderers.current.options_overrideMtl_on = false
			    renderers.current.options_overrideMtl_mtl = undefined
				chk268_AOmap.enabled=true
				)              
		try (delete MtlDummyObj) catch()
	)
	on chk432_uselightcahe changed state do
	(
	if state == on
	then (renderers.current.gi_secondary_type = 3
			try (VRayjianhuaRollout.chk27_uselicache.checked = true)catch()
		)
	else (renderers.current.gi_secondary_type = 2
		try (VRayjianhuaRollout.chk27_uselicache.checked = false)catch())
	)
	on chk272_TDmaterial changed state do
	(
	if state == on
	then xrcztd = true
	else xrcztd = false
	)
	on chk273_TDgroup changed state do
	(
	if state == on
	then (xrztd = true)
	else (xrztd = false)
	)
	on chk302_TD6face changed state do
	(
	if state == on
	then xrlmtd = true
	else xrlmtd = false
	)
	on chk321_chengtu changed state do
	(
		if (state == on)
		then (
				if( edt18_GZpath.text ==""  )
				then (messagebox "请先指定光子路径" title:"DM温馨提示！"
					chk322_guangzi.state = false
					xrct=false)
				else(xrct=true
	                     rendCT()
	                     ))
		else (xrct=false)
	)
	on chk322_guangzi changed state do
	(
		if (state == on)
		then (
				if( edt18_GZpath.text ==""  )
				then (messagebox "请先指定光子路径" title:"DM温馨提示！"
					chk322_guangzi.state = false
					xrgz=false)
				else(xrgz=true
	                     rendGZ()
	                     ))
		else (xrgz=false)

	)
	on ckb79_animationtype changed state do
	(
		if state == on
		then (rendTimeType=2
				spn366_gezhen.enabled = true
	-- 				 chk533_AOxl.enabled = true
	               chk322_guangzi.checked = false 
	               chk321_chengtu.checked = false 
	)
			else (rendTimeType = 1
				spn366_gezhen.enabled = false
	-- 				 chk533_AOxl.enabled = false
	               chk322_guangzi.checked = false 
	               chk321_chengtu.checked = false )
			renderSceneDialog.update()
		)
	on spn366_gezhen changed val do
	(
		rendNThFrame = val
		renderSceneDialog.update()
	)
	on btn268_Render pressed do
	(
		renderSceneDialog.close()     --关闭渲染设置面板
				
		renderwidth = spn343_width.value * rdscale
		renderheight = spn344_height.value * rdscale
			
		if ddl68_renderjibie.selection != 6
		then (
				for f in renderjibie do(try execute f catch())
				)
		else()
		renderSceneDialog.update()
		
		if (chk264_kuaizhao.state ==on )                             				-- 判定快照按扭开启
		then (rentype = getrendertype()
			render camera outputwidth:renderwidth  outputheight:renderheight  renderType:rentype)    --则 用渲染视窗为 view
		else (
				actionMan.executeAction 0 "50031"
			)                        			-- 正常渲染器渲染按扭
	)
	on sld13_GIbaohedu changed val do
	(
		try (renderers.current.gi_saturation = sld13_GIbaohedu.value
			spn384_GIbaohedu.value = sld13_GIbaohedu.value) catch ()
	)
	on sld14_GIduibidu changed val do
	(
		try (renderers.current.gi_contrast = sld14_GIduibidu.value
			spn383_GIduibidu.value = sld14_GIduibidu.value) catch ()	
	)
	on sld15_baoguang changed val do
	(
		try (renderers.current.colorMapping_brightMult = sld15_baoguang.value) catch()
		try (spn382_baoguang.value = sld15_baoguang.value ) catch()
	)
	on chk413_usebaoguang changed state do
	(
		if state ==on 
		then (
			sld15_baoguang.enabled = true
			spn382_baoguang.enabled = true
			renderers.current.colorMapping_type = 6	)
		else (sld15_baoguang.enabled = false
			spn382_baoguang.enabled = false
			spn382_baoguang.value = 1
			renderers.current.colorMapping_brightMult=1
			 sld15_baoguang.value = 1)
		renderSceneDialog.update()
	)
	on spn382_baoguang changed val do
	(
		try (renderers.current.colorMapping_brightMult = spn382_baoguang.value) catch()
		try (sld15_baoguang.value  = spn382_baoguang.value) catch()
	)
	on spn383_GIduibidu changed val do
	(
		try (renderers.current.gi_contrast = spn383_GIduibidu.value
			sld14_GIduibidu.value = spn383_GIduibidu.value) catch ()	
	)
	on spn384_GIbaohedu changed val do
	(
		try (renderers.current.gi_saturation = spn384_GIbaohedu.value
			sld13_GIbaohedu.value = spn384_GIbaohedu.value) catch ()
	)
	on ddl103_lightsystem selected sel do
	(
	 case sel of
	 (
		1:(try (filein (getdir #scripts + "\DM Tools\\DM_VRay 灯光1.0.mse"))catch(messagebox "没有找到VRay自动灯光脚本" title:"DM温馨提示！"))
		2:(try (filein (getdir #scripts + "\DM Tools\\DM_VRay 环境1.0.mse"))catch(messagebox "没有找到VRay HDRI环境模板" title:"DM温馨提示！"))
		)
	)
	on btn370_renderyuansu pressed do
	(
		try (destroydialog REleRollout)catch()
		
		rollout REleRollout "渲染元素设置" width:320 height:222
		(
			label lbl1 "渲染元素列表" pos:[5,5] width:106 height:16
			label lbl2 "需要渲染的元素" pos:[175,5] width:106 height:16
			button btn2_tj ">" pos:[150,37] width:19 height:30 toolTip:"添加元素"
			button btn3_sc "<" pos:[150,142] width:19 height:30 toolTip:"移除元素"
			button btn4_app "应用设置" pos:[172,189] width:142 height:28 toolTip:"将选择好的渲染元素应用到渲染器！"
			listbox lbx2_ysEle "" pos:[3,23] width:145 height:14 items:#("VRayAlpha", "VRayAtmosphere", "VRayBackground", "VRayBumpNormals", "VRayCaustics", "VRayDiffuseFilter", "VRayExtraTex", "VRayGlobalIllumination", "VRayIlluminance", "VRayLighting", "VRayMatteShadow", "VRayMtlID", "VRayMtlSelect", "VRayNormals", "VRayObjectID", "VRayRawGlobalIllumination", "VRayRawLighting", "VRayRawReflection", "VRayRawRefraction", "VRayRawShadow", "VRayRawTotalLighting", "VRayReflection", "VRayReflectionFilter", "VRayRefraction", "VRayRefractionFilter", "VRayRenderID", "VRaySampleRate", "VRaySelfIllumination", "VRayShadows", "VRaySpecular", "VRayTotalLighting", "VRayUnclampedColor", "VRayVelocity", "VRayWireColor", "VRayZDepth") selection:1
			listbox lbx3_xrEle "" pos:[170,24] width:145 height:12
			button btn41_clearEle "X" pos:[150,92] width:19 height:28 toolTip:"清空元素列表"
			
			local RenderEleList = #()
			local selEle = #()
			local elementlist = #()
			
			fn UIaddEle = (
					append  RenderEleList lbx2_ysEle.selected
					uniitems = makeUniqueArray RenderEleList
					lbx3_xrEle.items = for f in uniitems collect f
				)
			
			fn UIremEle = (
					try (deleteItem RenderEleList lbx3_xrEle.selection)catch()
					uniitems = makeUniqueArray RenderEleList
					lbx3_xrEle.items = for f in uniitems collect f
				)
			
			fn addElement = (
				for i in lbx3_xrEle.items do (append elementlist (execute i))
				re = maxOps.GetCurRenderElementMgr() 
				re.removeallrenderelements()
				re.numrenderelements() 
				theManager = maxOps.GetRenderElementMgr #Production
				theManager.numrenderelements()
				if (DM_Renderroll.edt19_CTpath.text =="")or (DM_Renderroll.edt19_CTpath.text ==".tga")
					 then(messagebox "请先在上面设置好输出路径！" title:"DM温馨提示！")
				else(Elementpath =  DM_Renderroll.edt19_CTpath.text
					rendoutputfilename = (getFilenamePath Elementpath)+(getFilenameFile Elementpath)+".tga"
					)
				
		
				makeUniqueArray elementlist		
				for n in elementlist do
				(
					re.addrenderelement (n elementname:("DM_" + (n as string)))
					format "\nAdded % renderelement" n
				)
				setsilentmode true
				renderSceneDialog.open()
				for n = 0 to (theManager.numrenderelements()- 1) do
				(
					el = re.getrenderelement n
					format "\nGetting % render element" el.elementname
					format "\nRender element outputfilename: %" (re.GetRenderElementFileName n)
				)
		
			)
			
			fn deleteElement = ( 
				re = maxOps.GetCurRenderElementMgr() --Delete Renderelement
				re.removeallrenderelements() --Delete Renderelement
					)
			
			on btn2_tj pressed do
				(UIaddEle())
			on btn3_sc pressed do
				(UIremEle())
			on btn4_app pressed do
				(elementlist = #()
					deleteElement()
					addElement())
			
			on lbx2_ysEle doubleClicked itm do
				(UIaddEle())
			on lbx3_xrEle doubleClicked itm do
				(UIremEle())
			on btn41_clearEle pressed do
			(
				lbx3_xrEle.items = #()
				RenderEleList = #()
				elementlist = #()
				deleteElement()
			)
		)
		createdialog REleRollout
		)
	on btn371_showlastframe pressed do
	(
		if (chk266_VFB.state == on)
		then(
			cls=renderers.current.classid
			if (cls[1]==1941615238 and cls[2]==2012806412) then renderers.current.showLastVFB()
		)
		else(actionMan.executeAction 0 "348")  -- Render: Rendered Frame Window
	)
	on btn844 pressed do
	(
	actionMan.executeAction 0 "50048" 
	)
	on btn845 pressed do
	(
	actionMan.executeAction 0 "40029"
	)
	on btn372_author pressed do
	(
	   shellLaunch "explorer.exe" "http://blog.sina.com.cn/hfarts"
	)
	on btn619_GZpath pressed do
	(
	local saveGZ = getSaveFileName  caption:"保存光子"  types:  "All file(*.*)"
		  try (edt18_GZpath.text = (getfilenamepath saveGZ ) + (filenameFromPath saveGZ ))catch(edt18_GZpath.text = "")
		  renderers.current.adv_irradmap_autoSaveFileName = edt18_GZpath.text + ".vrmap"
			renderers.current.adv_irradmap_loadFileName  = DM_Renderroll.edt18_GZpath.text + ".vrmap"
		  renderers.current.lightcache_autoSaveFileName = edt18_GZpath.text + ".vrlmap"
			renderers.current.lightcache_loadFileName  = DM_Renderroll.edt18_GZpath.text + ".vrlmap"
		
	)
	on btn620_CTpath pressed do
	( 
	local savect = SelectSaveBitMap  caption:"保存成图"  
		   try (edt19_CTpath.text = (getfilenamepath savect ) + (filenameFromPath savect ))catch(edt19_CTpath.text = "")
		   rendOutputFilename =edt19_CTpath.text
		   renderSceneDialog.update()
	)
	on chk1397_CTsave changed state do
	(
		rendSaveFile = chk1397_CTsave.state
		renderSceneDialog.update()
	)
	on btn1261_specialrender pressed do
	(
		DM_render()	
	)
	on btn242_clearset pressed do
	(
	returnframe()
	chk322_guangzi.checked = false
	chk321_chengtu.checked = false
	)
	on btn25 pressed do
	(
	actionMan.executeAction 0 "60010"
	)
	on chk221_savecopymax changed state do
	(
	if state == on
	then savecopy = true
	else savecopy = false
	)
	on chk245_rendendclosecp changed state do
	(
	if state == on
	then endrenderclose = true
	else endrenderclose = false
	)
)
 

if (classof renderers.current == vray)
then(createdialog DM_Renderroll 200 715  80 10)
else(
	if queryBox "请先将渲染器设置为VRay渲染器！\n是：设置为VRay渲染器\n否：取消操作" title:"DM温馨提示！"
	then
	(
		renderers.current = Vray()
		createdialog DM_Renderroll  200 715  80 10 
	)
	else()
)

macros.new  "DM-工具箱" "DM_boxtool01" "黑马-VRay渲染助手" "DM_R" ("try(fileIn ((getDir #scripts) + \"\DM Tools\DM_VRay 渲染助手1.0.mse\"))catch(messagebox\"抱歉加载出错！！！\\n 请联系作者 \"title:\"提示\")")

