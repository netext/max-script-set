--色库1.0  由DM编写，禁止用于商业用途


try(destroydialog colorset_roll)catch()
global RGB_Red = random 0 255
global RGB_Green = random 0 255
global RGB_Blue = random 0 255
global HSB_Hue = random 0 359
global HSB_Saturation = random 0.0 1.0
global HSB_Brightness = random 0.0 1.0
global randomRGB =(color RGB_Red RGB_Green RGB_Blue)
global randomcol = #()
global ran_cankaocol = #()
global H_ar = #()
global S_ar = #()
global B_ar = #()
global colorku_roll,subrollcolorku,colorset_roll,help_roll,sub_help_roll,imagecankao,image_roll,colorku_cankao_roll
global default_inifile = "$Scripts\\色库.ini"


if not (doesFileExist default_inifile)then (	
	default_inifile = "$Scripts\\色库.ini"
	setinisetting default_inifile "默认启动" "色库01" "undefined"
	setinisetting default_inifile "默认启动" "色库02" "undefined"
	setinisetting default_inifile "默认启动" "色库03" "undefined"
	setinisetting default_inifile "默认启动" "参考图色库01" "undefined"
	setinisetting default_inifile "默认启动" "参考图色库02" "undefined"
	setinisetting default_inifile "默认启动" "参考图色库03" "undefined"
	setinisetting default_inifile "默认启动" "参考图色库04" "undefined"
	setinisetting default_inifile "默认启动" "参考图色库05" "undefined"
	)

fn HSB_Bias HSB_H HSB_S HSB_B = (     --控制偏移
	for a = 1 to 60 do
		(
			local H01,H02,S01,S02,B01,B02
			--色相偏移
			if HSB_Hue-(HSB_H/2)<0 then (H01 = 0;H02 = 0 +HSB_H) 
			else (
					H01 = HSB_Hue-(HSB_H/2)
					if HSB_Hue+(HSB_H/2)>359 then (H02 = 359;H01 = 359 -HSB_H ) else (H02 = HSB_Hue+(HSB_H/2))
				) 
			
			local RAN_H = (random H01 H02 ) 
			if RAN_H>=0 and RAN_H<=359  then (append H_ar RAN_H )
			
			 --饱和度偏移
			if HSB_Saturation-HSB_S/2 <= 0 then (S01 = 0.001;S02 = 0+HSB_S ) 
				else(
						S01 = HSB_Saturation-(HSB_S/2)
						if HSB_Saturation+HSB_S/2 >= 1 then (S02 = 0.999;S01 = 1-HSB_S) else(S02 = HSB_Saturation+(HSB_S/2))
					)
						local RAN_S = (random S01 S02 )   
			if RAN_S>0.0 and RAN_S <1.0 then (append S_ar RAN_S ) 
			
			--明度偏移
			if HSB_Brightness-HSB_B/2 <=0 then (B01 = 0.001;B02 = 0+HSB_B)
					else(
							 B01 = HSB_Brightness-(HSB_B/2)
							if HSB_Brightness+HSB_B/2 >1 then(B02 = 0.999;B01 = 1-HSB_B) else(B02 = HSB_Brightness+HSB_B/2)
						)
			local RAN_B = (random B01 B02 )    
			if RAN_B>0.0 and RAN_B <1.0 then (append B_ar RAN_B ) 
			
		)
	)

