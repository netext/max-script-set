--macroScript RenameThem category:"盖天工具" 

--(

rollout rename_rollout "【黑马设计网】出品-改名工具"

(


	
label LblName "None"
	
edittext prefix_txt "物体名字:"	
edittext base_name "要改名字:" 
button rename_them "-----改名------" 
	

on rename_them pressed do

(

if base_name.text != "" then

for i in selection do i.name =  base_name.text

)--end on

)--end rollout

Fn Fn_CallBack_RolSelectName01 =
 (
     try
     (
        TheSelection = Selection as array
         if TheSelection.count == 1 then

        (
		 rename_rollout.LblName.Text = TheSelection[1].Name   
			 
				 
			 
			 
		 )
         else
         (
             if TheSelection.count == 0 then( rename_rollout.LblName.Text = "None"
				 rename_rollout.prefix_txt.text="")
				 
             else if TheSelection.count ＞ 1 do rename_rollout.LblName.Text = TheSelection.Count as string + " Objects In Selection "
         )
		 
		 
		 if TheSelection.count == 1 then  
		 (if rename_rollout.LblName.Text ==TheSelection[1].Name   then   rename_rollout.prefix_txt.text=rename_rollout.LblName.Text)
		 
		 
		 
     )
     catch()
	 
 )

Callbacks.AddScript #SelectionSetChanged "Fn_CallBack_RolSelectName01()" ID:#TestName01
createDialog rename_rollout 400 100

--)
