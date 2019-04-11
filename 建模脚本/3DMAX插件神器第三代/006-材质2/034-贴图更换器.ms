rollout changetexture "贴图更换(3dheima.com)" 
(
	local name1
	local path1
	local f
	local p_s=true
	local geoa=for geo in geometry collect geo
	listBox cbx2 "选择物体" pos:[5,5] width:150 height:10 items:(for geo in geometry collect geo.name)
	label lbl1 "材质类型或贴图名称" pos:[5,160] width:150 height:20
	edittext edt4 "" pos:[0,175] width:130 height:20 text:""
	button btn65 "..." pos:[135,175] width:20 height:20 enabled:false toolTip:"选择贴图路径"
	label lbl6 "选择材质ID" pos:[5,202] width:60 height:15 enabled:false
	dropDownList ddl1 "" pos:[66,200] width:37 height:15 enabled:false
	checkbutton chk1 "显示面" pos:[105,199] width:50 height:22 enabled:false toolTip:"显示材质ID对应的面"
	label lbl2 "更换贴图" pos:[5,220] width:60 height:20
	button btn66 "<<<" pos:[5,237] width:50 height:20 enabled:false
	button btn67 ">>>" pos:[58,237] width:50 height:20 enabled:false
	button btn68 "刷新" pos:[112,237] width:43 height:20
	Timer clock "testClock" pos:[13,240] width:24 height:24 interval:1000 active:false
	button btn2 "play" pos:[110,260] width:45 height:18 enabled:false
	spinner spn1 "" pos:[33,261] width:55 height:16 range:[1,10000,1000] type:#integer
	label lbl5 "延时" pos:[7,261] width:25 height:24
	label lbl3 "ms" pos:[92,261] width:15 height:16
	
	label lbl10 "=========================" pos:[5,280] width:206 height:30
	label lbl11 "版本: TextureChanger v1.0\n版权: 艾雨 (QQ:109668208)" pos:[10,295] width:206 height:30
	label lbl12 "更多资源请登录3dheima.com！" pos:[10,322] width:260 height:30

	on chk1 changed theState do(if chk1.checked==true
							then(Convertto geoa[cbx2.selection] (Editable_Poly)
								max modify mode
								subobjectLevel = 4
								geoa[cbx2.selection].EditablePoly.selectByMaterial ddl1.selection
								)
							else subobjectLevel = 0
							)
	on ddl1 selected value do (btn2.enabled=false
							select geoa[cbx2.selection]
							max modify mode
							if chk1.checked==true
							then(subobjectLevel = 4
								geoa[cbx2.selection].EditablePoly.selectByMaterial ddl1.selection
								)
							else subobjectLevel = 0
							case of ((classof geoa[cbx2.selection].material[ddl1.selection]==standardmaterial)\
		 							:(case of((geoa[cbx2.selection].material[ddl1.selection].diffusemap!=undefined and\ 
											  classof geoa[cbx2.selection].material[ddl1.selection].diffusemap==Bitmaptexture)\
											  :(edt4.text=filenameFromPath geoa[cbx2.selection].material[ddl1.selection].diffusemap.filename as string;btn2.enabled=true;btn66.enabled=true;btn67.enabled=true;btn65.enabled=true)
											  (geoa[cbx2.selection].material[ddl1.selection].diffusemap!=undefined and\ 
											  classof geoa[cbx2.selection].material[ddl1.selection].diffusemap!=Bitmaptexture)\
											  :(edt4.text="Texture_"+(classof geoa[cbx2.selection].material[ddl1.selection].diffusemap as string);btn2.enabled=false;btn66.enabled=false;btn67.enabled=false;btn65.enabled=false)
											  (geoa[cbx2.selection].material[ddl1.selection].diffusemap==undefined):(edt4.text="未指定贴图";btn66.enabled=false;btn67.enabled=false;btn65.enabled=true)
											  )
											)
									default:(edt4.text="Material_"+(classof geoa[cbx2.selection].material[ddl1.selection] as string);btn2.enabled=false;btn66.enabled=false;btn67.enabled=false;btn65.enabled=false)
	 									    )
							)
	on spn1 changed value do(clock.interval=spn1.value
						 )
	on btn2 pressed do(case of((p_s==true):(btn2.caption="stop";clock.active=true;p_s=false;ddl1.enabled=false;cbx2.enabled=false;btn68.enabled=false)
						    (p_s==false):(btn2.caption="play";clock.active=false;p_s=true;ddl1.enabled=(if classof geoa[cbx2.selection].material==Multimaterial then true else false);cbx2.enabled=true;btn68.enabled=true)
						   )
					)
	on clock tick do
	(
		megaarray = #()
		if classof geoa[cbx2.selection].material==Multimaterial
		then currentbmp = geoa[cbx2.selection].material[ddl1.selection].diffusemap
		else currentbmp = geoa[cbx2.selection].material.diffusemap
		currenttex = currentbmp.filename
		filepath = getFilenamePath currentbmp.filename
		bmparray = getFiles (filepath + "*.bmp")
		jpgarray = getFiles (filepath + "*.jpg")
		jpegarray = getFiles (filepath + "*.jpeg")
		jpearray = getFiles (filepath + "*.jpe")
		tifarray = getFiles (filepath + "*.tif")
		gifarray = getFiles (filepath + "*.gif")
		tgaarray = getFiles (filepath + "*.tga")
		pngarray = getFiles (filepath + "*.png")
		rpfarray = getFiles (filepath + "*.rpf")
		rlaarray = getFiles (filepath + "*.rla")
		hdrarray = getFiles (filepath + "*.hdr")
		picarray = getFiles (filepath + "*.pic")
		aviarray = getFiles (filepath + "*.avi")
		movarray = getFiles (filepath + "*.mov")
		cinarray = getFiles (filepath + "*.cin")
		cwsarray = getFiles (filepath + "*.cws")
		psdarray = getFiles (filepath + "*.psd")
		megaarray = (bmparray + jpgarray + jpegarray + jpearray + tifarray + gifarray + tgaarray + pngarray + rpfarray + rlaarray + hdrarray + picarray + aviarray + movarray + cinarray + cwsarray + psdarray)
		sort megaarray
		oldtex = finditem megaarray currenttex
		newtex = (oldtex + 1)
		if newtex > megaarray.count then currentbmp.filename = megaarray[1]
		else
		(
		currentbmp.filename = megaarray[newtex]
		)
		if classof geoa[cbx2.selection].material==Multimaterial
		then edt4.text=filenameFromPath geoa[cbx2.selection].material[ddl1.selection].diffusemap.filename as string
		else edt4.text=filenameFromPath geoa[cbx2.selection].material.diffusemap.filename as string
		)
	on btn68 pressed do(geoa=for geo in geometry collect geo;cbx2.items=(for geo in geometry collect geo.name))
	on btn65 pressed do(if classof geoa[cbx2.selection].material==Multimaterial
						then(   
								if geoa[cbx2.selection].material[ddl1.selection]==undefined
								then geoa[cbx2.selection].material[ddl1.selection]=standardmaterial();btn2.enabled=false
								if geoa[cbx2.selection].material[ddl1.selection].diffusemap==undefined
			 			         then(   geoa[cbx2.selection].material[ddl1.selection].diffusemap=Bitmaptexture()
										f=getOpenFileName FileName:"" types:"All Files|*.*|"
										btn2.enabled=false
									)
								else(f=getOpenFileName FileName:(getFilenamePath geoa[cbx2.selection].material[ddl1.selection].diffusemap.filename) types:"All Files|*.*|";btn2.enabled=true
									)
								if f!=undefined
								then(btn66.enabled=true;btn67.enabled=true
									showTextureMap  geoa[cbx2.selection].material[ddl1.selection] on
									path1=getFilenamePath f
									geoa[cbx2.selection].material[ddl1.selection].diffusemap.filename=path1
									edt4.text=filenameFromPath geoa[cbx2.selection].material[ddl1.selection].diffusemap.filename
									btn2.enabled=true
									)
							)
						else(
								if geoa[cbx2.selection].material==undefined
								then geoa[cbx2.selection].material=standardmaterial();btn2.enabled=false
								if geoa[cbx2.selection].material.diffusemap==undefined
								then(	geoa[cbx2.selection].material.diffusemap=Bitmaptexture()
										f=getOpenFileName FileName:"" types:"All Files|*.*|"
										btn2.enabled=false
									)
								else(f=getOpenFileName FileName:(getFilenamePath geoa[cbx2.selection].material.diffusemap.filename) types:"All Files|*.*|";btn2.enabled=true
									)
								if f!=undefined
								then(btn66.enabled=true;btn67.enabled=true
									showTextureMap  geoa[cbx2.selection].material on
									path1=getFilenamePath f
									geoa[cbx2.selection].material.diffusemap.filename=path1
									edt4.text=filenameFromPath geoa[cbx2.selection].material.diffusemap.filename
									btn2.enabled=true
									)
							)
					btn2.enabled=true;btn66.enabled=true;btn67.enabled=true
					if f==undefined
					then (name1="";path1="";btn66.enabled=false;btn67.enabled=false;btn2.enabled=false
							messagebox "温馨提示：请打开文件夹内文件才能正确找到路径！" title:"温馨提示"
							)
					else (name1=filenameFromPath f
						path1=getFilenamePath f
						;btn66.enabled=true;btn67.enabled=true;btn2.enabled=true
						)
					edt4.text=name1
					if classof geoa[cbx2.selection].material==Multimaterial
					then geoa[cbx2.selection].material[ddl1.selection].diffusemap.filename=(path1+name1)
					else geoa[cbx2.selection].material.diffusemap.filename=(path1+name1)
					)
	on cbx2 selected text do (btn2.enabled=false
	 					    select geoa[cbx2.selection]
	 					    case of ((classof geoa[cbx2.selection].material==standardmaterial)\
		 							:(case of((geoa[cbx2.selection].material.diffusemap!=undefined and\ 
											  classof geoa[cbx2.selection].material.diffusemap==Bitmaptexture)\
											  :(edt4.text=filenameFromPath geoa[cbx2.selection].material.diffusemap.filename as string;btn2.enabled=true;btn66.enabled=true;btn67.enabled=true;btn65.enabled=true;ddl1.enabled=false;lbl6.enabled=false;chk1.enabled=false)
											  (geoa[cbx2.selection].material.diffusemap!=undefined and\ 
											  classof geoa[cbx2.selection].material.diffusemap!=Bitmaptexture)\
											  :(edt4.text="Texture_"+(classof geoa[cbx2.selection].material.diffusemap as string);btn2.enabled=false;btn66.enabled=false;btn67.enabled=false;btn65.enabled=false;ddl1.enabled=false;lbl6.enabled=false;chk1.enabled=false)
											  (geoa[cbx2.selection].material.diffusemap==undefined):(edt4.text="未指定贴图";btn66.enabled=false;btn67.enabled=false;btn65.enabled=true;ddl1.enabled=false;lbl6.enabled=false;chk1.enabled=false)
											  )
											)
									(geoa[cbx2.selection].material==undefined):(edt4.text="未指定材质";btn2.enabled=false;btn66.enabled=false;btn67.enabled=false;btn65.enabled=true;ddl1.enabled=false;lbl6.enabled=false;chk1.enabled=false)
									(classof geoa[cbx2.selection].material==Multimaterial):(edt4.text="多维\子对象材质";btn2.enabled=false;btn66.enabled=false;btn67.enabled=false;btn65.enabled=false;ddl1.enabled=false;ddl1.enabled=true;lbl6.enabled=true;chk1.enabled=true
									 												mcount=geoa[cbx2.selection].material.count
																		  			u=0;marray=#();for u=u+1 to mcount do(append marray (u as string)
																		  								)
																		  			ddl1.items=marray;ddl1.selection=1
																					)
									default:(edt4.text="Material_"+(classof geoa[cbx2.selection].material as string);btn2.enabled=false;btn66.enabled=false;btn67.enabled=false;btn65.enabled=false;ddl1.enabled=false;lbl6.enabled=false;chk1.enabled=false)
	 									    )
						   )
	on btn66 pressed do (
						megaarray = #()
						if classof geoa[cbx2.selection].material==Multimaterial
						then currentbmp =geoa[cbx2.selection].material[ddl1.selection].diffusemap
						else currentbmp =geoa[cbx2.selection].material.diffusemap
						currenttex = currentbmp.filename
						filepath = getFilenamePath currentbmp.filename
						bmparray = getFiles (filepath + "*.bmp")
						jpgarray = getFiles (filepath + "*.jpg")
						jpegarray = getFiles (filepath + "*.jpeg")
						jpearray = getFiles (filepath + "*.jpe")
						tifarray = getFiles (filepath + "*.tif")
						gifarray = getFiles (filepath + "*.gif")
						tgaarray = getFiles (filepath + "*.tga")
						pngarray = getFiles (filepath + "*.png")
						rpfarray = getFiles (filepath + "*.rpf")
						rlaarray = getFiles (filepath + "*.rla")
						hdrarray = getFiles (filepath + "*.hdr")
						picarray = getFiles (filepath + "*.pic")
						aviarray = getFiles (filepath + "*.avi")
						movarray = getFiles (filepath + "*.mov")
						cinarray = getFiles (filepath + "*.cin")
						cwsarray = getFiles (filepath + "*.cws")
						psdarray = getFiles (filepath + "*.psd")
						megaarray = (bmparray + jpgarray + jpegarray + jpearray + tifarray + gifarray + tgaarray + pngarray + rpfarray + rlaarray + hdrarray + picarray + aviarray + movarray + cinarray + cwsarray + psdarray)
						sort megaarray
						oldtex = finditem megaarray currenttex
						newtex = (oldtex - 1)
						if newtex < 1 then currentbmp.filename = megaarray[megaarray.count]
						else currentbmp.filename = megaarray[newtex]
						if classof geoa[cbx2.selection].material==Multimaterial
						then edt4.text=filenameFromPath geoa[cbx2.selection].material[ddl1.selection].diffusemap.filename as string
						else edt4.text=filenameFromPath geoa[cbx2.selection].material.diffusemap.filename as string
					)
	on btn67 pressed do (
						megaarray = #()
						if classof geoa[cbx2.selection].material==Multimaterial
						then currentbmp = geoa[cbx2.selection].material[ddl1.selection].diffusemap
						else currentbmp = geoa[cbx2.selection].material.diffusemap
						currenttex = currentbmp.filename
						filepath = getFilenamePath currentbmp.filename
						bmparray = getFiles (filepath + "*.bmp")
						jpgarray = getFiles (filepath + "*.jpg")
						jpegarray = getFiles (filepath + "*.jpeg")
						jpearray = getFiles (filepath + "*.jpe")
						tifarray = getFiles (filepath + "*.tif")
						gifarray = getFiles (filepath + "*.gif")
						tgaarray = getFiles (filepath + "*.tga")
						pngarray = getFiles (filepath + "*.png")
						rpfarray = getFiles (filepath + "*.rpf")
						rlaarray = getFiles (filepath + "*.rla")
						hdrarray = getFiles (filepath + "*.hdr")
						picarray = getFiles (filepath + "*.pic")
						aviarray = getFiles (filepath + "*.avi")
						movarray = getFiles (filepath + "*.mov")
						cinarray = getFiles (filepath + "*.cin")
						cwsarray = getFiles (filepath + "*.cws")
						psdarray = getFiles (filepath + "*.psd")
						megaarray = (bmparray + jpgarray + jpegarray + jpearray + tifarray + gifarray + tgaarray + pngarray + rpfarray + rlaarray + hdrarray + picarray + aviarray + movarray + cinarray + cwsarray + psdarray)
						sort megaarray
						oldtex = finditem megaarray currenttex
						newtex = (oldtex + 1)
						if newtex > megaarray.count then currentbmp.filename = megaarray[1]
						else
						(
						currentbmp.filename = megaarray[newtex]
						)
						if classof geoa[cbx2.selection].material==Multimaterial
						then edt4.text=filenameFromPath geoa[cbx2.selection].material[ddl1.selection].diffusemap.filename as string
						else edt4.text=filenameFromPath geoa[cbx2.selection].material.diffusemap.filename as string
					)
)
createdialog changetexture 
