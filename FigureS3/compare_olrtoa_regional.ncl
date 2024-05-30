load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
    print_clock("start")
    RAD2DEG = get_r2d("double")
    gravity = 9.80665
    minlat = 0
    maxlat = 50
    minlon = 80
    maxlon = 160
    setfileoption("nc","Format","NetCDF4")

    case_prefix = "/home/jungu/storage/2106_In-Fa/"
    res_list = (/"u3km","v4km","u60km","v3km"/)
    var_list = (/"olrtoa"/)
    ;diag_paths = systemfunc("ls " + case_prefix + "u3km/seperate_vars/ensemble/ |grep mpas_diag  |grep -E '07-2[1-6]'|grep -E '00.00.00|06.00.00|12.00.00|18.00.00' |grep -Ev '07-26_[01][268]'")
    diag_paths = systemfunc("ls " + case_prefix + "u3km/seperate_vars/ensemble/ |grep mpas_diag  |grep -E '07-2[1-5]'")

    ERA5_path = "/home/jungu/storage/2106_In-Fa/analysis/data/ERA5/"
    ERA5_paths = systemfunc("ls " + ERA5_path + " |grep ERA5  |grep -E '07-2[1-5]'")
    ;ERA_finame = "/home/export/online1/mdt00/shisuan/swustc/jungu/MPAS/cases/2106_In-Fa/analysis/data/temperature_ERA5.nc"
    ;ERA5_fi = addfile(ERA_finame,"r")
    ;ERA5_time = ERA5_fi->time
    ;ERA5_temperature_all = ERA5_fi->temperature_850hPa
    ;cd_time = cd_calendar(ERA5_time,-3)

    ;ndiag = dimsizes(diag_paths)
    iDiag = 58

        print("" + diag_paths(iDiag))
        print("" + ERA5_paths(iDiag+2))
        timestamp := str_split(diag_paths(iDiag), ".")
        timestamp := timestamp(1)

        olrtoa_u3km_fi = addfile(case_prefix + res_list(0) + "/seperate_vars/ensemble/" + diag_paths(iDiag) + "/ERA5/" + var_list(0) + ".nc","r")
        olrtoa_u3km = olrtoa_u3km_fi->$var_list(0)$

        olrtoa_v4km_fi = addfile(case_prefix + res_list(1) + "/seperate_vars/ensemble/" + diag_paths(iDiag) + "/ERA5/" + var_list(0) + ".nc","r")
        olrtoa_v4km = olrtoa_v4km_fi->$var_list(0)$

        olrtoa_u60km_fi = addfile(case_prefix + res_list(2) + "/seperate_vars/ensemble/" + diag_paths(iDiag) + "/ERA5/" + var_list(0) + ".nc","r")
        olrtoa_u60km = olrtoa_u60km_fi->$var_list(0)$

        olrtoa_v3km_fi = addfile(case_prefix + res_list(3) + "/seperate_vars/ensemble/" + diag_paths(iDiag) + "/ERA5/" + var_list(0) + ".nc","r")
        olrtoa_v3km = olrtoa_v3km_fi->$var_list(0)$

        olrtoa_ERA5_fi = addfile(ERA5_path +  ERA5_paths(iDiag+2) + "/" +  var_list(0) + ".nc","r")
        olrtoa_ERA5 = olrtoa_ERA5_fi->$var_list(0)$

        diff = olrtoa_u3km -  olrtoa_v4km

        printMinMax(olrtoa_u3km, 1)
        printMinMax(olrtoa_v3km, 1)
        printMinMax(olrtoa_u60km, 1)
        printMinMax(olrtoa_v4km, 1)
        printMinMax(diff, 1)
        copy_VarCoords(olrtoa_u3km,diff)


        N_res = 2

        plot_name = "./Figure_olrtoa_" + timestamp

        wks_type = "png"
        wks_type@wkWidth  = 1024*N_res;
        wks_type@wkHeight = 1024*N_res
        wks = gsn_open_wks(wks_type,plot_name)

        temp_cmap  = read_colormap_file("WhiteBlueGreenYellowRed")
        white_color = temp_cmap(0,:)
        white_color(3) = 0
        temp_color = temp_cmap(248:8:-2,:)
        temp_cnlevels = fspan(90,210,121);121
        temp_colors = new((/122,4/),double)
        temp_colors(0:120,:) = temp_color
        temp_colors(121,:) = white_color

        diff_cmap  = read_colormap_file("BlueRed")
        diff_cnlevels = fspan(-100,100,51);121
        diff_colors = new((/52,4/),double)
        diff_colors(0:51,:) = diff_cmap(24:228:4,:)

        ;set uniform resources
        res = True
        res@gsnDraw = False
        res@gsnFrame= False
        res@gsnAddCyclic = True
        res@gsnMaximize  = False
        res@gsnLeftString = ""
        res@gsnStringFont = 25
        res@gsnStringFontHeightF = 0.022
        res@gsnLeftStringOrthogonalPosF = 0.02
        res@gsnRightString= ""
        res@tiMainString = ""

        mpres = res
        mpres@mpFillOn          = True
        mpres@mpDataBaseVersion = "LowRes"
        mpres@mpDataSetName     = "Earth..4"
        ;mpres@mpAreaMaskingOn   = True
        ;mpres@mpLandFillColor   = "Transparent"
        ;mpres@mpOceanFillColor  = "dodgerblue"
        mpres@mpGridAndLimbOn =  True
        mpres@mpGridLatSpacingF = 10
        mpres@mpGridLonSpacingF = 10
        mpres@mpGridLineThicknessF = 1.2*N_res
        mpres@mpGridLineDashPattern = 1

        mpres@mpOutlineOn       = True
        mpres@mpOutlineBoundarySets = "Geophysical"
        mpres@mpGeophysicalLineThicknessF = 3*N_res
        mpres@mpCenterLonF = 120
        mpres@mpMaxLatF = maxlat
        mpres@mpMinLatF = minlat
        mpres@mpMaxLonF = maxlon
        mpres@mpMinLonF = minlon

        mpres@cnFillOn = True

        mpres@tmXTOn = False
        mpres@tmYROn = False
        ;mpres@tmBorderThicknessF = 8.0
        mpres@tmBorderThicknessF = 2.5*N_res
        mpres@tmYLMajorThicknessF = 2.5*N_res
        mpres@tmYLMajorLengthF    = 0.006
        mpres@tmXBMajorThicknessF = 2.5*N_res
        mpres@tmXBMajorLengthF    = 0.006

        mpres@tmXBMinorOn = False
        mpres@tmYLMinorOn = False
        mpres@tmXBLabelDeltaF = -0.5
        mpres@tmYLLabelDeltaF = -0.5
        mpres@tmXBLabelFontHeightF = 0.017
        mpres@tmYLLabelFontHeightF = 0.017
        mpres@tmXBLabelFont = 25
        mpres@tmYLLabelFont = 25

        mpres@tmXBMode = "Explicit"
        mpres@tmXBValues = ispan(toint(minlon), toint(maxlon), 20)
        ;mpres@tmXBValues = ispan(-120, 180, 60)
        mpres@tmXBLabels = "~F25~" + abs(mpres@tmXBValues) + "~S~o~N~E"


        mpres@tmYLMode = "Explicit"
        mpres@tmYLValues = ispan(-20,80,20)
        YLLabels = new(6,string)
        YLLabels1 = "~F25~" + (/20/)+ "~S~o~N~S"
        YLLabels2 = "~F25~0~S~o~N~"
        YLLabels3 = "~F25~" + (/20,40,60,80/)+ "~S~o~N~N"
        YLLabels(0) = YLLabels1
        YLLabels(1) = YLLabels2
        YLLabels(2:5) = YLLabels3
        mpres@tmYLLabels = YLLabels

        ;;terrian_plot = gsn_csm_contour_map(wks,terrian,mpres)

        cnres = mpres
        cnres@vpWidthF = 0.6
        cnres@vpHeightF= 0.6
        cnres@cnFillDrawOrder = "Draw"
        cnres@cnFillMode = "RasterFill"
        cnres@cnRasterSmoothingOn = True
        cnres@cnInfoLabelOn   = False
        cnres@cnFillOn        = True
        cnres@cnLinesOn       = False
        cnres@cnLineLabelsOn  = False
        cnres@cnLevelSelectionMode = "ExplicitLevels"
        cnres@cnLevels        := temp_cnlevels
        cnres@cnFillColors    := temp_colors

        cnres@lbLabelBarOn    = False
        ;cnres@pmLabelBartemperatureF = 0.06
        ;cnres@pmLabelBarWidthF  = 0.55
        ;cnres@lbLabelFonttemperatureF = 0.015
        ;cnres@lbTitleString = "Precipitation [mm/h]";optional
        ;cnres@pmLabelBarOrthogonalPosF = 0.08
        ;cnres@lbTitlePosition = "Bottom"
        ;cnres@lbTitleFonttemperatureF = 0.015


        plot = new(2,graphic)
        ;cnres@gsnLeftString = "(a) ERA5"
        ;cnres@gsnRightString = ""
        ;plot(0) = gsn_csm_contour_map(wks,olrtoa_ERA5,cnres)

        cnres@gsnLeftString = "(a) U3KM"
        cnres@gsnRightString = ""
        plot(0) = gsn_csm_contour_map(wks,olrtoa_u3km,cnres)

        ;cnres@gsnLeftString = "(c) V3KM"
        ;cnres@gsnRightString = ""
        ;plot(2) = gsn_csm_contour_map(wks,olrtoa_v3km,cnres)

        ;cnres@gsnLeftString = "(d) U60KM"
        ;cnres@gsnRightString = ""
        ;plot(3) = gsn_csm_contour_map(wks,olrtoa_u60km,cnres)

        cnres@gsnLeftString = "(b) V4KM_28N117E"
        cnres@gsnRightString = ""
        plot(1) = gsn_csm_contour_map(wks,olrtoa_v4km,cnres)

        cnres@gsnLeftString = "(c) U3KM - V4KM_28N117E"
        cnres@gsnRightString = ""
        cnres@cnLevels        := diff_cnlevels
        cnres@cnFillColors    := diff_colors
        ;plot(2) = gsn_csm_contour_map(wks,diff,cnres)




        lnres=True
        lnres@gsLineColor = "black"
        lnres@gsLineDashPattern = 1
        lnres@gsLineThicknessF = 4.0 * N_res

        cen_lat = 28
        cen_lon = 117
        circle1    = geolocation_circle(cen_lat, cen_lon, 14.5, 0, 180, False)
        circle_lat1 = circle1[0]                   ; For clarity: explicitly extract list elements¬
        circle_lon1 = circle1[1]

        lnres@gsLineColor = "navyblue"
        dum11 = gsn_add_polyline(wks, plot(0), circle_lon1(0,0,:), circle_lat1(0,0,:), lnres)
        dum12 = gsn_add_polyline(wks, plot(1), circle_lon1(0,0,:), circle_lat1(0,0,:), lnres)
        ;dum13 = gsn_add_polyline(wks, plot(2), circle_lon1(0,0,:), circle_lat1(0,0,:), lnres)
        circle2    = geolocation_circle(cen_lat, cen_lon, 34, 0, 180, False)
        circle_lat2 = circle2[0]                   ; For clarity: explicitly extract list elements
        circle_lon2 = circle2[1]
        lnres@gsLineColor = "white"
        dum21 = gsn_add_polyline(wks, plot(0), circle_lon2(0,0,:), circle_lat2(0,0,:), lnres)
        dum22 = gsn_add_polyline(wks, plot(1), circle_lon2(0,0,:), circle_lat2(0,0,:), lnres)
        ;dum23 = gsn_add_polyline(wks, plot(2), circle_lon2(0,0,:), circle_lat2(0,0,:), lnres)

        txres = True
        txres@txFont = 26
        txres@txFontHeightF = 0.018
        txres@txDirection = "Across"
        txres@txAngleF = 0.
        ;gsn_text_ndc(wks, "UTC: " + timestamp, 0.5, 0.77, txres)

        ;Create common label
        lbres = True
        lbres@vpXF = 0.2
        lbres@vpYF = 0.35
        ;lbres@vpYF = 0.30
        lbres@vpWidthF = 0.6
        lbres@vpHeightF= 0.05

        lbres@lbPerimOn = False
        lbres@lbBoxLinesOn = True
        lbres@lbBoxSeparatorLinesOn = False
        lbres@lbBoxLineThicknessF = 1.2*N_res
        lbres@lbFillColors  := temp_colors
        lbres@lbOrientation = "horizontal"
        lbres@lbMonoFillPattern = True
        lbres@lbLabelFontHeightF = 0.015
        lbres@lbLabelAlignment   = "InteriorEdges"
        lbres@lbTitlePosition = "Bottom"
        lbres@lbTitleFontHeightF = 0.016
        lbres@lbTitleOffsetF = 0.2
        lbres@lbTitleExtentF = 0.25
        lbres@lbTitleString = "~F25~Outgoing longwave radiation flux (W/m~S~2~N~)";optional
        ;lbres@lbLabelStride = 5
        nboxes = dimsizes(temp_colors)
        labels = "~F25~"+temp_cnlevels
        lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
        draw(lbid)
        ;drawNDCGrid(wks)

        resP = True
        resP@gsnPanelLabelBar = False
        resP@gsnMaximize = True
        resP@gsnPanelRowSpec = True
        resP@gsnPanelCenter = True
        ;drawNDCGrid(wks)
        gsn_panel(wks,plot,(/3/),resP)
        print_clock("finish one")

;system("convert -trim -background white -density 128 " + plot_name + ".png  " +plot_name + ".png")
end
