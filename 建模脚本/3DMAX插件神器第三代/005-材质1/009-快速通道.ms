fn MakeChannelsI=
(
		try (destroydialog MakeChannels) catch()
		rollout MakeChannels "快速生成通道"
		(
			local H_Step = 1
			local V_Step = 1
			local H_Max = 24
			local V_Max = 24
			local ChannelsColor = #()
			local ChnCount = 0
			local ChnColNum = 1
			
			fn StatChnNum GetMtl Mul Ble =
			(
				if Classof GetMtl == Blend and GetMtl.Mask != undefined and Ble == true then
				(
					StatChnNum GetMtl.map1 Mul Ble
					StatChnNum GetMtl.map2 Mul Ble
				)
				else if Classof GetMtl == Multimaterial and Mul == true then
					(
						for i = 1 to getnumsubmtls GetMtl do
							StatChnNum GetMtl[i] Mul Ble
					)
				else
					ChnCount += 1
			)
			
			fn H_Step_Count Count =
			(
				H_Step = (255/(ceil (Count/6.))) as integer
			)
			
			fn Step_Count =
			(
				if ChnCount <= H_Max then
				(
					H_Step_Count ChnCount
				)
				else
				(	
					if ChnCount <= (H_Max * V_Max) then
					(
						while (H_Max * V_Step) < ChnCount and V_Step <= V_Max do
							V_Step += 1
						H_Step_Count (ceil (ChnCount/(V_Step as float)))
					)
					else
					(
						H_Max += 6
						V_Max += 6
						Step_Count()
					)
				)
			)
			fn RandomColor =
			(
				Step_Count()
				
				Color_Var = #()
				for i = 0 to 255 by H_Step do
				(
					append Color_Var i
				)
				
				for j = 1 to V_Step do
				(
					StepTmp = (V_Step+1-j)/(V_Step as float)
					append ChannelsColor ((color 255 0 0)*StepTmp)
					append ChannelsColor ((color 0 255 0)*StepTmp)
					append ChannelsColor ((color 0 0 255)*StepTmp)
					append ChannelsColor ((color 255 255 0)*StepTmp)
					append ChannelsColor ((color 255 0 255)*StepTmp)
					append ChannelsColor ((color 0 255 255)*StepTmp)
					ColorVar_Count = Color_Var.count
					for i = 2 to (ColorVar_Count-1) do
					(
						append ChannelsColor ((color 255 0 Color_Var[i])*StepTmp)
						append ChannelsColor ((color 255 Color_Var[i] 0)*StepTmp)
						append ChannelsColor ((color 0 255 Color_Var[i])*StepTmp)
						append ChannelsColor ((color Color_Var[i] 255 0)*StepTmp)
						append ChannelsColor ((color 0 Color_Var[i] 255)*StepTmp)
						append ChannelsColor ((color Color_Var[i] 0 255)*StepTmp)
					)
				)

			)
			fn SetChn GetMtl SetMtl Mul Ble Opa =
			(
				if Classof GetMtl == blend and GetMtl.Mask != undefined and Ble == true then
				(
					SetMtl.mask = GetMtl.mask
					if Classof GetMtl.map1 == Blend and GetMtl.map1.Mask != undefined and Ble == true then
					(
						SetMtl.map1 = blend()
						SetMtl.map1.name = SetMtl.name + "_1"
						SetMtl.map1.mask = GetMtl.map1.mask
						SetChn GetMtl.map1 SetMtl.map1 Mul Ble Opa
					)
					else if Classof GetMtl.map1 == Multimaterial and Mul == true then
						(
							SetMtl.map1 = Multimaterial()
							SetMtl.map1.name = SetMtl.name + "_1"
							SetMtl.map1.materialList.count = GetMtl.map1.materialList.count
							SetMtl.map1.mapEnabled = GetMtl.map1.mapEnabled
							SetMtl.map1.materialIDList = GetMtl.map1.materialIDList
							SetChn GetMtl.map1 SetMtl.map1 Mul Ble Opa
						)
						else
						(
							SetMtl.map1 = Standard()
							SetMtl.map1.name = SetMtl.name + "_1"
							SetChn GetMtl.map1 SetMtl.map1 Mul Ble Opa
						)

					if Classof GetMtl.map2 == Blend and GetMtl.map2.Mask != undefined and Ble == true then
					(
						SetMtl.map2 = blend()
						SetMtl.map2.name = SetMtl.name + "_2"
						SetMtl.map2.mask = GetMtl.map2.mask
						SetChn GetMtl.map2 SetMtl.map2 Mul Ble Opa
					)
					else if Classof GetMtl.map2 == Multimaterial and Mul == true then
						(
							SetMtl.map2 = Multimaterial()
							SetMtl.map2.name = SetMtl.name + "_2"
							SetMtl.map2.materialList.count = GetMtl.map2.materialList.count
							SetMtl.map2.mapEnabled = GetMtl.map2.mapEnabled
							SetMtl.map2.materialIDList = GetMtl.map2.materialIDList
							SetChn GetMtl.map2 SetMtl.map2 Mul Ble Opa
						)
						else
						(
							SetMtl.map2 = Standard()
							SetMtl.map2.name = SetMtl.name + "_2"
							SetChn GetMtl.map2 SetMtl.map2 Mul Ble Opa
						)
				)
				else if Classof GetMtl == Multimaterial and Mul == true then
					(
						SetMtl.materialList.count = GetMtl.materialList.count
						SetMtl.mapEnabled = GetMtl.mapEnabled
						SetMtl.materialIDList = GetMtl.materialIDList
			
						for i = 1 to getnumsubmtls GetMtl do
						(
							if Classof GetMtl[i] == Blend and GetMtl[i].Mask != undefined and Ble == true then
							(
								SetMtl[i] = blend()
								SetMtl[i].name = SetMtl.name + "_" + i as string
								SetMtl[i].mask = GetMtl[i].mask
								SetChn GetMtl[i] SetMtl[i] Mul Ble Opa
							)
							else if Classof GetMtl[i] == Multimaterial and Mul == true then
								(
									SetMtl[i] = Multimaterial()
									SetMtl[i].name = SetMtl.name + "_" + i as string
									SetMtl[i].materialList.count = GetMtl[i].materialList.count
									SetMtl[i].mapEnabled = GetMtl[i].mapEnabled
									SetMtl[i].materialIDList = GetMtl[i].materialIDList
									SetChn GetMtl[i] SetMtl[i] Mul Ble Opa
								)
								else
								(
									SetMtl[i] = Standard()
									SetMtl[i].name = SetMtl.name + "_" + i as string
									SetChn GetMtl[i] SetMtl[i] Mul Ble Opa
								)
						)
					)
					else
					(
						SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
						ChnColNum += 1
						SetMtl.Selfillumination = 100
						SetMtl.Glossiness = 0
						SetMtl.Soften = 0
						SetMtl.name = "Channel_R" + ChannelsColor[ChnColNum].r as string + "_G" + ChannelsColor[ChnColNum].g as string + "_B" + ChannelsColor[ChnColNum].b as string
						if Opa == true do
						(
							try
							(
								SetMtl.Opacitymap = GetMtl.Opacitymap
								SetMtl.Opacity = GetMtl.Opacity
							)
							catch()
						)
					)
			)
			fn ColorChannels Mul Ble Opa UMO =
			(
				ChannelsColor = #()
				ChnCount = 0
				ChnColNum = 1
				ScnMtl = for a in sceneMaterials where (for b in objects where b.material == a collect b).count != 0 collect a
				ScnUnMtlObj = for a in objects where a.material == undefined and (superclassof a == GeometryClass or (superclassof a == shape and a.render_renderable == true)) collect a
				for GetMtl in ScnMtl do
				(
					StatChnNum GetMtl Mul Ble
				)
				if UMO == 1 then
					ChnCount += 1
				else
					ChnCount += ScnUnMtlObj.count
				RandomColor()
				for GetMtl in ScnMtl do
				(
					SetMtl = Standard()
					SetMtl.name = "Channel_" + GetMtl.name
					if Classof GetMtl == blend and GetMtl.Mask != undefined and Ble == true then
					(
						SetMtl = blend()
						SetMtl.name = "Channel_" + GetMtl.name
						SetChn GetMtl SetMtl Mul Ble Opa
					)
					else if Classof GetMtl == Multimaterial and Mul == true then
						(
							SetMtl = Multimaterial()
							SetMtl.name = "Channel_" + GetMtl.name
							SetChn GetMtl SetMtl Mul Ble Opa
						)
						else
						(
							SetMtl.name = "Channel_" + GetMtl.name
							SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
							ChnColNum += 1
							SetMtl.Selfillumination = 100
							SetMtl.Glossiness = 0
							SetMtl.Soften = 0
							if Opa == true do
							(
								try
								(
									SetMtl.Opacitymap = GetMtl.Opacitymap
									SetMtl.Opacity = GetMtl.Opacity
								)
								catch()
							)
						)
					(for a in objects where a.material == GetMtl collect a).material = SetMtl
				)
				if UMO == 1 then
				(
					SetMtl = Standard()
					SetMtl.name = "Channel_UnMtl" 
					SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
					ChnColNum += 1
					SetMtl.Selfillumination = 100
					SetMtl.Glossiness = 0
					SetMtl.Soften = 0
					ScnUnMtlObj.material = SetMtl
				)
				else
				(
					for a in ScnUnMtlObj do
					(
						SetMtl = Standard()
						SetMtl.name = "Channel_" + a.name
						SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
						ChnColNum += 1
						SetMtl.Selfillumination = 100
						SetMtl.Glossiness = 0
						SetMtl.Soften = 0
						a.material = SetMtl
					)
				)
			)
			fn MakeLib =
			(
				ChannelsColor = #()
				ChnCount = meditMaterials.count
				RandomColor()
				for i = 1 to meditMaterials.count do
				(
					meditMaterials[i] = Standard()
					meditMaterials[i].name = "Channel_" + i as string
					meditMaterials[i].Ambient = meditMaterials[i].diffuse = meditMaterials[i].Specular = ChannelsColor[i]
					meditMaterials[i].Selfillumination = 100
					meditMaterials[i].Glossiness = 0
					meditMaterials[i].Soften = 0
				)
			)
			fn FindMtl TheMtl Name =
			(
				if classof TheMtl == Standardmaterial do
				(
					TheMtl.Ambient = TheMtl.diffuse = TheMtl.Specular = ChannelsColor[ChnColNum]
					TheMtl.name = TheMtl.name + "_" + Name
				)
				if getNumSubMtls TheMtl > 0 and keyboard.escPressed != true do
				(
					for i = 1 to (getNumSubMtls TheMtl) do
					(
						FindMtl (getSubMtl TheMtl i) Name
					)
				)
			)
			
			fn For2Side TheMtl =
			(
				if classof TheMtl == Standardmaterial do
				(
					TheMtl.twoSided = true
				)
				if getNumSubMtls TheMtl > 0 and keyboard.escPressed != true do
				(
					for i = 1 to (getNumSubMtls TheMtl) do
					(
						For2Side (getSubMtl TheMtl i)
					)
				)
			)
			
			fn LayerChn Type =
			(
				ChannelsColor = #()
				ChnColNum = 1
				ChnCount = LayerManager.count
				RandomColor()
				ScnMtl = for a in sceneMaterials where (for b in objects where b.material == a collect b).count != 0 collect a
				LayerSet = #()
				if Type == 1 then
				(
					for i = 1 to LayerManager.count do
					(
						LayerSet[i] = for a in objects where a.INodeLayerProperties.layer.name == (LayerManager.getLayer (i-1)).name collect a
						for GetMtl in ScnMtl do
						(
							ObjTmp = for a in LayerSet[i] where a.material == GetMtl collect a
							if ObjTmp.count != 0 do
							(
								SetMtl = copy GetMtl
								SetMtl.name = GetMtl.name + "_" + (LayerManager.getLayer (i-1)).name
								FindMtl SetMtl (LayerManager.getLayer (i-1)).name
								ObjTmp.material = SetMtl
							)
						)
						ChnColNum += 1
					)
				)
				else
				(
					for i = 1 to LayerManager.count do
					(
						LayerSet[i] = for a in objects where a.INodeLayerProperties.layer.name == (LayerManager.getLayer (i-1)).name collect a
						SetMtl = standard()
						SetMtl.name = "Channel_" + (LayerManager.getLayer (i-1)).name
						SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
						ChnColNum += 1
						SetMtl.Selfillumination = 100
						SetMtl.Glossiness = 0
						SetMtl.Soften = 0
						LayerSet[i].material = SetMtl
					)
				)
			)
			fn GroupChn Type Sub =
			(
				ChannelsColor = #()
				ChnColNum = 1
				ScnMtl = for a in sceneMaterials where (for b in objects where b.material == a collect b).count != 0 collect a
				UnGrpObj = for a in objects where isGroupMember a == false and (superclassof a == GeometryClass or (superclassof a == shape and a.render_renderable == true)) collect a
				Grp = (for b in (for a in helpers where classof a == Dummy collect a) where isGroupHead b == true collect b)
				if Sub == false do
					Grp = for a in Grp where try isGroupHead a.parent == false catch true collect a
				if Type == 1 then
				(
					ChnCount = ScnMtl.count
					RandomColor()
					ScnMtl = for a in sceneMaterials where (for b in objects where b.material == a collect b).count != 0 collect a
					for i = 1 to Grp.count do
					(
						for GetMtl in ScnMtl do
						(
							if Sub == true then
								ObjTmp = for a in (for b in Grp[i] where b.parent == Grp[i] collect b) where a.material == GetMtl collect a
							else
								ObjTmp = for a in (for b in Grp[i] collect b) where a.material == GetMtl collect a
							if ObjTmp.count != 0 do
							(
								SetMtl = copy GetMtl
								SetMtl.name = GetMtl.name + "_" + Grp[i].name
								FindMtl SetMtl Grp[i].name
								ObjTmp.material = SetMtl
							)
						)
						ChnColNum += 1
					)
					for GetMtl in ScnMtl do
					(
						ObjTmp = for a in UnGrpObj where a.material == GetMtl collect a
						if ObjTmp.count != 0 do
						(
							SetMtl = copy GetMtl
							SetMtl.name = GetMtl.name + "_UnGroup"
							FindMtl SetMtl "UnGroup"
							ObjTmp.material = SetMtl
						)
						ChnColNum += 1
					)
				)
				else
				(
					ChnCount = Grp.count + UnGrpObj.count
					RandomColor()
					for i = 1 to Grp.count do
					(
						if Sub == true then
							ObjTmp = for a in Grp[i] where a.parent == Grp[i] collect a
						else
							ObjTmp = for a in Grp[i] Collect a
						SetMtl = standard()
						SetMtl.name = "Channel_" + Grp[i].name
						SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
						ChnColNum += 1
						SetMtl.Selfillumination = 100
						SetMtl.Glossiness = 0
						SetMtl.Soften = 0
						ObjTmp.material = SetMtl
					)
					for i = 1 to UnGrpObj.count do
					(
						SetMtl = standard()
						SetMtl.name = "Channel_" + UnGrpObj[i].name
						SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
						ChnColNum += 1
						SetMtl.Selfillumination = 100
						SetMtl.Glossiness = 0
						SetMtl.Soften = 0
						UnGrpObj[i].material = SetMtl
					)
				)
			)

			group ""
			(
				checkbox OnlyMtl "仅生成材质球  " pos:[10,15]
				checkbox UseGroup "仅按组划分" pos:[10,75]
				checkbox UseLayer "仅按层划分" pos:[10,50]
				checkbox SubGrp "识别子群组" pos:[10,95] enabled:false
				dropdownlist UnMtl "将无材质物体:" items:#("统一颜色","独立颜色") pos:[119,15] width:90
				checkbox BleMtl "识别混和材质  " checked:true pos:[108,80]
				checkbox IdMtl "识别多维材质  " checked:true pos:[108,60]
				checkbox OpaMtl "识别透明遮罩  " checked:true pos:[108,100]
			)
			group ""
			(
				checkbox CloseLight "自动关闭所有灯光     " checked:true offset:[0,-10]
				checkbox Force2Side "强制双面"
			)
			button Done "生成通道材质"
			
			on UseGroup changed state do
			(
				if UseGroup.checked == true then
				(
					UseLayer.enabled  = false
					UnMtl.enabled = false
					SubGrp.enabled = true
				)
				else
				(
					UseLayer.enabled  = true
					SubGrp.enabled = false
					UnMtl.enabled = true
				)
			)

			on UseLayer changed state do
			(
				if UseLayer.checked == true then
				(
					UnMtl.enabled = false
					UseGroup.enabled = false
				)
				else
				(
					UnMtl.enabled = true
					UseGroup.enabled = true
				)
			)
			
			on OnlyMtl changed state do
			(
				if OnlyMtl.checked == true then
				(
					UnMtl.enabled = false
					UseLayer.enabled = false
					UseGroup.enabled = false
					IdMtl.enabled = false
					BleMtl.enabled = false
					OpaMtl.enabled = false
					SubGrp.enabled = false
				)
				else
				(
					IdMtl.enabled = true
					BleMtl.enabled = true
					OpaMtl.enabled = true
					if UseLayer.checked == false and UseGroup.checked == false do
					(
						UnMtl.enabled = true
					)
					if UseLayer.checked == false do
						UseGroup.enabled = true
					if UseGroup.checked == false then
						UseLayer.enabled = true
					else
						SubGrp.enabled = true
				)
			)
			
			on Done pressed do with undo label:"材质通道" on
			(
				if OnlyMtl.checked == true then
					MakeLib()
				else
				(
					if BleMtl.checked == true or IdMtl.checked == true or OpaMtl.checked == true do
					(
						if UnMtl.selected == "统一颜色" then UMO = 1 else UMO = 2
						ColorChannels IdMtl.checked BleMtl.checked OpaMtl.checked UMO
					)
					if UseLayer.checked == true do
					(
						if BleMtl.checked == true or IdMtl.checked == true or OpaMtl.checked == true then
							LayerChn 1
						else
							LayerChn 2
					)
					if UseGroup.checked == true do
					(
						if BleMtl.checked == true or IdMtl.checked == true or OpaMtl.checked == true then
							GroupChn 1 SubGrp.checked
						else
							GroupChn 2 SubGrp.checked
					)
				)
				if CloseLight.checked == true do
					for a in lights do try a.on = false catch(try a.enabled = false catch())
				if Force2Side.checked do
				(
					for Mtl in scenematerials do
						For2Side Mtl
				)
			)
		)
		createDialog MakeChannels 220 210 pos:(mouse.screenPos - mouse.Pos)
	)
	MakeChannelsI()