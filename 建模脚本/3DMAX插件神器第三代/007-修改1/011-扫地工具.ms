 global kao=false
 global oldpos
 (
 try(destroydialog saodi)catch()
 tool sao
 (
 -- ha=false
  on freemove  do
  (
  
     $tem.pos=worldpoint
     oldpos=worldpoint
   
  )
  on mousePoint clickno do
  (
   if clickno==1 then
   (
  
   oldpos=worldpoint
    
   )
   else if clickno==2 or clickno==kao then ok
  )
  on mouseMove clickno do
  (
   
    try(
      --$tem.radius=saodi.spn5.value
      $tem.radius=saodi.spn5.value
      $tem.pos=worldpoint
      
    
      tem=worldpoint-oldpos
    
      if altkey then
      (
       mm=distance worldpoint oldpos
       saodi.spn5.value=mm --+ saodi.spn5.value
       $tem.radius=mm --+ saodi.spn5.value
      )
      else
      (
       if lbutton then
       (
        
        for e in selection do
        (
        
         if e.ishidden==false and e.isfrozen ==false then
         (
         --oldscale=e.scale
         juli=distance [e.pos.x,e.pos.y,0] [oldpos.x,oldpos.y,0]
          if  juli<=saodi.spn5.value then
          (
           if saodi.chk4.checked==false then
           (
            e.pos = e.pos+(tem*(saodi.spn5.value-juli)/saodi.spn5.value)
           )
           else
           (
            --e.scale=oldscale
            if not ctrlkey then
            (
             scale e [saodi.scal.value,saodi.scal.value,saodi.scal.value]
            )
            else
            (
             scale e [(1-(saodi.scal.value-1)),(1-(saodi.scal.value-1)),(1-(saodi.scal.value-1))]
            )
           )
          )
         )
        )
        
    
       )
      )
      
     if (not altkey) then
     (
     oldpos=worldpoint 
     )
     kao=false
    )catch()
  )
  on mouseAbort clickno do
  (
   delete $tem
  )
 )
 
 
 rollout saodi "扫地【黑马设计网】出品" width:167 height:170
 (
  button btn6 "扫帚" pos:[24,75] width:118 height:32
  spinner spn5 "半径" pos:[35,16] width:106 height:16 range:[0,1e+006,300] scale:1
  label lbl1 "  按 ALT 移动鼠标，可以改变半径值！ 在 Scale 勾选时按 Ctrl 键 可以缩小！" pos:[13,114] width:143 height:63
  spinner scal "Scale" pos:[48,48] width:104 height:16 enabled:false range:[0,2,1.01] type:#float
  checkbox chk4 "Checkbox" pos:[23,46] width:16 height:19
  on btn6 pressed do
  (
   if selection.count!=0 then
   (
   undo on
   (
   circle radius:spn5.value wirecolor:red  name:"tem"
   starttool sao
   )
   )
   else
   messagebox "请选择要 扫 的物体！！"
  )
  on spn5 changed val do
  (
   try(myc.radius=val)catch()
  )
  on chk4 changed state do
  (
   scal.enabled=state
  )
 ) 
  createdialog saodi
 )