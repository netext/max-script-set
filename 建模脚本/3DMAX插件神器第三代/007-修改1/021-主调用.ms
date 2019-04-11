	--设置全局变量
		global absystemcjnb
		global spInifilepath=getdir #scripts+"\\abroot.ini"
		try AddRollout absystemcjnb absystemrollout catch ()
		ROLLheigh=(systemTools.GetScreenHeight())/9*7
	
	--检查配置文件是否存在，若存在则写入数据A。若不存在则创建配置文件并写入数据B
 if (getfiles (spInifilepath)).count >=1 
	then
(
	SetINISetting spInifilepath "GlobalSet"  "Dock" "#cui_dock_left"
	SetINISetting spInifilepath "MatToolSet" "UseProjectMatLib" "True"
)

	else 
(   createfile (getdir #scripts+"\\abroot.ini")
	SetINISetting spInifilepath "Main" "PerTitOpen" "1"
	SetINISetting spInifilepath "Main" "PerTitle" "111111"
	SetINISetting spInifilepath "GlobalSet"  "Dock" "#cui_dock_left"
	SetINISetting spInifilepath "MatToolSet" "UseProjectMatLib" "True"
)
rollout ab_zdkz "轴点控制" width:120 height:268
(
		button SetPivotToCenter "轴点置中" pos:[3,7] width:110 height:20
		button ResetPivotAndTransform "置中重置Trans" pos:[3,106] width:110 height:24
		button AxisMax "轴向最大" pos:[3,52] width:110 height:20
		button AxisMin "轴向最小" pos:[3,29] width:110 height:20
		button XAxisMin "X" pos:[17,135] width:25 height:20
		button YAxisMin "Y" pos:[47,135] width:25 height:20
		button ZAxisMin "Z" pos:[77,135] width:25 height:20
		button XAxisMax "X" pos:[17,160] width:25 height:20
		button YAxisMax "Y" pos:[47,160] width:25 height:20
		button ZAxisMax "Z" pos:[77,160] width:25 height:20
		button ResetTransformTool "重置TransForm" pos:[3,80] width:110 height:24
		button ResetXformTool "重置XForm" pos:[3,185] width:110 height:24
		
		button btn13 "关掉这个卷展栏" pos:[3,220] width:110 height:20 
		button btn14 "浮动这个卷展栏" pos:[3,244] width:110 height:20
		on SetPivotToCenter pressed do
			for i in Selection do CenterPivot i
		on ResetPivotAndTransform pressed do
		(
			for i in Selection do
				(
					CenterPivot i
					ResetTransform i
				)
		)
		on AxisMax pressed do
			for i in selection do i.Pivot = i.Max
		on AxisMin pressed do
			for i in selection do i.pivot = i.Min
		on XAxisMin pressed do
			for i in selection do i.Pivot.X = i.Min.X
		on YAxisMin pressed do
			for i in selection do i.Pivot.Y = i.Min.Y
		on ZAxisMin pressed do
			for i in selection do i.Pivot.Z = i.Min.Z
		on XAxisMax pressed do
			for i in selection do i.Pivot.X = i.Max.X
		on YAxisMax pressed do
			for i in selection do i.Pivot.Y = i.Max.Y
		on ZAxisMax pressed do
			for i in selection do i.Pivot.Z = i.Max.Z
		on ResetTransformTool pressed do
			for i in Selection do ResetTransform i
		on ResetXformTool pressed do
		(
			for i in Selection do (ResetXForm i)
		)
			on btn13 pressed do
		(
		removerollout ab_zdkz
		)
			on btn14 pressed do
		(
		removerollout ab_zdkz
		createdialog ab_zdkz 120 215
		)
)
	
rollout ab_ksdq "快速对齐" width:120 height:252
(
	GroupBox GroupBoxAlignCenter "对齐中心" pos:[3,7] width:111 height:59
	button QuickAlignX "X" pos:[8,24] width:30 height:15
	button QuickAlignY "Y" pos:[44,24] width:30 height:15
	button QuickAlignZ "Z" pos:[79,25] width:30 height:15
	button QuickAlignXY "XY" pos:[8,44] width:30 height:15
	button QuickAlignYZ "YZ" pos:[79,43] width:30 height:15
	button QuickAlignXZ "XZ" pos:[44,43] width:30 height:15
	GroupBox GroupBoxTargetAlign "对齐目标" pos:[3,70] width:111 height:59
	pickbutton QuickTargetAlignX "X" pos:[8,90] width:30 height:15
	pickbutton QuickTargetAlignY "Y" pos:[44,90] width:30 height:15
	pickbutton QuickTargetAlignZ "Z" pos:[78,87] width:30 height:15
	pickbutton QuickTargetAlignXY "XY" pos:[8,108] width:30 height:15
	pickbutton QuickTargetAlignXZ "XZ" pos:[44,109] width:30 height:15
	pickbutton QUickTargetAlignYZ "YZ" pos:[78,109] width:30 height:15
	GroupBox GroupBoxDistribute "平均分布" pos:[3,133] width:109 height:64
	button DistributeX "X" pos:[8,148] width:30 height:20
	button DistributeY "Y" pos:[44,148] width:30 height:20
	button DistributeZ "Z" pos:[78,148] width:30 height:20
	button DistributeXYZ "XYZ" pos:[8,171] width:100 height:20
	button btn17 "关掉这个卷展栏" pos:[5,208] width:110 height:18
	button btn18 "浮动这个卷展栏" pos:[5,230] width:110 height:18
		
		fn QuickAlignAxisX Target =
		(
			TempCenter = Target.Center
			for i in Selection do I.Pos.X= TempCenter.X
		)	
		
		fn QuickAlignAxisY Target =
		(
			TempCenter = Target.Center
			for i in Selection do I.Pos.Y= TempCenter.Y
		)	
		
		fn QuickAlignAxisZ Target =
		(
			TempCenter = Target.Center
			for i in Selection do I.Pos.Z= TempCenter.Z
		)
		
		fn QuickDistributeX =
		(
			TempArray = getCurrentSelection()
			MinLength = Amin(for i in selection  collect i.pos.X )
			MaxLength = Amax(for i in selection  collect i.pos.X )
			TheDistance = (MaxLength - MinLength)/(Selection.Count-1)
			local MaxPos
			while TempArray.Count != 0 do 
			(
			TempMinLength = Amin(for i in TempArray collect i.pos.X )
			TempMaxLength = Amax(for i in TempArray collect i.pos.X )
			for i in TempArray do (if I.pos.x == TempMaxLength do  MaxPos = I)
			MaxPos.pos.x = MaxLength - (TheDistance * (Selection.count - TempArray.Count))
			MaxPosXobjNum = findItem TempArray MaxPos
			deleteItem TempArray MaxPosXobjNum
			)
		)
	
		fn QuickDistributeY =
		(
			TempArray = getCurrentSelection()
			MinLength = Amin(for i in selection  collect i.pos.y)
			MaxLength = Amax(for i in selection  collect i.pos.y)
			TheDistance = (MaxLength - MinLength)/(Selection.Count-1)
			local MaxPos
			while TempArray.Count != 0 do 
			(
			TempMinLength = Amin(for i in TempArray collect i.pos.y)
			TempMaxLength = Amax(for i in TempArray collect i.pos.y)
			for i in TempArray do (if I.pos.y == TempMaxLength do MaxPos = I)
			MaxPos.pos.y = MaxLength - (TheDistance * (Selection.count - TempArray.Count))
			MaxPosYobjNum = findItem TempArray MaxPos
			deleteItem TempArray MaxPosYobjNum
			)
		)
	
		fn QuickDistributeZ =
		(
			TempArray = getCurrentSelection()
			MinLength = Amin(for i in selection  collect i.pos.z)
			MaxLength = Amax(for i in selection  collect i.pos.z)
			TheDistance = (MaxLength - MinLength)/(Selection.Count-1)
			local MaxPos
			while TempArray.Count != 0 do 
			(
			TempMinLength = Amin(for i in TempArray collect i.pos.z)
			TempMaxLength = Amax(for i in TempArray collect i.pos.z)
			for i in TempArray do (if I.pos.z == TempMaxLength do MaxPos = I)
			MaxPos.pos.z = MaxLength - (TheDistance * (Selection.count - TempArray.Count))
			MaxPosZobjNum = findItem TempArray MaxPos
			deleteItem TempArray MaxPosZobjNum
			)
		)
		
	on QuickAlignX pressed do
	(
	QuickAlignAxisX Selection
	)
	on QuickAlignY pressed do
	(
	QuickAlignAxisY Selection
	)
	on QuickAlignZ pressed do
	(
	QuickAlignAxisZ Selection
	)
	on QuickAlignXY pressed do
	(
	QuickAlignAxisX Selection
	QuickAlignAxisY Selection
	)
	on QuickAlignYZ pressed do
	(
	QuickAlignAxisY Selection
	QuickAlignAxisZ Selection
	)
	on QuickAlignXZ pressed do
	(
	QuickAlignAxisX Selection
	QuickAlignAxisZ Selection
	)
	on QuickTargetAlignX picked obj do
	(
	QuickAlignAxisX QuickTargetAlignX.Object
	)
	on QuickTargetAlignY picked obj do
	(
	QuickAlignAxisY QuickTargetAlignY.Object
	)
	on QuickTargetAlignZ picked obj do
	(
	QuickAlignAxisZ QuickTargetAlignZ.Object
	)
	on QuickTargetAlignXY picked obj do
	(
	QuickAlignAxisX QuickTargetAlignX.Object
	QuickAlignAxisY QuickTargetAlignY.Object
	)
	on QuickTargetAlignXZ picked obj do
	(
	QuickAlignAxisX QuickTargetAlignX.Object
	QuickAlignAxisZ QuickTargetAlignZ.Object
	)
	on QUickTargetAlignYZ picked obj do
	(
	QuickAlignAxisY QuickTargetAlignY.Object
	QuickAlignAxisZ QuickTargetAlignZ.Object
	)
	on DistributeX pressed do
	(
	QuickDistributeX()
	)
	on DistributeY pressed do
	(
	QuickDistributeY()
	)
	on DistributeZ pressed do
	(
	QuickDistributeZ()
	)
	on DistributeXYZ pressed do
	(
	QuickDistributeX()
	QuickDistributeY()
	QuickDistributeZ()
	)
	on btn17 pressed  do
		(removerollout ab_ksdq)
	on btn18 pressed  do
	(removerollout ab_ksdq
	   createdialog ab_ksdq 120 200)
)

rollout zlwlnc "整理物理内存" width:120 height:75
(
	button bmpdel "场景贴图内存" pos:[3,5] width:110 height:20
	button savdel "撤消保存历史" pos:[3,28] width:110 height:20
	button ovnc "关掉这个卷展栏" pos:[3,54] width:110 height:18
	on bmpdel pressed do
		(
			freeSceneBitmaps()
			)
	on savdel pressed do
		(
			clearUndoBuffer()
			)
	on ovnc pressed do
		(
			removeRollout zlwlnc
			)
)

rollout absystemcjnb "个性化Max" width:120 height:284
(
	GroupBox grp1 "个性化标题栏" pos:[4,3] width:110 height:149
	checkbox isOpen "启用" pos:[14,24] width:74 height:16 enabled:true checked:false
	checkbox filen "文件名" pos:[14,46] width:65 height:20
	checkbox filep "文件路径" pos:[14,95] width:74 height:18
	checkbox size "文件大小" pos:[14,80] width:75 height:16
	checkbox creDate "文件创建时间" pos:[14,111] width:93 height:20
	checkbox modDate "最后修改时间" pos:[14,128] width:93 height:18
	checkbox ver "Max版本" pos:[14,63] width:71 height:18
	GroupBox grp_display "显示/隐藏" pos:[4,155] width:110 height:95
	checkbox chk_slider "滑动条" pos:[14,179] width:90 height:18
	checkbox chk_frame "动画帧" pos:[14,194] width:90 height:21
	checkbox chk_status "状态栏" pos:[14,213] width:90 height:18
	checkbox chk_modify "修改面板" pos:[14,230] width:90 height:17
	button btn25 "关掉这个卷展览" pos:[5,256] width:110 height:18
	local cont=#(filen,filep,size,creDate,modDate,ver)
	local tit=""
	--获取MAX版本
	fn getVer =
	(	v=(maxversion())[1]/1000
		if v<=9 then return v
		else return (2008+v-10)
	)
	--设置标题
	fn getStr n =
	(	filename= maxfilename
		filepath=maxfilepath		
	    file=filepath+filename
		if not doesfileexist file then 
		(
			filename="无标题"
			filepath= (getdir #Scene)
			)
		case n of
		(	1 : filename
			2 : filepath
			3 : (	thestr="大小:"
					fs=getFileSize file
					ss=fs/1024
					if ss < 1024 then thestr+=ss as string + " KB"
					else thestr+=(fs/1048576) as string + " MB"
					thestr
					)
			4 : ( 	s01="创建:"
					if not doesfileexist file then s01+="未创建" else s01+=getFileCreateDate file
					s01
					)
			5 : (	s01="修改:"
					if not doesfileexist file then s01+="未修改" else s01+=getFileModDate file
					s01
					)
			6 : "3ds Max "+(getVer()) as string
			default : ""
			)
	)
	fn setTitle content:"" =
	(	str=""
		idx=findstring content "1"
		if idx!=undefined then 
		(	str+=getStr idx
			for t in idx+1 to 6 where content[t]!=undefined and content[t]!="0" do str+="  -  " + getStr t
			)
		if str.count==0 then str="MAX超级奶爸"
		cui.setAppTitle str
	)
	--定制标题栏
	fn setTheTitle =
	(	tit=getinisetting spInifilepath "Main" "PerTitle"
		absystemcjnb.setTitle content:tit
	)
	--开关
	fn switchTitle state:false =
	(	callbacks.removeScripts id:#setThePersTitle
		if state then
		(	tit=getinisetting spInifilepath "Main" "PerTitle"
			absystemcjnb.setTitle content:tit
			callbacks.addScript #filePostOpen "absystemcjnb.setTheTitle()" id:#setThePersTitle
			callbacks.addScript #filePostSave "absystemcjnb.setTheTitle()" id:#setThePersTitle
			callbacks.addScript #systemPostReset "absystemcjnb.setTheTitle()" id:#setThePersTitle
			callbacks.addScript #systemPostNew "absystemcjnb.setTheTitle()" id:#setThePersTitle
		)
		else ()
	)
	--配置文件路径
	fn getINIpath = 
	(	
		thepath = getFilenamePath (getmaxinifile())+"defaults\\*"
		dirs = getDirectories thepath
		for d in dirs do
		(	
			file=d+"\\CurrentDefaults.ini"
			if doesfileexist file then return file 
			else (
				dirs01 = getDirectories (d+"*")
				for d01 in dirs01 do (
					file01 = d01+"\\CurrentDefaults.ini"
					if doesfileexist file then return file01
				)--end for
			)--end else
		)--end for
		""
	)

	on absystemcjnb open do
	(	
		if timeSlider.isVisible() then chk_slider.checked = true else chk_slider.checked = false
		if trackbar.visible then chk_frame.checked = true else chk_frame.checked = false
		if statusPanel.visible then chk_status.checked = true else chk_status.checked = false
		if cui.commandPanelOpen then chk_modify.checked = true else chk_modify.checked = false
		
		tit=getinisetting spInifilepath "Main" "PerTitle"
		for t in 1 to 6 do if tit[t]=="0" then cont[t].checked=false else cont[t].checked=true
		st=getinisetting spInifilepath "Main" "PerTitOpen"
		if st=="1" then isOpen.checked=true
		else (isOpen.checked=false;for i in cont do i.enabled=false)
		thever=maxversion()
		
	)
	on isOpen changed st do
	(	if st then
		(	setTheTitle()
			for i in cont do i.enabled=true
			setinisetting spInifilepath "Main" "PerTitOpen" "1"
		)
		else (
			for i in cont do i.enabled=false
			setinisetting spInifilepath "Main" "PerTitOpen" "0"
		)
		switchTitle state:st
	)
	on filen changed state do
	(	if state then tit[1]="1"
		else tit[1]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on filep changed state do
	(	if state then tit[2]="1"
		else tit[2]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on size changed state do
	(	if state then tit[3]="1"
		else tit[3]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on creDate changed state do
	(	if state then tit[4]="1"
		else tit[4]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on modDate changed state do
	(	if state then tit[5]="1"
		else tit[5]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on ver changed state do
	(	if state then tit[6]="1"
		else tit[6]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on chk_slider changed state do
	(
		if state then timeSlider.setVisible true else timeSlider.setVisible false
	)
	on chk_frame changed state do
	(
	 	if state then trackbar.visible = true else trackbar.visible = false
	)
	on chk_status changed state do
	(
		if state then statusPanel.visible = true else statusPanel.visible = false
	)
	on chk_modify changed state do
	(
		if state then cui.commandPanelOpen = true else cui.commandPanelOpen = false
	)
	on btn25 pressed do
		removeRollout absystemcjnb
)

rollout killmod "模型优化" width:120 height:300
(
	button btn37 "无用粒子模型" pos:[3,117] width:109 height:18
	button btn38 "动画曲线编辑器" pos:[3,18] width:109 height:18
	GroupBox grp19 "清除记录" pos:[2,2] width:115 height:90
	button btn39 "控制器视图历史" pos:[3,39] width:109 height:18
	GroupBox grp20 "清除无用模型" pos:[2,99] width:115 height:63
	button btn40 "塌陷" pos:[3,193] width:50 height:20
	button btn41 "塌陷" pos:[63,193] width:50 height:20
	GroupBox grp21 "优化选项" pos:[2,176] width:115 height:52
	button btn9 "关闭这个卷展览" pos:[3,257] width:110 height:16
	button btn10 "浮动这个卷展览" pos:[3,275] width:110 height:16
	on killmod Close do
		(AddRollout killmod absystemrollout )
	on btn37 pressed do
		(delete $'particle view*')
	on btn38 pressed do
		(t=trackviewnodes;n=t[#Max_MotionClip_Manager];deleteTrackViewController t n.controller)
	on btn40 pressed do
	(
		
		)
	on btn9 pressed do
		(removerollout killmod)
	on btn10 pressed do
	(removerollout killmod
	createdialog killmod width:120 height:254)
)

rollout ab_system_About "关于" width:120 height:52
(
	button ButtonAbout "关于MAX超级奶爸" pos:[3,5] width:110 height:20
	button btn2 "关掉这个卷展栏" pos:[3,28] width:110 height:20
	on ButtonAbout pressed do
	(
		messageBox "BY:3d狼设计网 联系QQ：363613301："  beep:off
	)
	on btn2 pressed do
	(
		removerollout ab_system_About
	)
)

rollout ab_sdgj "锁定工具" width:120 height:432
(
			button LockScale "锁定缩放" pos:[3,140] width:70 height:16
			button LockMove "锁定移动" pos:[3,23] width:70 height:16 enabled:true
			button LockRotate "锁定旋转" pos:[3,81] width:70 height:16
			button UndoLockMove "解除锁定" pos:[3,59] width:70 height:16
			button LockMoveX "X" pos:[3,41] width:20 height:16
			button LockMoveY "Y" pos:[28,41] width:20 height:16
			button LockMoveZ "Z" pos:[53,41] width:20 height:16
			button LockRotateX "X" pos:[3,99] width:20 height:16
			button LockRotateY "Y" pos:[28,99] width:20 height:16
			button LockRotateZ "Z" pos:[53,99] width:20 height:16
			button UndoLockRotate "解除锁定" pos:[3,118] width:70 height:16
			button LockAll "锁定" pos:[78,77] width:35 height:56
			button LockScaleX "X" pos:[3,158] width:20 height:16
			button LockScaleY "Y" pos:[28,158] width:20 height:16
			button LockScaleZ "Z" pos:[53,158] width:20 height:16
			button UndoLockScale "解除锁定" pos:[3,176] width:70 height:16
			button UndoLockAll "解锁" pos:[78,136] width:35 height:56
			button CancelInheritScale "取消继承" pos:[3,371] width:70 height:16
			button CancelInheritMove "取消继承" pos:[3,254] width:70 height:16
			button CancelInheritRotate "取消继承" pos:[3,312] width:70 height:16
			button InheritMove "继承移动" pos:[3,218] width:70 height:16
			button CancelInheritMoveX "X" pos:[3,236] width:20 height:16
			button CancelInheritMoveY "Y" pos:[28,236] width:20 height:16
			button CancelInheritMoveZ "Z" pos:[53,236] width:20 height:16
			button CancelInheritRotateX "X" pos:[3,294] width:20 height:16
			button CancelInheritRotateY "Y" pos:[28,294] width:20 height:16
			button CancelInheritRotateZ "Z" pos:[53,294] width:20 height:16
			button InheritRotate "继承旋转" pos:[3,276] width:70 height:16
			button CancelInherit "取消" pos:[78,272] width:35 height:56
			button CancelInheritScaleX "X" pos:[3,353] width:20 height:16
			button CancelInheritScaleY "Y" pos:[28,353] width:20 height:16
			button CancelInheritScaleZ "Z" pos:[53,353] width:20 height:16
			button InheritScale "继承缩放" pos:[3,335] width:70 height:16
			button InheritTransform "继承" pos:[78,331] width:35 height:56 enabled:true
			label lbl3 "操作全部" pos:[83,49] width:26 height:27
			GroupBox grp1 "" pos:[1,14] width:74 height:63
			GroupBox grp2 "" pos:[1,73] width:74 height:63
			GroupBox grp3 "" pos:[1,131] width:74 height:63
			button btn253 "简介" pos:[78,20] width:35 height:24 enabled:true
			GroupBox grp4 "" pos:[76,40] width:39 height:154
			label lbl4 "操作全部" pos:[83,242] width:26 height:27
			button btn254 "简介" pos:[78,215] width:35 height:24 enabled:true
			GroupBox grp5 "" pos:[1,209] width:74 height:63
			GroupBox grp6 "" pos:[1,267] width:74 height:63
			GroupBox grp7 "" pos:[1,326] width:74 height:63
			GroupBox grp8 "" pos:[76,235] width:39 height:154
			label lbl5 "模型空间M.R.S控制" pos:[8,3] width:107 height:16
			label lbl6 "模型继承M.R.S控制" pos:[7,197] width:105 height:16
			button btn255 "关闭这个卷展栏" pos:[3,393] width:110 height:16
			button btn256 "浮动这个卷展栏" pos:[3,411] width:110 height:16
			on LockScale pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) + #{7,8,9})
			on LockMove pressed do
				for i in selection do SetTransformLockFlags i (#{1,2,3}+(GetTransformLockFlags i ))
			on LockRotate pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) + #{4,5,6})
			on UndoLockMove pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) - #{1,2,3})
			on LockMoveX pressed do
				for i in selection do SetTransformLockFlags i (#{1}+(GetTransformLockFlags i ))
			on LockMoveY pressed do
				for i in selection do SetTransformLockFlags i (#{2}+(GetTransformLockFlags i ))
			on LockMoveZ pressed do
				for i in selection do SetTransformLockFlags i (#{3}+(GetTransformLockFlags i ))
			on LockRotateX pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) + #{4})
			on LockRotateY pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) + #{5})
			on LockRotateZ pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) + #{6})
			on UndoLockRotate pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) - #{4,5,6})
			on LockAll pressed do
				SetTransformLockFlags selection #All
			on LockScaleX pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) + #{7})
			on LockScaleY pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) + #{8})
			on LockScaleZ pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) + #{9})
			on UndoLockScale pressed do
				for i in selection do SetTransformLockFlags i ((GetTransformLockFlags i ) - #{7,8,9})
			on UndoLockAll pressed do
				SetTransformLockFlags selection #None
			on CancelInheritScale pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{7,8,9})
			on CancelInheritMove pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{1,2,3})
			on CancelInheritRotate pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{4,5,6})
			on InheritMove pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) + #{1,2,3})
			on CancelInheritMoveX pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{1})
			on CancelInheritMoveY pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{2})
			on CancelInheritMoveZ pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{3})
			on CancelInheritRotateX pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{4})
			on CancelInheritRotateY pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{5})
			on CancelInheritRotateZ pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{6})
			on InheritRotate pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) + #{4,5,6})
			on CancelInherit pressed do
				SetInheritanceFlags Selection #None
			on CancelInheritScaleX pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{7})
			on CancelInheritScaleY pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{8})
			on CancelInheritScaleZ pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) - #{9})
			on InheritScale pressed do
				for i in Selection do SetInheritanceFlags i ((GetInheritanceFlags i) + #{7,8,9})
			on InheritTransform pressed do
				SetInheritanceFlags Selection #All
			on btn253 pressed do
				messagebox "可以控制模型的移动、旋转、缩放。"
			on btn254 pressed do
				messagebox "可以控制模型链接继承（主工具栏左上角链子图标那个）的移动、旋转、缩放。"
			on btn255 pressed do
				(
					removerollout ab_sdgj
						)
			on btn256 pressed  do
				(
					removerollout ab_sdgj
					createdialog ab_sdgj 120 392
					)
)
		