fn RGBtoHSB  RGB_R RGB_G RGB_B =(     -- RGB转HSB
	local RGB_color = #(RGB_R,RGB_G,RGB_B)
		-- 判定 色相 HSB_H
		if RGB_R == RGB_G and RGB_G == RGB_B then(HSB_Hue = undefined)   --R G B色相等，为灰色，无色相
		else (
			if amax RGB_color == RGB_R and RGB_G >= RGB_B then (HSB_Hue = (60*(RGB_G - RGB_B)/(amax RGB_color - amin RGB_color)+0)as integer )
			else(
				if amax RGB_color == RGB_R and RGB_G < RGB_B then (HSB_Hue = (60*(RGB_G - RGB_B)/(amax RGB_color - amin RGB_color)+360)as integer)
				else(
					if amax RGB_color == RGB_G then(HSB_Hue = (60*(RGB_B-RGB_R)/(amax RGB_color - amin RGB_color)+120)as integer)
					else(
						if amax RGB_color == RGB_B then(HSB_Hue = (60*(RGB_R-RGB_G)/(amax RGB_color - amin RGB_color)+240)as integer)
						)
					)
				)
			)
		-- 判定 饱和度 HSB_G
		if amax RGB_color == 0 then (HSB_Saturation =0) else(HSB_Saturation = (amax RGB_color - amin RGB_color)/(amax RGB_color as float) )
		-- 判定 明度 HSB_B
		HSB_Brightness = (amax RGB_color / 255.0)
	)-- end fn
 
fn HSBtoRGB  HSB_H HSB_S HSB_B  =(  -- 先转化 HSB 为 RGB，然后将RGB转化生成随机色并加入到 randomcol 数组中
	local H_mode = (HSB_H / 60) 
	local f = (HSB_H / 60.0) - H_mode
	local p = HSB_B*255 * (1-HSB_S)
	local q = HSB_B*255 * (1-f*HSB_S)
	local t = HSB_B*255 * (1-(1-f)*HSB_S)
		case H_mode of
		(
			0:(RGB_Red = HSB_B*255;RGB_Green = t;RGB_Blue = p )
			1:(RGB_Red = q;RGB_Green = HSB_B*255;RGB_Blue = p )
			2:(RGB_Red = p;RGB_Green = HSB_B*255;RGB_Blue = t )
			3:(RGB_Red = p;RGB_Green = q;RGB_Blue = HSB_B*255 )
			4:(RGB_Red = t;RGB_Green = p;RGB_Blue = HSB_B*255 )
			5:(RGB_Red = HSB_B*255;RGB_Green = p;RGB_Blue = q )
			default:(RGB_Red = HSB_B*255;RGB_Green = t;RGB_Blue = p )
		)
		randomRGB = (color (RGB_Red as integer) (RGB_Green as integer) (RGB_Blue as integer))
		if finditem randomcol randomRGB == 0 then append randomcol randomRGB
	)-- end fn
	
fn changematcol mat=           --改材质颜色
	(
		 if (classof mat == standardmaterial)  then
		( try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (mat.Diffuse = randomcol[random 1 randomcol.count])else (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (mat.Diffuse = ran_cankaocol[random 1 ran_cankaocol.count])))
		catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (mat.Diffuse = ran_cankaocol[random 1 ran_cankaocol.count]))
		
		)
        else
				if classof mat==multimaterial then
                for j=1 to mat.count do
                (
                        deletemapray mat[j]
                )                        
        else
                if classof mat==topbottom then
                        (
							changematcol mat.topMaterial
							changematcol mat.bottomMaterial 
                        )
        else
                if classof mat==blend then
                (
                changematcol mat.map1
                changematcol mat.map2 
                )
		else   
				if classof mat == VRayMtl then
				(
				try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (mat.Diffuse = randomcol[random 1 randomcol.count]) else (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (mat.Diffuse = ran_cankaocol[random 1 ran_cankaocol.count])))
				catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (mat.Diffuse = ran_cankaocol[random 1 ran_cankaocol.count]))
		
				)
		
	)

fn changelightcol = (    --改灯光颜色
	
	for a in selection where superclassof a == light do 
		(
			case classof a of 
			(
				VRaylight:( try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (a.color = randomcol[random 1 randomcol.count]) else(if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count])))
							catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count]))
							)
				VRayIES:(try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (a.color = randomcol[random 1 randomcol.count])else(if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count])))
							catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count]))
							)
				Omnilight: (try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (a.rgb = randomcol[random 1 randomcol.count])else(if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count])))
							catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.rgb = ran_cankaocol[random 1 ran_cankaocol.count]))
							)
				targetSpot: (try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (a.rgb = randomcol[random 1 randomcol.count])else(if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count])))
							catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.rgb = ran_cankaocol[random 1 ran_cankaocol.count]))
							)
				TargetDirectionallight:(try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (a.rgb = randomcol[random 1 randomcol.count])else(if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count])))
							catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.rgb = ran_cankaocol[random 1 ran_cankaocol.count]))
							)
				freeSpot:(try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (a.rgb = randomcol[random 1 randomcol.count])else(if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count])))
							catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.rgb = ran_cankaocol[random 1 ran_cankaocol.count]))
							)
				Directionallight:(try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (a.rgb = randomcol[random 1 randomcol.count])else(if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.color = ran_cankaocol[random 1 ran_cankaocol.count])))
							catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (a.rgb = ran_cankaocol[random 1 ran_cankaocol.count]))
							)
			)
		)
	
	)
	
