global m=1,Files,x=1

rollout unnamedRollout "打开下一个模型 【黑马设计网】出品" width:547 height:122
(
	label lbl1 "打开下一个模型" pos:[14,9] width:510 height:24
	edittext edt1 "路径：" pos:[18,35] width:520 height:25
	button btn1 "打开下一个模型" pos:[62,74] width:471 height:37
	
	fn getFilesRecursive root pattern =

(

dir_array = GetDirectories (root+"/*")

	
for d in dir_array do

join dir_array (GetDirectories (d+"/*"))

my_files = getfiles(root+ "/"+pattern)--#() d:\tt*.*

for f in dir_array do

	join my_files (getFiles (f + pattern))


--join my_files (getfiles(root+ pattern))

my_files 

) --递归查询文件函数
	
			
FN Fixdongli=(
	--处理打开慢，保存慢的问题
		--a,处理trackviewnodes
			try (numNoteTracks trackviewnodes[#Max_MotionClip_Manager]) catch()
			try (t=trackviewnodes;n=t[#Max_MotionClip_Manager];deleteTrackViewController t n.controller) catch()
			--b处理动力学
			try (
				cui.commandPanelOpen = on
				max utility mode
				UtilityPanel.OpenUtility Reactor
				UIAccessor.PressButton (windows.getChildHWND #max "Clear")[1]
				UtilityPanel.CloseUtility()
				)
				catch()
		    try (reactor.clearStoredCollisions())catch()
			
		--处理打开慢，保存慢的问题结束
			)
			
			
	
	on btn1 pressed  do
	(
		
	Files=getFilesRecursive (edt1.text) ("*.max")
	
		
			    MAXF=files[m]
				lbl1.caption = m as string +"/"+files.count as string +"------"+MAXF
				
				--try (resetMaxFile #noPrompt) catch()  
				Fixdongli()--解决保存慢
				try (loadMaxFile MAXF missingDLLsAction: #default quiet:true) catch(
						print (files[k] +"---------------------加载错误")
					)
				--try (mergeMAXFile MAXF ) catch(
				--		print (files[k] +"---------------------加载错误")
				--	)
					
			
		
					
					


	
					
	m=m+1


	
		max tool zoomextents all
		Fixdongli()--解决保存慢			
				
		
		
		)
)
createdialog unnamedRollout style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
