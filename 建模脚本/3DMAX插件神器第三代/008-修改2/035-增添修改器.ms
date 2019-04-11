----1.起初是为了把多个物体的控制器删除。。下来我就写了这个工具
----2. 我想为了其方便性，我就把它做成界面的形式。。
---3. 目的就是为了快速的删除控制器。我想在加上，，删除哪一个的 
---4. 问题的出现。相对解决问题。我就叫他“修改器管理者”
---5. 创建时间：2010.6.24

try ( closerolloutfloater  g_t_leiguanliqi ) catch ()
rollout gt_leiguanli_qi "类管理器1.0" 
(
	label gt_lei_lab1 "classof$.modifiers" pos:[11,33] width:128 height:19
	spinner gt_lei_spn1 "" pos:[139,34] width:34 height:16 range:[1,20,1] type:#integer scale:1 
	editText gt_lei_edt1 "" pos:[182,31] width:75 height:23
	label gt_lei_lab2 "=" pos:[177,34] width:8 height:15
	groupBox gt_lei_grp2 "访问类" pos:[6,4] width:257 height:77
	groupBox gt_quan_grp1 "全局修改" pos:[6,84] width:257 height:153
	groupBox gt_quan_grp01 "" pos:[13,101] width:99 height:40
	label gt_quan_lab1 "删除修改器" pos:[19,114] width:76 height:20
	groupBox gt_quan_grp2 "" pos:[13,144] width:99 height:40
	label gt_quan_lab2 "关掉修改器" pos:[19,157] width:76 height:20
	groupBox gt_quan_grp3 "" pos:[13,190] width:99 height:40
	label gt_quan_lab3 "打开修改器" pos:[19,203] width:76 height:20
	label gt_quan_lab4 "..........." pos:[120,111] width:88 height:14
	label gt_quan_lab5 "..........." pos:[120,154] width:88 height:14
	label gt_quan_lab6 "..........." pos:[121,204] width:88 height:14
	button gt_quan_btn1 "////" pos:[206,109] width:50 height:27
	button gt_quan_btn2 "////" pos:[206,152] width:50 height:27
	button gt_quan_btn3 "////" pos:[206,198] width:50 height:27
	groupBox gt_ju_grp1 "局部修改" pos:[6,242] width:257 height:153
	groupBox gt_ju_grp2 "" pos:[15,255] width:99 height:40
	label gt_ju_lab1 "删除修改器" pos:[21,268] width:76 height:20
	groupBox gt_ju_grp3 "" pos:[15,298] width:99 height:40
	label gt_ju_lab2 "关掉修改器" pos:[21,311] width:76 height:20
	groupBox gt_ju_grp4 "" pos:[15,344] width:99 height:40
	label gt_ju_lab3 "打开修改器" pos:[21,357] width:76 height:20
	spinner gt_ju_spn1 "" pos:[129,269] width:44 height:16 range:[1,20,1] type:#integer scale:1 
	spinner gt_ju_spn2 "" pos:[129,312] width:44 height:16 range:[1,20,1] type:#integer scale:1 
	spinner gt_ju_spn3 "" pos:[129,358] width:44 height:16 range:[1,20,1] type:#integer scale:1 
	button gt_ju_btn1 "////" pos:[206,261] width:50 height:27
	button gt_ju_btn2 "////" pos:[206,307] width:50 height:27
	button gt_ju_btn3 "////" pos:[206,355] width:50 height:27
	button gt_lei_btn1 "访问类" pos:[12,59] width:242 height:17
		on gt_lei_btn1 pressed  do
		(
			try( 
			juk=classof$.modifiers[(gt_lei_spn1.value)]
			gt_lei_edt1.text=juk as string
			   ) catch (messagebox "选择物体。\n " Title:"黑马编")
		)
	  
		on gt_quan_btn1 pressed  do
		(
			
			local oop= #()
			for i in selection do 
			(  
			  if i.modifiers.count>=1 then 
				  
			  (  
				 append oop i 
			  )
			  )
			      oop
				  
				 for si in (oop) do 
				 (  
					jjk = si.modifiers.count
					 
					for o =1 to jjk do
					(
							 if classof (si.modifiers[o])==  execute gt_lei_edt1.text
							  then 
							   (
								-- si.modifiers[o].enabledINviews = false
								  deleteModifier si o 
							   )
					)
					 
				
					 
				 )  
			
		)
		
		
		
		on gt_quan_btn2 pressed  do
		(
			
			local oop= #()
			for i in selection do 
			(  
			  if i.modifiers.count>=1 then 
				  
			  (  
				 append oop i 
			  )
			  )
			      oop
				  
				 for si in (oop) do 
				 (  
					jjk = si.modifiers.count
					 
					for o =1 to jjk do
					(
							 if classof (si.modifiers[o])==  execute gt_lei_edt1.text
							  then 
							   (
								 si.modifiers[o].enabledINviews = false
								 --deleteModifier si o 
							   )
					)
					 
				
					 
				 )  
			
		)
		
		
		on gt_quan_btn3 pressed  do
		(
			
			local oop= #()
			for i in selection do 
			(  
			  if i.modifiers.count>=1 then 
				  
			  (  
				 append oop i 
			  )
			  )
			      oop
				  
				 for si in (oop) do 
				 (  
					jjk = si.modifiers.count
					 
					for o =1 to jjk do
					(
							 if classof (si.modifiers[o])==  execute gt_lei_edt1.text
							  then 
							   (
								 si.modifiers[o].enabledINviews = true
								 --deleteModifier si o 
							   )
					)
					 
				
					 
				 )  
			
		)
		--------修改局部的
		on gt_ju_btn1 pressed  do
		(
			
			local oop= #()
			for i in selection do 
			(  
			  if i.modifiers.count>=1 then 
				  
			  (  
				 append oop i 
			  )
			  )
			      oop
				  
				 for si in (oop) do 
				 (  
					--jjk = si.modifiers.count
					 
					--for o =1 to jjk do
					--(
							 if classof (si.modifiers[gt_ju_spn1.value])==  execute gt_lei_edt1.text
							  then 
							   (
								 --si.modifiers[o].enabledINviews = true
								 deleteModifier si gt_ju_spn1.value
							   )
					--)
 
				 )  
			
		)
	  
		
		on gt_ju_btn2 pressed  do
		(
			
			local oop= #()
			for i in selection do 
			(  
			  if i.modifiers.count>=1 then 
				  
			  (  
				 append oop i 
			  )
			  )
			      oop
				  
				 for si in (oop) do 
				 (  
					--jjk = si.modifiers.count
					 
					--for o =1 to jjk do
					--(
							 if classof (si.modifiers[gt_ju_spn2.value])==  execute gt_lei_edt1.text
							  then 
							   (
								 si.modifiers[gt_ju_spn2.value].enabledINviews = false
								 --deleteModifier si gt_ju_spn1.value
							   )
					--)
 
				 )  
			
		)
		
		
		on gt_ju_btn3 pressed  do
		(
			
			local oop= #()
			for i in selection do 
			(  
			  if i.modifiers.count>=1 then 
				  
			  (  
				 append oop i 
			  )
			  )
			      oop
				  
				 for si in (oop) do 
				 (  
					--jjk = si.modifiers.count
					 
					--for o =1 to jjk do
					--(
							 if classof (si.modifiers[gt_ju_spn3.value])==  execute gt_lei_edt1.text
							  then 
							   (
								 si.modifiers[gt_ju_spn3.value].enabledINviews = true
								 --deleteModifier si gt_ju_spn1.value
							   )
					--)
 
				 )  
			
		)
		
	
	
)

 g_t_leiguanliqi=newrolloutfloater "盖天工具（黑马设计网）" 273 437   50 120
 addrollout  gt_leiguanli_qi   g_t_leiguanliqi