fn new_rolLout_col  =  --生成色库rollout
(
	try(removeSubrollout colorset_roll.subrollcolorku colorku_roll )catch()
	colorku_roll_creat = rolloutCreator "colorku_roll" "色库" --设置 rollout name  caption 
	colorku_roll_creat.width = 250	--设置 rollout 宽度
	colorku_roll_creat.begin()       --初始化 rollout 
	for i in 1 to randomcol.count do     --循环生成按扭
	(
		colorname=execute ("#cp_"+i as string)   --设置按扭的 name
		colorku_roll_creat.addControl #colorPicker colorname "" paramStr:(" width:29 height:20 across:7 color:"+randomcol[i] as string ) --) --添加按扭
	)
	colorku_roll_creat.end()
	addSubRollout colorset_roll.subrollcolorku colorku_roll
)--end fn

fn new_rolLout_cankao_col  =  --生成参考图色库rollout
(
	try(removeSubrollout colorset_roll.subrollcolorku colorku_cankao_roll )catch()
	colorku_cankao_roll_creat = rolloutCreator "colorku_cankao_roll" "参考图色库" --设置 rollout name  caption 
	colorku_cankao_roll_creat.width = 250	--设置 rollout 宽度
	colorku_cankao_roll_creat.begin()       --初始化 rollout 
	for i in 1 to ran_cankaocol.count do     --循环生成按扭
	(
		colorname=execute ("#cp_"+i as string)   --设置按扭的 name
		colorku_cankao_roll_creat.addControl #colorPicker colorname "" paramStr:(" width:29 height:20 across:7 color:"+ran_cankaocol[i] as string ) --) --添加按扭
	)
	colorku_cankao_roll_creat.end()
	addSubRollout colorset_roll.subrollcolorku colorku_cankao_roll
)

