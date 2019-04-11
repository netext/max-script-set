


---自动渲染用全局变量定义----其中objcolor该变量数组在yy分层中也用到
global  objxss=#(),matss=#(),matss_tmp=#(),colori=1
global  objcolor=#(color 171 232 255,color 38 115 109,color 255 120 0,color 246 255 0,color 138 255 0,color 0 255 216,color 253 0 0 ,color 0 90 255,color 255 255 255,color 102 0 255,color 174 0 255,color 255 0 246,color 194 0 46,color 150 0 0,color 150 62 137,color 93 62 150,color 62 83 150,color 62 124 150,color 62 150 101,color 101 150 62,color 150 126 61,color 150 95 62,color 176 73 102,color 185 80 80,color 60 16 45,color 43 25 60,color 25 46 60,color 55 60 25,color 60 43 25,color 60 25 25,color 150 115 115,color 142 115 150,color 115 121 150,color 115 150 150,color 125 150 115,color 150 135 115,color 240 212 212,color 240 240 212,color 151 223 111,color 0 116 198,color 92 0 95,color 0 255 255,color 134 0 91,color 255 135 135,color 255 219 155,color 255 254 155,color 240 255 155,color 226 255 217,color 155 255 214,color 155 216 255,color 155 181 255,color 190 155 255,color 255 155 247,color 255 155 155,color 120 99 99,color 120 102 64,color 94 120 64,color 64 120 109,color 64 90 120,color 63 66 120,color 81 64 120,color 120 64 101,color 120 64 64,color 183 128 128,color 209 199 126,color 229 203 199,color 218 127 167,color 214 210 99)







---yy材质变成通道材质
fn yyme smaterial=
	(
		local opi=0
	       --randr = random 0 255
  	       --randg = random 0 255
  	       --randb = random 0 255
  	          smaterial.diffuse = objcolor[colori]
		     colori=colori+1
		     if colori>68 then colori=1
  	       smaterial.shaderType = 1
  	       smaterial.adTextureLock = on
  	       smaterial.useSelfIllumColor = off
  	       smaterial.selfIllumAmount=100
  	       smaterial.glossiness=0
  	       smaterial.specularLevel=0
  	       smaterial.opacity=100
  	       smaterial.Soften=0
  	       smaterial.opacityFallOff = 0
  	       smaterial.diffuseMapEnable=false
  	       smaterial.specularMapEnable=false
  	       smaterial.specularLevelMapEnable=false
  	       smaterial.glossinessMapEnable=false
  	       smaterial.selfillumMapEnable=false
  	       smaterial.filterMapEnable=false
  	       smaterial.bumpMapEnable=false
  	       smaterial.reflectionMapEnable=false
  	       smaterial.refractionMapEnable=false
  	       smaterial.displacementMapEnable=false
		   )

--自动渲染中生成材质通道-------

fn yycztd =
(
  local mt,i,ii
  for i in lights where (classOf i != targetObject) do i.on = false --关闭所有灯光
  for i=1 to scenematerials.count do
  	(    
	     case classof scenematerials[i] of
		 (
  	        Standardmaterial: yyme scenematerials[i]
		    Multimaterial: (
		                    for ii=1 to scenematerials[i].count do
							(
							  case classof scenematerials[i][ii] of
								 (
									Standardmaterial: yyme scenematerials[i][ii]
									Bitmaptexture: ()
									Gradient:()
									VRayHDRI:()
									VRaySky:()
									default:(
									         mt=standard()
											try (
									                 replaceinstances scenematerials[i][ii] mt
										            yyme scenematerials[i][ii]
											 	  )
											catch
												(
												messageBox ("第"+i as string+"个材质出错了，请在脚本命令行里运行scenematerials["+i as string+"]然后再和yy联系！，如果出现本消息则有可能材质通道会有某个材质未被转换成通道，但本次渲染会被继续，请渲好之后再检查。")
												)
										      )
									)
								)							
		                     )
			Bitmaptexture: ()
			Gradient:()
			VRayHDRI:()
			VRaySky:()
	         default:(
		         mt=standard()
                  try (
					  replaceinstances scenematerials[i] mt
					  yyme scenematerials[i]
					  )
				catch
					(
					messageBox ("第"+i as string+"个材质出错了，请在脚本命令行里运行scenematerials["+i as string+"]然后再和yy联系！，如果出现本消息则有可能材质通道会有某个材质未被转换成通道，但本次渲染会被继续，请渲好之后再检查。")
					)
			      )
		  )

   )
)



--自动渲染中生成组通道-------


fn db obj objss =   --对比obj是不是在objss中
(
local a=0
for i=1 to objss.count do 
	(
	if obj==objss[i] then 
		( 
		a=1
		exit 
		) 
	)
if a==1 then false else true 
)


fn scczz objss_ch=  --生成可以分材质的组
(
for ii=1 to objss_ch.children.count do 
if superclassof objss_ch.children[ii]==GeometryClass or superclassof objss_ch.children[ii]==shape then append matss_tmp objss_ch.children[ii] else scczz objss_ch.children[ii]

)

