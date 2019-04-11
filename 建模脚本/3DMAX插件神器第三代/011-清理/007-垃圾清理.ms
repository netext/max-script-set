global Supclear
try(destroyDialog Supclear)catch()
rollout Supclear " 超级场景清理器 1.0" width:218 height:367
(
	dotNetControl bq_neirong "System.Windows.Forms.Label" pos:[0,33] width:218 height:20
 
	dotNetControl bq_biaoti "System.Windows.Forms.Label" pos:[0,0] width:218 height:33
	
	checkbox _chkBox1 "清除轨迹节点:" pos:[16,65] width:100 height:16 checked:true across:2
	dotNetControl _lblStatus1 "System.Windows.Forms.label" pos:[156,65] width:52 height:14
		
	checkbox _chkBox2 "清除场景垃圾:" pos:[16,86] width:120 height:16 checked:true across:2
	dotNetControl _lblStatus2 "System.Windows.Forms.label" pos:[156,86] width:52 height:14
		
	checkbox _chkBox3 "清除位图缓存:" pos:[16,107] width:100 height:16 checked:true across:2
	dotNetControl _lblStatus3 "System.Windows.Forms.label" pos:[156,107] width:52 height:14
		
	checkbox _chkBox4 "清除丢失的贴图:" pos:[16,128] width:120 height:16 checked:false across:2
	dotNetControl _lblStatus4 "System.Windows.Forms.label" pos:[156,128] width:52 height:14
		
	checkbox _chkBox5 "清除碰撞缓存:" pos:[16,149] width:120 height:16 checked:true across:2
	dotNetControl _lblStatus5 "System.Windows.Forms.label" pos:[156,149] width:52 height:14
	
	checkbox _chkBox6 "清除无用动画图层:" pos:[16,170] width:120 height:16 checked:true across:2
	dotNetControl _lblStatus6 "System.Windows.Forms.label" pos:[156,170] width:52 height:14
	
	checkbox _chkBox7 "清除场景缓存:" pos:[16,191] width:120 height:16 checked:true across:2
	dotNetControl _lblStatus7 "System.Windows.Forms.label" pos:[156,191] width:52 height:14
	
	checkbox _chkBox8 "清除粒子视图:" pos:[16,212] width:120 height:16 checked:true across:2
	dotNetControl _lblStatus8 "System.Windows.Forms.label" pos:[156,212] width:52 height:14
	
	checkbox _chkBox9 "清除返回缓存(慎用):" pos:[16,233] width:126 height:16 checked:false across:2
	dotNetControl _lblStatus9 "System.Windows.Forms.label" pos:[156,233] width:52 height:14
	
	checkbox _chkBox10 "清除空物体(手动提示删除)" pos:[16,254] width:180 height:16 checked:false across:2
	dotNetControl _lblStatus10 "System.Windows.Forms.label" pos:[156,233] width:52 height:14
	dotNetControl tips "System.Windows.Forms.Label" pos:[0,278] width:218 height:20
		
	button _btnStart "开始清理" pos:[9,302] width:200 height:40
	HyperLink website "By:Coronaer  coronaer.com" pos:[42,348] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.3dheima.com"

---------tip结果标签---------------------------
	global _DISABLED = "未开启"
	global _OK = "已清理"
	global _NOTFOUND = "未发现"
	global _WAIT = "等待中.."
 
 
	
	fn createLabel lbl =
	(
		dotnetColor = dotnetclass "System.Drawing.Color"
		maxUiBg = (colorman.getcolor #background) * 255
		bgColor = dotnetColor.FromArgb maxUiBg[1] maxUiBg[2] maxUiBg[3]
		fgColor = dotnetColor.FromArgb 200 200 200
				
		lbl.BackColor = bgColor
		lbl.ForeColor = fgColor		
		lbl.BorderStyle = (dotnetclass "System.Windows.Forms.BorderStyle").Fixed3D
	)
	
	fn lablelStatus lbl status: #disabled = 
	(
		dotnetColor = dotnetclass "System.Drawing.Color"
		txt = ""
		bgColor = dotnetColor.FromArgb 255 255 255 
		fgColor = dotnetColor.FromArgb 0 0 0
		lbl.BorderStyle = (dotnetclass "System.Windows.Forms.BorderStyle").None	
		bold = (dotnetclass "System.Drawing.FontStyle").Bold
		lbl.Font = dotnetobject "System.Drawing.Font" "微软雅黑" 8 bold
		
		case status of
		(
			#disabled:
			(
				bgColor = dotnetColor.FromArgb 255 229 153
				fgColor = dotnetColor.FromArgb 215 144 0
				txt = _DISABLED
			)
			#notfound:
			(
				bgColor = dotnetColor.FromArgb 147 196 125
				fgColor = dotnetColor.FromArgb 56 118 79
				txt = _NOTFOUND
			)
			#ok:
			(
				bgColor = dotnetColor.FromArgb 224 102 102
				fgColor = dotnetColor.FromArgb 153 0 0
				txt = _OK
			)
			default:
			(
				bgColor = dotnetColor.FromArgb 183 183 183
				fgColor = dotnetColor.FromArgb 67 67 67
				txt = _WAIT
			)
		)
		
		lbl.BackColor = bgColor
		lbl.ForeColor = fgColor
		lbl.Text = txt
	)
	
	fn initDotNet disabled: false = 
	(
		createLabel _lblStatus1
		createLabel _lblStatus2
		createLabel _lblStatus3
		createLabel _lblStatus4
		createLabel _lblStatus5
		createLabel _lblStatus6
		createLabel _lblStatus7
		createLabel _lblStatus8
		createLabel _lblStatus9
	
		if(disabled == true) do
		(
			lablelStatus _lblStatus1 status:#disabled
			lablelStatus _lblStatus2 status:#disabled
			lablelStatus _lblStatus3 status:#disabled
			lablelStatus _lblStatus4 status:#disabled
			lablelStatus _lblStatus5 status:#disabled
			lablelStatus _lblStatus6 status:#disabled
			lablelStatus _lblStatus7 status:#disabled
			lablelStatus _lblStatus8 status:#disabled
			lablelStatus _lblStatus9 status:#disabled
		)

	)
	
	fn fnMissingFiles name j = 
	(
		append j name
	)

	fn pruneBitmap1 =
	(		
		szMissingFiles = #()
		
		enumerateFiles fnMissingFiles szMissingFiles  #missing

		for i in szMissingFiles do 
		(
			for b in (getClassInstances bitmapTexture) do 	
			(						
				if (pathConfig.pathsResolveEquivalent b.filename i) do
				(													
					b.filename = ""
				
				)
			)		
		)	

		return szMissingFiles.count
	)
	
	fn pruneBitmap2 =
	(
		szMissing = #()
		for b in (getClassInstances missing_texturemap asTrackViewPick:true) where b != undefined do appendIfUnique szMissing b.client					 					
		
		for b in szMissing where b != undefined do 
		(
			bProp = getPropNames b
			for a in bProp do
			(
				p = getProperty b a
				if classOf p == missing_texturemap do try setProperty b bProp undefined catch()
			)
		)

		return szMissing.count
	)
	
	
	
	on Supclear open do
	(
			bq_neirong.text = "彻底解决文件保存慢,体积大等问题." --set the text of the label
			bq_neirong.backcolor = bq_neirong.backcolor.fromARGB  180 180 180 
			bq_neirong.foreColor = bq_neirong.backcolor.fromARGB 90 90 90
			bq_neirong.font= dotnetobject "System.Drawing.Font" "微软雅黑" 9
			bq_biaoti.text = "—  SPCleaner  —"
			bold = (dotnetclass "System.Drawing.FontStyle").Bold
			bq_biaoti.font= dotnetobject "System.Drawing.Font" "微软雅黑" 16 bold
			bq_neirong.font= dotnetobject "System.Drawing.Font" "微软雅黑" 9 bold
			bq_biaoti.backcolor = bq_biaoti.backcolor.fromARGB  50 107 193
			bq_biaoti.foreColor = bq_biaoti.backcolor.fromARGB 214 214 214
			bq_biaoti.TextAlign = (dotNetClass "System.Drawing.ContentAlignment").MiddleCenter 
			bq_neirong.TextAlign = (dotNetClass "System.Drawing.ContentAlignment").MiddleCenter 
			tips.text = "PS:清理大场景请事先做好备份"
			tips.backcolor = bq_neirong.backcolor.fromARGB  60 60 60 
			tips.foreColor = bq_neirong.backcolor.fromARGB 90 90 90
			tips.TextAlign = (dotNetClass "System.Drawing.ContentAlignment").MiddleCenter 
			 initDotNet()
		)
	on _chkBox9 changed state do
	(
		
		if _chkBox9.checked==true do(
			if querybox "勾选此项会清除您所有的操作记录（Ctrl+Z）,一般情况无需清理，是否确认勾选呢？" beep: true then
			(
			_chkBox9.checked=true
			)
			else
			(
			_chkBox9.checked=false
			)
		)
	)
	
	on _btnStart pressed do
	(
		initDotNet disabled: true
	
		if(_chkBox1.checked == true) do 
		(
			lablelStatus _lblStatus1 status:#wait
			
			try
			(				
				deleteTrackViewController trackViewNodes trackViewNodes[#Max_MotionClip_Manager].controller
								
				trackViewNodes[#Max_MotionClip_Manager].track = copy trackViewNodes[#Max_MotionClip_Manager].track
									
				lablelStatus _lblStatus1 status:#ok	
			)
			catch
			(
				lablelStatus _lblStatus1 status:#notfound	
			)			
		)
	
		if(_chkBox2.checked == true) do 
		(
			lablelStatus _lblStatus2 status:#wait
	
			gc light:true
			for o in objects where matchpattern ((classof o) as string) pattern:"*miss*" do delete o
			
			lablelStatus _lblStatus2 status:#ok			
		)
	
		if(_chkBox3.checked == true) do 
		(
			lablelStatus _lblStatus3 status:#wait	
			freeSceneBitmaps()
			
			lablelStatus _lblStatus3 status:#ok
		)
	
		if(_chkBox4.checked == true) do 			
		(
			lablelStatus _lblStatus4 status:#wait
					
			iMiss1 = pruneBitmap1()
			
			iMiss2 = pruneBitmap2()
			
			lablelStatus _lblStatus4 status:#notfound
			if(iMiss1 > 0 or iMiss2 > 0) do lablelStatus _lblStatus4 status:#ok
		)
		
		if(_chkBox5.checked == true) do 
		(
			try
			(
				lablelStatus _lblStatus5 status:#wait
				
				reactor.clearStoredCollisions()
									
				lablelStatus _lblStatus5 status:#ok		
			)
			catch
			(
				lablelStatus _lblStatus5 status:#notfound
			)
		)		
	
		if(_chkBox6.checked == true) do 
		(
			
			lablelStatus _lblStatus6 status:#notfound
			
			try
			(
				animLayer = (getproperty trackviewnodes.Anim_Layer_Control_Manager.controller #animlayers)								
				if(animLayer.count > 0) do lablelStatus _lblStatus6 status:#ok
				animLayer.count = 0							
			)
			catch()
			
			try
			(	
				deleteTrackViewController trackViewNodes trackViewNodes[#Anim_Layer_Control_Manager].controller
			)
			catch()
		)
		if(_chkBox7.checked == true) do 
		(
			
			try
			(
				lablelStatus _lblStatus7 status:#wait
				
				gc()
									
				lablelStatus _lblStatus7 status:#ok		
			)
			catch
			(
				lablelStatus _lblStatus7 status:#notfound
			)
			
		)
		if(_chkBox8.checked == true) do 
		(
			
			try
			(
				--lablelStatus _lblStatus8 status:#wait
				
				
				if ((delete $'particle view*') as string) =="0" then (
					
					lablelStatus _lblStatus8 status:#notfound
					
					)
				else(
					
					lablelStatus _lblStatus8 status:#ok
					
					)	
				
					
			)
			catch
			(
				
			)
			
		)
		if(_chkBox9.checked == true) do 
		(
			
			
			try
			(
				lablelStatus _lblStatus9 status:#wait
				
				clearUndoBuffer()
					
				lablelStatus _lblStatus9 status:#ok
					
			)
			catch()
			
		)
		if(_chkBox10.checked == true) do 
		(
			
		try(
			NoneObj=#()
			for i in geometry do
			(	 
				a=getPolygonCount i 
				if (classof i!= VRayProxy ) do if (classof i!= CProxy ) do
					(
					if a[1]==0 then append NoneObj i
					)
				
			)
			if NoneObj.count == 0 then messagebox"当前未发现有空物体" 
			else
			( 
			select NoneObj
			messagebox ("当前场景有"+ (selection.count as string) +"个空物体，已为您选择，请确认后手动删除")
			
			--delete $;
			)
				
					
			)
			catch()
			
		)
		
	)
)

createdialog Supclear --style:#(#style_toolwindow, #style_sysmenu)