rollout ab_MaterialTools "材质工具" width:120 height:333
(
	button ResetMedit "重置材质编辑器" pos:[3,71] width:110 height:24
	button ScMatToEMat "场景材质->编辑器" pos:[3,6] width:110 height:18
	spinner ScMatPN "" pos:[3,26] width:110 height:16 range:[1,999999,1] type:#integer
	button ScMatPDown ">" pos:[68,47] width:45 height:18
	button ScMatPUP "<" pos:[3,47] width:45 height:18
	button RestScMat "整理场景材质" pos:[3,102] width:110 height:18
	dropdownList MatLList "    材质库文件列表" pos:[4,125] width:110 height:41
	button MatLPath "选择材质库目录" pos:[3,171] width:110 height:18
	button LibEdit "材质库->编辑器" pos:[3,196] width:110 height:18
	spinner MatLPN "" pos:[3,218] width:110 height:16 range:[1,999999,1] type:#integer
	button MatLibListUpDate "刷新库列表" pos:[3,261] width:110 height:20
	button MatLibPUp ">" pos:[68,238] width:45 height:20
	button MatLibPDown "<" pos:[3,238] width:45 height:20
	button btn107 "关掉这个卷展览" pos:[3,289] width:110 height:16
	
	
	local MatEP = 1
	local ScMatResidual = (mod SceneMaterials.count  meditMaterials.Count ) as Integer
	local ScMatToMatEPMax = SceneMaterials.count / meditMaterials.Count
	
	fn MatEPUpDate =
	(
		ScMatResidual = (mod SceneMaterials.count  meditMaterials.Count ) as Integer
		ScMatToMatEPMax = SceneMaterials.count / meditMaterials.Count
		if MatEP <= ScMatToMatEPMax then
			(
			for i=1 to MeditMaterials.Count do MeditMaterials[i] = SceneMaterials[(MatEP-1)*MeditMaterials.Count+I]
			)
		else
			(
			for i=ScMatResidual to MeditMaterials.count  do 
			(
			MeditMaterials[i] = StandardMaterial ()
			if i < 10  then MeditMaterials[i].Name = "0" +(i as string) +  " - Default" else MeditMaterials[i].Name = (i as string) +  " - Default" 
			)
			
			for i=1 to ScMatResidual do meditMaterials[i] = SceneMaterials[ScMatToMatEPMax*MeditMaterials.Count + i ]
			)
	)
	
	local MatLibEP = 1
	local MatLibResidual = (mod currentMaterialLibrary.count  meditMaterials.Count ) as Integer
	local MatLibToMatEPMax = currentMaterialLibrary.count / meditMaterials.Count
	local MatLibPath
	
	fn MatLibEPUpDate =
	(
		MatLibResidual = (mod currentMaterialLibrary.count  meditMaterials.Count ) as Integer
		MatLibToMatEPMax = currentMaterialLibrary.count / meditMaterials.Count
		if MatLibEP <= MatLibToMatEPMax then
			(
			for i=1 to MeditMaterials.Count do MeditMaterials[i] = currentMaterialLibrary[(MatLibEP-1)*MeditMaterials.Count+I]
			)
		else
			(
			for i=MatLibResidual to MeditMaterials.count  do 
			(
			MeditMaterials[i] = StandardMaterial ()
			if i < 10  then MeditMaterials[i].Name = "0" +(i as string) +  " - Default" else MeditMaterials[i].Name = (i as string) +  " - Default" 
			)
			
			for i=1 to MatLibResidual do meditMaterials[i] = currentMaterialLibrary[MatLibToMatEPMax*MeditMaterials.Count + i ]
			)
	)
	

	 
	 
	button btn108 "浮动这个卷展览" pos:[3,309] width:110 height:16
	on ResetMedit pressed do
	(
			for i=1 to MeditMaterials.count do 
			(
			MeditMaterials[i] = StandardMaterial ()
			if i < 10  then MeditMaterials[i].Name = "0" +(i as string) +  " - Default" else MeditMaterials[i].Name = (i as string) +  " - Default" 
			)
	)
	on ScMatToEMat pressed do
	(
		MatEP = ScMatPN.value
		try (MatEPUpDate()) catch()
	)
	on ScMatPN changed val do
	(
		ScMatToMatEPMax = SceneMaterials.count / meditMaterials.Count
		
		if val <= (ScMatToMatEPMax+1)  then 
		(
		MatEP = val
		)
		else
		(
		MatEP = ScMatToMatEPMax+1
		ScMatPN.value = ScMatToMatEPMax+1
		)
		
		try (MatEPUpDate()) catch()
	)
	on ScMatPDown pressed do
	(
		MatEP += 1
		if MatEP > (ScMatToMatEPMax+1) then  MatEP = (ScMatToMatEPMax+1)
		ScMatPN.value = MatEP 
		try (MatEPUpDate()) catch()
	)
	on ScMatPUP pressed do
	(
		MatEP -= 1
		if MatEP <1 then  MatEP = 1
		ScMatPN.value = MatEP 
		try (MatEPUpDate()) catch()
	)
	on RestScMat pressed do
	(
		TempMatArray = #()
		for i in Objects do	( if i.Material != undefined do ( if   (FindItem TempMatArray i.Material) == 0   do append  TempMatArray i.material ))
		while  SceneMaterials.count > 0 do ( deleteItem  SceneMaterials 1)	
		for i in TempMatArray do append SceneMaterials i
	)
	on MatLList selected i do
	(
		loadMaterialLibrary (MatLibPath+ "\\" + MatLList.items[i])
	)
	on MatLPath pressed do
	(
		TempMatLibPath = GetSavePath()
		if TempMatLibPath != undefined do MatLibPath = TempMatLibPath
		MatLibArray = GetFiles (MatLibPath + "\*.mat")
		MatLibNameArray = MatLibArray
		for i=1 to  MatLibNameArray.count do MatLibNameArray[i] = FileNameFromPath MatLibNameArray[i]
		MatLList.items  = MatLibNameArray
	)
	on LibEdit pressed do
	(
		loadMaterialLibrary (MatLibPath+ "\\" + MatLList.items[MatLList.Selection])
		MatLibEP = MatLPN.value
		MatLibEPUpDate()
	)
	on MatLPN changed val do
	(
		loadMaterialLibrary (MatLibPath+ "\\" + MatLList.items[MatLList.Selection])
		MatLibToMatEPMax = currentMaterialLibrary.count / meditMaterials.Count
		
		if val <= (MatLibToMatEPMax+1)  then 
		(
		MatLibEP = val
		)
		else
		(
		MatLibEP = MatLibToMatEPMax+1
		MatLPN.value = MatLibToMatEPMax+1
		)
		
		try (MatLibEPUpDate()) catch()
	)
	on MatLibListUpDate pressed do
	(
		MatLibArray = GetFiles (MatLibPath + "\*.mat")
		MatLibNameArray = MatLibArray
		for i=1 to  MatLibNameArray.count do MatLibNameArray[i] = FileNameFromPath MatLibNameArray[i]
		MatLList.items  = MatLibNameArray
	)
	on MatLibPUp pressed do
	(
		MatLibEP += 1
		loadMaterialLibrary (MatLibPath+ "\\" + MatLList.items[MatLList.Selection])
		if MatLibEP <1 then  MatLibEP = 1
		MatLPN.value = MatLibEP 
		try (MatLibEPUpDate()) catch()
	)
	on MatLibPDown pressed do
	(
		MatLibEP -= 1
		loadMaterialLibrary (MatLibPath+ "\\" + MatLList.items[MatLList.Selection])
		if MatLibEP > (MatLibToMatEPMax+1) then  MatLibEP = (MatLibToMatEPMax+1)
		MatLPN.value = MatLibEP 
		try (MatLibEPUpDate()) catch()
	)
	on btn107 pressed do
		(removerollout ab_MaterialTools)
	on btn108 pressed do
	(removerollout ab_MaterialTools
	createdialog ab_MaterialTools 120 288)
)