fn scztd = 
(
allobj=$*
allobjarr=allobj as array
objxss=#()
matss=#()
for i=1  to allobjarr.count do
	(
		if allobjarr[i].parent==undefined and allobjarr[i].lookat==undefined and db allobjarr[i] objxss then 
		if superclassof allobjarr[i]==helper or superclassof allobjarr[i]==GeometryClass or superclassof allobjarr[i]==shape then append objxss allobjarr[i] 
	)
for i=1 to  objxss.count do
	(
	case superclassof objxss[i] of
		  (
		  	shape:append matss objxss[i]
		     GeometryClass:append matss objxss[i]
			helper: 
			 (
			 		scczz  objxss[i]
					if matss_tmp!=#() then 
					(
					append matss matss_tmp
					matss_tmp=#()
					)
			)
		)
	)
for i=1 to matss.count do
	(
	if matss[i]!=#() then
		(
		mti=standard()
		yyme mti
		matss[i].material=mti
		)
	)

)

---组通道--end

--自动渲染中生成影子通道-------

fn yztd =
(
for i in lights where (classOf i != targetObject) do i.on = false --关闭所有灯光
try select $zg catch messagebox "没有设置主灯光"
zgd=getCurrentSelection()
if zgd!=undefined then
	(
	if classof zgd[1]==TargetDirectionallight or classof zgd[1]==targetSpot then 
		(
		zgd[1].enabled = on
		zgd[1].multiplier = 2
		zgd[1].rgb = color 255 255 255
		zgd[1].shadowColor = color 255 0 0
		zgd[1].shadowMultiplier = 2
		zgd[1].lightAffectsShadow = off
		if zgd[1].shadowgenerator as string=="VRayShadow:VRayShadow" then
			(
			zgd[1].transparentShadows = off
			zgd[1].smoothShadows = off
			)
		
		mt=standard()
		mt.ambient = color 255 255 255
		mt.Specular = color 255 255 255
		mt.Diffuse = color 255 255 255
		select $*
		$.material=mt
		)
	)
)

--自动渲染中生成影子通道-----end--










-----------------end------------------------------------------函数定义-------------end--------------------










-----------------------------------------







try(closerolloutfloater xrzs) catch()
colori=1
 --在MAX中创建一个浮动式窗体--
xrzs =newrolloutfloater"渲染助手"175 440

--创建第一个材质整理卷帘--
	rollout ro_czzl "材质整理" width:160 height:150
	(
		local maxi,ma,ss,maxi2,new_mat_name
		button btn_qlcz "清理编辑材质" pos:[10,10] width:130 height:21
		button btn_zlcz "整理场景材质" pos:[10,37] width:76 height:21
		spinner spn_zlcz "000" pos:[100,38] width:50 height:16 enabled:true range:[1,1,1] type:#integer scale:1
		--button btn5 "合并同名材质" pos:[10,113] width:130 height:21
		button btn_xzcz "选中物体材质" pos:[10,66] width:76 height:21      
		spinner spn_xzcz "000" pos:[100,67] width:50 height:16 enabled:true range:[1,1,1] type:#integer scale:1
		
		on btn_qlcz pressed do
		if queryBox "要清理编辑材质,是否继续?" title:"yy_tools" then
			(
				for i=1 to 24 do
			  	        (
			  	         new_mat_name=i as string + "-Default"
			  	         meditmaterials[i]=standard name:new_mat_name 
			  	        )
			)----qlcz---end
		on btn_zlcz pressed do
		  	if queryBox "要整理场景材质,是否继续?" title:"xy_tools" then
				(
					maxi2=ceil (scenematerials.count / 24.0)
					spn_zlcz.range=[1,maxi2,1]
					spn_zlcz.caption=scenematerials.count as string
				  
					  	for si=1 to 24 do
						  	(
						  	if scenematerials[si]!=undefined
						  	then
						  	meditmaterials[si]=scenematerials[si]
						  	else
							  	(
							  	newname=si as string + " - Default"
							  	meditMaterials[si] = standard name: newname
							  	)
						  	)
					max mtledit
					medit.UpdateMtlEditorBrackets()
				  	)--btn2---end
			on spn_zlcz changed val do
			(
			if maxi2 == undefined 
				then messageBox "请先按左边按钮!" 
				else
					(
					   for i=1 to 24 do 
					   		if  scenematerials[(spn_zlcz.value-1)*24+i]!=undefined 
							then 
							    meditMaterials[i]=scenematerials[(spn_zlcz.value-1)*24+i]
							else
								(
						  	       new_mat_name = i as string + " - Default"
						  	       meditmaterials[i] = standard name:new_mat_name 
						  	        )			            
					)
			)----spn_zlcz end
		on spn_xzcz changed val do
		(   
		    if ma==undefined 
			then messageBox "请先按左边按钮!" 
			else
				(
					for i=1 to 24 do  
					(
						if ma[(spn_xzcz.value-1)*24+i] != undefined 
							then 
								meditMaterials[i]=ma[(spn_xzcz.value-1)*24+i]
						     else
					            (
					  	         new_mat_name = i as string + " - Default"
					  	         meditmaterials[i] = standard name:new_mat_name 
					  	        )
					)
				)
		)----spn_xzcz end
			
		on btn_xzcz pressed do
		(
			if $ != undefined then
				(
					ss=getCurrentSelection()
					ma=MaterialLibrary()
					for i=1 to ss.count do
					(
						if superclassof ss[i] == GeometryClass then if ss[i].Material != undefined then append ma ss[i].Material 
					 )
					maxi=ceil (ma.count / 24.0)
					spn_xzcz.range=[1,maxi,1]
					for i=1 to 24 do
					(
						if ma[i] != undefined 
								then 
									meditMaterials[i]=ma[i]
							     else
						            (
						  	         new_mat_name = i as string + " - Default"
						  	         meditmaterials[i] = standard name:new_mat_name 
						  	        )
					)
					
					spn_xzcz.caption=ma.count as string
					max mtledit
					medit.UpdateMtlEditorBrackets()
				)
				else 	
				messageBox "请先选中物体!" 
					
		)----btn6 end
	)---第一个卷帘end--


