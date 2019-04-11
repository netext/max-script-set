rollout bcm "保存慢_zy"
(
	local t=trackviewnodes
	local n=t[#Max_MotionClip_Manager]
	
	button doit "加快保存速度" width:100 height:30
	label ab1 "此场景保存正常"
	hyperlink getzy "ZY tool---313 703 763"color:green address:"http://3dheima.com"
	
	on doit pressed do
		
	(
		
	try (
		
		t=trackviewnodes
		n=t[#Max_MotionClip_Manager]
		
		if n == undefined then 
			(
			
			messagebox "当前保存速度正常"  
				
			)else
			
			(
				deleteTrackViewController t n.controller 
				messagebox "已加快保存速度"
				ab1.caption = "此场景保存速度正常"
			)
		) catch()
	
	)
	
	on bcm open do
		
	if n == undefined then ab1.caption = "此场景保存速度正常" else  ab1.caption = "点击加快保存速度"
)
createdialog bcm 130 80 