fn opencankaotu = 
(
	try(removeSubRollout colorset_roll.subrollcolorku sub_help_roll)catch()
	try (destroydialog image_roll)catch()
	rollout image_roll "参考图像" width:500 height:352
	(
		button btn_randomcankao_rol "随机提取" pos:[3,4] width:59 height:23
		dotNetControl PictureBox_Color "system.windows.forms.picturebox" pos:[0,0] width:500 height:350
		

		local ImageClass = dotnetclass "system.drawing.image"
		local ColorClass =dotnetclass "system.drawing.color"
		
		local m_IsDown = true
		local m_Image
		
		fn mousepickcol _args =(    --鼠标点击吸取颜色
			m_Image = ImageClass.FromFile (imagecankao) 

			if(m_IsDown)then(
				if(_args.X  < 0 or _args.Y < 0 or _args.X  > m_Image.width or _args.Y > m_Image.height)then(
					return false
				)
				
				try(
				pixelObj = m_Image.GetPixel _args.X _args.Y
				r = pixelObj.R
				g = pixelObj.G
				b = pixelObj.B
				MaxColor = color r g b
				if finditem ran_cankaocol MaxColor == 0 then append ran_cankaocol MaxColor
				)catch()
			)
			new_rolLout_cankao_col()
			
		)
		
		fn random_cankao_color _args =(   --随机提取
			if imagecankao!= undefined then m_Image = ImageClass.FromFile (imagecankao) 
	
				try(
				pixelObj = m_Image.GetPixel (random 0 m_Image.width) (random 0 m_Image.height)
				r = pixelObj.R
				g = pixelObj.G
				b = pixelObj.B
				MaxColor = color r g b
				if finditem ran_cankaocol MaxColor == 0 then append ran_cankaocol MaxColor
				)catch()
			
		)
		
		

		on image_roll open do
		(
			ran_cankaocol = #()
			local path_text = getopenFileName types:"JPG图像（.jpg）|*.jpg" --|TGA图像（.tga）|*.tga|BMP图像（.bmp）|*.bmp|TIF图像（.tif）|*.tif"
			imagecankao = path_text
			if path_text!= undefined then m_Image = ImageClass.FromFile path_text
			colorset_roll.btn_liulancankao.toolTip= path_text as string
			if  imagecankao != undefined
			then(
				PictureBox_Color.backcolor = ColorClass.Black
				PictureBox_Color.imagelocation = imagecankao
				PictureBox_Color.width = m_Image.width
				PictureBox_Color.height = m_Image.height
				image_roll.width = m_Image.width
				image_roll.height = m_Image.height
		-- 				PictureBox_Color.SizeMode = (dotnetclass "System.Windows.Forms.PictureBoxSizeMode").zoom\
			)
		)
		on PictureBox_Color mouseDown _args do
		(
			if (keyboard.controlPressed == true) then (mousepickcol _args) else (messagebox "按住ctrl点击，可将点击处的颜色加入到色库中！")
		)
		on btn_randomcankao_rol pressed  do
			(
				try (colorset_roll.subrollcolorku.colorku_roll.open = false)catch()
				ran_cankaocol = #()
				for a= 1 to 56 do random_cankao_color _args
				new_rolLout_cankao_col()
			)
		)
		createdialog image_roll  pos:(GetDialogPos colorset_roll + [225,0] ) style:#(#style_titlebar, #style_border,#style_minimizebox,#style_sysmenu) 
	
	)


fn helpcreat =  --帮助窗口
	(
		try(destroydialog help_roll)catch()
		rollout help_roll "工具说明" width:220 height:260
		(
			label lbl1 "DM_色库V1.0" pos:[84,5] width:80 height:20
			label lbl2 "      本工具是为了方便用户调色而开发，颜色调试都是基于色彩基本原理，通过对HSB（色相、饱和度、明度）的调节，再生成RGB颜色。" pos:[7,26] width:207 height:60 --style_sunkenedge:true 
			label lbl3 "【单色】：先设置一个基本色，并对它的色相偏移，饱和度偏移，明度偏移进行设置，再批量生成。" pos:[7,86] width:207 height:45 --style_sunkenedge:true
			label lbl4 "【双色】：先设置好两个基本色，批量生成的颜色是这两个颜色的过渡色，也可设置两个灰色，批量生成这两个灰色的中间颜色。" pos:[7,131] width:207 height:60 --style_sunkenedge:true
			label lbl5 "【图片参考】：点击参考图，找到参考图并打开，可以直接生成色库！按扭ctrl+点击图像，即可以一个一个将颜色加入到图库。【在图像的左上方，点击，可以随机提取颜色到色库】" pos:[7,191] width:207 height:70  --style_sunkenedge:true
			button btn8 "X" pos:[5,3] width:15 height:15
			on btn8 pressed  do
				(destroydialog help_roll)
		)
		createdialog help_roll pos:(GetDialogPos colorset_roll + [225,0] ) style:#() 
	)

rollout sub_help_roll "工具说明" width:250 height:255 --帮助卷展栏
	(
		label lbl1 "DM_色库V1.0" pos:[84,5] width:80 height:20
		label lbl2 "      本工具是为了方便用户调色而开发，颜色调试都是基于色彩基本原理，通过对HSB（色相、饱和度、明度）的调节，再生成RGB颜色。" pos:[18,26] width:207 height:60 --style_sunkenedge:true 
		label lbl3 "【单色】：先设置一个基本色，并对它的色相偏移，饱和度偏移，明度偏移进行设置，再批量生成。" pos:[18,86] width:207 height:45 --style_sunkenedge:true
		label lbl4 "【双色】：先设置好两个基本色，批量生成的颜色是这两个颜色的过渡色，也可设置两个灰色，批量生成这两个灰色的中间颜色。" pos:[18,131] width:207 height:60 --style_sunkenedge:true
		label lbl5 "【图片参考】：点击参考图，找到参考图并打开，可以直接生成色库！按扭ctrl+点击图像，即可以一个一个将颜色加入到图库。【在图像的左上方，点击，可以随机提取颜色到色库】" pos:[18,191] width:207 height:70  --style_sunkenedge:true
	)

