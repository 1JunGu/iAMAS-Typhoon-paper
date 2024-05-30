begin
    setfileoption("nc", "Format","NetCDF4" )
    case_path = "/storage/jungu/2106_In-Fa/"
    res_list = (/"u3km","v3km","v4km","u60km"/)
    track_path = "/storage/jungu/2106_In-Fa/analysis/track/"

    mesh_path = "/home/jungu/storage/2106_In-Fa/mesh/" + res_list + "/cell_fill.nc"

    if(.not.isvar("ires"))then
        print("Please selecet diag path, such as: u3km")
        exit
    end if
    print("NCL: plotting "+  res_list(ires))

    csv_filename = "./steering_csv/2106In-Fa_" + res_list(ires) + ".txt"
    system("rm -f " + csv_filename)                ; Remove file in case it exists.
    fields = (/"TIME", "uzonal", "umeridional"/)
    ;---Create a header line for CSV file
    dq     = str_get_dq()
    fields = dq + fields + dq                      ; Pre/append quotes to field names
    header = [/str_join(fields,",")/]              ; Header is field names separated
    ; by commas.
    ;
    ; Format to use for writing each variable to CSV file.
    ; If you don't want spaces in CSV file, use the following
    ; format string:
    ;     format = "%s,%g,%g,%g"
    ; 
    format = "%s,%6.4f,%6.4f"
    write_table(csv_filename, "w", header, "%s")   ; Write header to CSV file.

    ;do ires = 2, 2
        ;read track info and zoom region of interest
        track_id = asciiread(track_path + res_list(ires) + "/2106In-Fa_" + res_list(ires) + ".txt",(/40,4/),"float")
        track_lon = tofloat(track_id(:,2))
        track_lat = tofloat(track_id(:,1))
        minlon = min(track_lon) -8.
        minlat = min(track_lat) -8.
        maxlon = max(track_lon) +8.
        maxlat = max(track_lat) +8.
        print("" + minlon + " " + minlat + " " + maxlat + " " + maxlon)

        ;read lat*lon info
        cell_fi = addfile(mesh_path(ires), "r")
        latCell = cell_fi->latCell
        lonCell = cell_fi->lonCell

        cell_ind := ind(latCell.ge.minlat.and.latCell.le.maxlat.and.\
                        lonCell.ge.minlon.and.lonCell.le.maxlon)
        latCell_subset := latCell(cell_ind)
        lonCell_subset := lonCell(cell_ind)

        ;prepare mpas data info
        mpas_out_path = case_path + res_list(ires) + "/seperate_vars/ensemble/mpas_out/"
        mpas_out_dirs = systemfunc("ls " + mpas_out_path)
        mpas_path = mpas_out_path + mpas_out_dirs + "/"
        ;nfiles = dimsizes(mpas_path)
        ;Steeringflow_U = new(40,double)
        ;Steeringflow_V = new(40,double)
        do ifile = 0, 39 
            ;ensure timestamp
            timestamp := str_split(mpas_out_dirs(ifile), ".")
            timestamp := timestamp(1)
            print("" + timestamp)
            ;create circle
            cen_lat = track_lat(ifile)
            cen_lon = track_lon(ifile)

            crad = 3
            urad = 0; 0 means degress and 1 meas kilometers
            N = 360; # of points; more points nicer 'circle'
            circle_inner = geolocation_circle(cen_lat,cen_lon,crad,urad,N,False)
            circle_inner_lat = circle_inner[0]
            circle_inner_lon = circle_inner[1]
            crad = 7
            circle_outer = geolocation_circle(cen_lat,cen_lon,crad,urad,N,False)
            circle_outer_lat = circle_outer[0]
            circle_outer_lon = circle_outer[1]

            cell_circle_inner = gc_inout(latCell_subset,lonCell_subset,circle_inner_lat(0,0,:),circle_inner_lon(0,0,:))
            cell_circle_outer = gc_inout(latCell_subset,lonCell_subset,circle_outer_lat(0,0,:),circle_outer_lon(0,0,:))

            u_isobaric_fi = addfile(mpas_path(ifile) + "uzonal_isobaric.nc", "r")
            u_isobaric = u_isobaric_fi->uzonal_isobaric(cell_ind,:)

            v_isobaric_fi = addfile(mpas_path(ifile) + "umeiridional_isobaric.nc", "r")
            v_isobaric = v_isobaric_fi->umeiridional_isobaric(cell_ind,:)

            DeepLayerMean_300_850hPa_U = dim_avg_n_Wrap(u_isobaric,1)
            DeepLayerMean_300_850hPa_V = dim_avg_n_Wrap(v_isobaric,1)

            DeepLayerMean_300_850hPa_U = where(cell_circle_outer,DeepLayerMean_300_850hPa_U,DeepLayerMean_300_850hPa_U@_FillValue)
            DeepLayerMean_300_850hPa_U = where(cell_circle_inner,DeepLayerMean_300_850hPa_U@_FillValue,DeepLayerMean_300_850hPa_U)
            DeepLayerMean_300_850hPa_V = where(cell_circle_outer,DeepLayerMean_300_850hPa_V,DeepLayerMean_300_850hPa_V@_FillValue)
            DeepLayerMean_300_850hPa_V = where(cell_circle_inner,DeepLayerMean_300_850hPa_V@_FillValue,DeepLayerMean_300_850hPa_V)

            Steeringflow_U = dim_avg_n_Wrap(DeepLayerMean_300_850hPa_U,0)
            Steeringflow_V = dim_avg_n_Wrap(DeepLayerMean_300_850hPa_V,0)
            ;DeepLayerMean_wspd = wind_speed(DeepLayerMean_300_850hPa_U, DeepLayerMean_300_850hPa_V)
            ;printVarSummary(DeepLayerMean_wspd)
            ;DeepLayerMean_wspd = where(cell_circle,DeepLayerMean_wspd,DeepLayerMean_wspd@_FillValue)
            ;printMinMax(Steeringflow_wspd,1)
            alist = [/timestamp,Steeringflow_U,Steeringflow_V/]   ; Store data to be written in a list.
            write_table(csv_filename, "a", alist, format)     ; Write list to CSV file.


   ; N_res = 4
   ; plot_name = "./test_circle/" + timestamp

   ; wks_type = "png"
   ; wks_type@wkWidth  = 1024*N_res;
   ; wks_type@wkHeight = 1024*N_res
   ; wks = gsn_open_wks(wks_type,plot_name)

   ; cmap  = read_colormap_file("wind_17lev")
   ; colors = cmap(0:17:1,:)
   ; cnlevels = fspan(2,36,17)
   ; print(cnlevels)

   ; ;set uniform resources
   ; res = True
   ; res@gsnDraw = False
   ; res@gsnFrame= False
   ; res@gsnAddCyclic = True
   ; res@gsnMaximize  = False
   ; res@gsnLeftString = ""
   ; res@gsnStringFont = 25
   ; res@gsnStringFontHeightF = 0.017
   ; res@gsnLeftStringOrthogonalPosF = 0.02
   ; res@gsnRightString= ""

   ; mpres = res
   ; mpres@mpFillOn          = True
   ; mpres@mpDataBaseVersion = "LowRes"
   ; mpres@mpDataSetName     = "Earth..4"

   ; mpres@mpOutlineOn       = True
   ; mpres@mpOutlineBoundarySets = "Geophysical"
   ; mpres@mpGeophysicalLineThicknessF = 3*N_res
   ; ;display grid line
   ; mpres@mpGridAndLimbOn = True
   ; mpres@mpGridLatSpacingF = 1.0
   ; mpres@mpGridLonSpacingF = 1.0
   ; mpres@mpGridLineThicknessF = 1.2*N_res
   ; mpres@mpGridLineDashPattern = 1

   ; mpres@cnFillOn = True

   ; mpres@tmXTOn = False
   ; mpres@tmYROn = False
   ; ;mpres@tmBorderThicknessF = 8.0
   ; mpres@tmBorderThicknessF = 2.5*N_res
   ; mpres@tmYLMajorThicknessF = 2.5*N_res
   ; mpres@tmYLMajorLengthF    = 0.006
   ; mpres@tmXBMajorThicknessF = 2.5*N_res
   ; mpres@tmXBMajorLengthF    = 0.006

   ; mpres@tmXBMinorOn = False
   ; mpres@tmYLMinorOn = False
   ; mpres@tmXBLabelDeltaF = -0.5
   ; mpres@tmYLLabelDeltaF = -0.5
   ; mpres@tmXBLabelFontHeightF = 0.014
   ; mpres@tmYLLabelFontHeightF = 0.014
   ; mpres@tmXBLabelFont = 25
   ; mpres@tmYLLabelFont = 25


   ; cnres = mpres
   ; cnres@vpWidthF = 0.5
   ; cnres@vpHeightF= 0.5
   ; cnres@cnFillDrawOrder = "Draw"
   ; cnres@cnFillMode = "RasterFill"
   ; cnres@cnRasterSmoothingOn = True
   ; ;cnres@cnFillMode = "CellFill"
   ; cnres@cnInfoLabelOn   = False
   ; cnres@cnFillOn        = True
   ; cnres@cnLinesOn       = False
   ; cnres@cnLineLabelsOn  = False
   ; cnres@cnLevelSelectionMode = "ExplicitLevels"
   ; cnres@cnLevels        := cnlevels
   ; cnres@cnFillColors    := colors

   ; cnres@lbLabelBarOn    = False

   ; mstring = "k" 
   ; fontnum = 35
   ; xoffset = 0.0 
   ; yoffset = 0.0 
   ; ratio   = 1.0 
   ; size    = 0.4
   ; angle   = 0.0
   ; TC_marker = NhlNewMarker(wks, mstring, fontnum, xoffset, yoffset, ratio, size, angle)
   ; mkres = True
   ; mkres@gsMarkerIndex = TC_marker
   ; mkres@gsMarkerSizeF = 0.03
   ; mkres@gsMarkerThicknessF = 1.0*N_res
   ; mkres@gsMarkerColor = "Black"

   ; cnres@mpCenterLonF = cen_lon
   ; cnres@mpMaxLatF = maxlat
   ; cnres@mpMinLatF = minlat
   ; cnres@mpMaxLonF = maxlon
   ; cnres@mpMinLonF = minlon

   ; cnres@tmXBMode = "Explicit"
   ; cnres@tmXBValues = ispan(toint(minlon), toint(maxlon), 1)
   ; cnres@tmXBLabels = "~F25~" + abs(cnres@tmXBValues) + "~S~o~N~E"

   ; cnres@tmYLMode = "Explicit"
   ; cnres@tmYLValues = ispan(toint(minlat), toint(maxlat), 1)
   ; cnres@tmYLLabels = "~F25~" + abs(cnres@tmYLValues) + "~S~o~N~N"


   ; cnres@gsnLeftString =str_upper(res_list(ires))
   ; cnres@gsnRightString = ""
   ; cnres@sfXArray := lonCell_subset
   ; cnres@sfYArray := latCell_subset
   ; plot = gsn_csm_contour_map(wks,DeepLayerMean_wspd,cnres)
   ; TC = gsn_add_polymarker(wks, plot, cen_lon, cen_lat, mkres)


   ; lnres=True
   ; lnres@gsLineColor = "black"
   ; lnres@gsLineDashPattern = 1
   ; lnres@gsLineThicknessF = 4.0 * N_res

   ; cen_lat = 28
   ; cen_lon = 117
   ; circle1    = geolocation_circle(cen_lat, cen_lon, 14.5, 0, 180, False)
   ; circle_lat1 = circle1[0]                   ; For clarity: explicitly extract list elements¬
   ; circle_lon1 = circle1[1]

   ; lnres@gsLineColor = "black"
   ;     dum11 = gsn_add_polyline(wks, plot, circle_lon1(0,0,:), circle_lat1(0,0,:), lnres)

   ; circle2    = geolocation_circle(cen_lat, cen_lon, 34, 0, 180, False)
   ; circle_lat2 = circle2[0]                   ; For clarity: explicitly extract list elements
   ; circle_lon2 = circle2[1]
   ; lnres@gsLineColor = "red"
   ;     dum21 = gsn_add_polyline(wks, plot, circle_lon2(0,0,:), circle_lat2(0,0,:), lnres)

   ; txres = True
   ; txres@txFont = 26
   ; txres@txFontHeightF = 0.018
   ; txres@txDirection = "Across"
   ; txres@txAngleF = 0.
   ; gsn_text_ndc(wks, "UTC: " + timestamp, 0.5, 0.96, txres)

   ; ;Create common label
   ; lbres = True
   ; lbres@vpXF = 0.2
   ; lbres@vpYF = 0.08
   ; ;lbres@vpYF = 0.30
   ; lbres@vpWidthF = 0.6
   ; lbres@vpHeightF= 0.05

   ; lbres@lbPerimOn = False
   ; lbres@lbBoxLinesOn = True
   ; lbres@lbBoxSeparatorLinesOn = False
   ; lbres@lbBoxLineThicknessF = 1.2*N_res
   ; lbres@lbFillColors  := colors
   ; lbres@lbOrientation = "horizontal"
   ; lbres@lbMonoFillPattern = True
   ; lbres@lbLabelFontHeightF = 0.016
   ; lbres@lbLabelAlignment   = "InteriorEdges"
   ; lbres@lbTitlePosition = "Bottom"
   ; lbres@lbTitleFontHeightF = 0.019
   ; lbres@lbTitleOffsetF = 0.2
   ; lbres@lbTitleExtentF = 0.25
   ; lbres@lbTitleString = "~F25~Deep Layer Mean Wind speed (m/s)";optional
   ; lbres@lbLabelStride = 1
   ; nboxes := dimsizes(colors)
   ; labels := "~F25~"+cnlevels
   ; lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
   ; draw(lbid)
   ; ;drawNDCGrid(wks)
   ; draw(plot)
   ; frame(wks)
        ;end do
    end do
end 