rollout ab_system "系统" width:130 height:228
(
	checkbutton dockleft "浮动/停靠" pos:[3,5] width:110 height:24
	button btn4 "重启MAX" pos:[3,62] width:53 height:20	
	button btn5 "重置MAX" pos:[60,62] width:53 height:20		
	button btn11 "个性化MAX" pos:[3,86] width:110 height:16
	button btn14 "优化场景" pos:[3,104] width:110 height:16
	button btn7 "优化内存" pos:[3,122] width:110 height:16		
	button btn6 "锁定工具" pos:[3,140] width:110 height:16
	button ab_zdgj "轴点控制" pos:[3,158] width:110 height:16
	button btn8 "快速对齐" pos:[3,176] width:110 height:16
	button btn9 "材质工具" pos:[3,194] width:110 height:16
	button btn10 "全部关闭" pos:[3,33] width:110 height:24 toolTip:"可用于卷展览错误时的重置"

	on ab_system open do
	(
		if (GetINISetting spInifilepath "GlobalSet"  "Dock") == "#cui_dock_left" then  
		(
			DockLeft.state = on
		)
		else
		(
			DockLeft.state = off
		)
	)
	on ab_system moved pos do
(
		try if (cui.getDockState absystemrollout) == #cui_floatable 
		then()
		else(
		cui.DockDialogBar absystemrollout #cui_dock_left
		)catch()
	)
	on dockleft changed state do
	(
		if state == on then 
		(
			cui.UnRegisterDialogBar absystemrollout
			absystemrollout.size= [absystemrollout.size[1],(systemTools.GetScreenHeight())]
			Cui.RegisterDialogBar absystemrollout
			Cui.DockDialogBar absystemrollout #cui_dock_Left
			SetINISetting spInifilepath "GlobalSet"  "Dock" "#cui_dock_left"
		)
		else
		(
			cui.UnRegisterDialogBar absystemrollout
			absystemrollout.size= [absystemrollout.size[1],ROLLheigh]
			Cui.RegisterDialogBar absystemrollout
			SetINISetting spInifilepath "GlobalSet"  "Dock" "None"
		)
	)
	on btn4 pressed do
	(	
	rollout over_aa "警告!!" width:215 height:129
	(
		button qdover "确定" pos:[7,98] width:55 height:20
		button btn27 "取消" pos:[152,98] width:55 height:20
		label lbl3 "你确认在不保存的情况         下重启MAX吗？" pos:[17,24] width:125 height:43
		button btn20 "保存并继续" pos:[70,98] width:74 height:20
		on qdover pressed do
		(shellLaunch (getdir #maxroot+"\\3dsmax.exe") (maxfilepath+maxfilename)
		quitmax #noPrompt)
		on btn27 pressed do
		(destroydialog over_aa )
		on btn20 pressed do
		(max file save
		shellLaunch (getdir #maxroot+"\\3dsmax.exe") (maxfilepath+maxfilename)
		quitmax #noPrompt)
	)
		createdialog over_aa
	)
	on btn5 pressed do
	(			
	rollout over_ba "警告!!" width:215 height:129
	(
		button qdre "确定" pos:[7,98] width:55 height:20
		button ce02 "取消" pos:[153,98] width:55 height:20
		label lbl4 "你确认在不保存的情况         下重置MAX吗？" pos:[44,32] width:129 height:45 enabled:true
		button qdsavre "保存并继续" pos:[66,98] width:83 height:20
		on qdre pressed do
		(resetMaxFile #noPrompt 
			destroydialog over_ba)
		on ce02 pressed do
			(destroydialog over_ba )
		on qdsavre pressed do
		(resetMaxFile #noPrompt 
			destroydialog over_ba)
	)
	   createdialog over_ba
	)
	on btn11 pressed do
		(AddRollout absystemcjnb absystemrollout)
	on btn14 pressed do
		(AddRollout killmod absystemrollout)
	on btn7 pressed do
		(AddRollout zlwlnc absystemrollout)
	on btn6 pressed do
		(AddRollout ab_sdgj absystemrollout)
	on ab_zdgj pressed do
		(AddRollout ab_zdkz absystemrollout)
	on btn8 pressed do
		(AddRollout ab_ksdq absystemrollout)
	on btn9 pressed do
		(AddRollout ab_MaterialTools absystemrollout)
	on btn10 pressed do
	(
	removerollout absystemcjnb
	removerollout killmod
	removerollout zlwlnc
	removerollout ab_sdgj
	removerollout ab_zdkz
	removerollout ab_ksdq
	removerollout ab_MaterialTools
	)
)
	
-- 全局窗口创建卷展栏代码

absystemrollout = NewRolloutFloater "超级奶爸" 130 (systemTools.GetScreenHeight())

    AddRollout ab_system absystemrollout
	AddRollout ab_system_About absystemrollout	

--读取配置文件后按配置选择是否进行主窗口靠左
if (GetINISetting spInifilepath "GlobalSet"  "Dock") == "#cui_dock_left" 
then
(
	Cui.RegisterDialogBar absystemrollout
	Cui.DockDialogBar absystemrollout #cui_dock_Left
	)
else(
		absystemrollout.size= [absystemrollout.size[1],ROLLheigh]
		)