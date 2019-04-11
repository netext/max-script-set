
(
rollout facetools "空物体检查" width:112 height:105
(
	button btn0face "选择空物体" pos:[11,33] width:92 height:25	
	button btnmaxface "选择面王" pos:[11,67] width:92 height:25	
	checkbox chkselected "" pos:[10,11] width:20 height:16
	
	label lbl1 "选择的物体" pos:[28,10] width:65 height:18
	global my_sel
	global my0faceobj_sel
	global my0faceobj_sel_ingroup
	global my0faceobj_all
	global my0faceobj_all_ingroup
					fn facecompare v1 v2=
				(
					local d=v1.mesh.numfaces-v2.mesh.numfaces
					case of
					(
					(d>0):1
					(d<0):-1
					default: 0
					)
				)
	on btn0face pressed do
		(
		
		my_sel=chkselected.state
		if my_sel==true then
			(
				my0faceobj_sel= for j in geometry where j.isselected==true and j.mesh.numfaces==0 collect j
				if my0faceobj_sel.count!=0 then
					(
						my0faceobj_sel_ingroup=for n in my0faceobj_sel where isGroupMember n==on collect n
						select my0faceobj_sel_ingroup
						for m =1 to my0faceobj_sel_ingroup.count do 
							(
								while isOpenGroupMember my0faceobj_sel_ingroup[m]==off do (max group open ;select my0faceobj_sel_ingroup[m])
							)
						select my0faceobj_sel
						mycount="选择集中共有"(my0faceobj_sel.count as string)+" 个空物体 :("
						messagebox mycount
					)
				else messagebox "选择的物体中没有空物体 :)"
			)
		else
			(
				my0faceobj_all= for i in geometry where i.mesh.numfaces==0 collect i
				if my0faceobj_all.count!=0 then
				(
					my0faceobj_all_ingroup=for p in my0faceobj_all where isGroupMember p==on collect p
					select my0faceobj_all_ingroup
					
					for k =1 to my0faceobj_all_ingroup.count do 
						(
							while isOpenGroupMember my0faceobj_all_ingroup[k]==off do (max group open ;select my0faceobj_all_ingroup[k])
						)
					select my0faceobj_all
					unhide my0faceobj_all
					mycount="场景中共有"+(my0faceobj_all.count as string)+" 个空物体 :("
					messagebox mycount
				)
				else messagebox "场景中没有空物体 :)"
			)
		)
	on btnmaxface pressed do
		(		
		my_sel=chkselected.state
		if my_sel==true then
		(
			mymaxfaceobj_sel=for j in geometry where j.isselected==true collect j
			if mymaxfaceobj_sel.count!=0 then
			(
				qsort mymaxfaceobj_sel facecompare
				mymaxim=mymaxfaceobj_sel[mymaxfaceobj_sel.count]
				select mymaxim
				if isGroupMember mymaxim==true then
					(
					while isOpenGroupMember mymaxim==off do (max group open ;select mymaxim)
					)
				select mymaxim
				maximcount01=mymaxim.mesh.numfaces as string+"个面的物体——"+mymaxim.name as string+"已被选择 :)"
				messagebox maximcount01
			)
			else 
			(
			messagebox "请选择物体！"
			)
		)
		else
		(
			mymaxfaceobj_all=for j in geometry collect j
			if mymaxfaceobj_all.count!=0 then
			(
				qsort mymaxfaceobj_all facecompare
				mymaxim02=mymaxfaceobj_all[mymaxfaceobj_all.count]
				select mymaxim02
				if isGroupMember mymaxim02==true then
					(
					while isOpenGroupMember mymaxim02==off do (max group open ;select mymaxim02)
					)
				select mymaxim02
				if mymaxim02.ishidden==on then unhide mymaxim02
				maximcount02=mymaxim02.mesh.numfaces as string+"个面的物体--"+mymaxim02.name as string+"已被选择 :)"
				messagebox maximcount02
			)
			else 
			(
			messagebox "场景中没有物体啊！"
			)
		)
		)
)
createDialog facetools
)