rollout test "按id选择面" width:162 height:42
(
 button btn1 "点击一下试试!" pos:[21,12] width:120 height:20
 on btn1 pressed  do
 (
 obj = $
xhz_SelFaceArray = ( polyop.getFaceSelection obj ) as array
xhz_FaceID = for i=1 to xhz_SelFaceArray.count collect ( polyop.getFaceMatID obj xhz_SelFaceArray[i] )
for i=1 to xhz_FaceID.count do
(
xhz_SetFaceArray = #{}
for o=1 to (polyop.getNumFaces obj) do
(
if ( polyop.getFaceMatID obj o) == xhz_FaceID[i] do append xhz_SetFaceArray o
)
polyop.setFaceSelection obj xhz_SetFaceArray
update $
)

 )
)
createdialog test