rollout colorset_roll "色库 --DM" width:220 height:411
(
	GroupBox grp_basecolor "基本色" pos:[4,3] width:210 height:70
	radiobuttons rdo_colortype "" pos:[3,23] width:249 height:16 labels:#("单色偏移", "双色过渡", "图片匹配") columns:3
	colorPicker cp_basecolor01 "" pos:[8,44] width:77 height:25 color:(color 240 210 45) title:"选择第一基本色"
	colorPicker cp_basecolor02 "" pos:[90,44] width:77 height:25 enabled:false color:(color 40 100 25) title:"选择第二基本色" visible:false
	button btn_liulancankao "打开一张图像作为颜色参考" pos:[9,44] width:163 height:25 enabled:false visible:false
	button btn_help "?" pos:[180,44] width:25 height:25 toolTip:"工具说明"
	
	spinner spn_sexiang "色相偏移" pos:[28,78] width:95 height:16 range:[0,359,50] type:#integer scale:1
	spinner spn_baohedu "饱和偏移" pos:[28,98] width:95 height:16 range:[0,1,0.3] type:#float scale:0.01
	spinner spn_mingdu "明度偏移" pos:[28,118] width:95 height:16 range:[0,1,0.4] type:#float scale:0.01
	
	button btn_do "点击生成" pos:[129,75] width:85 height:38 toolTip:"生成色库"
-- 	button btn_save "S" pos:[129,115] width:25 height:20 enabled:false toolTip:"保存色库"
-- 	button btn_load "L" pos:[156,115] width:25 height:20 enabled:false toolTip:"读取色库"
	button btn_clearku "C" pos:[183,115] width:25 height:20 toolTip:"清空色库"
	
	subRollout subrollcolorku "" pos:[-16,134] width:260 height:251
	
	HyperLink LTLINK "CG4A " pos:[10,389] width:30 height:15 color:(color 250 150 0) hovercolor:(color 100 100 150) visitedcolor:(color 200 150 0) address:"http://www.3dheima.com/"
	HyperLink blogLINK " --DM" pos:[40,389] width:35 height:15 color:(color 250 200 0) hovercolor:(color 100 100 150) visitedcolor:(color 200 150 0) address:"http://3dheima.com"
	button btn_tolight "》灯" pos:[113,389] width:50 height:18 toolTip:"将颜色指定给选择的灯"
	button btn_toobj "》物体" pos:[166,389] width:50 height:18 toolTip:"将颜色指定给选择的物体（线框颜色）
ctrl:将颜色指定给选择的物体的材质"
	
	fn falsespn = (spn_sexiang.enabled = false;spn_baohedu.enabled = false;spn_mingdu.enabled = false)
	fn truespn = (spn_sexiang.enabled = true;spn_baohedu.enabled = true;spn_mingdu.enabled = true)
	
	
	
	
	on colorset_roll open do
	(
	--读取 色库
	try (
	local sekucol = (execute (getinisetting default_inifile "默认启动" "色库01"))+(execute (getinisetting default_inifile "默认启动" "色库02"))+(execute (getinisetting default_inifile "默认启动" "色库03"))
	for u = 1 to sekucol.count do (if sekucol[u] != undefined  then append randomcol sekucol[u])
		)catch()
	
	--读取 参考图色库
	try (
	local sekucankaorol = (execute (getinisetting default_inifile "默认启动" "参考图色库01"))+(execute (getinisetting default_inifile "默认启动" "参考图色库02"))+(execute (getinisetting default_inifile "默认启动" "参考图色库03"))+(execute (getinisetting default_inifile "默认启动" "参考图色库04"))+(execute (getinisetting default_inifile "默认启动" "参考图色库05"))
	for u = 1 to sekucankaorol.count do (if sekucankaorol[u] != undefined  then append ran_cankaocol sekucankaorol[u])
		)catch()
	if randomcol.count == 0 and ran_cankaocol.count <= 1 
	then (
			addSubRollout colorset_roll.subrollcolorku sub_help_roll
		)
	else(
			if randomcol.count != 0 then ( new_rolLout_col())
			if ran_cankaocol.count != 0 then (new_rolLout_cankao_col();try(colorset_roll.subrollcolorku.colorku_roll.open = false)catch())
		
		)
	)
	on colorset_roll close do
	(
	-- 将色库组拆为三份进行保存 （因为数组内容超过20，20以后的内容，数组只是以“...”显示）
	local rc_01 = #()
	local rc_02 = #()
	local rc_03 = #()
	
	try (for m = 1 to 20 do (append rc_01 randomcol[m]))catch()
	try (for m = 21 to 40 do (append rc_02 randomcol[m]))catch()
	try (for m = 41 to 60 do (append rc_03 randomcol[m]))catch()
	setinisetting default_inifile "默认启动" "色库01" (rc_01 as string)
	setinisetting default_inifile "默认启动" "色库02" (rc_02 as string)	
	setinisetting default_inifile "默认启动" "色库03" (rc_03 as string)
	
	-- 将参考图色库组拆为三份进行保存 （因为数组内容超过20，20以后的内容，数组只是以“...”显示）
	local rc_ck_01 = #()
	local rc_ck_02 = #()
	local rc_ck_03 = #()
	local rc_ck_04 = #()
	local rc_ck_05 = #()
	try (for m = 1 to 20 do (append rc_ck_01 ran_cankaocol[m]))catch()
	try (for m = 21 to 40 do (append rc_ck_02 ran_cankaocol[m]))catch()
	try (for m = 41 to 60 do (append rc_ck_03 ran_cankaocol[m]))catch()
	try (for m = 61 to 80 do (append rc_ck_04 ran_cankaocol[m]))catch()
	try (for m = 81 to 100 do (append rc_ck_05 ran_cankaocol[m]))catch()
	setinisetting default_inifile "默认启动" "参考图色库01" (rc_ck_01 as string)
	setinisetting default_inifile "默认启动" "参考图色库02" (rc_ck_02 as string)
	setinisetting default_inifile "默认启动" "参考图色库03" (rc_ck_03 as string)
	setinisetting default_inifile "默认启动" "参考图色库04" (rc_ck_04 as string)
	setinisetting default_inifile "默认启动" "参考图色库05" (rc_ck_05 as string)
	try(destroydialog help_roll)catch()
	try (destroydialog image_roll)catch()
		
	
	)
	on colorset_roll moved pos do
	(
	try (SetDialogPos help_roll (GetDialogPos colorset_roll + [225,0]))catch()
	try (SetDialogPos image_roll (GetDialogPos colorset_roll + [225,0]))catch()
	
	) 
	on rdo_colortype changed stat do
	(
		case rdo_colortype.state of 
		(
			1:(cp_basecolor01.enabled =true;cp_basecolor02.enabled =false;btn_liulancankao.enabled=false;truespn() ;cp_basecolor01.visible=true;cp_basecolor02.visible=false; btn_liulancankao.visible=false)
			2:(cp_basecolor01.enabled =true;cp_basecolor02.enabled =true;btn_liulancankao.enabled=false;falsespn();cp_basecolor01.visible=true;cp_basecolor02.visible=true; btn_liulancankao.visible=false)
			3:(cp_basecolor01.enabled =true;cp_basecolor02.enabled =true;btn_liulancankao.enabled=true;falsespn() ;cp_basecolor01.visible=false;cp_basecolor02.visible=false; btn_liulancankao.visible=true)
			default:(cp_basecolor01.enabled =true;cp_basecolor02.enabled =false;btn_liulancankao.enabled=false;truespn())
		)
	)
	on btn_liulancankao pressed do
	(
		opencankaotu()
	)
	on btn_help pressed do
	(
		helpcreat()
	)
	on btn_do pressed do
	( try(removeSubRollout colorset_roll.subrollcolorku sub_help_roll)catch()
	  try (colorset_roll.subrollcolorku.colorku_cankao_roll.open = false)catch()
		case rdo_colortype.state of
			(
				1:(
					
					RGBtoHSB  cp_basecolor01.color.r cp_basecolor01.color.g cp_basecolor01.color.b --第一个颜色转 HSB
					if (HSB_Hue == undefined)          --当第一个颜色没有色相时
					then (
							randomcol = #()   --清空 randomcol数组
							for u = 1 to 56 do 
						   (
							-- 颜色生成为 明度偏移值 到 黑色的 随机
							randomRGB = cp_basecolor01.color * (random (0.0) (spn_mingdu.value)) 
							if finditem randomcol randomRGB == 0 then append randomcol randomRGB
							)
						)   
					else(
						randomcol = #()  --清空 randomcol数组
						H_ar = #()   --清空 H 色相数组
						S_ar = #()   --清空 S 饱和度数组
						B_ar = #()   --清空 B 明度数组
						HSB_Bias  spn_sexiang.value spn_baohedu.value spn_mingdu.value  --将控制偏移生成的 H S B 加入到相对应的 H_ar ,S_ar,B_ar数组，以备转RGB色调用
					
						if H_ar.count!=0 and S_ar.count!=0 and B_ar.count!=0 
						then (
							for m=1 to 56 do (try (HSBtoRGB H_ar[m] S_ar[m] B_ar[m])catch())  -- 将 H_ar ,S_ar,B_ar数组 相对应的组合起来，转成RGB，循环56次 并将转成的RGB颜色加入到randomcol数组中
							)
						)
					new_rolLout_col () --生成色库
					)
				2:(
					RGBtoHSB  cp_basecolor01.color.r cp_basecolor01.color.g cp_basecolor01.color.b  --第一个颜色转 HSB
					local HSB01 = #(HSB_Hue,HSB_Saturation,HSB_Brightness)  --收集第一个颜色的 HSB
					RGBtoHSB  cp_basecolor02.color.r cp_basecolor02.color.g cp_basecolor02.color.b  --第二个颜色转 HSB
					local HSB02 = #(HSB_Hue,HSB_Saturation,HSB_Brightness) --收集第二个颜色的 HSB
					if HSB01[1] == undefined  and  HSB02[1] == undefined  --两个颜色都无色相
					then
					(	
						
						Local qh = 1
						randomcol = #() --清空 randomcol数组
						--两个颜色都无色相
						for u = 1 to 56 do 
						(   
							local grayrandom = (random HSB02[3] HSB01[3]  * 255 )as integer
							randomRGB = color  grayrandom  grayrandom  grayrandom
							if finditem randomcol randomRGB == 0 then append randomcol randomRGB
						)
					)
					else
					(
						local col01rgb = #(cp_basecolor01.color.r,cp_basecolor01.color.g,cp_basecolor01.color.b)
						local col02rgb = #(cp_basecolor02.color.r,cp_basecolor02.color.g,cp_basecolor02.color.b)
										
						if HSB01[1] == undefined and HSB02[1] != undefined  --颜色一无色相，颜色二有色相
						then
						(  
							randomcol = #() --清空 randomcol数组
								if amax col02rgb == col02rgb[1]
								then
								(
									
									for u = 1 to 56 do
									(	local c = random 0 col02rgb[1]
										local b = random 0 c
										randomRGB = color (col02rgb[1]) (if amin col02rgb == col02rgb[2] then b else c) (if amin col02rgb == col02rgb[3] then b else c)
										if finditem randomcol randomRGB == 0 then append randomcol randomRGB
									)
								)
								else
								(
									if amax col02rgb == col02rgb[2] 
									then
									(
										
										for u = 1 to 56 do
										(
											local c = random 0 col02rgb[2]
											local b = random 0 c
											randomRGB = color (if amin col02rgb == col02rgb[1] then b else c) (col02rgb[2]) (if amin col02rgb == col02rgb[3] then b else c)
											if finditem randomcol randomRGB == 0 then append randomcol randomRGB
										)
									)
									else
									(
										if amax col02rgb == col02rgb[3] 
										then
										(
											
											for u = 1 to 56 do
											(
												local c = random 0 col02rgb[3]
												local b = random 0 c
												randomRGB = color (if amin col02rgb == col02rgb[1] then b else c) (if amin col02rgb == col02rgb[2] then b else c) (col02rgb[3]) 
												if finditem randomcol randomRGB == 0 then append randomcol randomRGB
											)
										)
										
									)
								)	
						)
						else
						(
							if HSB01[1] != undefined and HSB02[1] == undefined  --颜色二无色相，颜色一有色相
							then
							(  
								randomcol = #() --清空 randomcol数组
								if amax col01rgb == col01rgb[1]
								then
								(
									
									for u = 1 to 56 do
									(	local c = random 0 col01rgb[1]
										local b = random 0 c
										randomRGB = color (col01rgb[1]) (if amin col01rgb == col01rgb[2] then b else c) (if amin col01rgb == col01rgb[3] then b else c)
										if finditem randomcol randomRGB == 0 then append randomcol randomRGB
									)
								)
								else
								(
									if amax col01rgb == col01rgb[2] 
									then
									(
										
										for u = 1 to 56 do
										(
											local c = random 0 col01rgb[2]
											local b = random 0 c
											randomRGB = color (if amin col01rgb == col01rgb[1] then b else c) (col01rgb[2]) (if amin col01rgb == col01rgb[3] then b else c)
											if finditem randomcol randomRGB == 0 then append randomcol randomRGB
										)
									)
									else
									(
										if amax col01rgb == col01rgb[3] 
										then
										(
											
											for u = 1 to 56 do
											(
												local c = random 0 col01rgb[3]
												local b = random 0 c
												randomRGB = color (if amin col01rgb == col01rgb[1] then b else c) (if amin col01rgb == col01rgb[2] then b else c) (col01rgb[3]) 
												if finditem randomcol randomRGB == 0 then append randomcol randomRGB
											)
										)
										
									)
								)
									
							)
							else
							(
								if HSB01[1] != undefined and HSB02[1] != undefined  --两个颜色都有色相
								then
								(
									randomcol = #() --清空 randomcol数组
									for u = 1 to 56 do
									(	randomRGB = random cp_basecolor01.color cp_basecolor02.color
										print randomrgb
										if finditem randomcol randomRGB == 0 then append randomcol randomRGB
									)
								)
								
							)--end else
						)--end else
					)--end else
				new_rolLout_col () --生成色库
					)--end 2
				3:(
					new_rolLout_cankao_col()
					)
	
			)
			
	)
	on btn_clearku pressed do
	(
		randomcol = #()   --清空 randomcol数组
		randomRGB = #()
		new_rolLout_col () --生成色库
		try(removeSubrollout colorset_roll.subrollcolorku sub_help_roll )catch()
	)
	on btn_tolight pressed do
	(
		changelightcol()
	)
	on btn_toobj pressed do
	(
		if (keyboard.controlPressed == true) then
		(
			local selmat = #()
			if selection.count !=0 then (for a in selection do( if (finditem selmat a.material == 0)then append selmat a.material) )
			for m = 1 to selmat.count do  changematcol selmat[m]
		)
		else(
			if (randomcol.count!=0) or (ran_cankaocol!=0)
			then (
				
				try (if (colorset_roll.subrollcolorku.colorku_roll.open == true)then  (for a in selection do a.wirecolor = randomcol[random 1 randomcol.count]))
				catch (if (colorset_roll.subrollcolorku.colorku_cankao_roll.open == true)then (for a in selection do a.wirecolor = ran_cankaocol[random 1 ran_cankaocol.count]))
			
				)
			else(
				messagebox "色库中没有颜色" title:"DM提示"
				)
		)
	)
)


createdialog colorset_roll 220 410 30 30 style:#(#style_titlebar, #style_border,#style_minimizebox,#style_sysmenu)
