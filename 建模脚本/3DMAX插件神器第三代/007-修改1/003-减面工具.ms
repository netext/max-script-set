(
global xhz_KuaiSuJianMian
try (destroydialog xhz_KuaiSuJianMian)catch()
rollout xhz_KuaiSuJianMian "批量减面工具(3dheima.com)" width:248 height:264
(
	GroupBox grp_Node "减面对象：" pos:[8,10] width:232 height:80
	checkbox chk_Sel "：选择物体" pos:[24,34] width:96 height:24 checked:true
	checkbox chk_Face "：物体面数" pos:[24,58] width:88 height:24 checked:false
	spinner spn_Face_Sel "" pos:[112,58] width:72 height:16 enabled:false range:[0,999999999,500] type:#integer
	button btn_Sel "选择" pos:[200,26] width:32 height:48 enabled:false tooltip:"选择场景物体等于物体面数的物体"
	GroupBox grp_Do "减面类型：" pos:[8,98] width:232 height:94
	checkbox chk_Val "：面数比例" pos:[24,122] width:96 height:24 checked:true
	spinner spn_NorVal "" pos:[128,122] width:56 height:16 range:[0,100,60] type:#integer
	checkbox chk_SubVal "：大约面数" pos:[24,150] width:96 height:24 checked:false
	spinner spn_SubVal "" pos:[128,150] width:56 height:16 enabled:false range:[0,1e+006,100]
	checkbutton ckb_Collapse "强制" pos:[190,122] width:42 height:44 enabled:off checked:on tooltip:"建议开启强制模式"
	button btn_GetFNum "？" pos:[212,168] width:20 height:20 tooltip:"查询面数,支持多物体"
	label lblNUM "" pos:[22,172] width:190 height:15
	checkbox chk_RestObj "：重建物体结构" pos:[24,196] width:200 height:24
	checkbox chk_Save "：保存" pos:[164,196] width:200 height:24 --checked:on
	button btn_Go "点   我   就   减   面" pos:[8,220] width:232 height:40 tooltip:"开始减面"
	


--local obj = for o in geometry where (getPolygonCount o)[1] >= spn_Face_Sel.value collect o

Fn delmod obj mod=(
i=obj.modifiers.count
while i>0 do(
if  obj.modifiers[i].name == mod then deleteModifier obj i
    i-=1))

Fn xhz_CollapseToIns obj style =
(
	local xhz_InsArray =#(), xhz_obj, Ins2 =#(), ori_sel_ori, ori_sel, obb, pos_center
	xhz_obj = obj as array
	ori_sel_ori = for e in xhz_obj collect e
	ori_sel = for e in xhz_obj collect e
	obb = for e in xhz_obj collect e
	pos_center = for i=1 to ori_sel.count collect ori_sel[i].center
	while obb.count >0 do
	(
		for o in obb do
		(
			num = InstanceMgr.GetInstances o &instances
			temp = Instances
			append xhz_InsArray temp
			for j in temp do
			(
				num2 = finditem obb j
				deleteitem obb num2
			)
		)
	)
	
	for i in xhz_obj do
	Undo on
	(
		case style of
		(
			1: ( if CanConvertTo i Mesh do ConvertTo i Editable_Mesh )
			2: ( if CanConvertTo i Editable_Poly do ConvertTo i Editable_Poly            )
		)
	)
	
	for o=1 to xhz_InsArray.count do ( append ins2 (xhz_InsArray[o])[1]; xhz_InsArray[o] = deleteitem (xhz_InsArray[o]) 1)
	try( for i=1 to Ins2.count do instancereplace xhz_InsArray[i] Ins2[i] )catch()
	for i in 1 to ori_sel_ori.count do move ori_sel_ori[i] (pos_center[i]-ori_sel_ori[i].center)
)
  
Fn Adv_JianMian =
(
  global JianMianWuTi = #()
  local MianBiLi
  local SubVercount
  local FaceNum = 0
  max create mode
  gc()
  if chk_Sel.checked == on then JianMianWuTi = getcurrentselection() else if chk_Face.checked == on then JianMianWuTi = for o in geometry where (getPolygonCount o)[1] >= spn_Face_Sel.value collect o
  for i in JianMianWuTi do FaceNum += (getPolygonCount i)[1]
  --for o in JianMianWuTi do o.isSelected = off
  clearSelection()
  if chk_Val.checked == on then (
  MianBiLi = spn_NorVal.value
  AddMultRes = ( MultiRes reqGenerate:off vertexPercent:MianBiLi )
  disableSceneRedraw()
  if chk_Save.checked == on do max file save
  for a in JianMianWuTi do ( addModifier a AddMultRes )
  )
  if chk_SubVal.checked == on then (
  for e in JianMianWuTi do (
  NO_Face = (getPolygonCount e)[1]
  MianBiLi = (NO_Face/spn_SubVal.value)
  addModifier e ( MultiRes reqGenerate:off vertexPercent:MianBiLi )
  ))
  if ckb_Collapse.checked == on do 
    (
     --for o in JianMianWuTi do o.isSelected = on
	 select JianMianWuTi
     max modify mode
    )
  for i in JianMianWuTi do try( i.modifiers[1].reqGenerate = on )catch()
  --if ckb_Collapse.checked == on then convertToMesh JianMianWuTi
  if ckb_Collapse.checked == on do ( for o in JianMianWuTi do o.isSelected = off )
  xhz_CollapseToIns JianMianWuTi 1
  --convertToMesh JianMianWuTi
  if chk_SubVal.checked == on do
  (
    FS = 0
	for i in JianMianWuTi do FS += (getPolygonCount i)[1]
    lblNUM.caption = "简化后实际面数为：" + FS as string + "/" + FaceNum as string
   )
  if chk_RestObj.checked == on do
     (
	   for i in JianMianWuTi do
	     (
		   ResetXForm i
		   convertToMesh i
		   ResetTransform i
		   ResetScale i
		   ResetPivot i
		 )
	 )
  gc()
  enableSceneRedraw()
  redrawviews()
)

on chk_Sel changed state do
(
  if chk_Sel.checked == on then ( chk_Face.checked = off; spn_Face_Sel.enabled=off; btn_Sel.enabled=off ) else ( chk_Face.checked = on; spn_Face_Sel.enabled=on; btn_Sel.enabled=on )
)
on chk_Face changed state do
(
  if chk_Face.checked == on then ( chk_Sel.checked = off; spn_Face_Sel.enabled=on; btn_Sel.enabled=on ) else ( chk_Sel.checked = on; spn_Face_Sel.enabled=off; btn_Sel.enabled=off )
)
--on spn_Face_Sel changed val do
--(
  
--)
on btn_Sel pressed do
(
  max select none
  select (for o in geometry where (getPolygonCount o)[1] >= spn_Face_Sel.value collect o)
)
on chk_Val changed state do
(
  if chk_Val.checked == on then ( spn_NorVal.enabled=on; chk_SubVal.checked = off; spn_SubVal.enabled=off ) else ( spn_NorVal.enabled=off; chk_SubVal.checked = on; spn_SubVal.enabled=on )
)
--on spn_NorVal changed val do
--(

--)
on chk_SubVal changed state do
(
  if chk_SubVal.checked == on then ( spn_SubVal.enabled=on; chk_Val.checked = off; spn_NorVal.enabled=off ) else ( spn_SubVal.enabled=off; chk_Val.checked = on; spn_NorVal.enabled=on )
)
--on spn_SubVal changed val do
--(

--)
on ckb_Collapse changed state do
(
  if ckb_Collapse.checked == on then ckb_Collapse.caption = "强制" else ckb_Collapse.caption = "不强制"
)
on btn_GetFNum pressed do
  (
    if chk_Sel.checked == on then JianMianWuTi = getcurrentselection() else if chk_Face.checked == on then JianMianWuTi = for o in geometry where (getPolygonCount o)[1] >= spn_Face_Sel.value collect o
    NO_Face = 0
	for i in JianMianWuTi do NO_Face += (getPolygonCount i)[1]
    lblNUM.caption = "面数为：" + NO_Face as string
   )
on btn_Go pressed do
(
  Undo "Adv_JianMian" off
  --if ckb_Collapse.checked != on then delmod a "MultiRes"; 
  try Adv_JianMian()catch(enableSceneRedraw();redrawviews())
)
)
CreateDialog xhz_KuaiSuJianMian
)