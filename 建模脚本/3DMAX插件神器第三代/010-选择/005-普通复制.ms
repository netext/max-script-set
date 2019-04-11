(
-- deletefile @"C:\Users\concopy\temp.ini"
global MAXconvert
try(destroydialog MAXconvert)catch()
rollout MAXconvert "跨场模型"  
(
button but01 "复制带map"					offset:[0,0]		width:120			height:40			across:2
button but02 "粘贴带map"					offset:[0,0]		width:120			height:40
checkbox a1 "转换模型"						offset:[2,4]		checked:off								across:2
button but07 "使用说明"						offset:[0,0]		width:120			height:25	
button but04 "选择33131面和多维" 			offset:[0,0]		width:120			height:25			across:2
button but03 "平滑模型"						offset:[0,0]		width:120			height:25
button but05 "选择TurboSmooth"				offset:[0,0]		width:120								across:2
button but06 "删除TurboSmooth"				offset:[0,0]		width:120
button but09 "选择MeshSmooth"				offset:[0,0]		width:120								across:2
button but10 "删除MeshSmooth"				offset:[0,0]		width:120
button but11 "选择Shell"					offset:[0,0]		width:120								across:2
button but12 "删除Shell"					offset:[0,0]		width:120
button but13 "转换_复制_分离ID"				offset:[0,0]		width:120			height:40			across:2
button but14 "转换_粘贴"					offset:[0,0]		width:120			height:40
checkbox a2 "快"							pos:[93,55]			checked:off			enabled:false
button but15 "121齐步走:  QQ610280246"		pos:[60,231]			width:150			height:26
fn concopymod1=
(
if selection.count !=0 then 
	(
(--保存map
fn getFilesFromObjects objs =
(
	local mats = makeUniqueArray (for o in objs where (o.material !=undefined) collect o.material)
	local totalFiles = #()
	for m in mats do
	(	
		for b in getClassInstances bitmapTex target:m where b.filename != undefined do
		(
			if (doesFileExist b.filename ==false )then (local setname=mapPaths.getFullFilePath b.filename;if setname!="" then b.filename=setname)
			if (doesFileExist b.filename ==false )then ()else(appendIfUnique totalFiles b.filename)
		)
	)
	totalFiles
)
		savemaxfpath="C:\Users\\"+"concopy\\"
		if((dotNetclass "System.IO.Directory").Exists SavemaxfPath) then () else(MakeDir(SavemaxfPath))	
		if $ != undefined 
		then(
		files = getFiles (savemaxfpath+"\\*.*")
		for f in files do (deletefile f)
		aa=getFilesFromObjects selection
		for k in aa do 
		(
			copyfile k (savemaxfpath+(filenameFromPath k))
			)
		for obj in selection where ((IsKindOf obj Target_Light) or (IsKindOf obj Free_Light)or (IsKindOf obj Vrayies)) do
			(
				try (
					if (doesFileExist obj.ies_file ==false )then (obj.ies_file=mapPaths.getFullFilePath obj.ies_file)
					if (doesFileExist obj.ies_file ==false )then ()else(copyfile obj.ies_file (savemaxfpath+(filenameFromPath obj.ies_file) ))
					
					
					)
				catch(
					if (doesFileExist obj.webFile ==false )then (obj.webFile=mapPaths.getFullFilePath obj.webFile)
					if (doesFileExist obj.webFile ==false )then ()else(copyfile obj.webFile (savemaxfpath+(filenameFromPath obj.webFile) ))
					)
			)
		for DL in selection where (IsKindof DL vrayproxy) do
			(
			   if (doesFileExist DL.filename ==false )then (DL.filename=mapPaths.getFullFilePath DL.filename)
			   if (doesFileExist DL.filename ==false )then ()else(copyfile DL.filename (savemaxfpath+(filenameFromPath DL.filename))	)
				)
			)
		else(
			  messagebox "请选择需要复制的物体!"
			)
	
)
(--转换line为mesh,line.steps=3,line.sides=8,TurboSmooth和MeshSmooth的平滑值改为1
	for i in selection do 
	(
		if (superclassof i == shape and i.render_displayRenderMesh == true) then
	try(
			i.sides=8
			i.render_auto_smooth=off
			i.steps=4
			convertTo i TriMeshGeometry
		)catch()
		if (superclassof i == GeometryClass) then 
		(
			try		i.modifiers[#TurboSmooth].iterations=1	catch()
			try		i.modifiers[#TurboSmooth].isoline_display=off	catch()
		)
		if (superclassof i == GeometryClass) then 
		(
			try		i.modifiers[#MeshSmooth].iterations=1	catch()
			try		i.modifiers[#MeshSmooth].isolineDisplay=off	catch()
		)
	)
)
(--导出fbx
		dd="C:\Users\\"+"concopy\\"
			--if a2.checked==off then max freeze inv
			--if a2.checked==off then saveNodes $ (dd+"2.max")
fn rename_obj_gro=
(--按组改物体名
	OBJ_gro=for i in selection where isGroupHead i collect i
	for i in OBJ_gro do
		(
			RanName="group_"+(random 1 1000000000 as string)
			for j in i do if superclassof j==GeometryClass then (j.name=RanName)
		)
		
	OBJ_obj=for i in selection where (not isGroupMember i and not isGroupHead i) collect i
	for i in OBJ_obj do
		(
			RanName="object_"+(random 1 1000000000 as string)
			if superclassof i==GeometryClass then i.name=RanName
		)
)
rename_obj_gro()

local delmod

(--Blend材质
	selmore=selection as array
	delmod=#()
for i in selection do
	(
		if classof i.material==Blend then
		(
			local RanName="blendmat_"+(random 1 1000000000 as string)
			box1=box name:(RanName+"_"+1 as string);box1.material=i.material.map1
			box11=box name:(RanName+"_"+2 as string);box11.material=i.material.map2
			box111=box name:(RanName+"_"+3 as string);box111.material=vraymtl name:"3" texmap_diffuse:i.material.Mask
			i.name=replace RanName 6 3 ""
			join delmod #(box1)
			join delmod #(box11)
			join delmod #(box111)
		)
	)
	join selmore delmod
	selectmore selmore
)

		--FBXExporterSetParam "SmoothingGroups" true
		FBXExporterSetParam "FileVersion" "FBX200900"
		exportfile (dd+"1.fbx") #noprompt selectedOnly:on
			--if a2.checked==off then max delete;mergemaxfile (dd+"2.max") #mergedups #useSceneMtlDups #select
			--if a2.checked==off then unfreeze objects
--Blend材质
for i in delmod do delete i


)
	)
)
fn conpastemod1=
(
	oldtime=timeStamp()/1000 as float
	filepath="C:\Users\\"+"concopy\\"
	if doesFileExist (filepath+"1.fbx")==true then
	(
		clearSelection()
		max freeze inv
		FBXImporterSetParam "Skin" true
		try(importfile (filepath+"1.fbx") #noPrompt)catch()
		max select all
		--刷新物体单位
		fn refresh_obj obj=
			(
				--缓存属性
				tempN = obj.name
				tempP = obj.pivot
				tempC = obj.wirecolor
				tempM = obj.material
				--刷新物体
				b = convertToPoly(box())
				polyop.deleteFaces b #{1..b.numfaces}
				polyOp.attach b obj
-- 				--干掉大文件
				convertToMesh b
				newMesh=meshop.detachFaces b #{1..b.numfaces} delete:on asMesh:on
				delete b 
				emesh = Editable_mesh()
				emesh.mesh = newMesh
-- 					addModifier emesh (smooth autosmooth:on threshold:45)
-- 					convertToMesh emesh
				update emesh 
				--还原缓存属性
				emesh.name = tempN
				emesh.pivot = tempP
				emesh.wirecolor = tempC
				emesh.material = tempM
			)

		fn refresh_obj1 obj=
			(
				--缓存属性
				tempN = obj.name
				tempP = obj.pivot
				tempC = obj.wirecolor
				tempM = obj.material
				--干掉大文件
-- 				emesh = Editable_mesh()
-- 				meshop.attach emesh obj
				convertToMesh obj
				newMesh=meshop.detachFaces obj #{1..obj.numfaces} delete:on asMesh:on
				delete obj
				emesh = Editable_mesh()
				emesh.mesh = newMesh
				update emesh 
					addModifier emesh (smooth autosmooth:on threshold:45)
					convertToMesh emesh
				--还原缓存属性
				emesh.name = tempN
				emesh.pivot = tempP
				emesh.wirecolor = tempC
				emesh.material = tempM
			)
		sel=for j in selection where not isGroupHead j collect j
		for i in sel do (if superclassof i==GeometryClass then try(refresh_obj i)catch() else (if classof i==Dummy then delete i))
		max select all
		actionMan.executeAction 0 "63508" --showmap
		unfreeze objects
		files = getFiles (filepath+"\*.*")
		for i in files do (setFileAttribute i #readOnly false;deletefile i)
(--粘贴map
	savemaxfpath="C:\Users\\"+"concopy\\"
	if maxfilepath!="" then 
	(
		--创建map文件夹
		newmappath=maxfilepath+"\map\\"
		if((dotNetclass "System.IO.Directory").Exists newmappath) then () else(MakeDir(newmappath))	
	
		--复制排除max和fbx文件的贴图到新位置
		files = getFiles (savemaxfpath+"\\*.*")
		for f in files where (getFilenameType f !=".max" and getFilenameType f !=".fbx") do copyfile f (newmappath+(filenameFromPath f))
	)
)

(--合并同名材质
fn fl_sameItemNum arr =
(	
	local c,i=1,j,k
	local newArr=#(),newSameArr=#()
	sort arr					--sort the array
	while i<=arr.count do
	(	
		k=0
		j=i+1
		while j<=arr.count do
		(	
			if arr[j]==arr[i] do 
			(	
				if (findItem newSameArr arr[i])==0	do 
				(	
					append newSameArr arr[i]
						--collect the same value
				)
				append newArr j		--collect the same item
				k=k+1	
			)
			j=j+1
		) 
		i=i+k+1
	)
	#(newArr.count,newSameArr)	
)
(	
	allMtls=for i in sceneMaterials collect i.name	
	theSameMtls=(fl_sameItemNum allMtls)[2]
	m=theSameMtls.count
	if m==0 then 1 --messagebox "没有同名材质！" title:"助手提示"
	else
	(	with redraw off
		undo off
		(
		sceneObjs=objects as array
		for i=1 to m do
			(	sameMtlObjs=#()
				temp_mtl=sceneMaterials[theSameMtls[i]]
				for j in sceneObjs do
				( 	if (classof j.material)!=UndefinedClass then
						if j.material.name==temp_mtl.name then
							append sameMtlObjs j
				)
				for l in sameMtlObjs do
				(	l.material = temp_mtl
					obj_number = findItem sceneObjs l
					deleteItem sceneObjs obj_number
				)
			)
		)
		max views redraw
	)
)
)
fn newgroup=
(--按物体名成组
	getname=for i in selection collect i.name
	getname=makeUniqueArray getname
	for i in getname do 
	(
		local addgroup=#()
		for j in selection do 
		(
			if (filterstring i "_")[1]=="group" then 
			if i==j.name then join addgroup j
		)
		group addgroup name:i
	)
)
(--Blend材质
	global mat1
	global mat2
	global mat3
	global B_objmat
B_obj=for i in selection where (filterstring i.name "_")[1]=="blend" collect i
B_objmat=for i in selection where (filterstring i.name "_")[1]=="blendmat" collect i
for i in 1 to B_obj.count do
(
	B_obj_name=(filterstring B_obj[i].name "_")[2]
	for j in 1 to B_objmat.count do 
	(
		if (filterstring B_objmat[j].name "_")[2]==B_obj_name then
		(
			if (filterstring B_objmat[j].name "_")[3]=="1" then mat1=B_objmat[j].material
			if (filterstring B_objmat[j].name "_")[3]=="2" then mat2=B_objmat[j].material
			if (filterstring B_objmat[j].name "_")[3]=="3" then mat3=B_objmat[j].material
			try B_obj[i].material=Blend name:(B_obj[i].name) catch()
			try B_obj[i].material.map1=mat1 catch()
			try B_obj[i].material.map2=mat2 catch()
			try B_obj[i].material.Mask=mat3.texmap_diffuse catch()
		)
	)
)
for j in 1 to B_objmat.count do delete B_objmat[j]
)
newgroup()
	)
newtime=(timeStamp()/1000 as float)-oldtime
if newtime>60 then print((newtime1=newtime/60)as integer) as string+"(分)" 
else print ((newtime as integer)as string+"(秒)")
)
fn clear_color=
(	
type=Multimaterial
for i in geometry do 
	(
		if i.material!=unmaterial then
		(
			if classof i.material==type then
			(
				for j in i.material do
					if classof (j.texmap_diffuse)==Missing_TextureMap then  j.texmap_diffuse=undefined
			)else
			if classof (i.material.texmap_diffuse)==Missing_TextureMap then i.material.texmap_diffuse=undefined
		)
	)
)
fn detachid=
(
	--打开所有组
	max select all;max group open;max select all;max group open;max select all;max group open;max select all;max group open;max select all;max group open;max select all;max group open;max select all
	global SelGeoID
SelGeoID=for i in selection collect i
for j in 1 to SelGeoID.count do 
	(
		if (classof SelGeoID[j].material==Multimaterial) then 
		(
		select SelGeoID[j]
(
for i in objects do 
	(
		if i.name=="Object" then i.name="0"
		if i.name=="Object01" then i.name="0"
		if i.name=="Object02" then i.name="0"
		if i.name=="Object03" then i.name="0"
		if i.name=="Object04" then i.name="0"
		if i.name=="Object05" then i.name="0"
		if i.name=="Object06" then i.name="0"
		if i.name=="Object07" then i.name="0"
		if i.name=="Object08" then i.name="0"
		if i.name=="Object09" then i.name="0"
		if i.name=="Object10" then i.name="0"
		if i.name=="Object11" then i.name="0"
		if i.name=="Object12" then i.name="0"
		if i.name=="Object13" then i.name="0"
		if i.name=="Object14" then i.name="0"
		if i.name=="Object15" then i.name="0"
	)
convertToPoly($)
modPanel.addModToSelection (Edit_Poly ()) ui:on
-- if (classof selection[1].material==Multimaterial) then Multmat=($.material)
global Multmat=($.material)
fn SelID x=
	(
		$.modifiers[#Edit_Poly].SetSelection #Face #{}
		subobjectLevel = 4
		$.modifiers[#Edit_Poly].selectByMaterialID = x-1
		$.modifiers[#Edit_Poly].ButtonOp #SelectByMaterial
		$.modifiers[#Edit_Poly].DetachToObject ("Object0"+x as string)
		subobjectLevel = 0
		max views redraw
		try(if x==1 then $Object01.material=Multmat[x])catch()
		try(if x==2 then $Object02.material=Multmat[x])catch()
		try(if x==3 then $Object03.material=Multmat[x])catch()
		try(if x==4 then $Object04.material=Multmat[x])catch()
		try(if x==5 then $Object05.material=Multmat[x])catch()
		try(if x==6 then $Object06.material=Multmat[x])catch()
		try(if x==7 then $Object07.material=Multmat[x])catch()
		try(if x==8 then $Object08.material=Multmat[x])catch()
		try(if x==9 then $Object09.material=Multmat[x])catch()
		try(if x==10 then $Object10.material=Multmat[x])catch()
		try(if x==11 then $Object11.material=Multmat[x])catch()
	)
if Multmat.count==2 then (SelID 1;SelID 2)
if Multmat.count==3 then (SelID 1;SelID 2;SelID 3)
if Multmat.count==4 then (SelID 1;SelID 2;SelID 3;SelID 4)
if Multmat.count==5 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5)
if Multmat.count==6 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6)
if Multmat.count==7 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7)
if Multmat.count==8 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7;SelID 8)
if Multmat.count==9 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7;SelID 8;SelID 9)
if Multmat.count==10 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7;SelID 8;SelID 9;SelID 10)
if Multmat.count==11 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7;SelID 8;SelID 9;SelID 10;SelID 11)
if Multmat.count==12 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7;SelID 8;SelID 9;SelID 10;SelID 11;SelID 12)
if Multmat.count==13 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7;SelID 8;SelID 9;SelID 10;SelID 11;SelID 12;SelID 13)
if Multmat.count==14 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7;SelID 8;SelID 9;SelID 10;SelID 11;SelID 12;SelID 13;SelID 14)
if Multmat.count==15 then (SelID 1;SelID 2;SelID 3;SelID 4;SelID 5;SelID 6;SelID 7;SelID 8;SelID 9;SelID 10;SelID 11;SelID 12;SelID 13;SelID 14;SelID 15)
)
		)
	)
	--删除空物体
	for i in geometry do if (getPolygonCount i)[1]==0 then delete i
)
fn detachface1=
(
max select all
SelGeoFace=for i in selection collect i
for i in 1 to SelGeoFace.count do if (getPolygonCount SelGeoFace[i])[1]>33131 then selectmore SelGeoFace[i]
for i in 1 to SelGeoFace.count do if (getPolygonCount SelGeoFace[i])[1]>33131 then
	(
fn DetachFace=
	(
		if (getPolygonCount $)[1]>33131 then
		(
			convertToPoly($)
			modPanel.addModToSelection (Edit_Poly ()) ui:on
			subobjectLevel = 4
			$.modifiers[#Edit_Poly].SetSelection #Face #{}
			$.modifiers[#Edit_Poly].Select #Face #{1..30000}
			$.modifiers[#Edit_Poly].ButtonOp #DetachFace
			subobjectLevel = 0
			convertToPoly($)
		)
	)
		select SelGeoFace[i]
		num=(getPolygonCount $)[1]/33131
		if num==1 then (DetachFace())
		if num==2 then (DetachFace();DetachFace())
		if num==3 then (DetachFace();DetachFace();DetachFace())
		if num==4 then (DetachFace();DetachFace();DetachFace();DetachFace())
		if num==5 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==6 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==7 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==8 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==9 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==10 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==11 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==12 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==13 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==14 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==15 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==16 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==17 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==18 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==19 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==20 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==21 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==22 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==23 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==24 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==25 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==26 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==27 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==28 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==29 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())
		if num==30 then (DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace();DetachFace())

	)
)
fn concopymod=
(
if a2.checked!=true then saveNodes $ "c:\3.max"
	(
		max freeze inv
			try(detachid())catch()
			try(detachface1())catch()
			try(for i in Geometry do (	if classof i.material==Standardmaterial then (TempMap=i.material.diffuseMap;TempMap1=i.material.Diffuse;i.material=VRayMtl name:(random 100000000 1000000000 as string);i.material.texmap_diffuse=TempMap;i.material.Diffuse=TempMap1;i.material.showinviewport=true)))catch()
			
			--导出为FBX
		units.SystemType=#inches
			max select all
			exportfile "C:\\1.fbx"#noprompt selectedOnly:on
		unfreeze objects
		units.SystemType=#millimeters
	)
if a2.checked!=true then max delete;mergemaxfile "c:\3.max" #mergedups #useSceneMtlDups #select			
)
fn conpastemod=
(
if doesFileExist "C:\\1.fbx"==true then 
(
for i in objects do 
	(
		if i.name=="Object" then i.name="0"
		if i.name=="Object01" then i.name="0"
		if i.name=="Object02" then i.name="0"
		if i.name=="Object03" then i.name="0"
		if i.name=="Object04" then i.name="0"
		if i.name=="Object05" then i.name="0"
		if i.name=="Object06" then i.name="0"
		if i.name=="Object07" then i.name="0"
		if i.name=="Object08" then i.name="0"
		if i.name=="Object09" then i.name="0"
		if i.name=="Object10" then i.name="0"
		if i.name=="Object11" then i.name="0"
		if i.name=="Object12" then i.name="0"
		if i.name=="Object13" then i.name="0"
		if i.name=="Object14" then i.name="0"
		if i.name=="Object15" then i.name="0"
	)
	(
		units.SystemType=#inches
		clearSelection()
		max freeze inv
		importfile "C:\\1.fbx"#noprompt
		max select all
		try(saveNodes $ "C:\\2.max")catch()
		exportfile "C:\\1.3ds"#noprompt selectedOnly:on
		max delete
		importfile "C:\\1.3ds"#noprompt
		try(saveNodes $  "C:\\1.max")catch()
		max delete
		mergemaxfile "C:\\2.max"
		mergemaxfile "C:\\1.max" #mergedups #deleteolddups #useSceneMtlDups #select
		max select invert
		max delete
		max select invert
		try(for i in selection do if classof i==Dummy then delete i)catch()
		
		unfreeze objects
		actionMan.executeAction 0 "63508" --showmap
		actionMan.executeAction 0 "330"  -- Tools: Zoom Extents
		units.SystemType=#millimeters
		
		deletefile "C:\1.fbx"
		deletefile "C:\1.3ds"
		deletefile "C:\2.max"
		deletefile "C:\1.max"
		deletefile "C:\3.max"
	)
)
)
fn copymod=
(
(--保存map和保存模型
fn getFilesFromObjects objs =
(
	local mats = makeUniqueArray (for o in objs where (o.material !=undefined) collect o.material)
	local totalFiles = #()
	for m in mats do
	(	
		for b in getClassInstances bitmapTex target:m where b.filename != undefined do
		(
			if (doesFileExist b.filename ==false )then (setname=mapPaths.getFullFilePath b.filename;if setname!="" then b.filename=setname)
			if (doesFileExist b.filename ==false )then ()else(appendIfUnique totalFiles b.filename)
		)
	)
	totalFiles
)
		savemaxfpath="C:\Users\\"+"concopy\\"
		if((dotNetclass "System.IO.Directory").Exists SavemaxfPath) then () else(MakeDir(SavemaxfPath))	
		if $ != undefined 
		then(
		files = getFiles (savemaxfpath+"\\*.*")
		for f in files do (deletefile f)
		saveNodes $ (savemaxfpath+"3.max")
			
		aa=getFilesFromObjects selection
		for k in aa do 
		(
			copyfile k (savemaxfpath+(filenameFromPath k))
			)
		for obj in selection where ((IsKindOf obj Target_Light) or (IsKindOf obj Free_Light)or (IsKindOf obj Vrayies)) do
			(
				try (
					if (doesFileExist obj.ies_file ==false )then (obj.ies_file=mapPaths.getFullFilePath obj.ies_file)
					if (doesFileExist obj.ies_file ==false )then ()else(copyfile obj.ies_file (savemaxfpath+(filenameFromPath obj.ies_file) ))
					
					
					)
				catch(
					if (doesFileExist obj.webFile ==false )then (obj.webFile=mapPaths.getFullFilePath obj.webFile)
					if (doesFileExist obj.webFile ==false )then ()else(copyfile obj.webFile (savemaxfpath+(filenameFromPath obj.webFile) ))
					)
			)
		for DL in selection where (IsKindof DL vrayproxy) do
			(
			   if (doesFileExist DL.filename ==false )then (DL.filename=mapPaths.getFullFilePath DL.filename)
			   if (doesFileExist DL.filename ==false )then ()else(copyfile DL.filename (savemaxfpath+(filenameFromPath DL.filename))	)
				)
			)
		else(
			  messagebox "请选择需要复制的物体!"
			)
)
)
fn pastemod=
(
	savemaxfpath="C:\Users\\"+"concopy\\"
	if maxfilepath!="" then 
	(
		--创建map文件夹
		newmappath=maxfilepath+"\map\\"
		if((dotNetclass "System.IO.Directory").Exists newmappath) then () else(MakeDir(newmappath))	
		
		--复制排除max和fbx文件的贴图到新位置
		files = getFiles (savemaxfpath+"\\*.*")
		for f in files where (getFilenameType f !=".max" and getFilenameType f !=".fbx") do copyfile f (newmappath+(filenameFromPath f))
	)
		mergemaxfile (savemaxfpath+"3.max") #select #mergedups #renameMtlDups
		files = getFiles (savemaxfpath+"\*.*")
		for i in files do (setFileAttribute i #readOnly false;deletefile i)
)
fn smoothpoly=
(
if selection.count!=0 then
	(
		try
		(
			max select all
			modPanel.addModToSelection (Edit_Poly ()) ui:on
			subobjectLevel = 1
			max select all
			$[1].modifiers[#Edit_Poly].SetOperation #WeldVertex
			$[1].modifiers[#Edit_Poly].weldVertexThreshold = 0.00393701
			$[1].modifiers[#Edit_Poly].Commit ()
			subobjectLevel = 5
			max select all
			$[1].modifiers[#Edit_Poly].ButtonOp #Autosmooth
			$[1].modifiers[#Edit_Poly].smoothingGroupsToClear = 0
			$[1].modifiers[#Edit_Poly].ButtonOp #DetachFace
			subobjectLevel = 0
			max delete
		)catch
			try
			(
				max select all
				modPanel.addModToSelection (Edit_Poly ()) ui:on
				subobjectLevel = 1
				max select all
				$.modifiers[#Edit_Poly].SetOperation #WeldVertex
				$.modifiers[#Edit_Poly].weldVertexThreshold = 0.00393701
				$.modifiers[#Edit_Poly].Commit ()
				subobjectLevel = 5
				max select all
				$.modifiers[#Edit_Poly].ButtonOp #Autosmooth
				$.modifiers[#Edit_Poly].ButtonOp #DetachFace
				subobjectLevel = 0
				max delete
				hide $cad
			)catch()
	)
)
fn selectbyid=
(
	clearSelection()
	for i in objects do if ((getPolygonCount i)[1]>33131 or (classof i.material==Multimaterial)) then selectmore i 
)
on but13 pressed do (if (a1.checked==on and selection.count!=0) then concopymod() else copymod())
on but14 pressed do (if (a1.checked==on) then conpastemod() else pastemod())
on but01 pressed do (if (a1.checked==on and selection.count!=0) then concopymod1() else copymod())
on but02 pressed do (if (a1.checked==on) then conpastemod1() else pastemod())
on but03 pressed do try(smoothpoly())catch()
on but04 pressed do try(selectbyid())catch()
on but04 rightclick do try(unhide helpers Toggle;for i in helpers do try(try(setgroupopen i off)catch();try(setgroupopen i on)catch();try(delete i)catch())catch())catch()
on but05 pressed do try(hidebycategory.none();max unhide all;max select all;max group open;clearSelection();for i in Geometry do for j in i.modifiers where j.name == "TurboSmooth" do selectmore i)catch()
on but06 pressed do try(hidebycategory.none();max unhide all;max select all;max group open;clearSelection();for i in Geometry do for j in i.modifiers where j.name == "TurboSmooth" do deleteModifier i j )catch()
on but09 pressed do try(hidebycategory.none();max unhide all;max select all;max group open;clearSelection();for i in Geometry do for j in i.modifiers where j.name == "MeshSmooth" do selectmore i)catch()
on but10 pressed do try(hidebycategory.none();max unhide all;max select all;max group open;clearSelection();for i in Geometry do for j in i.modifiers where j.name == "MeshSmooth" do deleteModifier i j )catch()
on but11 pressed do try(hidebycategory.none();max unhide all;max select all;max group open;clearSelection();for i in Geometry do for j in i.modifiers where j.name == "Shell" do selectmore i)catch()
on but12 pressed do try(hidebycategory.none();max unhide all;max select all;max group open;clearSelection();for i in Geometry do for j in i.modifiers where j.name == "Shell" do deleteModifier i j )catch()
on but07 pressed do (messageBox "1、勾选(转换模型)则由高到低的版本复制,之后可用(平滑).\n2、不勾选(转换模型)则是同版本之间复制粘贴.\n3、(选择TurboSmooth)可以选择有平滑修改器的物体.\n4、(删除TurboSmooth)删除有平滑修改器的物体,省面.\n5、勾选(快)可加快转换速度." title:"转换提示")
on a1 changed a do 
	(
		if a then
			(
				but01.text="转换_复制带map"
				but02.text="转换_粘贴带map"
				a2.enabled=true
				MAXconvert.height=80 --233
				MAXconvert.title="转换复制"
				setinisetting "c:\users\max_comvert.ini" "1" "1" (a1.checked as string))
				else
				(
					but01.text="复制带map"
					but02.text="粘贴带map"
					a2.enabled=false
					MAXconvert.height=80
					setinisetting "c:\users\max_comvert.ini" "1" "1" (a1.checked as string)
					MAXconvert.title="普通复制"
			)
	)
on a2 changed a do (setinisetting "c:\users\max_comvert.ini" "1" "2" (a2.checked as string))
on MAXconvert open do 
	(
		if getinisetting "c:\users\max_comvert.ini" "1" "1"=="true" then 
		(
			a1.checked=true
			a2.enabled=true
			but01.text="转换_复制带map"
			but02.text="转换_粘贴带map"
			MAXconvert.height=80 --233
			MAXconvert.title="转换复制"
		)else MAXconvert.title="普通复制"
		if getinisetting "c:\users\max_comvert.ini" "1" "2"=="true" then a2.checked=true
	)
on MAXconvert close do 
	(
		MAXconvert=undefined
	)	
)
createdialog MAXconvert width:270 height:80
)
