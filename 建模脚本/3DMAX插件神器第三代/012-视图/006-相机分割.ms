(
        rollout ro_imageCompHelper "黄金分割线:" width:90 height:169
        (
                
                checkbutton ckb_thirds "三分法则" pos:[1,77] width:88 height:22 highlightColor:(color 162 162 0) toolTip:"" checked:false
                checkbutton ckb_golden "黄金比例" pos:[1,123] width:88 height:22 highlightColor:(color 185 140 0) toolTip:"" checked:false
                checkbutton ckb_cross "中心十字" pos:[1,146] width:88 height:22 highlightColor:(color 0 55 150) toolTip:"" checked:false
                checkbutton ckb_diagonals "对角线" pos:[1,100] width:88 height:22 highlightColor:(color 130 0 0) toolTip:"" checked:false
                GroupBox grp_custom "自定义:" pos:[1,0] width:88 height:76
                spinner spn_XDivs "X Divs:" pos:[5,15] width:80 height:16 range:[0,999,4] type:#integer scale:1
                spinner spn_YDivs "Y Divs:" pos:[5,33] width:80 height:16 range:[0,999,4] type:#integer scale:1
                checkbutton ckb_custom "自定义" pos:[3,52] width:84 height:22 highlightColor:(color 0 125 0) toolTip:"" checked:false
 
                fn drawLines=
                (
                        if ckb_thirds.checked or ckb_golden.checked or ckb_cross.checked or ckb_diagonals.checked or ckb_custom.checked do
                        (
                                --General Calculation of Drawing Field:
                                offsetX = 0
                                offsetY = 0
                                fieldX = 0
                                fieldY = 0
                                winX = gw.getWinSizeX()
                                winY = gw.getWinSizeY()
                                winAspect = winX as float / winY as float
                                renAspect = renderWidth as float / renderHeight as float
                                --if width > height:
                                if winAspect > renAspect then
                                (
                                        fieldFactor = winY as float / renderHeight as float
                                        fieldY = winY
                                        fieldX = fieldFactor * renderWidth
                                        offsetX = (winX - fieldX)/2 + 1
                                )--end if
                                --if height > width:
                                else
                                (
                                        fieldFactor = winX as float / renderWidth as float
                                        fieldX = winX
                                        fieldY = fieldFactor * renderHeight
                                        offsetY = (winY - fieldY)/2 + 1
                                )--end else
                                
                                --Custom:
                                if ckb_custom.checked do
                                (
                                        if (displaysafeframes==false) do (displaysafeframes=true)        
                                        if spn_XDivs.value > 0 do
                                        (
                                                b = fieldX / (spn_XDivs.value+1) as float
                                                for i=1 to spn_XDivs.value do
                                                (                                        
                                                        gw.wPolyline #([i*b+offsetX, 0+offsetY, 0], [i*b+offsetX, fieldY+offsetY-1, 0]) true rgb:#((color 10 175 0),(color 10 175 0))
                                                )--end for
                                        )--end if
                                        if spn_YDivs.value > 0 do
                                        (
                                                h = fieldY / (spn_YDivs.value+1) as float
                                                for i=1 to spn_YDivs.value do
                                                (                                        
                                                        gw.wPolyline #([0+offsetX, i*h+offsetY, 0], [fieldX+offsetX-1, i*h+offsetY, 0]) true rgb:#((color 10 175 0),(color 10 175 0))
                                                )--end for
                                        )--end if
                                )--end if
                                
                                --Rule of Thirds:
                                if ckb_thirds.checked do
                                (
                                        if (displaysafeframes==false) do (displaysafeframes=true)        
                                        b = fieldX / 3
                                        h = fieldY / 3
                                        gw.wPolyline #([b+offsetX, 0+offsetY, 0], [b+offsetX, 3*h+offsetY-1, 0]) true rgb:#((color 202 202 0), (color 202 202 0))
                                        gw.wPolyline #([2*b+offsetX, 0+offsetY, 0], [2*b+offsetX, 3*h+offsetY-1, 0]) true rgb:#((color 222 222 0), (color 222 222 0))
                                        gw.wPolyline #([0+offsetX, h+offsetY, 0], [3*b+offsetX-1, h+offsetY, 0]) true rgb:#((color 222 222 0), (color 222 222 0))
                                        gw.wPolyline #([0+offsetX, 2*h+offsetY, 0], [3*b+offsetX-1, 2*h+offsetY, 0]) true rgb:#((color 222 222 0), (color 222 222 0))
                                )--end if
                                
                                --Diagonals:
                                if ckb_diagonals.checked do
                                (
                                        if (displaysafeframes==false) do (displaysafeframes=true)        
                                        gw.wPolyline #([0+offsetX, 0+offsetY, 0], [fieldX+offsetX, fieldY+offsetY, 0]) true rgb:#((color 180 0 0),(color 180 0 0))
                                        gw.wPolyline #([0+offsetX, fieldY+offsetY, 0], [fieldX+offsetX, 0+offsetY, 0]) true rgb:#((color 180 0 0),(color 180 0 0))
                                )--end if
                                
                                --Golden Ratio:
                                if ckb_golden.checked do
                                (
                                        if (displaysafeframes==false) do (displaysafeframes=true)        
                                        gldX = fieldX as float / 1.6180
                                        gldY = fieldY as float / 1.6180
                                        gw.wPolyline #([gldX+offsetX, 0+offsetY, 0], [gldX+offsetX, fieldY+offsetY-1, 0]) true rgb:#((color 255 140 0), (color 255 140 0))
                                        gw.wPolyline #([fieldX-gldX+offsetX, 0+offsetY, 0], [fieldX-gldX+offsetX, fieldY+offsetY-1, 0]) true rgb:#((color 255 140 0), (color 255 140 0))
                                        gw.wPolyline #([0+offsetX, gldY+offsetY, 0], [fieldX+offsetX-1, gldY+offsetY, 0]) true rgb:#((color 255 140 0), (color 255 140 0))
                                        gw.wPolyline #([0+offsetX, fieldY-gldY+offsetY, 0], [fieldX+offsetX-1, fieldY-gldY+offsetY, 0]) true rgb:#((color 255 140 0), (color 255 140 0))
                                )--end if
                                
                                --Center Cross:
                                if ckb_cross.checked do
                                (
                                        if (displaysafeframes==false) do (displaysafeframes=true)        
                                        b = fieldX / 2
                                        h = fieldY / 2
                                        gw.wPolyline #([b+offsetX, 0+offsetY, 0], [b+offsetX, fieldY+offsetY-1, 0]) true rgb:#((color 0 105 200),(color 0 105 200))
                                        gw.wPolyline #([0+offsetX, h+offsetY, 0], [fieldX+offsetX-1, h+offsetY, 0]) true rgb:#((color 0 105 200),(color 0 105 200))
                                )--end if
                                
                                gw.enlargeUpdateRect #whole
                                gw.updateScreen()
                                redrawViews()
                        )--end if
                )--end fn

                on ro_imageCompHelper open do
                (
                        unregisterRedrawViewsCallback drawLines
                        registerRedrawViewsCallback drawLines
                        if (displaysafeframes==false) do (displaysafeframes=true)        
                        max views redraw --redraw all views to show the safe frame immediately after starting the script
                )--end on
                on ro_imageCompHelper close do
                (
                        unregisterRedrawViewsCallback drawLines
                        max views redraw
                )--end on
                on ckb_thirds changed theState do
                (
                        max views redraw
                )--end on
                on ckb_golden changed theState do
                (
                        max views redraw
                )--end on
                on ckb_cross changed theState do
                (
                        max views redraw
                )--end on
                on ckb_diagonals changed theState do
                (
                        max views redraw
                )--end on
                on spn_XDivs changed theValue do
                (
                        max views redraw
                )--end on
                on spn_YDivs changed theValue do
                (
                        max views redraw
                )--end on
                on ckb_custom changed theState do
                (
                        max views redraw
                )--end on
        )
        try(destroyDialog ro_imageCompHelper)catch()
        createDialog ro_imageCompHelper
)--end macro
