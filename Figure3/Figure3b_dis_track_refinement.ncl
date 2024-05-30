begin
    CMA                = "./2106In-Fa.txt"
    CMA_id = asciiread(CMA,(/28,6/),"integer")
    CMA_time = CMA_id(:,0)
    CMA_yyyy = CMA_time/1000000
    CMA_mmddhh = CMA_time - CMA_yyyy * 1000000

    CMA_mm = CMA_mmddhh/10000
    CMA_ddhh = CMA_mmddhh - CMA_mm * 10000

    CMA_dd = CMA_ddhh / 100
    CMA_hh  = CMA_ddhh - CMA_dd*100

    CMA_lon = tofloat(CMA_id(:,3))
    CMA_lat = tofloat(CMA_id(:,2))
    CMA_lon := CMA_lon/10
    CMA_lat := CMA_lat/10

    u3km = "./v3km_track/2106In-Fa_v3km_1540460.txt"
    u3km_id = asciiread(u3km,(/40,4/),"integer")
    u3km_time = toint(u3km_id(:,0))
    u3km_yyyy = u3km_time/1000000
    u3km_mmddhh = u3km_time - u3km_yyyy * 1000000

    u3km_mm = u3km_mmddhh/10000
    u3km_ddhh = u3km_mmddhh - u3km_mm * 10000
    u3km_dd = u3km_ddhh / 100
    u3km_hh  = u3km_ddhh - u3km_dd*100

    u3km_id := asciiread(u3km,(/40,4/),"float")
    u3km_lon = u3km_id(:,2)
    u3km_lat = u3km_id(:,1)

    v3km_2 = "./v3km_track/2106In-Fa_v3km_2441957.txt"
    v3km_2_id = asciiread(v3km_2,(/40,4/),"integer")
    v3km_2_time = toint(v3km_2_id(:,0))
    v3km_2_yyyy = v3km_2_time/1000000
    v3km_2_mmddhh = v3km_2_time - v3km_2_yyyy * 1000000

    v3km_2_mm = v3km_2_mmddhh/10000
    v3km_2_ddhh = v3km_2_mmddhh - v3km_2_mm * 10000
    v3km_2_dd = v3km_2_ddhh / 100
    v3km_2_hh  = v3km_2_ddhh - v3km_2_dd*100

    v3km_2_id := asciiread(v3km_2,(/40,4/),"float")
    v3km_2_lon = v3km_2_id(:,2)
    v3km_2_lat = v3km_2_id(:,1)

    v3km_3 = "./v3km_track/2106In-Fa_v3km_3056192.txt"
    v3km_3_id = asciiread(v3km_3,(/40,4/),"integer")
    v3km_3_time = toint(v3km_3_id(:,0))
    v3km_3_yyyy = v3km_3_time/1000000
    v3km_3_mmddhh = v3km_3_time - v3km_3_yyyy * 1000000

    v3km_3_mm = v3km_3_mmddhh/10000
    v3km_3_ddhh = v3km_3_mmddhh - v3km_3_mm * 10000
    v3km_3_dd = v3km_3_ddhh / 100
    v3km_3_hh  = v3km_3_ddhh - v3km_3_dd*100

    v3km_3_id := asciiread(v3km_3,(/40,4/),"float")
    v3km_3_lon = v3km_3_id(:,2)
    v3km_3_lat = v3km_3_id(:,1)

    N_res = 2
    wks_type = "png"
    wks_type@wkWidth  = 1024*N_res;
    wks_type@wkHeight = 1024*N_res
    wks  = gsn_open_wks(wks_type,"Figure3b")   ; send graphics to PNG file

    res                = True              ; plot mods desired
    res@gsnDraw        = False             ; don't draw the plots
    res@gsnFrame       = False             ; don't advance the frame
    res@gsnLeftString = ""
    res@gsnLeftStringFontHeightF = 0.023
    res@gsnStringFont = 25
    res@gsnLeftStringOrthogonalPosF = 0.02
    res@vpHeightF = 0.8
    res@vpWidthF = 0.8
    ;res@gsnCenterStringFontHeightF = 0.03  ; set the center string font height

    ;-------------------------------------------------------------------------------
    ;----------The following two resources, mpGridAndLimbOn and mpPerimOn, will be turned on
    ;----------and off depending on the map projections used below.
    ;-------------------------------------------------------------------------------  
    ;res@mpGridAndLimbOn   = True           ; turn on lat/lon lines
    ;res@mpPerimOn         = True               ; turn off perimeter

    ;res@mpGridLatSpacingF =  90            ; change latitude  line spacing
    ;res@mpGridLonSpacingF = 180.           ; change longitude line spacing
    ;res@mpGridLineColor   = "transparent"  ; trick ncl into drawing perimeter

    ;res@mpCenterRotF = 0.
    ;res@mpLeftAngleF = 10
    ;mas tickmark

    ;res@mpProjection = "Satellite"
    res@mpProjection = "CylindricalEquidistant"
    ;res@mpProjection = "CylindricalEquidistant"
    res@mpLimitMode = "LatLon"
    res@mpCenterLonF = 130
    res@mpMaxLatF = 45 + 1
    res@mpMinLatF = 5 - 1
    res@mpMaxLonF = 155 + 1
    res@mpMinLonF = 105 - 1
    ;res@pmTickMarkDisplayMode = "Always"

    res@mpDataSetName            = "Earth..4"
    res@mpDataBaseVersion        = "MediumRes"
    res@mpOutlineOn              =  True
    res@mpGeophysicalLineColor      = "black"
    res@mpGeophysicalLineThicknessF = 2.0

    res@mpFillOn                 = True
    res@mpOceanFillColor         = "lightblue"
    res@mpInlandWaterFillColor = "lightblue"
    res@mpLandFillColor = "tan"
    ;res@gsnCenterString = res@mpProjection+" Projection"
    res@tmXTOn = False
    res@tmYROn = False
    res@tmBorderThicknessF = 1.5*N_res
    res@tmYLMajorThicknessF = 2.5*N_res
    res@tmYLMajorLengthF    = 0.006
    res@tmYLMinorThicknessF = 2.5*N_res
    res@tmYLMinorLengthF    = 0.004
    res@tmXBMajorThicknessF = 2.5*N_res
    res@tmXBMajorLengthF    = 0.006
    res@tmXBMinorThicknessF = 2.5*N_res
    res@tmXBMinorLengthF    = 0.004
    res@tmXBLabelFont = 25
    res@tmYLLabelFont = 25

    res@tmXBMinorOn = True
    res@tmYLMinorOn = True
    res@tmXBMode = "Explicit"
    res@tmXBValues = ispan(105,155,10)
    res@tmXBMinorValues = ispan(104,156,1)
    res@tmXBLabels = "~F25~" + abs(res@tmXBValues) + "~S~o~N~E"
    res@tmYLMode = "Explicit"
    res@tmYLValues = ispan(5, 45,10)
    res@tmYLMinorValues = ispan(4, 46,1)
    res@tmYLLabels = "~F25~" + abs(res@tmYLValues) + "~S~o~N~N"

    res@tmXBLabelDeltaF = -0.5
    res@tmYLLabelDeltaF = -0.5
    res@tmXBLabelFontHeightF = 0.014
    res@tmYLLabelFontHeightF = 0.014


    ;-------Plot---------
    map = gsn_csm_map(wks,res)
    print("draw map")
    colors = (/"darkorchid4","tomato4","turquoise4"/)
    ;draw box lines
    lnres                  = True               ; polyline resources
    lnres@gsLineThicknessF = 5*N_res                ; line thickness
    ln_u3km_lon = (/105,135,135,105,105/)
    ln_u3km_lat = (/5,5,35,35,5/)

    lnres@gsLineColor      = colors(0) 
    u3km_box = gsn_add_polyline(wks,map,ln_u3km_lon,ln_u3km_lat,lnres); draw the traj 

    ln_v3km_lon = (/105+0.1,155,155,105+ 0.1,105 +0.1/)
    ln_v3km_lat = (/5-0.1,5-0.1,35-0.1,35-0.1,5-0.1/)
    lnres@gsLineColor      = colors(1) 
    v3km_box = gsn_add_polyline(wks,map,ln_v3km_lon,ln_v3km_lat,lnres); draw the traj 

    ln_v3km_3_lon = (/105+0.2,155+0.1,155+0.1,105+0.2,105+0.2/)
    ln_v3km_3_lat = (/5-0.2,5-0.2,45,45,5-0.2/)
    lnres@gsLineColor      = colors(2) 
    v3km_3_box = gsn_add_polyline(wks,map,ln_v3km_3_lon,ln_v3km_3_lat,lnres); draw the traj 

    mkres  = True
    mkres@gsMarkerIndex  = 16
    mkres@gsMarkerSizeF  = 0.01
    mkres@gsMarkerThicknessF  = 1.*N_res

    pres                  = True               ; polyline resources
    pres@gsLineThicknessF = 4*N_res                ; line thickness
    pres@gsLineColor      = "black"

    best_track = gsn_add_polyline(wks,map,CMA_lon,CMA_lat,pres); draw the traj
    ;best_track_mk = gsn_add_polymarker(wks,map,CMA_lon,CMA_lat,mkres); draw the traj

    pres@gsLineColor      = colors(0)
    mkres@gsMarkerColor  = colors(0)
    u3km_track = gsn_add_polyline(wks,map,u3km_lon,u3km_lat,pres); draw the traj
    ;u3km_track_mk = gsn_add_polymarker(wks,map,u3km_lon,u3km_lat,mkres); draw the traj

    pres@gsLineColor      = colors(1)
    mkres@gsMarkerColor  = colors(1)
    v3km_2_track = gsn_add_polyline(wks,map,v3km_2_lon,v3km_2_lat,pres); draw the traj

    pres@gsLineColor      = colors(2)
    v3km_3_track = gsn_add_polyline(wks,map,v3km_3_lon,v3km_3_lat,pres); draw the traj

    ;draw larger marker for 00h of that day
    mkres@gsMarkerIndex  = 16
    mkres@gsMarkerSizeF  = 0.01
    mkres@gsMarkerThicknessF  = 1.5*N_res

    txres = True
    txres@txFont = 25
    txres@txFontHeightF = 0.010

    ;for all plots add CMA track and time labels

    dum = 0
    dum8 = -1
    dum1 = 1
    do iCMA =0, 27
        if(CMA_hh(iCMA).eq.0)then
            txres@txFontColor = "Black"
            mkres@gsMarkerColor  = "Black"
            ;dum@$unique_string("")$ = gsn_add_text(wks,map,tostring(sprinti("%02i",CMA_dd(iCMA))),CMA_lon(iCMA) + .5,CMA_lat(iCMA) + 1.,txres)
            dum1@$unique_string("")$ = gsn_add_polymarker(wks,map,CMA_lon(iCMA),CMA_lat(iCMA),mkres)
            if(CMA_dd(iCMA).eq.25 .or. CMA_dd(iCMA).eq.26 .or. CMA_dd(iCMA).eq.24) then
                dum8@$unique_string("")$ = gsn_add_text(wks,map,tostring(sprinti("%02i",CMA_dd(iCMA))),CMA_lon(iCMA) + .5,CMA_lat(iCMA) + 1.,txres)
            end if
        end if
    end do

    dum = 2
    dum1 = 3
    dum4 = 9
    do iMPAS =0, 39
        if(u3km_hh(iMPAS).eq.0)then
            txres@txFontColor = colors(0)
            mkres@gsMarkerColor  = colors(0)
            dum1@$unique_string("u3km")$ = gsn_add_polymarker(wks,map,u3km_lon(iMPAS),u3km_lat(iMPAS),mkres)
            if(u3km_dd(iMPAS).eq.25 .or. u3km_dd(iMPAS).eq.26 .or. u3km_dd(iMPAS).eq.24) then
                dum@$unique_string("u3km")$ = gsn_add_text(wks,map,tostring(u3km_dd(iMPAS)),u3km_lon(iMPAS),u3km_lat(iMPAS)-1.,txres)
            end if
            txres@txFontColor = colors(1)
            mkres@gsMarkerColor  = colors(1)
            dum1@$unique_string("v3km_2")$ = gsn_add_polymarker(wks,map,v3km_2_lon(iMPAS),v3km_2_lat(iMPAS),mkres)
            if(u3km_dd(iMPAS).eq.25 .or. u3km_dd(iMPAS).eq.26 .or. u3km_dd(iMPAS).eq.24) then
                dum@$unique_string("v3km_2")$ = gsn_add_text(wks,map,tostring(v3km_2_dd(iMPAS)),v3km_2_lon(iMPAS) -.6,v3km_2_lat(iMPAS)-1.,txres)
            end if

            txres@txFontColor = colors(2)
            mkres@gsMarkerColor  = colors(2)
            dum1@$unique_string("v3km_3")$ = gsn_add_polymarker(wks,map,v3km_3_lon(iMPAS),v3km_3_lat(iMPAS),mkres)
            if(u3km_dd(iMPAS).eq.26) then
                dum4@$unique_string("v3km_3")$ = gsn_add_text(wks,map,tostring(v3km_3_dd(iMPAS)),v3km_3_lon(iMPAS) + 0.9,v3km_3_lat(iMPAS),txres)
            end if
        end if
    end do
    draw(map)

    lgcolors =  new(4,string)
    lgcolors(0) = "black"
    lgcolors(1:3) = colors
    lgLabels = "~F25~" + (/"   Best Track ","   V3KM_4 ","   V3KM_5 ", "   V3KM_6 "/)
    lgres = True
    ;lgres@tfPolyDrawOrder = "Draw"

    lgres@vpWidthF = 0.2
    lgres@vpHeightF = 0.14
    lgres@lgAutoManage = False
    
    lgres@lgMonoDashIndex = True
    lgres@lgDashIndex = 0

    lgres@lgMonoItemType = True
    lgres@lgItemType = "MarkLines"

    lgres@lgMonoMarkerIndex = True
    lgres@lgMarkerIndex = 16
    lgres@lgMonoMarkerThickness = True
    lgres@lgMarkerThicknessF = 2
    lgres@lgMarkerSizeF = 0.01
    lgres@lgMarkerColors  = lgcolors

    lgres@lgMonoLineColor = False
    lgres@lgLineColors    = lgcolors
    lgres@lgMonoLineThickness = True
    lgres@lgLineThicknessF = 16

    lgres@lgBoxBackground = "Transparent"
    lgres@lgPerimFill           = "SolidFill"
    lgres@lgLabelStrings = lgLabels
    lgres@lgLabelFontHeightF = 0.06
    lgres@lgPerimOn = False
    lgres@lgItemCount =4
    lgres@lgItemOrder = (/3,2,1,0/)
    lgres@lgBoxMinorExtentF = 0.4
    gsn_legend_ndc(wks,4,lgLabels,0.7,0.8,lgres)
    print("draw legend")

    frame(wks)
end
