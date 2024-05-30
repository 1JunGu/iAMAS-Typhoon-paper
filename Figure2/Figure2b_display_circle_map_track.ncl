begin
    CMA                = "../Figure1/2106In-Fa.txt"
    CMA_id = asciiread(CMA,(/28,6/),"integer")
    CMA_time = CMA_id(:,0)
    CMA_yyyy = CMA_time/1000000
    CMA_mmddhh = CMA_time - CMA_yyyy * 1000000

    CMA_mm = CMA_mmddhh/10000
    CMA_ddhh = CMA_mmddhh - CMA_mm * 10000

    CMA_dd = CMA_ddhh / 100
    CMA_hh  = CMA_ddhh - CMA_dd*100

    ;print(CMA_dd)
    ;print(CMA_hh)

    CMA_lon = tofloat(CMA_id(:,3))
    CMA_lat = tofloat(CMA_id(:,2))
    CMA_lon := CMA_lon/10
    CMA_lat := CMA_lat/10

    v2km                = "2106In-Fa_v4km_24N125E.txt"
    v2km_id = asciiread(v2km,(/40,4/),"integer")
    v2km_time = toint(v2km_id(:,0))
    v2km_yyyy = v2km_time/1000000
    v2km_mmddhh = v2km_time - v2km_yyyy * 1000000

    v2km_mm = v2km_mmddhh/10000
    v2km_ddhh = v2km_mmddhh - v2km_mm * 10000

    v2km_dd = v2km_ddhh / 100
    v2km_hh  = v2km_ddhh - v2km_dd*100

    print(v2km_dd)
    print(v2km_hh)

    v2km_id := asciiread(v2km,(/40,4/),"float")
    v2km_lon = v2km_id(:,2)
    v2km_lat = v2km_id(:,1)

    v4km                = "2106In-Fa_v4km_28N117E.txt"
    v4km_id = asciiread(v4km,(/40,4/),"integer")
    v4km_time =toint(v4km_id(:,0))
    v4km_yyyy = v4km_time/1000000
    v4km_mmddhh = v4km_time - v4km_yyyy * 1000000

    v4km_mm = v4km_mmddhh/10000
    v4km_ddhh = v4km_mmddhh - v4km_mm * 10000

    v4km_dd = v4km_ddhh / 100
    v4km_hh  = v4km_ddhh - v4km_dd*100

    print(v4km_dd)
    print(v4km_hh)
    v4km_id := asciiread(v4km,(/40,4/),"float")
    v4km_lon = v4km_id(:,2)
    v4km_lat = v4km_id(:,1)

    N_res = 2
    wks_type = "png"
    wks_type@wkWidth  = 1024*N_res;
    wks_type@wkHeight = 1024*N_res
    wks  = gsn_open_wks(wks_type,"Figure2b")   ; send graphics to PNG file

    res                = True              ; plot mods desired
    res@gsnDraw        = False             ; don't draw the plots
    res@gsnFrame       = False             ; don't advance the frame
    res@gsnCenterStringFontHeightF = 0.03  ; set the center string font height

    ;-------------------------------------------------------------------------------
    ;----------The following two resources, mpGridAndLimbOn and mpPerimOn, will be turned on
    ;----------and off depending on the map projections used below.
    ;-------------------------------------------------------------------------------  
    ;res@mpGridAndLimbOn   = True           ; turn on lat/lon lines
    ;res@mpPerimOn         = True               ; turn off perimeter

    ;res@mpGridLatSpacingF =  90            ; change latitude  line spacing
    ;res@mpGridLonSpacingF = 180.           ; change longitude line spacing
    ;res@mpGridLineColor   = "transparent"  ; trick ncl into drawing perimeter


    res@mpProjection = "Satellite"
    res@mpCenterLatF = 28
    res@mpCenterLonF = 117
    res@mpCenterRotF = 0.
    ;res@mpLeftAngleF = 10
    res@mpSatelliteDistF = 1.3
    ;res@mpProjection = "CylindricalEquidistant"
    ;res@mpProjection = "CylindricalEquidistant"
    ;res@mpLimitMode = "LatLon"
    ;res@mpMaxLatF = 62
    ;res@mpMinLatF = -14
    ;res@mpMaxLonF = 160
    ;res@mpMinLonF = 90
    ;res@pmTickMarkDisplayMode = "Always"

    res@mpDataSetName            = "Earth..4"
    res@mpDataBaseVersion        = "HighRes"
    res@mpOutlineOn              =  True
    res@mpGeophysicalLineColor      = "black"
    res@mpGeophysicalLineThicknessF = 2.0
    res@mpOceanFillColor = "lightblue"
    res@mpInlandWaterFillColor = "lightblue"
    res@mpLandFillColor = "tan"
    res@mpPerimOn = False
    res@mpGridAndLimbOn  =True
    res@mpGridLineColor = "transparent"
    ;res@gsnCenterString = res@mpProjection+" Projection"
    ;res@tmXTOn = False
    ;res@tmYROn = False
    ;res@tmBorderThicknessF = 2.5*N_res
    ;res@tmYLMajorThicknessF = 2.5*N_res
    ;res@tmYLMajorLengthF    = 0.005
    ;res@tmXBMajorThicknessF = 2.5*N_res
    ;res@tmXBMajorLengthF    = 0.005
    ;res@tmXBLabelFont = 25
    ;res@tmYLLabelFont = 25

    ;res@tmXBMinorOn = False
    ;res@tmYLMinorOn = False
    ;res@tmXBLabelDeltaF = -0.5
    ;res@tmYLLabelDeltaF = -0.5
    ;res@tmXBLabelFontHeightF = 0.018
    ;res@tmYLLabelFontHeightF = 0.018

    cnres = res
    cnres@cnFillDrawOrder = "Draw"
    cnres@cnFillOn = True
    cnres@cnLinesOn = False
    cnres@cnInfoLabelOn   = False
    cnres@cnLineLabelsOn  = False

    cnres@cnFillMode = "RasterFill"
    cnres@cnRasterSmoothingOn = True
    ;cnres@sfXArray = lonCell
    ;cnres@sfYArray = latCell

    cnres@cnLevelSelectionMode = "ExplicitLevels"
    ;cnres@cnLevels        = mslp_cnlevels
    ;cnres@cnFillColors    = mslp_colors

    cnres@gsnLeftString            = ""
    cnres@gsnLeftStringFontHeightF = 0.017
    cnres@gsnRightString            = ""
    cnres@gsnRightStringFontHeightF = 0.017
    cnres@lbLabelBarOn    = False
    cnres@tmGridDrawOrder = "Draw"

    ;-------Plot---------
    map = gsn_csm_map(wks,res)
    print("draw map")
    vcres                       = res
    vcres@vcGlyphStyle          = "LineArrow"
    vcres@vcRefLengthF          = 0.03
    vcres@vcLineArrowColor      = "Black"
    vcres@vcFillArrowFillColor  = "Black"
    vcres@vcLineArrowThicknessF = 1.5*N_res
    vcres@vcFillArrowEdgeThicknessF = 3*N_res
    vcres@vcFillArrowEdgeColor  = "Black"
    vcres@vcMinDistanceF        = 0.025
    vcres@vcVectorDrawOrder     = "PostDraw"
    ;vcres@vcMinMagnitudeF       = 0.

    vcres@vcRefAnnoOn               = True
    vcres@vcRefMagnitudeF           = 20.0
    vcres@vcRefAnnoString1          = "20"
    vcres@vcRefAnnoString2          = "[m/s]"
    vcres@vcRefAnnoPerimOn          = True
    vcres@vcRefAnnoJust             = "TopRight"
    vcres@vcRefAnnoSide             = "Top"
    vcres@vcRefAnnoOrthogonalPosF   = -0.218
    vcres@vcRefAnnoParallelPosF     = 1.0
    vcres@vcRefAnnoBackgroundColor  = "white"
    vcres@vcRefAnnoFont = 25
    vcres@vcRefAnnoFontHeightF = 0.017
    vcres@gsnLeftString            = ""
    vcres@gsnRightString            = ""
    vcres@tmGridDrawOrder = "Draw"

    ;vector = gsn_csm_vector(wks,u10,v10,vcres)
    ;print("draw vector")
    ;overlay(contour,vector)

    lnres=True
    lnres@gsLineColor = "firebrick3"
    lnres@gsLineDashPattern = 1
    lnres@gsLineThicknessF = 4.0*N_res

    ;---Attach a single blue hollow circle marker to the map
    cen_lat = 28;30.4
    cen_lon = 117;118.5
    circle1    = geolocation_circle(cen_lat, cen_lon, 14.5, 0, 180, False)
    circle_lat1 = circle1[0]                   ; For clarity: explicitly extract list elements
    circle_lon1 = circle1[1]
    ;printVarSummary(circle_lat1)
    dum1 = gsn_add_polyline(wks, map, circle_lon1(0,0,:), circle_lat1(0,0,:), lnres)

    lnres@gsLineColor = "gray"
    cen_lat = 28
    cen_lon = 117
    circle3    = geolocation_circle(cen_lat, cen_lon, 34, 0, 180, False) ;v16
    circle_lat3 = circle3[0]                   ; For clarity: explicitly extract list elements
    circle_lon3 = circle3[1]
    dum3 = gsn_add_polyline(wks, map, circle_lon3(0,0,:), circle_lat3(0,0,:), lnres)


    lnres@gsLineColor = "blueviolet"
    cen_lat = 24
    cen_lon = 125
    circle2    = geolocation_circle(cen_lat, cen_lon, 14.5, 0, 180, False) ;v16
    circle_lat2 = circle2[0]                   ; For clarity: explicitly extract list elements
    circle_lon2 = circle2[1]
    dum2 = gsn_add_polyline(wks, map, circle_lon2(0,0,:), circle_lat2(0,0,:), lnres)

    lnres@gsLineColor = "lightsalmon"
    cen_lat = 24
    cen_lon = 125
    circle3    = geolocation_circle(cen_lat, cen_lon, 34, 0, 180, False) ;v16
    circle_lat3 = circle3[0]                   ; For clarity: explicitly extract list elements
    circle_lon3 = circle3[1]
    ;dum4 = gsn_add_polyline(wks, map, circle_lon3(0,0,:), circle_lat3(0,0,:), lnres)


    pres                  = True               ; polyline resources
    pres@gsLineThicknessF = 4*N_res                ; line thickness
    pres@gsLineColor      = "black"

    mkres  = True
    mkres@gsMarkerIndex  = 16
    mkres@gsMarkerSizeF  = 0.005
    mkres@gsMarkerThicknessF  = 1.*N_res

    mkres@gsMarkerColor = "black"
    best_track = gsn_add_polyline(wks,map,CMA_lon,CMA_lat,pres); draw the traj
    best_track_mk = gsn_add_polymarker(wks,map,CMA_lon,CMA_lat,mkres); draw the traj

    pres@gsLineColor      = "blueviolet"
    mkres@gsMarkerColor = "blueviolet"
    v3km_track = gsn_add_polyline(wks,map,v2km_lon,v2km_lat,pres); draw the traj
    v3km_track_mk = gsn_add_polymarker(wks,map,v2km_lon,v2km_lat,mkres); draw the traj

    pres@gsLineColor      = "firebrick3"
    mkres@gsMarkerColor      = "firebrick3"
    v4km_track = gsn_add_polyline(wks,map,v4km_lon,v4km_lat,pres); draw the traj
    v4km_track_mk = gsn_add_polymarker(wks,map,v4km_lon,v4km_lat,mkres); draw the traj

    txres = True
    txres@txFontHeightF = 0.012
    txres@txFont = 25
    txres@txFontColor = "Black"

    dum = 0
    dum12 = 21
    do iCMA =0, 27
        if(CMA_hh(iCMA).eq.0.and.(CMA_dd(iCMA).eq.21 .or. CMA_dd(iCMA).eq.25 .or. CMA_dd(iCMA).eq.26))then
            txres@txFontColor = "Black"
            dum@$unique_string("")$ = gsn_add_text(wks,map,tostring(sprinti("%02i",CMA_dd(iCMA))),CMA_lon(iCMA),CMA_lat(iCMA)+0.7,txres)
            mkres@gsMarkerColor  = "Black"
            dum12@$unique_string("")$ = gsn_add_polymarker(wks,map,CMA_lon(iCMA),CMA_lat(iCMA),mkres)
        end if
    end do

    dum = 2
    dum13 = 3
    do iMPAS =0, 39
        if(v2km_hh(iMPAS).eq.0.and.(v2km_dd(iMPAS).eq.21 .or. v2km_dd(iMPAS).eq.25 .or. v2km_dd(iMPAS).eq.26))then
            txres@txFontColor = "blueviolet"
            mkres@gsMarkerColor  = "blueviolet"
            dum@$unique_string("v2km")$ = gsn_add_text(wks,map,tostring(v2km_dd(iMPAS)),v2km_lon(iMPAS),v2km_lat(iMPAS)-0.7,txres)
            dum13@$unique_string("v2km")$ = gsn_add_polymarker(wks,map,v2km_lon(iMPAS),v2km_lat(iMPAS),mkres)

            txres@txFontColor = "firebrick3"
            mkres@gsMarkerColor  = "firebrick3"
            dum@$unique_string("v4km")$ = gsn_add_text(wks,map,tostring(v4km_dd(iMPAS)),v4km_lon(iMPAS),v4km_lat(iMPAS)-0.7,txres)
            dum13@$unique_string("v4km")$ = gsn_add_polymarker(wks,map,v4km_lon(iMPAS),v4km_lat(iMPAS),mkres)

        end if
    end do

    draw(map)

    lgLabels = "~F25~" + (/"   Best Track ","   V4KM_24N125E","   V4KM_28N117E"/)
    lgres = True
    lgres@tfPolyDrawOrder = "PostDraw"

    lgres@vpWidthF = 0.18
    lgres@vpHeightF = 0.09
    lgres@lgAutoManage = False

    lgres@lgMonoDashIndex = True
    lgres@lgDashIndex = 0

    lgres@lgMonoItemType = True
    lgres@lgItemType = "MarkLines"

    lgres@lgMonoMarkerIndex = True
    lgres@lgMarkerIndex = 16
    lgres@lgMonoMarkerThickness = True
    lgres@lgMarkerThicknessF = 2
    lgres@lgMarkerSizeF = 0.008
    lgres@lgMarkerColors  = (/"Black","blueviolet","firebrick3"/)

    lgres@lgMonoLineColor = False
    lgres@lgLineColors    = (/"Black","blueviolet","firebrick3"/)

    lgres@lgBoxBackground = "Transparent"
    lgres@lgMonoLineThickness = True
    lgres@lgLineThicknessF = 14

    ;lgres@lgLabelStrings = lgLabels
    lgres@lgPerimFill            = "SolidFill"
    lgres@lgLabelFontHeightF = 0.045
    lgres@lgPerimOn = False
    lgres@lgItemCount = 3
    lgres@lgItemOrder = (/2,1,0/)
    lgres@lgBoxMinorExtentF = 0.25
    gsn_legend_ndc(wks,3,lgLabels,0.35,0.63,lgres)

    frame(wks)
end
