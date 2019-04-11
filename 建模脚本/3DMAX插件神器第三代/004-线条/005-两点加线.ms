(
	
	if $ != undefined or superclassof $ == shape then 
(
(
	 a=#()
 p=#()
 for i in 1 to (numsplines $) do
     ( 
  b=getknotselection $ i
  append a b
   ) 
--print a  
  for j in 1 to a.count do 
      (
      for k in 1 to a[j].count do 
         (
       c=getknotpoint $ j a[j][k]
       append p c
      ) 
      )
--print "选择顶点数："+(p.count) as string
 if p.count ==2 then
  (
  newline = splineshape()
  addnewspline newline
  for i in 1 to p.count do 
     (
     addknot newline 1 #corner #curve p[i]
      ) 
  updateshape newline
  addandweld $ newline 1
   )
   else
   (
	actionMan.executeAction 0 "40043"  -- Selection: Select None
    messagebox "只能选择两个点！"
   )
   )
--modPanel.setCurrentObject $.baseObject
--subobjectLevel = 1
  actionMan.executeAction 0 "40021"
    splineOps.weld $
actionMan.executeAction 0 "40043"
)
else
messagebox"请选择线！"

)