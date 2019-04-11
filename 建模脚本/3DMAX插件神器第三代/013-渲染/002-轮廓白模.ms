--Vray Ambient Occlusion
--version 2.0
--works with Vray 1.5 or higher, max 5 or higher
--by Marc Lorenz
--http://3dlang.com

--------------------------------修改分割线------------------------------------------
--修改 By Bingo  2015-01-31 
--修改内容: 将渲染AO功能改为渲染线框和白模的功能,
		--目前可以渲染线框白模\纯白模\通透线框(纯结构线)\
		--轮廓(无结构线)白模\纯轮廓(无结构线)\
		--另外可以渲染反射和折射(或许有些人有这方面需求)
		--关闭脚本时,自动保存设置信息到ini文件

--2011.3.31
--界面调整
--欢迎使用场景助手4.0
--下载地址: http://www.3dheima.com/

--版权归原作者所有,感谢其无私奉献
--修改内容：
--1.增加了standard的AO材质，原来默认是用VrayLightMtl
--2.增加了vraydirt和抗锯齿可控参数，界面调整
--3.默认参数是网上教程里渲室内AO的御用参数：D
--4.修正了渲单面出问题的BUG
--修改作者:飞浪 2008.4.8
--想对此修改发表讨论,请来这里:
--http://www.3dlang.com
-------------------------------------modification-----------------------------------------
--Copyright reserved by the original author Marc Lorenz,thanks for his sharing
--Modified contents:
--1.Add standard material for AO material type,the default is VrayLightMtl before
--2.Add spinners for VrayDirt and Image sampler,adjust the interface
--3.The default parameters are optimized for interier AO rendering,and they're from the net
--4.Correct the bug for the single plane rendering mistake
--Modified by Feilang  2008.4.8
--For more discussing,plz click here:
--http://www.3dlang.com/

------------------------------------------------------------------------------------------


try destroydialog ro_vrayWire catch() 
global ml_edgesMaterial

fn isLoadedVray targetslot assign:false=
	(
	try
	(
	if (targetslot==1) then slot=renderers.production
	else slot=renderers.draft
	)
	catch()
	--is vray even installed?
	a=(findItem RendererClass.classes vray)
	if (a!=0) then
		(
		--detect if ANY VRay version is active
		if (findString (slot as string) "VRay"!=undefined) or (findString (slot as string) "V_Ray"!=undefined) then return true
		else
			(
			if assign then 
				(
				if (queryBox "VRay 不是当前渲染器。   \n是否继续？" title:"警告") then
					(
					--store current
					--dumb maxscript can only assign to currently avtive renderer slots
					b=renderer
					case targetslot of
						(
						1:	(
							renderer=#production
							renderers.production=RendererClass.classes[a]()
							)
						2:	(
							renderer=#draft
							renderers.draft=RendererClass.classes[a]()
							)
						)
					--reassign current
					renderer=b
					return true
					)
				)
			)
		)
	return false
	)

