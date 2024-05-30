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

    res_list = (/"u3km","u15km","u60km"/)
    finame = "./2106In-Fa_" + res_list + ".txt"

    u3km_id = asciiread(finame(1),(/40,4/),"integer")
    u3km_time = toint(u3km_id(:,0))
    u3km_yyyy = u3km_time/1000000
    u3km_mmddhh = u3km_time - u3km_yyyy * 1000000

    u3km_mm = u3km_mmddhh/10000
    u3km_ddhh = u3km_mmddhh - u3km_mm * 10000
    u3km_dd = u3km_ddhh / 100
    u3km_hh  = u3km_ddhh - u3km_dd*100

    mn = u3km_hh ; ; create arrays [*] of required size
    sc = u3km_hh
    mn = 0
    sc = 0

    units = "hours since 2021-07-21 00:00:00"
    hours_time = cd_inv_calendar(u3km_yyyy, u3km_mm, u3km_dd, u3km_hh, mn, sc, units, 0)
    hours_time!0 = "hours"

    mn := CMA_hh ; ; create arrays [*] of required size
    sc := CMA_hh
    mn = 0
    sc = 0
    hours_time_CMA = cd_inv_calendar(CMA_yyyy, CMA_mm, CMA_dd, CMA_hh, mn, sc, units, 0)
    hours_time_CMA!0 = "hours"
    print(hours_time_CMA)

    u3km_id := asciiread(finame(1),(/40,4/),"float")
    u3km_lon = u3km_id(:,2)
    u3km_lat = u3km_id(:,1)

    static_path = "/home/jungu/storage/mesh/u15km"

    f_static = addfile(static_path + "/cell_fill.nc","r")

    latCell = f_static->latCell
    lonCell = f_static->lonCell
    latVoc  = f_static->latvoc
    lonVoc  = f_static->lonvoc
    full = latCell
    full = 1

    ter_colors = new((/27,4/),"float")
    cmap = read_colormap_file("MPL_RdYlBu")
    ter_colors = cmap(127:49:3,:)
    ter_cnlevels = fspan(-100,100,26)


    N_res = 2
    wks_type = "png"
    wks_type@wkWidth  = 1024*N_res;
    wks_type@wkHeight = 1024*N_res
    wks  = gsn_open_wks(wks_type,"Figure1c")   ; send graphics to PNG file

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
    res@mpMinLatF = 23.5
    res@mpMaxLatF = 24.25
    res@mpMinLonF = 124.5
    res@mpMaxLonF = 126
    ;res@pmTickMarkDisplayMode = "Always"

    res@mpDataSetName            = "Earth..4"
    res@mpDataBaseVersion        = "HighRes"
    res@mpOutlineOn              =  True
    res@mpGeophysicalLineColor      = "black"
    res@mpGeophysicalLineThicknessF = 2.0

    ;res@mpFillOn                 = False
    ;res@mpOceanFillColor         = "lightblue"
    ;res@mpInlandWaterFillColor = "lightblue"
    ;res@mpLandFillColor = "transparent"
    ;res@gsnCenterString = res@mpProjection+" Projection"

    res@tmXTOn = False
    res@tmYROn = False
    res@tmBorderThicknessF = 3*N_res
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
    ;res@tmXBValues = ispan(125,126,1)
    res@tmXBValues = fspan(124.5,126,7)
    sq = str_get_sq()
    colors = (/"Violetred","NavyBlue","dimgray"/)

    XBLabels = (/"124~S~o~N~30"+sq,"124~S~o~N~45"+sq,"125~S~o~N~","125~S~o~N~15"+sq,"125~S~o~N~30"+sq,"125~S~o~N~45"+sq,"126~S~o~N~"/) + "E"
    res@tmXBLabels = XBLabels
    res@tmYLMode = "Explicit"
    ;res@tmYLValues = 24
    res@tmYLValues = fspan(23.5, 24.25,4)
    YLLabels = (/"23~S~o~N~30" +sq,"23~S~o~N~45"+ sq,"24~S~o~N~","24~S~o~N~15" +sq/) + "N"
    res@tmYLLabels = "~F25~" + YLLabels

    res@tmXBLabelDeltaF = -0.5
    res@tmYLLabelDeltaF = -0.5
    res@tmXBLabelFontHeightF = 0.014
    res@tmYLLabelFontHeightF = 0.014
    res@tmBorderLineColor = colors(1)

    cnres = res
    cnres@cnFillDrawOrder = "Draw"
    cnres@cnFillMode = "CellFill"
    ;cnres@cnRasterSmoothingOn = True
    cnres@cnInfoLabelOn   = False
    cnres@cnFillOn        = True
    cnres@cnLinesOn       = False
    cnres@cnLineLabelsOn  = False
    cnres@cnLevelSelectionMode = "ExplicitLevels"
    cnres@cnLevels        :=(/0,2/)
    cnres@cnFillColors    := (/"white","lightblue","white"/)
    cnres@lbLabelBarOn    = False
    cnres@sfXArray =lonCell
    cnres@sfYArray =latCell
    cnres@sfXCellBounds = lonVoc
    cnres@sfYCellBounds = latVoc
    cnres@cnCellFillEdgeColor = "Gray45"
    cnres@cnConstFLabelOn = False
    cnres@cnConstFEnableFill = True


    ;-------Plot---------
    map = gsn_csm_contour_map(wks, full, cnres)
    ;map = gsn_csm_map(wks, res)
    print("draw map")
    mkres  = True
    mkres@gsMarkerIndex  = 16
    mkres@gsMarkerSizeF  = 0.01
    mkres@gsMarkerThicknessF  = 1.*N_res

    pres                  = True               ; polyline resources
    pres@gsLineThicknessF = 4*N_res                ; line thickness
    pres@gsLineColor      = "black"

    best_track = gsn_add_polyline(wks,map,CMA_lon,CMA_lat,pres); draw the traj
    best_track_mk = gsn_add_polymarker(wks,map,CMA_lon,CMA_lat,mkres); draw the traj

    pres@gsLineColor      = colors(1)
    mkres@gsMarkerColor  = colors(1)
    u3km_track = gsn_add_polyline(wks,map,u3km_lon,u3km_lat,pres); draw the traj
    u3km_track_mk = gsn_add_polymarker(wks,map,u3km_lon,u3km_lat,mkres); draw the traj

    txres = True
    txres@txFont = 25
    txres@txFontHeightF = 0.015
    txres@txFontColor = colors(1)
    repeat = 0
    do ihour =1, 39
        if(u3km_lon(ihour).eq.u3km_lon(ihour-1))then 
            repeat = repeat + 1
        else if(u3km_lon(ihour).ne.u3km_lon(ihour-1))
            repeat = 0
        end if
        end if
        u3km_track_text = gsn_add_text(wks,map,sprinti("%02i",toint(hours_time(ihour))),u3km_lon(ihour)+ .03,u3km_lat(ihour) + 0.07*repeat,txres)
    end do
    txres@txFontColor = "black"
    best_track_text = gsn_add_text(wks,map,sprinti("%02i",toint(hours_time_CMA)),CMA_lon+ .03,CMA_lat+.01,txres)


    draw(map)

    ;lgcolors = new(4,"string")
    ;lgcolors(0) = "black"
    ;lgcolors(1:3) = colors
    ;lgLabels = "~F25~" + (/"   Best Track ","   U3KM ","   U15KM ", "   U60KM "/)
    ;lgres = True
    ;;lgres@tfPolyDrawOrder = "Draw"

    ;lgres@vpWidthF = 0.2
    ;lgres@vpHeightF = 0.14
    ;lgres@lgAutoManage = False
    
    ;lgres@lgMonoDashIndex = True
    ;lgres@lgDashIndex = 0

    ;lgres@lgMonoItemType = True
    ;lgres@lgItemType = "MarkLines"

    ;lgres@lgMonoMarkerIndex = True
    ;lgres@lgMarkerIndex = 16
    ;lgres@lgMonoMarkerThickness = True
    ;lgres@lgMarkerThicknessF = 2
    ;lgres@lgMarkerSizeF = 0.01
    ;lgres@lgMarkerColors  = lgcolors

    ;lgres@lgMonoLineColor = False
    ;lgres@lgLineColors    = lgcolors
    ;lgres@lgMonoLineThickness = True
    ;lgres@lgLineThicknessF = 16

    ;lgres@lgBoxBackground = "Transparent"
    ;lgres@lgPerimFill           = "SolidFill"
    ;lgres@lgLabelStrings = lgLabels
    ;lgres@lgLabelFontHeightF = 0.06
    ;lgres@lgPerimOn = False
    ;lgres@lgItemCount =4
    ;lgres@lgItemOrder = (/3,2,1,0/)
    ;lgres@lgBoxMinorExtentF = 0.4
    ;gsn_legend_ndc(wks,4,lgLabels,0.7,0.8,lgres)
    ;print("draw legend")

    frame(wks)
end
