Try(DestroyDialog  xw_FastToFile) Catch()
if  not doesFileExist "$scripts\\xw_render_yjtd.ini" then
(
	setinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_render_yjtd_plxr_path" ""
	setinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_maxlist_allmaxren" "#()"
	setinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_maxlist_allmax" "#()"
)

global xw_maxlist_allmaxren= (getinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_maxlist_allmaxren") ---存入要渲染的MAX
global xw_maxlist_allmax=  (getinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_maxlist_allmax")
global xw_maxlist_allmax_string="" --将数组里全陪加在一起 组成一个新新的字符串 最后再解开
xw_maxlist_allmaxren=(filterString xw_maxlist_allmaxren ",")
xw_maxlist_allmax=(filterString xw_maxlist_allmax ",")
global max02count="批量渲染列表："+(xw_maxlist_allmaxren.count as string)+"个"
global max01count="选择列表："+(xw_maxlist_allmax.count as string)+"个"
rollout xw_tongdao "一键正图+通道" 
(
	---------------------------------------------变量声名-------------------------------
	local rdw
	local rdh
	local gzdx=2                ------用来记录微调器参数 初始值为1----
	local ztchk=true            ------记录渲染正图复选框的状态--------
	local czchk=true            ------记录材质通道复选框的状态--------
	local tkchk=true            ------记录体块通道复选框的状态--------
	local yzchk=false            ------记录阴子通道复选框的状态--------
	local machk=false
	local guanji=false
	local fileshuchu ----------记录保存位图的路径以便其它地方调用
	local mapname  ----------返回渲染存图的文件名-----
	local mappath  ----------返回渲染存图的路径部分---
	local rentype = getrendertype()           ----------------获取渲染类型---
	local vr = renderers.current
	local endrender=false --当值为FALSE时 可正常流程泻染 当为TRUE时 中止渲染流程
	local y_pos=320
	local y_pos1=110
	local Defaultlist= getFiles (GetDir #renderPresets + "\\*.rps")
	local xw_maxlist_path
	local xw_maxlist_path_getini=getinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_render_yjtd_plxr_path"
	--local xw_maxlist_allmax=getFiles (xw_maxlist_path_getini + "\\*.max")
	local endfor---
	local typemap--输入出图像类型
	local pl_guanji----这个用来记录批量渲染时的关机
	local xw_tktdobj=#()----组通道时用
	dropDownList xw_zhiliang "渲染设置列表：" pos:[2,5] width:150 height:10 items:(for i in Defaultlist collect getFilenameFile i)
	button save_set "Save.SET" pos:[2,50] width:75 height:20 toolTip:"亲!这个是保存渲染器设置，这样以后你可以直接调用这些设置！"
	button delete_set "Delete.SET" pos:[77,50] width:75 height:20 toolTip:"亲!这个是删除设置！"
	MultiListBox xw_xianmulist_max_kj "选则列表：" pos:[2,80] width:150 height:5 items:(for i in xw_maxlist_allmax collect getFilenameFile i)
	listBox xw_xianmulist_maxren_kj "要渲染的MAX列表：" pos:[2,190] width:150 height:5 items:(for i in xw_maxlist_allmaxren collect getFilenameFile i)
    button max_all_renkj "All"  pos:[2,170] width:38 height:16
	button max_all_gokj "↓↓"  pos:[40,170] width:38 height:16
	button max_all_dekj "-x-"  pos:[78,170] width:38 height:16
	button max_all_dekj_all "All-x"  pos:[116,170] width:38 height:16
	button loadpath "..." pos:[135,170+y_pos1] width:16 height:16
	button xw_open ">>" pos:[135,192+y_pos1] width:16 height:16
	editText savepath "路径:" pos:[2,170+y_pos1] width:130 height:16 text:xw_maxlist_path_getini enabled:true
	checkbox xw_piliangren "是否开起批量渲染" pos:[3,192+y_pos1] width:130 height:15 checked:false
	groupBox grp1 "光子：" pos:[2,5+y_pos] width:150 height:39
	checkbox chk1 "渲染正图" pos:[45,50+y_pos] width:90 height:15 checked:true
	checkbox chk2 "材质通道" pos:[45,68+y_pos] width:90 height:15 checked:true
	checkbox chk3 "体块通道" pos:[45,86+y_pos] width:90 height:15 checked:true
	checkbox chk4 "测面通道" pos:[45,104+y_pos] width:90 height:15 checked:false
	checkbox chk5 "影子通道" pos:[45,122+y_pos] width:90 height:15 checked:false
	checkbox chk6 "渲完关机" pos:[45,140+y_pos] width:90 height:15 checked:false
	button btn1 "一键渲染" pos:[13,180+y_pos] width:128 height:40
	button btn2 "取消关机" pos:[13,160+y_pos] width:128 height:20 enabled:false
	spinner spn1 "光子图大小设定 1/" pos:[70,20+y_pos] width:76 height:16 range:[1,4,2] type:#integer scale:1
	hyperLink xw_bolg "QQ:380738651去我的博客" address:"http://blog.sina.com.cn/u/2518417034"  pos:[13,230+y_pos] color:(color 0 0 255) hoverColor:(color 255 68 0) visitedColor:(color 255 68 0) width:175 height:75

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
fn xw_xtktd tk=
( 
    for i in tk.Children do
	(	
		if not isgrouphead i then(
			append xw_tktdobj i 
		)
		else
		if isgrouphead i then xw_xtktd i--递归
	)
)
fn xw_tktd=
(
undo on(
guandeng()
xw_vrcm()
renderers.current.options_reflectionRefraction =off
renderers.current.options_lights =off
renderers.current.environment_gi_map_on =off
renderers.current.gi_on=off
for a in objects where (isgrouphead a) and (a.parent==undefined)do
(
	xw_xtktd a
	colorrandom=random black white                           ------随机色
	try (xw_tktdobj.material=standardmaterial Diffuse:colorrandom selfIllumAmount:100) catch()--付材质
	xw_tktdobj=#()
)
for a in objects where (superclassof a==GeometryClass) or (superclassof a==shape)do
(
	if a.parent==undefined then
	(print a
	colorrandom=random black white                           ------随机色
	try (a.material=standardmaterial Diffuse:colorrandom selfIllumAmount:100) catch()--付材质
	)
)
)
)
---------------------------影子通道VR渲染器设定和灯光设定-------------------------------------------
fn xw_yztd = (
	undo on(
	guandeng()
	xw_vrcm()
	renderers.current.options_reflectionRefraction =off
	renderers.current.options_lights =on
	renderers.current.environment_gi_map_on =off
	renderers.current.gi_on=off
	renderers.current.options_overrideMtl_on=on
    try renderers.current.options_overrideMtl_mtl=vraymtl name:"yztd" diffuse:(color 255 255 255) catch( renderers.current.options_overrideMtl_mtl=VR材质 name:"yztd" diffuse:(color 255 255 255) )
	zg=(for i in lights where (classof i==TargetDirectionallight)or(classof i==targetSpot)or(classof i==VRaySun) collect i)
		for c in zg do
		(if (classof c==TargetDirectionallight) or (classof c==targetSpot) then
			(
			if (distance (c.pos) (c.target.pos))>50000 and c.shadowgenerator==VRayShadow then --自动找到主光（当主光的主点与目标点大于50米 且打开了阴影的时候 ）
			print c.name
			c.name = "zg"
		    c.isHidden=off
		    c.on=true
            c.multiplier=5.0
            c.rgb=color 255 255 255
		    c.shadowColor=red
		    c.lightAffectsShadow =on
			--c.shadowgenerator=shadowMap()
			--rootScene.mapbias=0
			--rootScene.mapsize = 5000
			--rootScene.samplerange = 8
			)
			else 
			(if classof c==VRaySun then 
			c.name="zg"
			c.isHidden=off
		    c.enabled=true
		    c.turbidity=2.0
		    c.intensity_multiplier=0.1
			)
			)
			)
)
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
---------------------------跑光子图---------------------------------------------------------
 fn paoguangzi=
	(
	 undo on(
	 ---------vr.options_reflectionRefraction =off------------开起VR的反射和折射
	 renderers.current.options_dontRenderImage=on-----------------不渲染最后图像
	 renderers.current.imageSampler_type = 0  --------------抗拒齿为固定
	 renderers.current.adv_irradmap_mode = 0  --------------光子调用为single frame (单帧) 
	 renderers.current.filter_on = off----关闭抗拒齿
	 renderers.current.adv_irradmap_autoSave =on --开起保存光子
	 renderers.current.adv_irradmap_switchToSavedMap = on---------打开自动调用光子
	 )
	 renderers.current.options_dontRenderImage = on
	 renderers.current.adv_irradmap_autoSaveFileName = (mappath+mapname+"gz.vrmap")---设置光子的保存路径
	 renderers.current.gi_irradmap_showCalcPhase = on------打开跑光子时的显示
	 renderers.current.gi_irradmap_showDirectLight = on-------光子分部显示打开 这种解释看来只有自己懂哈哈
	 try(
		renderers.current.lightcache_dontDelete=on
        renderers.current.lightcache_autoSave=on
		renderers.current.lightcache_switchToSavedMap=on
        renderers.current.lightcache_autoSaveFileName=(mappath+mapname+"gz1.vrlmap")
	 )catch()
     render camera  outputwidth:(renderwidth/gzdx) outputheight:(renderheight/gzdx) cancelled:&endrender  renderType:rentype 
	)                      
 --------------------------------------------------正图渲染设定-----------------------
 fn paozt=
(
	 renderwidth=rdw
	 renderheight=rdh
	 rendoutputfilename=mappath+mapname+"_dt"+typemap
	 rendSaveFile=true
	 ---------------------------------------------vr.options_reflectionRefraction =on  ------------打开反射--------------------
	 renderers.current.options_dontRenderImage =off      ------------打开渲染最终图像------------
	 ---------------------------------------------vr.imageSampler_type = 1             ----------抗拒齿类型为adaptivedmc-------
	 renderers.current.adv_irradmap_loadFileName=(mappath+mapname+"gz.vrmap")------这个和下面的顺序不能搞反
	 renderers.current.adv_irradmap_mode= 2
	 renderers.current.photonMap_mode = 2
	 try
	(
	 renderers.current.lightcache_loadFileName=(mappath+mapname+"gz1.vrlmap")
	 renderers.current.lightcache_mode=2
	)catch()
----------------------------------------vr.filter_on = off                    ----------打开抗拒齿过滤器-----------
	actionMan.executeAction 0 "50031"  -- Render: 渲染
	--render camera  outputwidth:rdw  outputheight:rdh  vfb: true outputfile:(mappath+mapname+"_dt"+typemap) cancelled:&endrender renderType:rentype
	if keyboard.escPressed==true then 
	(
		endrender=true
		endfor=false
	)
	try
	(
	renderers.current.adv_irradmap_mode= 0
    renderers.current.lightcache_mode=0
	renderers.current.lightcache_switchToSavedMap=off
	renderers.current.adv_irradmap_switchToSavedMap = off
	)catch()
)
fn xw_render_last =
	(
	renderSceneDialog.commit()  -----------渲染设置刷新设置-----------------
	rentype = getrendertype()   ------获取渲染方方式----例如区域渲染、放大框渲染
	AAAA=rendoutputfilename     
	rdw=renderwidth
	rdh=renderheight
	mapname=getfilenamefile rendoutputfilename
	mappath=getfilenamepath rendoutputfilename
	typemap=getFilenameType AAAA
		----------------------------------------------------------------------------
	         if ztchk==true then
            (
				/*
			 if(doesFileExist (mappath+mapname+"_dt"+typemap))then
				 (
				    if querybox "有相同名字的文件是否要覆盖原文件上？" then
					( 
				     paoguangzi()
                     max undo
					 if (endrender==false) then paozt()
	                )
				    else (endfor=true)--这里可以防止取消后继续加载MAX
				 )
			 else
				*/
				(
				paoguangzi()
				max undo
				if (endrender==false) then paozt()
				)
            )
			if (czchk==true)and (endrender==false) then
	        (
	         xw_cztd()
			 render camera  outputwidth:rdw  outputheight:rdh  vfb: true outputfile:(mappath+mapname+"_cltd"+typemap) cancelled:&endrender renderType:rentype
	         max undo
	        )
			if (tkchk==true) and (endrender==false)then
				(
                 xw_tktd()
				 render camera  outputwidth:rdw  outputheight:rdh   vfb: true outputfile:(mappath+mapname+"_tktd"+typemap) cancelled:&endrender renderType:rentype
		         max undo
				)
			if (machk==true) and (endrender==false) then
				(
		         xw_matd()
				render camera  outputwidth:rdw  outputheight:rdh  vfb: true outputfile:(mappath+mapname+"_mtd"+typemap) cancelled:&endrender renderType:rentype
				 max undo
				)
			if (yzchk==true) and (endrender==false) then
				(
		        xw_yztd()
				render camera  outputwidth:rdw  outputheight:rdh  vfb: true outputfile:(mappath+mapname+"_yztd"+typemap) cancelled:&endrender renderType:rentype
				max undo
				)
			if guanji==true and (endrender==false) then
           ( 
			   btn2.enabled=true
               theFile = (GetDir #Scene + "\\xw_rend.max")
			   savemaxfile thefile
               doscommand "Shutdown.exe -s -t 60"
            )
	rendoutputfilename=AAAA ----输出位图名还原
	)
fn xw_pl_render_last=
	(   pl_guanji=guanji ----关联到关机
		if (endrender==false)then
			(
		        for i=1 to (xw_maxlist_allmaxren).count do
		            (   
						(loadmaxfile xw_maxlist_allmaxren[i] useFileUnits:true quiet:true)
						renderSceneDialog.commit()
						xw_dir=for i in (GetDirectories (maxFilePath + "\\*")) where i==(maxFilePath+"\\xw_render_tga\\")collect i
		                if xw_dir.count==0 then (try makeDir (maxFilePath+"\\xw_render_tga") all:true catch(messagebox"亲！没有加载max!"))
						--if rendoutputfilename==undefined then rendoutputfilename=(maxFilePath+"\\xw_render_tga\\"+(getfilenamefile maxFileName)+".tga") ---如果没有指定位图路径就存放到这个（xw_render_tga）文件下面
						rendoutputfilename=(maxFilePath+"\\xw_render_tga\\"+(getfilenamefile maxFileName)+".tga")
						if pl_guanji==true then --保证最后一次渲染完才关机
							(
							     if i<(xw_maxlist_allmaxren).count then
								      (
										  guanji=false
									  ) 
								 if (i==(xw_maxlist_allmaxren).count) then 
									   (
										  guanji=true
									   )
							)
						xw_render_last()
						if (endfor==true)then exit
		             )
	         )
	)
fn xw_path_swap fn_xw_allmax all_amxini =( -----数组路径转字符再存INI以免出错 再取出再还原
-------这段想了好久---------------------------------------------------------------------------------------------------------------
           xw_maxlist_allmax_string=""
   for i in fn_xw_allmax collect
               (
                 s2="\\"
                 s3="/"
             substituteString i s2 s3
 xw_maxlist_allmax_string=xw_maxlist_allmax_string +i +","
   )	    
   setinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" all_amxini xw_maxlist_allmax_string
   fn_xw_allmax=(getinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" all_amxini)
   fn_xw_allmax=(filterString fn_xw_allmax ",")
----------------------------------------------------------------------------------------------------------------------------------
   )
--------------------------------微调器事件处理---------------------------------------------------
on spn1 changed vrg do
(
		gzdx=vrg
)
------------------------------------复选框处理事件----------------------------------------------	
	on chk1 changed State do
	( ztchk = chk1.checked)
	on chk2 changed State do
	( czchk = chk2.checked)
	on chk3 changed State do
	( tkchk = chk3.checked)
	on chk4 changed State do
	( machk = chk4.checked)
	on chk5 changed State do
	(  yzchk = chk5.checked)
	on chk6 changed State do
	(  guanji = chk6.checked)
----------------------------------------------------------------------------------------	
	on btn1 pressed do
	(	
		endrender==false
		endfor==true --这里可以防止取消后继续加载MAX
		if xw_piliangren.checked==true then
		(xw_pl_render_last())
		else
		xw_render_last()
	)
on btn2 pressed do
	(
	doscommand 	"shutdown -a"
	btn2.enabled=false
	)
on xw_open pressed do
	(
	 try
	 (
		aa=xw_maxlist_allmaxren[xw_xianmulist_maxren_kj.selection]
		shellLaunch (getfilenamepath aa) "" --打开模型文件夹 
	 )catch()
	)
on delete_set pressed  do
	(
	 if queryBox ("你是否要删除指定设置?") then
		(
		deletefile ((getfilenamepath (Defaultlist[xw_zhiliang.selection]))+(getfilenamefile ((Defaultlist[xw_zhiliang.selection])as string)+".rps"))
		)
		Defaultlist= getFiles (GetDir #renderPresets + "\\*.rps")
		xw_zhiliang.items=((for i in Defaultlist collect getFilenameFile i))
	)
on xw_xianmulist_max_kj doubleclicked sel do---加载MAX
	(  
		loadmaxfile xw_maxlist_allmax[sel] useFileUnits:true quiet:true
	)
on xw_xianmulist_maxren_kj doubleclicked sel do---加载MAX
	(  
		loadmaxfile xw_maxlist_allmaxren[sel] useFileUnits:true quiet:true	 
	)
on save_set pressed do
	(
				rollout  gaimingzi  "取名"
		(
			edittext gaimin "取名为:" pos: [10,13]width:140 height:15
			button gaimin_but "确定" pos: [155,11]
			on gaimin_but pressed do
			( try
				(
				if (gaimin.text !="")then
				(
				renderpresets.Save 0 (GetDir #renderPresets + "\\"+gaimin.text+".rps") #{32}
				Defaultlist= getFiles (GetDir #renderPresets + "\\*.rps")
		        xw_zhiliang.items=((for i in Defaultlist collect getFilenameFile i))
				DestroyDialog gaimingzi
				)
				--else
				--(messagebox"你没有选择物体上或者还没有键入名称！")
		    )catch()
			)
	    )		
		createdialog gaimingzi  200 40
	)
on xw_zhiliang selected i do
	(
		if queryBox ("你是否要加载指定设置?") then
		(
		renderpresets.load 0 ((getfilenamepath (Defaultlist[i]))+(getfilenamefile ((Defaultlist[i])as string)+".rps")) #{32}
		)
	)
on loadpath pressed do
	(
      xw_maxlist_path=getsavepath()
	  if xw_maxlist_path!=undefined then 
	  (
	   setinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_render_yjtd_plxr_path" xw_maxlist_path
	   xw_maxlist_path_getini=getinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_render_yjtd_plxr_path" 
	   savepath.text=xw_maxlist_path_getini
	   xw_maxlist_allmax=(getFiles (xw_maxlist_path_getini + "\\*.max"))
	   xw_path_swap xw_maxlist_allmax "xw_maxlist_allmax"--函数
	   xw_xianmulist_max_kj.items=(for i in xw_maxlist_allmax collect getFilenameFile i)
       )
    )
on max_all_renkj pressed do
(
   xw_xianmulist_max_kj.selection=(for i=1 to xw_maxlist_allmax.count collect i)  as bitArray
)
on max_all_gokj pressed do
(
   for i in xw_xianmulist_max_kj.selection as array  do
   (
	   if (findItem xw_maxlist_allmaxren xw_maxlist_allmax[i])==0 then
		   (append xw_maxlist_allmaxren  xw_maxlist_allmax[i])
   )
   xw_path_swap xw_maxlist_allmaxren "xw_maxlist_allmaxren"--函数
   xw_xianmulist_maxren_kj.items=(for i in xw_maxlist_allmaxren collect getFilenameFile i)
   max02count="批量渲染列表："+(xw_maxlist_allmaxren.count as string)+"个"
   xw_xianmulist_maxren_kj.caption=max02count
)
on max_all_dekj pressed do
(
	try
		(
	qq=xw_xianmulist_maxren_kj.selection
	deleteItem xw_maxlist_allmaxren qq
    xw_path_swap xw_maxlist_allmaxren "xw_maxlist_allmaxren"--函数		
	xw_xianmulist_maxren_kj.items=(for i in xw_maxlist_allmaxren collect getFilenameFile i)
	max02count="批量渲染列表："+(xw_maxlist_allmaxren.count as string)+"个"
    xw_xianmulist_maxren_kj.caption=max02count
		)catch()
)
on max_all_dekj_all pressed do
(
	xw_maxlist_allmaxren=#()
	cc=xw_maxlist_allmaxren as string
	setinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_maxlist_allmaxren" cc---存入要渲染的MAX
	xw_maxlist_allmaxren=execute (getinisetting "$scripts\\xw_render_yjtd.ini" "xw_render_yjtd" "xw_maxlist_allmaxren")
	xw_xianmulist_maxren_kj.items=(for i in xw_maxlist_allmaxren collect getFilenameFile i)
	max02count="批量渲染列表："+(xw_maxlist_allmaxren.count as string)+"个"
    xw_xianmulist_maxren_kj.caption=max02count
)	   
)
 createdialog xw_tongdao 154 570
allcontrols=xw_tongdao.controls
allcontrols[5].caption=max02count
allcontrols[4].caption=max01count