fn fl_vrayao_render =
(
	--render renderType:(getrendertype());
	max quick render
)
--detect light/dark ui for icons and hyperlink
global hyperlink_color, ui_color
if (colorMan.getColor #text).x < 0.2 then 
	(
	ui_color=3
	hyperlink_color=(color 8 8 136)
	)
else
	(
	ui_color=1
	hyperlink_color=white
	)
global ro_vrayWire

	

fn renderWire_En_XXOO=
		(
		
		renderpresets.save 0 (GetDir #renderPresets + "\\Wire_Render_En.rps") #{1,3,32} 
			
			--version checking
		err=undefined
		if findString (vray() as string) "VRay_Adv_1_0" != undefined then err="出错啦，要求Vray 1.5及以上版本！\nonly works with Vray 1.5 or higher."
		if findString (vray() as string) "VRay_Adv_1_45" != undefined then err="出错啦，要求Vray 1.5及以上版本！\nonly works with Vray 1.5 or higher."
		if findString (vray() as string) "VRay_Adv_1_46" != undefined then err="出错啦，要求Vray 1.5及以上版本！\nonly works with Vray 1.5 or higher."
	
		if (isLoadedVray 1)==false then err="当前渲染器不是Vray，请设置成Vray先！\nPlease assign VRay as the current renderer!"
		
		if err != undefined then messageBox err title:"出错！Error!"
	
		else(
		local hcoverride=#()
		
		--append hcoverride "gi_on=false"
		
		if ro_vrayWire.chk_override.state==true then
			(
			--optimial AA QMC settings
			append hcoverride "twoLevel_useQMCSamplerThresh=true"
			append hcoverride "qmc_earlyTermination_amount=0.85"
			append hcoverride "qmc_earlyTermination_threshold=0.001"		
		)
		append hcoverride "options_hiddenLights=false"
		append hcoverride "options_defaultLights=false"		
		append hcoverride "options_overrideMtl_on=true"
		
	    if ro_vrayWire.option_method.state==1 then   
		(
			if ro_vrayWire.chk_LightMtl.checked then  
			(
				ml_edgesMaterial=VRayLightMtl ()
				ml_edgesMaterial.color=ro_vrayWire.clp_diffuse.color
				
				if ro_vrayWire.chk_Outline.checked then  
				(
					addAtmospheric (VRayToon ())
					(getAtmospheric 1).color = ro_vrayWire.clp_wire.color
					if ro_vrayWire.option_Wire.state==0 then (getAtmospheric 1).widthType = 1 else (getAtmospheric 1).widthType = 0
					(getAtmospheric 1).linePixels = ro_vrayWire.spn_pixels.value
					(getAtmospheric 1).lineWorld = ro_vrayWire.spn_worldUnits.value
					
				)
				else
				(
					ml_edgesMaterial.texmap = VRayEdgesTex ()
					ml_edgesMaterial.texmap.edgesColor = ro_vrayWire.clp_wire.color
					ml_edgesMaterial.texmap.widthType = ro_vrayWire.option_Wire.state
					ml_edgesMaterial.texmap.thickness = ro_vrayWire.spn_worldUnits.value
					ml_edgesMaterial.texmap.pixelWidth = ro_vrayWire.spn_pixels.value
					ml_edgesMaterial.texmap.HiddenEdges =off 
				)
			)
			else  
			(
				ml_edgesMaterial=VrayMtl()
				ml_edgesMaterial.diffuse=ro_vrayWire.clp_diffuse.color
				ml_edgesMaterial.reflection=ro_vrayWire.clp_reflect.color
				ml_edgesMaterial.refraction=ro_vrayWire.clp_refract.color
				
				if ro_vrayWire.chk_Outline.checked then   
				(
					addAtmospheric (VRayToon ())
					(getAtmospheric 1).color = ro_vrayWire.clp_wire.color
					if ro_vrayWire.option_Wire.state==0 then (getAtmospheric 1).widthType = 1 else (getAtmospheric 1).widthType = 0
					(getAtmospheric 1).linePixels = ro_vrayWire.spn_pixels.value
					(getAtmospheric 1).lineWorld = ro_vrayWire.spn_worldUnits.value
					
				)
				else
				(
					ml_edgesMaterial.texmap_diffuse = VRayEdgesTex ()
					ml_edgesMaterial.texmap_diffuse.edgesColor = ro_vrayWire.clp_wire.color
					ml_edgesMaterial.texmap_diffuse.widthType = ro_vrayWire.option_Wire.state
					ml_edgesMaterial.texmap_diffuse.thickness = ro_vrayWire.spn_worldUnits.value
					ml_edgesMaterial.texmap_diffuse.pixelWidth = ro_vrayWire.spn_pixels.value
					ml_edgesMaterial.texmap_diffuse.HiddenEdges =off 
					
					local _tmpMtl_black=copy ml_edgesMaterial.texmap_diffuse
					_tmpMtl_black.edgesColor =color 0 0 0
					
					local _tmpMtl_white=copy ml_edgesMaterial.texmap_diffuse
					_tmpMtl_white.edgesColor =color 255 255 255
					
					if ml_edgesMaterial.reflection !=color 0 0 0 then ml_edgesMaterial.texmap_reflection=_tmpMtl_black
					if ml_edgesMaterial.refraction !=color 0 0 0 then ml_edgesMaterial.texmap_refraction=_tmpMtl_black
					
					if ro_vrayWire.chk_opacity.checked then  
					(
						ml_edgesMaterial.texmap_opacity=_tmpMtl_white;
						if ro_vrayWire.clp_Wire.color==color 0 0 0 then backgroundColor = color 255 255 255;
							else if ro_vrayWire.clp_Wire.color==color 255 255 255 then backgroundColor = color 0 0 0;
					)
				)
			)
		)
		else   
		(
			ml_edgesMaterial=VrayMtl()
			ml_edgesMaterial.diffuse=ro_vrayWire.clp_diffuse.color
			ml_edgesMaterial.reflection=ro_vrayWire.clp_reflect.color
			ml_edgesMaterial.refraction=ro_vrayWire.clp_refract.color
	    )
		
		append hcoverride "options_overrideMtl_mtl=ml_edgesMaterial"
		--meditMaterials[24] = copy ml_edgesMaterial
		------------------------------------------------------------------------------------------
		--append hcoverride "options_reflectionRefraction=false"
		if ro_vrayWire.filter_checkbox.state==true then
		(	append hcoverride"filter_on=true"
			case ro_vrayWire.anti_filter.selection of
			(
			1: append hcoverride"filter_kernel=Area()"
			2: append hcoverride"filter_kernel=Mitchell_Netravali()"
			3: append hcoverride"filter_kernel=Catmull_Rom()"
			4: append hcoverride"filter_kernel=VRayLanczosFilter()"
	
			)
		)
		else 
		(	
			append hcoverride"filter_on=false"
		)
	    case ro_vrayWire.imagesampler.selection of
		(
			1: 	append hcoverride "imageSampler_type=0"
			2:   append hcoverride "imageSampler_type=1"
			3:  append hcoverride "imageSampler_type=2"
		)
		append hcoverride "ColorMapping_type=0"
		append hcoverride "ColorMapping_DarkMult=1"
		append hcoverride "ColorMapping_BrightMult=1"
		append hcoverride "ColorMapping_gamma=1"
	
		disableSceneRedraw()
		
		--apply overrides  设置渲染器和其它面板参数
		for i in hcoverride do
			(
			try execute ("renderers.current."+i)
			catch()
			)
		--start rendering
		fl_vrayao_render();
		
		
		renderpresets.load 0 (GetDir #renderPresets + "\\Wire_Render_En.rps") #{1,3,32}
		
		enableSceneRedraw()
		)
	)	
	
	

rollout ro_vrayWire "Vray 轮廓白模 渲染 V1.0  --Bingo" width:260 height:492
(
	
	
	GroupBox grp25 "白模类型_Type" pos:[25,13] width:210 height:41
	radiobuttons option_method "" pos:[45,31] width:185 height:16 labels:#("线框白模            ", "纯白模") columns:2
	
	GroupBox grp_mtl "表面" pos:[25,61] width:210 height:85
	checkbox chk_LightMtl "无阴影" pos:[155,82]  height:15 checked:false toolTip:"勾选，则渲染的白模不受灯光影响"
	ColorPicker clp_diffuse "表面色：" pos:[45,82] width:105 height:16 color:[250,250,250]
	ColorPicker clp_reflect "反    射：" pos:[45,102] width:105 height:16 color:[0,0,0] enabled:true
	ColorPicker clp_refract "折    射：" pos:[45,122] width:105 height:16 color:[0,0,0] enabled:true
	checkbox chk_opacity "通    透" pos:[155,122]  height:15 checked:false toolTip:"勾选，则渲染的模型只有结构线，是通透的"
	
	GroupBox grp_dirt "线框" pos:[25,155] width:210 height:85
	ColorPicker clp_Wire "线框色：" pos:[45,175] width:105 height:16 color:[0,0,0]
	checkbox chk_Outline "无结构" pos:[155,175]  height:15 checked:true toolTip:"勾选，则无模型结构线，只是模型的轮廓线"
	radiobuttons option_Wire "" pos:[45,200] width:185 height:100 default:2 labels:#("世界单位", "像素") columns:1
	spinner spn_worldUnits "" pos:[140,200] width:60 height:16 range:[0,100000,5] type:#float
	spinner spn_Pixels "" pos:[140,215] width:60 height:16 range:[0,100000,1] type:#float
	
	GroupBox grp12 "Image sampler(Antialiasing)" pos:[25,250] width:210 height:115
	dropdownList imagesampler "Image sampler" pos:[38,266] width:165 height:41 items:#("Fixed", "Adaptive QMC", "Adaptive subdivision") selection:2
	checkbox filter_checkbox "Checkbox" pos:[181,334] width:13 height:15 checked:true
	dropdownList anti_filter "Antialiasing filter" pos:[38,312] width:134 height:41 items:#("Area", "Mitchell-Netravali", "Catmull-Rom", "VRayLanczosFilter") selection:3
	
	GroupBox grp2 "Image Sampler Override" pos:[25,372] width:210 height:46
	checkbox chk_override "Optimized rQMC Anti-Aliasing" pos:[41,395] width:160 height:15 checked:true
	
	button btn_testRender "TestRender" pos:[10,425] height:26 toolTip:"以300像素的尺寸，固定抗锯齿类型测试渲染"
	button btn_render "Render Wire" pos:[92,425] width:98 height:26 toolTip:"渲染线框白模" --enabled:false
	button btn_default "Default" pos:[200,425] height:26 toolTip:"恢复默认值"
	
	label lbl2 "本版适合VRay英文版本【黑马设计网】出品" pos:[10,464] width:250 height:18
	

	local iniPath="$Scripts\\Bingo_tools\\KuaiJie_tool\\libs\\Bingo_Tools.ini"
	local iniDic="renderWire_En"
	
	
	fn makeDefault=
	(
		 option_method.state=1
		 
		 chk_LightMtl.checked=false
		 chk_LightMtl.enabled=true
		 clp_reflect.enabled=true
		 clp_refract.enabled=true
		 chk_opacity.checked=false
		 chk_opacity.enabled=true
		 
		 clp_diffuse.color=color 250 250 250
		 clp_reflect.color=color 0 0 0
		 clp_refract.color=color 0 0 0
		 
		 grp_dirt.enabled=true
		 
		 chk_Outline.checked=true
		 chk_Outline.enabled=true
		 
		 clp_Wire.enabled=true
		 option_Wire.enabled=true
		 spn_worldUnits.enabled=true
		 spn_Pixels.enabled=true
		 
		 clp_Wire.color=color 0 0 0
		 option_Wire.state=2
		 spn_worldUnits.value=5
		 spn_Pixels.value=1
		 
		 imagesampler.selection=2
		 filter_checkbox.checked=true
		 anti_filter.selection=3
		 anti_filter.enabled=true
		 
		 chk_override.checked=true
		 
	)
	
	fn saveIniSettingXXOO=
	(
		setINISetting iniPath iniDic "option_method_state" (option_method.state as string)
		
		setINISetting iniPath iniDic "chk_LightMtl" (chk_LightMtl.checked as string)
		setINISetting iniPath iniDic "chk_LightMtl_enabled" (chk_LightMtl.enabled as string)
		setINISetting iniPath iniDic "clp_reflect_enabled" (clp_reflect.enabled as string)
		setINISetting iniPath iniDic "clp_refract_enabled" (clp_refract.enabled as string)
		setINISetting iniPath iniDic "chk_opacity" (chk_opacity.checked as string)
		setINISetting iniPath iniDic "chk_opacity_enabled" (chk_opacity.enabled as string)
		
		setINISetting iniPath iniDic "chk_Outline" (chk_Outline.checked as string)
		setINISetting iniPath iniDic "chk_Outline_enabled" (chk_Outline.enabled as string)
		
		_tmp=clp_diffuse.color
		_colorStr="[" + _tmp.r as string + "," + _tmp.g as string + "," + _tmp.b as string + "]"
		setINISetting iniPath iniDic "clp_diffuse_color" _colorStr
		
		_tmp=clp_reflect.color
		_colorStr="[" + _tmp.r as string + "," + _tmp.g as string + "," + _tmp.b as string + "]"
		setINISetting iniPath iniDic "clp_reflect_color" _colorStr
		
		_tmp=clp_refract.color
		_colorStr="[" + _tmp.r as string + "," + _tmp.g as string + "," + _tmp.b as string + "]"
		setINISetting iniPath iniDic "clp_refract_color" _colorStr
		
		setINISetting iniPath iniDic "grp_dirt" (grp_dirt.enabled as string)
		
		setINISetting iniPath iniDic "clp_Wire_Enabled" (clp_Wire.enabled as string)
		setINISetting iniPath iniDic "option_Wire_Enabled" (option_Wire.enabled as string)
		setINISetting iniPath iniDic "spn_worldUnits_Enabled" (spn_worldUnits.enabled as string)
		setINISetting iniPath iniDic "spn_Pixels_Enabled" (spn_Pixels.enabled as string)
		
		_tmp=clp_Wire.color
		_colorStr="[" + _tmp.r as string + "," + _tmp.g as string + "," + _tmp.b as string + "]"
		setINISetting iniPath iniDic "clp_Wire_color" _colorStr
		
		setINISetting iniPath iniDic "option_Wire_state" (option_Wire.state as string)
		setINISetting iniPath iniDic "spn_worldUnits_value" (spn_worldUnits.value as string)
		setINISetting iniPath iniDic "spn_Pixels_value" (spn_Pixels.value as string)
		
		setINISetting iniPath iniDic "imagesampler" (imagesampler.selection as string)
		setINISetting iniPath iniDic "filter_checkbox" (filter_checkbox.checked as string)
		setINISetting iniPath iniDic "anti_filter" (anti_filter.selection as string)
		setINISetting iniPath iniDic "anti_filter_enabled" (anti_filter.enabled as string)
		
		setINISetting iniPath iniDic "chk_override" (chk_override.checked as string)
	)
	on ro_vrayWire open do
	(
		makeDir (getFileNamePath(iniPath)) all:true ;
		try
		 (
			 option_method.state=(getINISetting iniPath iniDic "option_method_state")as integer
			 
			 chk_LightMtl.checked=(getINISetting iniPath iniDic "chk_LightMtl")as booleanClass
			 chk_LightMtl.enabled=(getINISetting iniPath iniDic "chk_LightMtl_enabled")as booleanClass
			 clp_reflect.enabled=(getINISetting iniPath iniDic "clp_reflect_enabled")as booleanClass
			 clp_refract.enabled=(getINISetting iniPath iniDic "clp_refract_enabled")as booleanClass			
		     chk_opacity.checked=(getINISetting iniPath iniDic "chk_opacity")as booleanClass
			 chk_opacity.enabled=(getINISetting iniPath iniDic "chk_opacity_enabled")as booleanClass
			 
			 chk_Outline.checked=(getINISetting iniPath iniDic "chk_Outline")as booleanClass
			 chk_Outline.enabled=(getINISetting iniPath iniDic "chk_Outline_enabled") as booleanClass
			 
			 clp_diffuse.color=(execute(getINISetting iniPath iniDic "clp_diffuse_color") as point3)as color
			 clp_reflect.color=(execute(getINISetting iniPath iniDic "clp_reflect_color") as point3)as color
			 clp_refract.color=(execute(getINISetting iniPath iniDic "clp_refract_color") as point3)as color
			 
			 grp_dirt.enabled=(getINISetting iniPath iniDic "grp_dirt")as booleanClass
			 
			 clp_Wire.enabled=(getINISetting iniPath iniDic "clp_Wire_Enabled")as booleanClass
			 option_Wire.enabled=(getINISetting iniPath iniDic "option_Wire_Enabled")as booleanClass
			 spn_worldUnits.enabled=(getINISetting iniPath iniDic "spn_worldUnits_Enabled")as booleanClass
			 spn_Pixels.enabled=(getINISetting iniPath iniDic "spn_Pixels_Enabled")as booleanClass
			 
			 clp_Wire.color=(execute(getINISetting iniPath iniDic "clp_Wire_color") as point3)as color
			 option_Wire.state=(getINISetting iniPath iniDic "option_Wire_state")as integer
			 spn_worldUnits.value=(getINISetting iniPath iniDic "spn_worldUnits_value")as float
			 spn_Pixels.value=(getINISetting iniPath iniDic "spn_Pixels_value")as float
			 
			 imagesampler.selection=(getINISetting iniPath iniDic "imagesampler")as integer
			 filter_checkbox.checked=(getINISetting iniPath iniDic "filter_checkbox")as booleanClass
			 anti_filter.selection=(getINISetting iniPath iniDic "anti_filter")as integer
			 anti_filter.enabled=(getINISetting iniPath iniDic "anti_filter_enabled")as booleanClass
			 
			 chk_override.checked=(getINISetting iniPath iniDic "chk_override")as booleanClass
			 
		)
		catch(makeDefault();)
		
	)
	on btn_default pressed do   --恢复默认值
	(
		makeDefault();
		saveIniSettingXXOO();
	)
	on btn_testRender pressed do  --以300像素尺寸测试渲染效果
	(
		_Nimagesampler=ro_vrayWire.imagesampler.selection;
		renderpresets.save 0 (GetDir #renderPresets + "\\测试Wire.rps") #{1,32}
		ro_vrayWire.imagesampler.selection=1;
		--更改渲染尺寸到300
		bili=getRendImageAspect();
		renderwidth=300;
		renderHeight=renderwidth/bili;
		renderSceneDialog.update();
		
		renderWire_En_XXOO();
		
		ro_vrayWire.imagesampler.selection=_Nimagesampler;
		renderpresets.load 0 (GetDir #renderPresets + "\\测试Wire.rps") #{1,32};
	)
	on ro_vrayWire close do
	(
		saveIniSettingXXOO();
	)
	
	on btn_render pressed do
	(
		renderWire_En_XXOO();
	)
	
	on option_method changed state do
	(
			case option_method.state of
				(
				1:( 
					 grp_dirt.enabled=true
					 clp_Wire.enabled=true
					 option_Wire.enabled=true
					 spn_worldUnits.enabled=true
					 spn_Pixels.enabled=true
					 chk_LightMtl.enabled=true
					 chk_opacity.enabled=true
					 chk_Outline.enabled=true
				)
				2:(
					 grp_dirt.enabled=false
					 clp_Wire.enabled=false
					 option_Wire.enabled=false
					 spn_worldUnits.enabled=false
					 spn_Pixels.enabled=false
					 chk_LightMtl.enabled=false
					 chk_opacity.enabled=false
					 chk_Outline.enabled=false
				)
	
			)
			if chk_LightMtl.enabled then
			(
				if chk_LightMtl.checked then
				(
					clp_reflect.enabled=false
					clp_refract.enabled=false
				)
				else
				(
				   	clp_reflect.enabled=true
					clp_refract.enabled=true
				)
			)
			else 
			(
				clp_reflect.enabled=true
				clp_refract.enabled=true
			)
		)
	on chk_LightMtl changed state do
	(
			case chk_LightMtl.checked of
			(
			true: (clp_reflect.enabled=false;clp_refract.enabled=false;chk_opacity.checked=false)
			false: (clp_reflect.enabled=true;clp_refract.enabled=true;)
			)
		)
	on chk_opacity changed state do
	(
			case chk_opacity.checked of
			(
			true: (chk_Outline.checked=false;chk_LightMtl.checked=false;clp_reflect.enabled=false;clp_refract.enabled=false;)
			false: (clp_reflect.enabled=true;clp_refract.enabled=true;)
			)
		)
	on chk_Outline changed state do
	(
			case chk_Outline.checked of
			(
			true: (chk_opacity.checked=false;if chk_LightMtl.checked==false then (clp_reflect.enabled=true;clp_refract.enabled=true;))
			false: (/*if chk_LightMtl.checked==false then (clp_reflect.enabled=true;clp_refract.enabled=true;)*/)
			)
		)
	on filter_checkbox changed state do
	(
			case filter_checkbox.checked of
			(
			true: anti_filter.enabled=true
			false: anti_filter.enabled=false
			)
		)
	on ro_vrayWire moved pp do
	(
		if CGplusplusFunc!=undefined then setinisetting spInifilepath "Main" "childLibPos" (pp as string)
	)

)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChildLib ro_vrayWire
else createdialog ro_vrayWire