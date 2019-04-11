rollout objectschecker "ObjectsChecker" 
(
	fn GetVectorsAngle v_1 v_2 = 
	(
		theAngle = acos(dot (normalize v_1) (normalize v_2))
	)
	fn GetVectorAngle v_1 v_2 = acos (dot (normalize v_1) (normalize v_2))
	--检查点
	GroupBox ocgv "Vertex" pos:[6,5] width:150 height:108
	label lblocvr "开放边阈值" pos:[15,22] width:75 height:18
	spinner spnocvr "" pos:[80,21] width:50 height:16 range:[0,180,179.9] type:#float
	label lblocvd "度" pos:[135,22] width:15 height:18
	button btnocvr "移除废点" pos:[10,40] width:80 height:23 toolTip:"移除物体上孤立点和无用点"
	label lblvos "选中点" pos:[95,45] width:60 height:18 
	checkbox chkvos "" pos:[135,45] width:15 height:15 
	label lblocvc "选中大于" pos:[15,68] width:60 height:18
	spinner spnocvc "" pos:[65,67] width:34 height:16 range:[0,99,6] type:#integer
	label lblocvn "条边的点" pos:[102,68] width:50 height:18
	button btnocvc "检查多边点" pos:[10,86] width:80 height:23 toolTip:"选中拥有超过规定边数的点"
	label lblcvos "选中点" pos:[95,91] width:60 height:18 
	checkbox chkcvos "" pos:[135,91] width:15 height:15 
	--检查线
	GroupBox ocge "Edge" pos:[6,115] width:150 height:82
	label lbl1 "面夹角阈值" pos:[12,132] width:72 height:16 
	spinner spn1 "" pos:[88,131] width:60 height:16 range:[0,180,0] scale:0.001 
	label lbl3 "边夹角阈值" pos:[12,152] width:72 height:16
	spinner spn2 "" pos:[88,151] width:60 height:16 range:[0,180,180] scale:0.001
	button btn_rml "移除废线" pos:[10,170] width:80 height:23 toolTip:"移除物体上无实际意义的线"
	label lbleos "选中线" pos:[95,175] width:60 height:18 
	checkbox chkeos "" pos:[135,175] width:15 height:15 
	--检查面
	GroupBox pigp "Face" pos:[6,200] width:150 height:173
	label lbl_objinfo "进程0/0" align:#center
	label lblocfc "选中大于" pos:[15,217] width:60 height:18
	spinner spnocfc "" pos:[65,216] width:34 height:16 range:[0,99,4] type:#integer
	label lblocfn "个点的面" pos:[102,217] width:50 height:18
	button btnocfc "检查多点面" pos:[10,235] width:80 height:23 toolTip:"选中拥有超过规定顶点数的面"
	label lblfcos "选中面" pos:[95,240] width:60 height:18 
	checkbox chkfcos "" pos:[135,240] width:15 height:15 
	--选中内角不合理的面
	label lblfas "过锐角阈值" pos:[15,263] width:60 height:18
	spinner spnfas "" pos:[80,262] width:50 height:16 range:[0,90,10] type:#float
	label lblfasd "度" pos:[135,263] width:15 height:18
	label lblfal "过顿角阈值" pos:[15,283] width:60 height:18
	spinner spnfal "" pos:[80,282] width:50 height:16 range:[90,180,180] type:#float
	label lblfald "度" pos:[135,283] width:15 height:18
	button btnfa "选中畸角面" pos:[10,301] width:80 height:23 toolTip:"选中内角过锐或过钝的面"
	label lblfaos "选中面" pos:[95,306] width:60 height:18 
	checkbox chkfaos "" pos:[135,306] width:15 height:15 
	label lblfdl "内角和阈值" pos:[12,328] width:60 height:18
	spinner spnfd "" pos:[74,327] width:60 height:16 range:[0.0,360.0,360.0] type:#float scale:0.001
	label lblfd "度" pos:[137,328] width:15 height:18
	button btnfd "选中畸形面" pos:[10,346] width:80 height:23 toolTip:"选中内角大于180度的面或扭曲的面"
	label lblfdos "选中面" pos:[95,351] width:60 height:18 
	checkbox chkfdos "" pos:[135,351] width:15 height:15 
	progressBar pb_objinfo pos:[5,395] width:150 height:6 color:red
	label lbl_proinfo "已处理物体0/0" align:#center
	progressBar pb_proinfo pos:[5,423] width:150 height:6 color:red
	
	label lbl10 "=========================" pos:[5,435] width:206 height:30
	label lbl11 "版本: Objects Checker v2.1\n版权: 艾雨 (QQ:260592419)" pos:[10,450] width:206 height:30
	label lbl12 "更多资源请登录www.3dheima.com" pos:[10,477] width:260 height:30

	
	--移除废点
	on btnocvr pressed do 
	(
		
		pb_objinfo.value=0
		pb_proinfo.value=0
		selarray=selection as array
		if selarray.count==0 
		then messagebox "请选择物体！" title:"温馨提示"
		else 
		(
			for i=1 to selarray.count do
			(
				wrvarray=#()
				x=selarray[i]
				pb_proinfo.value = (i-1)*100/selarray.count
				lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
				if classof x != Editable_Poly then
				(
					if queryBox "是否塌陷物体为 Editable_Poly？" title:"温馨提示" beep:true then ConvertTo x Editable_Poly
					else 
					(
						pb_proinfo.value=(i as float)/(selarray.count as float)*100
						--if i==selarray.count then lbl_proinfo.text="选中物体全部处理完成"
						continue
					)
				)
				escapeEnable = true --强行退出
				lbl_objinfo.text="移除孤立点..."
				--移除孤立点
				x.EditablePoly.deleteIsoVerts ()
				--移除同属于两条边并且同属于两个面的废点
				lbl_objinfo.text="移除废点..."
				pb_objinfo.value=0
				------------------------
				if chkvos.checked == false then 
				(
					x.EditablePoly.SetSelection #Vertex #{1..( x.GetNumVertices() )}
				)
				vtba=x.EditablePoly.getSelection #Vertex
				vta=vtba as array
				vnum=vta.count
				------------------------
				for j = 1 to vnum do 
				(
					lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
					--lbl_objinfo.text="移除废点 "+(vta[j] as string)+"/"+(vnum as string)
					lbl_objinfo.text="进程1/2"
					x.EditablePoly.SetSelection #Vertex #{vta[j]}
					vbarray=x.EditablePoly.getSelection #Vertex
					varray=vbarray as array
					if ((x.GetVertexEdgeCount vta[j])==2 and (x.GetVertexFaceCount vta[j])==2)
					then append wrvarray varray[1]
					pb_objinfo.value=(vta[j] as float)/(vnum as float)*100
				)
				lbl_objinfo.text="移除废点..."
				x.EditablePoly.SetSelection #Vertex (wrvarray as bitarray)
				x.EditablePoly.Remove selLevel:#Vertex
				pb_objinfo.value=100
				--移除开放边上的废点
				wvarray=#()
				for k=1 to vnum do 
				(	
					lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
					--lbl_objinfo.text="开放边上的废点 "+(k as string)+"/"+(vnum as string)
					lbl_objinfo.text="进程2/2"
					x.EditablePoly.SetSelection #Vertex #{}
					if ((x.GetVertexEdgeCount vta[k])==2 and (x.GetVertexFaceCount vta[k])==1) then
					(
						x.EditablePoly.SetSelection #Vertex #{vta[k]}
						x.EditablePoly.ConvertSelection #Vertex #Edge
						eb=x.EditablePoly.getSelection #Edge
						ea=eb as array
						es=#()
						append es ea[1]
						x.EditablePoly.SetSelection #Edge (es as bitarray)
						x.EditablePoly.ConvertSelection #Edge #Vertex
						vb=x.EditablePoly.getSelection #Vertex
						va=vb as array
						if va[1]==vta[k]
						then v1=(x.getvertex va[2])-(x.getvertex vta[k])
						else v1=(x.getvertex va[1])-(x.getvertex vta[k])
						
						es=#()
						va=#()
						append es ea[2]
						x.EditablePoly.SetSelection #Edge (es as bitarray)
						x.EditablePoly.ConvertSelection #Edge #Vertex
						vb=x.EditablePoly.getSelection #Vertex
						va=vb as array
						if va[1]==vta[k]
						then v2=(x.getvertex va[2])-(x.getvertex vta[k])
						else v2=(x.getvertex va[1])-(x.getvertex vta[k])
						
						ang=GetVectorsAngle v1 v2
						if ang>=spnocvr.value
						then append wvarray vta[k]
					)
					pb_objinfo.value=(vta[k] as float)/(vnum as float)*100
				)
				lbl_objinfo.text="移除开放边上的废点..."
				x.EditablePoly.SetSelection #Vertex (wvarray as bitarray)
				x.EditablePoly.Remove selLevel:#Vertex
				lbl_objinfo.text="废点已成功移除"
				--lbl_proinfo.text="已处理物体 "+(i as string)+"/"+(selarray.count as string)
				--pb_proinfo.value=(i as float)/(selarray.count as float)*100
				--if i==selarray.count then lbl_proinfo.text="选中物体全部处理完成"
			)
			pb_proinfo.value = 100
			lbl_proinfo.text = "已处理物体"+ ( selarray.count as string ) + "/" + ( selarray.count as string )
		)
	)
	--检查多边点
	on btnocvc pressed do
	(
		pb_objinfo.value=0
		pb_proinfo.value=0
		selarray=selection as array
		if selarray.count==0 
		then messagebox "请选择物体！" title:"温馨提示"
		else 
		(
			for i=1 to selarray.count do
			(
				wrvarray=#()
				x=selarray[i]
				pb_proinfo.value = (i-1)*100/selarray.count
				lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
				if classof x != Editable_Poly then
				(
					if queryBox "是否塌陷物体为 Editable_Poly？" title:"温馨提示" beep:true then ConvertTo x Editable_Poly
					else 
					(
						pb_proinfo.value=(i as float)/(selarray.count as float)*100
						--if i==selarray.count then lbl_proinfo.text="选中物体全部处理完成"
						continue
					)
				)
				escapeEnable = true --强行退出
				--选中拥有超过规定边数的点
				------------------------
				if chkcvos.checked == false then 
				(
					x.EditablePoly.SetSelection #Vertex #{1..( x.GetNumVertices() )}
				)
				vtba=x.EditablePoly.getSelection #Vertex
				vta=vtba as array
				vnum=vta.count
				------------------------
				for k = 1 to vnum do 
				(
					lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
					lbl_objinfo.text="正在检查点 "+(k as string)+"/"+(vnum as string)
					x.EditablePoly.SetSelection #Vertex #{vta[k]}
					vbarray=x.EditablePoly.getSelection #Vertex
					varray=vbarray as array
					if ((x.GetVertexEdgeCount vta[k])>=(spnocvc.value+1))
					then append wrvarray varray[1]
					pb_objinfo.value=(vta[k] as float)/(vnum as float)*100
				)
				x.EditablePoly.SetSelection #Vertex (wrvarray as bitarray)
				lbl_objinfo.text="多边点已选中"
				pb_objinfo.value=100
				pb_proinfo.value=(i as float)/(selarray.count as float)*100
				--if i==selarray.count then lbl_proinfo.text="选中物体全部处理完成"
			)
			pb_proinfo.value = 100
			lbl_proinfo.text = "已处理物体"+ ( selarray.count as string ) + "/" + ( selarray.count as string )
		)
	)
	--移除废线
	on btn_rml pressed do
	(
		sel=selection as array
		if sel.count == 0 then messagebox "请选择物体！" title:"温馨提示"
		else
		(
			for u = 1 to sel.count do
			(
				pb_proinfo.value = (u-1)*100/sel.count
				lbl_proinfo.text = "已处理物体"+ ((u-1) as string ) + "/" + ( sel.count as string )
				if classof sel[u] != Editable_Poly then
				(
					if queryBox "是否塌陷物体为 Editable_Poly？" title:"温馨提示" beep:true then ConvertTo sel[u] Editable_Poly
					else 
					(
						pb_proinfo.value=(u as float)/(sel.count as float)*100
						continue
					)
				)
				pb_objinfo.value = 0
				lbl_objinfo.text = "进程1/3"
				all_line = #()
				remove_line = #()
				temp_vertex =#()
				remove_vertex = #()
				linemun=#()
				cobj=sel[u]
				--convertToPoly cobj
				--linemun = cobj.GetNumEdges()
				------------------------
				if chkeos.checked == false then 
				(
					cobj.EditablePoly.SetSelection #Edge #{1..( cobj.GetNumEdges() )}
				)
				etba=cobj.EditablePoly.getSelection #Edge
				eta=etba as array
				linemun=eta.count
				--break()
				------------------------
				for i = 1 to linemun do 
				(
					escapeEnable = true --强行退出
					pb_objinfo.value = (i-1)*100/linemun
					cobj.EditablePoly.SetSelection #Edge #{eta[i]}
					cobj.EditablePoly.ConvertSelection #Edge #Face
					line_face = cobj.EditablePoly.GetSelection #Face as array
					if line_face.count == 2 then 
					(	
						if (GetVectorAngle (polyOp.getFaceNormal cobj line_face[1])(polyOp.getFaceNormal cobj line_face[2]) <= spn1.value)
						then append all_line i
						else continue	
					)
					else continue
				)
				pb_objinfo.value = 0
				lbl_objinfo.text = "进程2/3"
			
				for j = 1 to all_line.count do 
				(
					escapeEnable = true --强行退出
					pb_objinfo.value = (j-1)*100/all_line.count
					cobj.EditablePoly.SetSelection #Edge #{all_line[j]}
					cobj.EditablePoly.ConvertSelection #Edge #Vertex
					test_vertex = cobj.EditablePoly.GetSelection #Vertex as array
					
					face_count1=cobj.EditablePoly.GetVertexFaceCount test_vertex[1]
					face_count2=cobj.EditablePoly.GetVertexFaceCount test_vertex[2]
					--线上第一点
					if (face_count1 == 3 and face_count2 <= 4) then 
					(
						cobj.EditablePoly.SetSelection #Vertex #{test_vertex[1]}
						cobj.EditablePoly.GrowSelection selLevel:#Vertex
						temp_test = cobj.EditablePoly.GetSelection #Vertex as array
						deleteitem temp_test (finditem temp_test test_vertex[1])
						deleteitem temp_test (finditem temp_test test_vertex[2])
						test_angle = GetVectorAngle ((cobj.EditablePoly.GetVertex temp_test[1]) - (cobj.EditablePoly.GetVertex test_vertex[1])) ((cobj.EditablePoly.GetVertex temp_test[2]) - (cobj.EditablePoly.GetVertex test_vertex[1]))
						if test_angle >= spn2.value do
						(
							if (finditem remove_line j) == 0 do
							(
								append remove_line all_line[j]
								continue
							)
						)
					)
					--线上第二点
					if (face_count2 == 3 and face_count1 <= 4) then 
					(
						cobj.EditablePoly.SetSelection #Vertex #{test_vertex[2]}
						cobj.EditablePoly.GrowSelection selLevel:#Vertex
						temp_test = cobj.EditablePoly.GetSelection #Vertex as array
						deleteitem temp_test (finditem temp_test test_vertex[1])
						deleteitem temp_test (finditem temp_test test_vertex[2])
						test_angle = GetVectorAngle ((cobj.EditablePoly.GetVertex temp_test[1]) - (cobj.EditablePoly.GetVertex test_vertex[2])) ((cobj.EditablePoly.GetVertex temp_test[2]) - (cobj.EditablePoly.GetVertex test_vertex[2]))
						if test_angle >= spn2.value do
						(
							if (finditem remove_line j) == 0 do
							(
								append remove_line all_line[j]
								continue
							)
						)
					)
				)
				
				sort remove_line
				--break()
				cobj.EditablePoly.SetSelection #Edge (remove_line as bitarray)
				cobj.EditablePoly.SelectEdgeLoop ()
				-------------------------
				cobj.EditablePoly.ConvertSelection #Edge #Vertex 
				evtba=cobj.EditablePoly.getSelection #Vertex
				evta=evtba as array
				vc=evta.count
				-------------------------
				cobj.EditablePoly.Remove selLevel:#Edge				
				lbl_objinfo.text = "进程3/3"
				--vc = cobj.GetNumEdges()
				for v = 1 to vc do
				(
					escapeEnable = true --强行退出
					pb_objinfo.value = (v-1)*100/vc
					if (cobj.EditablePoly.GetVertexEdgeCount evta[v] == 2 and cobj.EditablePoly.GetVertexFaceCount evta[v] == 2) then append remove_vertex evta[v]
					else continue
				)
				cobj.EditablePoly.SetSelection #Vertex (remove_vertex as bitarray)
				cobj.EditablePoly.Remove selLevel:#Vertex 
				pb_objinfo.value=100
				lbl_objinfo.text = "废线已成功移除"
			)
			pb_proinfo.value = 100
			lbl_proinfo.text = "已处理物体"+ ( sel.count as string ) + "/" + ( sel.count as string )
		)
	)
	--检查多点面
	on btnocfc pressed do
	(
		pb_objinfo.value=0
		pb_proinfo.value=0
		selarray=selection as array
		if selarray.count==0 
		then messagebox "请选择物体！" title:"温馨提示"
		else 
		(
			for i=1 to selarray.count do
			(
				wrfarray=#()
				x=selarray[i]
				pb_proinfo.value = (i-1)*100/selarray.count
				lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
				if classof x != Editable_Poly then
				(
					if queryBox "是否塌陷物体为 Editable_Poly？" title:"温馨提示" beep:true then ConvertTo x Editable_Poly
					else 
					(
						pb_proinfo.value=(i as float)/(selarray.count as float)*100
						continue
					)
				)
				escapeEnable = true --强行退出
				pb_objinfo.value=0
				--选中大于规定顶点的面
				------------------------
				if chkfcos.checked == false then 
				(
					x.EditablePoly.SetSelection #Face #{1..( x.GetNumFaces() )}
				)
				ftba=x.EditablePoly.getSelection #Face
				fta=ftba as array
				fnum=fta.count
				------------------------
				--fnum =x.GetNumFaces()
				for k = 1 to fnum do
				(
					lbl_proinfo.text="已处理物体 "+( (i-1) as string)+"/"+(selarray.count as string)
					lbl_objinfo.text="正在检查面 "+(k as string)+"/"+(fnum as string)
					x.EditablePoly.SetSelection #Face #{fta[k]}
					fbarray=x.EditablePoly.getSelection #Face 
					x.EditablePoly.ConvertSelection #Face #Vertex
					vbarray=x.EditablePoly.getSelection #Vertex
					x.EditablePoly.SetSelection #Vertex #{}
					varray=vbarray as array
					farray=fbarray as array
					if varray.count>spnocfc.value
					then append wrfarray farray[1]
					pb_objinfo.value=(k as float)/(fnum as float)*100
				)
				x.EditablePoly.SetSelection #Face (wrfarray as bitarray)
				lbl_objinfo.text="多点面已选中"
				pb_objinfo.value=100
				pb_proinfo.value=(i as float)/(selarray.count as float)*100
				--if i==selarray.count then lbl_proinfo.text="选中物体全部处理完成"
			)
			pb_proinfo.value = 100
			lbl_proinfo.text = "已处理物体"+ ( selarray.count as string ) + "/" + ( selarray.count as string )
		)
	)
	--选中内角不合理的面
	on btnfa pressed do
	(
		pb_objinfo.value=0
		pb_proinfo.value=0
		selarray=selection as array
		if selarray.count==0 
		then messagebox "请选择物体！" title:"温馨提示"
		else 
		(
			for i=1 to selarray.count do
			(
				wrfarray=#()
				wrvarray=#()
				x=selarray[i]
				pb_proinfo.value = (i-1)*100/selarray.count
				lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
				if classof x != Editable_Poly then
				(
					if queryBox "是否塌陷物体为 Editable_Poly？" title:"温馨提示" beep:true then ConvertTo x Editable_Poly
					else 
					(
						pb_proinfo.value=(i as float)/(selarray.count as float)*100
						continue
					)
				)
				escapeEnable = true --强行退出
				pb_objinfo.value=0
				--选中内角不合理的面
				------------------------
				if chkfaos.checked == false then 
				(
					x.EditablePoly.SetSelection #Face #{1..( x.GetNumFaces() )}
				)
				ftba=x.EditablePoly.getSelection #Face
				fta=ftba as array
				fnum=fta.count
				------------------------
				--fnum =x.GetNumFaces()
				for j = 1 to fnum do
				(
					lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
					lbl_objinfo.text="正在检查面 "+(j as string)+"/"+(fnum as string)
					x.EditablePoly.SetSelection #Vertex #{} --取消选择
					x.EditablePoly.SetSelection #Face #{} --取消选择
					x.EditablePoly.SetSelection #Face #{fta[j]} --选中一个面
					fbarray=x.EditablePoly.getSelection #Face --将该面放入一个Bitarray
					x.EditablePoly.ConvertSelection #Face #Vertex --选中面上的点
					vbarray=x.EditablePoly.getSelection #Vertex --将选中点放入一个Bitarray
					x.EditablePoly.ConvertSelection #Face #Edge --选中面上的边
					ebarray=x.EditablePoly.getSelection #Edge --将选中边放入一个Bitarray
					varray=vbarray as array --将点Bitarray转为array
					earray=ebarray as array --将边Bitarray转为array
					farray=fbarray as array --将面Bitarray转为array
					for k=1 to varray.count do 
					(	
						x.EditablePoly.SetSelection #Vertex #{} --清空点选择
						m=varray[k]
						eat=#()
						ea=#()
						x.EditablePoly.SetSelection #Vertex #{m} --选择面上的一个点
						x.EditablePoly.ConvertSelection #Vertex #Edge --转化为边选择
						eb=x.EditablePoly.getSelection #Edge
						eat=eb as array
						for u=1 to eat.count do 
						(
							num=findItem earray eat[u]
							if num!=0 
							then append ea earray[num]
						)
						es=#()
						append es ea[1]
						x.EditablePoly.SetSelection #Edge (es as bitarray)
						x.EditablePoly.ConvertSelection #Edge #Vertex
						vb=x.EditablePoly.getSelection #Vertex
						va=vb as array
						if va[1]==m
						then v1=(x.getvertex va[2])-(x.getvertex m)
						else (v1=(x.getvertex va[1])-(x.getvertex m))
						es=#()
						va=#()
						append es ea[2]
						x.EditablePoly.SetSelection #Edge (es as bitarray)
						x.EditablePoly.ConvertSelection #Edge #Vertex
						vb=x.EditablePoly.getSelection #Vertex
						va=vb as array
						if va[1]==m
						then v2=(x.getvertex va[2])-(x.getvertex m)
						else (v2=(x.getvertex va[1])-(x.getvertex m))
						ang=GetVectorsAngle v1 v2
						if (ang>=spnfal.value or ang<=spnfas.value) then 
						(
							append wrvarray m
							append wrfarray fta[j]
						)
						pb_objinfo.value=(j as float)/(fnum as float)*100
					)
				)
				x.EditablePoly.SetSelection #Vertex (wrvarray as bitarray)
				x.EditablePoly.SetSelection #Face (wrfarray as bitarray)
				lbl_objinfo.text="内角不合理的面已选中"
				pb_objinfo.value=100
				pb_proinfo.value=(i as float)/(selarray.count as float)*100
				--if i==selarray.count then lbl_proinfo.text="选中物体全部处理完成"
			)
			pb_proinfo.value = 100
			lbl_proinfo.text = "已处理物体"+ ( selarray.count as string ) + "/" + ( selarray.count as string )
		)
	)
	--选中畸形面
	on btnfd pressed do
	(
		pb_objinfo.value=0
		pb_proinfo.value=0
		selarray=selection as array
		if selarray.count==0 
		then messagebox "请选择物体！" title:"温馨提示"
		else 
		(
			mvfobj=#()
			for i=1 to selarray.count do
			(
				wrfarray=#()
				wrmvarray=#()
				x=selarray[i]
				pb_proinfo.value = (i-1)*100/selarray.count
				lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
				if classof x != Editable_Poly then
				(
					if queryBox "是否塌陷物体为 Editable_Poly？" title:"温馨提示" beep:true then ConvertTo x Editable_Poly
					else 
					(
						pb_proinfo.value=(i as float)/(selarray.count as float)*100
						continue
					)
				)
				escapeEnable = true --强行退出
				pb_objinfo.value=0
				--选中畸形面
				------------------------
				if chkfdos.checked == false then 
				(
					x.EditablePoly.SetSelection #Face #{1..( x.GetNumFaces() )}
				)
				ftba=x.EditablePoly.getSelection #Face
				fta=ftba as array
				fnum=fta.count
				------------------------
				--fnum=x.GetNumFaces()
				for j = 1 to fnum do
				(
					lbl_proinfo.text="已处理物体 "+((i-1) as string)+"/"+(selarray.count as string)
					lbl_objinfo.text="正在检查面 "+(j as string)+"/"+(fnum as string)
					angs=#()
					angadd=360.0
					x.EditablePoly.SetSelection #Vertex #{} --取消选择
					x.EditablePoly.SetSelection #Face #{} --取消选择
					x.EditablePoly.SetSelection #Face #{fta[j]} --选中一个面
					fbarray=x.EditablePoly.getSelection #Face --将该面放入一个Bitarray
					x.EditablePoly.ConvertSelection #Face #Vertex --选中面上的点
					vbarray=x.EditablePoly.getSelection #Vertex --将选中点放入一个Bitarray
					varray=vbarray as array --将点Bitarray转为array
					if varray.count==4 then
					(
						x.EditablePoly.ConvertSelection #Face #Edge --选中面上的边
						ebarray=x.EditablePoly.getSelection #Edge --将选中边放入一个Bitarray
						earray=ebarray as array --将边Bitarray转为array
						farray=fbarray as array --将面Bitarray转为array
						for k=1 to varray.count do 
						(	
							x.EditablePoly.SetSelection #Vertex #{} --清空点选择
							m=varray[k]
							eat=#()
							ea=#()
							x.EditablePoly.SetSelection #Vertex #{m} --选择面上的一个点
							x.EditablePoly.ConvertSelection #Vertex #Edge --转化为边选择
							eb=x.EditablePoly.getSelection #Edge
							eat=eb as array
							for u=1 to eat.count do 
							(
								num=findItem earray eat[u]
								if num!=0 
								then append ea earray[num]
							)
							es=#()
							append es ea[1]
							x.EditablePoly.SetSelection #Edge (es as bitarray)
							x.EditablePoly.ConvertSelection #Edge #Vertex
							vb=x.EditablePoly.getSelection #Vertex
							va=vb as array
							if va[1]==m
							then v1=(x.getvertex va[2])-(x.getvertex m)
							else (v1=(x.getvertex va[1])-(x.getvertex m))
							es=#()
							va=#()
							append es ea[2]
							x.EditablePoly.SetSelection #Edge (es as bitarray)
							x.EditablePoly.ConvertSelection #Edge #Vertex
							vb=x.EditablePoly.getSelection #Vertex
							va=vb as array
							if va[1]==m
							then v2=(x.getvertex va[2])-(x.getvertex m)
							else (v2=(x.getvertex va[1])-(x.getvertex m))
							x.EditablePoly.SetSelection #Edge #{}
							ang=GetVectorsAngle v1 v2
							append angs ang
						)
						angadd=angs[1]+angs[2]+angs[3]+angs[4]
					)
					else if varray.count>4 then append wrmvarray fta[j]
					if angadd<spnfd.value then append wrfarray fta[j]
					pb_objinfo.value=(j as float)/(fnum as float)*100
				)
				x.EditablePoly.SetSelection #Face (wrfarray as bitarray)
				if wrmvarray.count>0 then append mvfobj x
				lbl_objinfo.text="畸形面已选中"
				pb_objinfo.value=100
				pb_proinfo.value=(i as float)/(selarray.count as float)*100
				--if i==selarray.count then lbl_proinfo.text="选中物体全部处理完成"
			)
			pb_proinfo.value = 100
			lbl_proinfo.text = "已处理物体"+ ( selarray.count as string ) + "/" + ( selarray.count as string )
			if mvfobj.count>0 then 
			(
				select mvfobj
				messagebox "选中物体中存在多于四个点的面，请检查！" title:"温馨提示"
			)
		)
	)
)
createdialog objectschecker 