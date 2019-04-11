-------------------------------------------------------------------------------
--   TO USE IT COPY THE FILE TO STARTUP DIRECTORY, RUN IT AND THEN ASSIGN IT TO A TOOLBAR
--   BY GOING TO CUSTOMIZE | MACRO SCRIPTS AND PICKING "Tools.BatchRender"
--   File:			BAT_REND.MS Ver3.00 		
--   Description:	A batch render utility with UI similar to the Render Scene dialog box
--   By:			Ravi Karra [Kinetix] 			ravi.karra@ktx.com
--
--	History:
--	5/4/98		Fixed a bug that throws "time type not defined" error when adding a file
--	5/5/98		Added "添加目录" button to add a whole directory of max files to the list
--	6/26/98		Added functionality for specifying viewport to render ("视口" dropdown)
--	11/06/98	Added support for renderFields and fieldOrder(odd or even).
--				Also changed the "被渲染文件" combobox to listbox
--  12/03/98	Changing it into a Macro button instead of a utility
--  12/06/98	Added progress bar display updated after each file is rendered 
--  12/06/98	Added error trapping, files with errors are added to "出错文件" dropdown
-- 	2/14/99		Added BrFloater Global
--	03/29/99	Added Help button
-------------------------------------------------------------------------------


	global brFloater -- Added brFloater Global - FD
	global brHelpFloater, dlgHelpBatRend, help_str
	rollout brParams "公用参数"
	(
		local bmp, curFile, br_error_files=#()

		-- y offsets for group controls
		local 	yTO = 25, 
				yOS = yTO + 75, 
				yOp = yOS + 100, 
				yIO = yOp + 85, 
				yC  = yIO + 285 
		
		-- An array to store the render details of all the files
		local file_data_array = #()
		
		-- An array to store the file names of all files to be rendered
		local file_name_array = #()
		
		-- A structure to represent the render details of a single file
		struct rdata (
				filename,
				camera,
	       		frame,
	       		framerange,
				fromframe,
				toframe,
				nthframe,
				timetype,
				outputwidth,
				outputheight,
				pixelaspect,
				videocolorcheck,
				renderhiddenobjects,
				superblack,
				force2sided,
				renderatmosphericeffects,
				renderfields,
				fieldorder,
				outputfile,
				outputdevice,
				vfb,
				netrender)
		
		-- A function used to modify file names containing '\' to "\\"
		fn replaceChar str oChar rChar = 
		(
			local tStr = ""
			for i=1 to str.count do
				tStr += (if str[i] == oChar then rChar else str[i])
			tStr
		)
		
		-- Checks to see if the given value is not null and undefined
		fn exists val =
		(
			if val == undefined or val == "" then 
				return false
			return true
		)
		
			
		group "时间输出:"
		(
			spinner spn_nthframe 	"每 N 帧: " pos:[260, yTO] range:[1, 99999, 1] type:#integer fieldwidth:50 enabled:false
			spinner spn_fromframe 	"" pos:[80, yTO+30] fieldwidth:50 range:[-10000, 10000, 0] type:#integer
			spinner spn_toframe 	"To " pos:[145, yTO+30] fieldwidth:50 range:[-10000, 10000, 100] type:#integer
			
			radioButtons rb_timetype columns:1  pos:[25, yTO] \
				labels:#(
					"单帧", 
					"有效时间段",
					"范围:")				 
		)
		
		group "输出大小"
		(
			spinner spn_width "宽度:  " pos:[20, yOS] range:[1, 10000, 640] type:#integer fieldwidth:65
			spinner spn_height "高度: " pos:[20, yOS+25] range:[1, 10000, 480] type:#integer fieldwidth:65
			
			button btn_320x240 "320x240" pos:[150, yOS] height:20 width:75
			button btn_256x243 "256x243" pos:[230, yOS] height:20 width:75
			button btn_512x486 "512x486" pos:[310, yOS] height:20 width:75
			button btn_640x480 "640x480" pos:[150, yOS+25] height:20 width:75
			button btn_720x486 "720x486" pos:[230, yOS+25] height:20 width:75
			button btn_800x600 "800x600" pos:[310, yOS+25] height:20 width:75
			spinner spn_pixelaspect "象素纵横比 : " pos:[260, yOS+50] range:[0.01, 10.0, 1] fieldwidth:65
		)
		
		group "选项:"
		(
			checkbox chk_videocolorcheck 	"视频颜色检查" 			pos:[20, yOp]
			checkbox chk_renderhiddenobjs 	"渲染隐藏物体" 		pos:[150, yOp]
			checkbox chk_superblack 		"超级黑" 					pos:[320, yOp]
			checkbox chk_force2sided 		"强制双面" 				pos:[20, yOp+20]
			checkbox chk_renderatmoseffects "渲染大气效果" 	pos:[150, yOp+20] checked:true
			checkbox chk_renderfields 		"渲染为场" 				pos:[320, yOp+20]
			label	 lbl_fo 				"场顺序:"					pos:[260, yOp+40] enabled:false
			radioButtons rb_fieldOrder 		"" 	labels:#("奇数场", "偶数场")		pos:[320, yOp+40] enabled:false  
		)
		
		group "输入/输出:"
		(
			editText	et_outputfile 	 	"输出文件:......."	pos:[15, yIO] fieldWidth:265
			button      btn_outputfile 	 	"文件..."		pos:[360, yIO] width:60
			editText 	et_outputdevice 	"输出设备:." 		pos:[15, yIO+20] fieldWidth:265
			--button 	btn_outputdevice  	"设备..."		pos:[360, 288]width:60
			editText	et_camera		"摄影机:............" 	pos:[15, yIO+40] fieldWidth:265
			
			checkbox chk_vfb 			"虚拟帧缓冲区" pos:[20, yIO+65] checked:on
			checkbox chk_netrender 		"网络渲染" pos:[150, yIO+65]
			checkbox chk_unDispBmp 		"关闭 VFB 之后再渲染" pos:[250, yIO+65] checked:on
			
			button btn_AddFile 			"添加" 					pos:[320, yIO+100] width:70
			button btn_AddDir			"添加文件夹"  			pos:[320, yIO+125] width:70
			button btn_RemoveFile 		"移除" 				pos:[320, yIO+150] width:70
			button btn_removeAll 		"移除全部" 			pos:[320, yIO+175] width:70
			button btn_ApplyToAll		"应用于所有" 			pos:[320, yIO+201] width:70
			button btn_Up 				"/\\"					pos:[270, yIO+100] width:25 height:25 
			button btn_Down 			"\\/" 					pos:[270, yIO+200] width:25 height:25 
			listbox lb_FileNames		"被渲染文件:" pos:[ 20, yIO+85 ] width:250 height:9 items:file_name_array
--			button btn_help				"帮助"					pos:[320, yIO+230] width:70
			dropdownlist dd_errorFiles 	"出错文件:" 			pos:[ 20, yIO+230] width:250			 
		)
		
		label	lbl_view		"视口:" pos:[10, yC+5] width:45
		dropdownlist dd_view	"" pos:[55, yC] width:65 items:#("激活视图", "后视图", "底视图", "前视图", "左视图", "透视图", "右视图", "顶视图")
		button btn_LoadPresets 	"加载预置" pos:[120, yC] width:75
		button btn_SavePresets 	"保存预置" pos:[195, yC] width:75 
		button btn_Render 		"渲染" pos:[270, yC] width:75
		button btn_Cancel 		"取消" pos:[345, yC] width:75
		label  lbl_sep1			"________________________________________________________________________" pos:[0, yC+22]
		label  lbl_About		"       www.3dheima.com  黑马设计网 " pos:[95, yC+42] 
		label  lbl_sep2			"________________________________________________________________________" pos:[0, yC+55]

		--------Common Functions:-----------------------------------------------------------
		--Gets the render details of a file from the dialog box controls
		fn GetRenderData fname =
		(
			if fname == undefined or fname == "" then return undefined
			local fdata = rdata \	
							filename:				fname \
							camera:					et_camera.text \
							outputwidth:			spn_width.value \
							outputheight:			spn_height.value \
							pixelaspect:			spn_pixelaspect.value \
							videocolorcheck:		chk_videocolorcheck.checked \
							renderhiddenobjects:	chk_renderhiddenobjs.checked \
							superblack:				chk_superblack.checked \
							force2sided:			chk_force2sided.checked \
							renderatmosphericeffects:chk_renderatmoseffects.checked \
							renderfields:			chk_renderfields.checked \
							fieldOrder:				rb_fieldOrder.state \
							outputfile:				et_outputfile.text \
							vfb:					chk_vfb.checked \
							netrender:				chk_netrender.checked
							
			fdata.timeType = rb_timeType.state
			case fdata.timeType of
			(
				1: fdata.frame = #current
				2: (
						fdata.framerange = #active
						fdata.nthframe 	 = spn_nthframe.value
					)
				3: (
						fdata.fromframe = spn_fromframe.value
						fdata.toframe 	= spn_toframe.value
						fdata.nthframe 	= spn_nthframe.value
					)	
			)
			return fdata	
		)
		
		--Sets the dialog box control values to render details of a file
		fn SetRenderData fname =
		(
			if fname == undefined or fname == "" then return undefined
			for fd in file_data_array do 
			(
				if fd.filename == fname then
				(
					et_camera.text 						= fd.camera
					spn_width.value 						= fd.outputwidth
					spn_height.value  					= fd.outputheight
					spn_pixelaspect.value 				= fd.pixelaspect
					chk_videocolorcheck.checked 			= fd.videocolorcheck
					chk_renderhiddenobjs.checked 		= fd.renderhiddenobjects
					chk_superblack.checked 				= fd.superblack
					chk_force2sided.checked 				= fd.force2sided
					chk_renderatmoseffects.checked 		= fd.renderatmosphericeffects
					chk_renderfields.checked = rb_fieldorder.enabled = lbl_fo.enabled = fd.renderfields
					rb_fieldorder.state					= fd.fieldorder
					et_outputfile.text 					= fd.outputfile
					chk_vfb.checked 						= fd.vfb
					chk_netrender.checked 				= fd.netrender
					
					rb_timeType.state = fd.timeType
					case fd.timeType of
					(
						1: spn_nthframe.enabled = false
						2: (
								spn_nthframe.enabled = true
								spn_nthframe.value 	= fd.nthframe
							)
						3: (
								spn_nthframe.enabled	= true
								spn_fromframe.value 	= fd.fromframe
								spn_toframe.value 	= fd.toframe
								spn_nthframe.value 	= fd.nthframe
							)
					)
					exit
				)
			)
		)
		
		-- Saves the render details of the current file into file_data_array
		fn SaveRenderData fname = 
		(
			if fname == undefined or fname == "" then return false
			local found = false
			local rd = GetRenderData fname
			for i =1 to file_data_array.count do 
			(
				if file_data_array[i].filename == fname then
				(
					file_data_array[i] = rd
					found = true
				)
			)
			if found == false then append file_data_array rd
		)
		
	
		-- Renders a file with the given render info
		fn RenderFile data = 
		(
			local rString = "render"
			if (exists data.camera) 	then rString += " camera:$'" 	+ data.camera + "'"
			if (exists data.frame) 		then rString += " frame:#" 		+ data.frame as string
			if (exists data.frameRange) then rString += " framerange:#" + data.frameRange
			if (exists data.fromframe) 	then rString += " fromframe:" 	+ data.fromframe as string
			if (exists data.toframe) 	then rString += " toframe:" 	+ data.toframe as string
			if (exists data.nthframe) 	then rString += " nthframe:" 	+ data.nthframe as string
			if (exists data.outputfile) then 
			(			
				rString += " outputfile:" 	+ "\""+ (replaceChar (data.outputfile as string) "\\" "\\\\") + "\""
			)
			rString += " outputwidth:" 				+ data.outputwidth as string
			rString += " outputheight:" 			+ data.outputheight as string
			rString += " pixelaspect:" 				+ data.pixelaspect as string
			rString += " videocolorcheck:" 			+ data.videocolorcheck as string
			rString += " renderhiddenobjects:" 		+ data.renderhiddenobjects as string
			rString += " superblack:" 				+ data.superblack as string
			rString += " force2sided:" 				+ data.force2sided as string
			rString += " renderatmosphericeffects:" + data.renderatmosphericeffects as string
			rString += " renderfields:" 			+ data.renderfields as string
			rString += " fieldOrder:" 				+ (if data.fieldOrder==1 then #odd else #even)as string
			rString += " vfb:" 						+ data.vfb as string	
			rString += " netrender:" 				+ data.netrender as string
			
			bmp = Execute (rString)	
		)
		
		-- Function is mainly used for reading render data from an ascii file
		-- Given a key, it's value is returned
		-- Eg: getKeyArg "videocolorcheck:false" videocolorcheck
		--		returns false 
		fn getKeyArg str key =
		(
			execStr = ""
			local i = findString str key
			if i == undefined then return undefined
			i += (key.count+1)
			while (i < str.count and str[i] != ",") do 
			(
				execStr += str[i]
				i += 1
			)
			if execStr[1] == "\"" then
			(
				execStr = (subString execStr 2 (execStr.count-2))
				return execStr  
			)
			return execute(execStr)
		)
		
		fn addFile f = 
		(
			if ((findItem file_name_array f) != 0) then
				MessageBox "项目已经存在"
			else
			(
				curFile = if lb_FileNames.selection != 0 then file_name_array[lb_FileNames.selection] else undefined
				SaveRenderData f
				append file_name_array f
				lb_FileNames.items = file_name_array
			)
		)
		
		--------Time Output:-----------------------------------------------------------
		on brParams close do rp_opened = false

		on rb_timetype changed val do
		(
			spn_nthframe.enabled = (val > 1)			
		)
		
		on spn_fromframe changed val do
		(
			rb_timetype.state = 3
			spn_nthframe.enabled = true
		)
		
		on spn_toframe changed val do
		(
			rb_timetype.state = 3
			spn_nthframe.enabled = true
		)
		--------Output Size:-----------------------------------------------------------
		on btn_320x240 pressed do (spn_width.value = 320; spn_height.value = 240)
		on btn_256x243 pressed do (spn_width.value = 256; spn_height.value = 243)
		on btn_512x486 pressed do (spn_width.value = 512; spn_height.value = 486)
		on btn_640x480 pressed do (spn_width.value = 640; spn_height.value = 480)
		on btn_720x486 pressed do (spn_width.value = 720; spn_height.value = 486)
		on btn_800x600 pressed do (spn_width.value = 800; spn_height.value = 600)

		--------Options:-----------------------------------------------------------
		on chk_renderfields changed val do rb_fieldOrder.enabled = lbl_fo.enabled = val			
		
		--------Input/Output:-----------------------------------------------------------
		on btn_outputfile pressed do
		(			
			local f = (if (SelectSaveBitMap != undefined) then SelectSaveBitMap else getSaveFileName) caption:"Render Output File"
			--selectBitmap caption:"渲染输出文件"
			if f != undefined then et_outputfile.text = f
		)
		
		on btn_outputdevice pressed do
		(
			local f = getSaveFileName caption:"渲染输出设备"
			if f != undefined then
			(
				et_outputdevice.text = f
			) 
		)
		
		on btn_AddFile pressed do
		(
			local f = getOpenFileName caption:"渲染打开文件" types:"3D Studio MAX (*.max)|*.max|"
			SaveRenderData curFile
			if f != undefined then addFile f
			curFile = if lb_FileNames.selection != 0 then file_name_array[lb_FileNames.selection] else undefined
			SetRenderData curFile
		)
		
		on btn_AddDir pressed do
		(
			local dir = getSavePath caption: "选择目录"
			if dir == undefined do return false
			SaveRenderData curFile
			for f in getFiles (dir + "\\*.max") do
			(
				addFile f 
			) 
			curFile = if lb_FileNames.selection != 0 then file_name_array[lb_FileNames.selection] else undefined
			SetRenderData curFile
		)
		
		on btn_RemoveFile pressed do
		(
			local s = lb_FileNames.selection
			if s != 0 and s <= file_name_array.count then
			(
				for f = 1 to file_data_array.count do
				(						
					if file_data_array[f].filename == file_name_array[s] then							
					(	
						if f > 1 then lb_FileNames.selection = f-1
						deleteItem file_data_array f
						exit
					) 
				)
				deleteItem file_name_array s
				lb_FileNames.items = file_name_array
			)	
			curFile = if lb_FileNames.selection != 0 then file_name_array[lb_FileNames.selection] else undefined
			SetRenderData curFile
		)
		
		on btn_RemoveAll pressed do
		(
			file_name_array = #()
			file_data_array = #()
			curFile = undefined
			lb_FileNames.items = file_name_array
		)
		
		on btn_ApplyToAll pressed do
		(
			SaveRenderData curFile
			local data = GetRenderData curFile
			for i=1 to file_data_array.count do
			(
				file_data_array[i].frame 					= data.frame
	       		file_data_array[i].framerange 				= data.framerange
				file_data_array[i].fromframe				= data.fromframe
				file_data_array[i].toframe					= data.toframe
				file_data_array[i].nthframe					= data.nthframe
				file_data_array[i].timetype					= data.timetype
				file_data_array[i].outputwidth				= data.outputwidth
				file_data_array[i].outputheight				= data.outputheight
				file_data_array[i].pixelaspect				= data.pixelaspect
				file_data_array[i].videocolorcheck			= data.videocolorcheck
				file_data_array[i].renderhiddenobjects		= data.renderhiddenobjects
				file_data_array[i].superblack				= data.superblack
				file_data_array[i].force2sided				= data.force2sided
				file_data_array[i].renderatmosphericeffects	= data.renderatmosphericeffects
				file_data_array[i].renderfields				= data.renderfields
				file_data_array[i].fieldOrder				= data.fieldOrder
			)
		)
		
		on btn_up pressed do
		(
			if lb_FileNames.selection > 1 then
			(
				SaveRenderData curFile
				lb_FileNames.selection -= 1
				curFile = file_name_array[lb_FileNames.selection]	
				SetRenderData curFile
			)	
		)
		
		on btn_down pressed do
		(
			if file_name_array.count==0 then return false
			if lb_FileNames.selection < file_name_array.count then
			(
				SaveRenderData curFile
				lb_FileNames.selection += 1
				curFile = file_name_array[lb_FileNames.selection]	
				SetRenderData curFile
			)		
		)
		
		on lb_FileNames selected val do
		(
			SaveRenderData curFile
			curFile = file_name_array[val]
			SetRenderData curFile
		) 
		
		on lb_FileNames entered val do
		(
			if val != undefined and val != "" then addFile val
		)
		---------------------------------------------------------------------------------
		on btn_LoadPresets pressed do
		(
			SaveRenderData curFile
			local n = getOpenFileName caption:"打开渲染数据" types:"批量渲染预置 (*.brp)|*.brp|"
			if n != undefined then
			(
				file_name_array = #()
				file_data_array = #()
				local f = openFile n
				while (not (eof f)) do
				(
					local data = rdata ()
					local ln = readLine f
					data.filename 					= getKeyArg ln "文件名"
					data.camera 					= getKeyArg ln "摄影机"
		       		data.frame 						= getKeyArg ln "frame"
		       		data.framerange					= getKeyArg ln "framerange"
					data.fromframe 					= getKeyArg ln "fromframe"
					data.toframe 					= getKeyArg ln "toframe"
					data.nthframe 					= getKeyArg ln "nthframe"
					data.timetype 					= getKeyArg ln "timetype"
					data.outputwidth 				= getKeyArg ln "outputwidth"
					data.outputheight 				= getKeyArg ln "outputheight"
					data.pixelaspect 				= getKeyArg ln "pixelaspect"
					data.videocolorcheck 			= getKeyArg ln "videocolorcheck"
					data.renderhiddenobjects 		= getKeyArg ln "renderhiddenobjects"
					data.superblack 				= getKeyArg ln "superblack"
					data.force2sided 				= getKeyArg ln "force2sided"
					data.renderatmosphericeffects	= getKeyArg ln "renderatmosphericeffects"
					data.renderfields 				= getKeyArg ln "renderfields"
					data.fieldorder 				= getKeyArg ln "fieldorder"
					data.outputfile 				= getKeyArg ln "outputfile"
					data.outputdevice 				= getKeyArg ln "outputdevice"
					data.vfb 						= getKeyArg ln "vfb"
					data.netrender 					= getKeyArg ln "netrender"
					
					if (data != undefined and data.filename != undefined) then
					(
						append file_data_array data
						append file_name_array data.filename
					)
				)
				close f
				lb_filenames.items = file_name_array
				if file_name_array.count > 0 then
				(
					curFile = file_name_array[1]
					SetRenderData curFile
				)
			)
		)

		on btn_SavePresets pressed do
		(
			SaveRenderData curFile
			local n = getSaveFileName caption:"保存渲染数据" types:"批量渲染预置 (*.brp)|*.brp|"
			if n != undefined then
			(
				local f = CreateFile n
				for d in file_data_array do print d to:f
				close f					
			) 
		)

		on btn_Render pressed do
		(
			SaveRenderData curFile
			progressStart "批量渲染" 
			for i=1 to file_data_array.count do 
			(					
				if (getProgressCancel()) then exit
				try
				(
					if (loadMaxFile file_data_array[i].filename) then 
					(	
						max views redraw 
						case dd_view.items[dd_view.selection] of
						(
							"后视图": max vpt back
							"底视图": max vpt bottom
							"前视图": max vpt front
							"左视图": max vpt left
							"透视图": vpt persp user
							"右视图": max vpt Right
							"顶视图": max vpt Top														
						)
						RenderFile file_data_array[i]
						if chk_unDispBmp.checked then 
						(
							unDisplay bmp
							close bmp
						)
					)
				)
				catch
				(
					append br_error_files file_data_array[i].filename	
				)
				progressUpdate ((i*100)/file_data_array.count)
			)
			progressEnd()
			dd_errorFiles.items = br_error_files
		)
		
		on btn_Cancel pressed do
		(
			SaveRenderData curFile
			if brFloater == undefined then return false
			rp_opened = false			
			closeRolloutFloater brFloater
		)			
		
		on btn_help pressed do
		(
			--if brHelpFloater != undefined then return false
			local help_file = (getDir #scripts) + "\\macroscripts\\bat_rend_help.txt" 
			local hf = openFile help_file
			if hf == undefined then 
			(
				MessageBox (help_file + " file no found")
				return false
			)
			help_str = "rollout dlgHelpBatRend \"批量渲染帮助\" \n(\n"
			local i=1
			while (not eof hf) do
			(
				help_str += ("\n label lbl" + (i as string) + " \"")
				help_str += replaceChar (readLine hf) "\"" "\\\""
				help_str += "\" align:#left \n"
				i+=1
			)
			help_str += ")\n"			 
			close hf
			execute help_str
			if dlgHelpBatRend != undefined then 
			(
				brHelpFloater = newRolloutFloater "批量渲染帮助" 500 600 200 80
				addRollout dlgHelpBatRend brHelpFloater
			)
		)
	)
		
	fn open_floater = 
	(
		if rp_opened == undefined then rp_opened = false
		if rp_opened then return false
		If brFloater != undefined then CloseRolloutFloater brFloater
		brFloater = newRolloutFloater "黑马设计网多文件批量渲染 - 支持2014" 460 655 200 80			
		addRollout brParams brFloater		
		rp_opened = true
	)
	open_floater()	