--创建第二个自动渲染卷帘--
	rollout ro_zdxr "自动渲染" width:162 height:196
	(
		local zg,yztd_cb_f=1,ztd_cb_f=1,cztd_cb_f=1,ct_cb_f=1,wasCancelled=false
		button rende "开渲" pos:[38,141] width:79 height:39
		checkbox yztd_cb "影子通道" pos:[44,94] width:90 height:20 checked:true
		checkbox scztd_cb "组通道" pos:[44,72] width:90 height:20 checked:true
		checkbox cztd_cb "材质通道" pos:[44,51] width:90 height:20 checked:true
		checkbox ct_cb "渲染成图" pos:[44,29] width:90 height:20 checked:true
		checkbox fdk_cb "放大框" pos:[44,115] width:90 height:20 checked:true
		on rende pressed do
		(
			zg=1
			try select $zg catch zg=0
			if zg==0 and yztd_cb.state then messageBox "请设置主灯光！" title:"xy_tools" 
			else
				if queryBox ("请确定设置好VRay所有参数并已经存盘,请确认成图存盘目录:\n"+rendoutputfilename+",\n是否继续?") title:"xy_tools" then
				(
					
					----cttd-----
					if ct_cb.state==true then
						if fdk_cb.state==true 
							then
							render outputfile:rendoutputfilename renderType:#blowup progressbar:true cancelled:&wasCancelled
							else
							render outputfile:rendoutputfilename renderType:#view  progressbar:true cancelled:&wasCancelled
					----metd-----
					if cztd_cb.state==true and (not wasCancelled) then
					(
					 	yycztd ()
						r = renderers.current
						r.gi_on=false
						if fdk_cb.state==true 
							then
								render outputfile:(getfilenamepath  rendoutputfilename + getfilenamefile rendoutputfilename + "_cltd" + getfilenametype rendoutputfilename) renderType:#blowup progressbar:true cancelled:&wasCancelled
							else
								render outputfile:(getfilenamepath  rendoutputfilename + getfilenamefile rendoutputfilename + "_cltd" + getfilenametype rendoutputfilename) renderType:#view   progressbar:true cancelled:&wasCancelled

					)
					----ztd-------
					if scztd_cb.state==true and (not wasCancelled) then
					(	r = renderers.current
						r.gi_on=false
						scztd ()
						if fdk_cb.state==true 
							then
							render outputfile:(getfilenamepath  rendoutputfilename + getfilenamefile rendoutputfilename + "_ztd" + getfilenametype rendoutputfilename) renderType:#blowup progressbar:true cancelled:&wasCancelled
							else
							render outputfile:(getfilenamepath  rendoutputfilename + getfilenamefile rendoutputfilename + "_ztd" + getfilenametype rendoutputfilename) renderType:#view   progressbar:true cancelled:&wasCancelled
					)
					----yztd-------
					if yztd_cb.state==true and (not wasCancelled) then
					(	r = renderers.current
						r.gi_on=false
						yztd()
						if fdk_cb.state==true 
							then
							render outputfile:(getfilenamepath  rendoutputfilename + getfilenamefile rendoutputfilename + "_yztd" + getfilenametype rendoutputfilename) renderType:#blowup progressbar:true cancelled:&wasCancelled
							else
							render outputfile:(getfilenamepath  rendoutputfilename + getfilenamefile rendoutputfilename + "_yztd" + getfilenametype rendoutputfilename) renderType:#view   progressbar:true cancelled:&wasCancelled
					)
				)
		)---rende--end
	)-----第二卷帘结束----

rollout ro_zhh "帮助" width:162 height:196
(
	label lbl2 "如果要用到自动渲染通道的话请设置主灯光的名字为\"zg\"，在渲染之前请本工具由黑马制作，由任何问题请联系QQ群46879535。欢迎大家交流脚本技术。" pos:[14,26] width:131 height:129
)

addRollout ro_czzl xrzs 
addRollout ro_zdxr xrzs 
addRollout ro_zhh xrzs 