;---------------------------------------------------
; File Name: track_error.ncl
; Author: JunGu
; Mail: gj99@mail.ustc.edu.cn
; Created Time: 2020年10月28日 星期三 14时13分25秒
;---------------------------------------------------
begin
    start_time = get_cpu_time()
    CMA                = "./v3km_track_6hour/2106In-Fa.txt"
    CMA_id = asciiread(CMA,(/20,6/),"integer")
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

    V3KM_1 = "./v3km_track_6hour/2106In-Fa_v3km_1540460.txt"
    V3KM_1_id = asciiread(V3KM_1,(/20,4/),"float")
    V3KM_1_lon := V3KM_1_id(:,2)
    V3KM_1_lat := V3KM_1_id(:,1)

    V3KM_2 = "./v3km_track_6hour/2106In-Fa_v3km_2441957.txt"
    V3KM_2_id = asciiread(V3KM_2,(/20,4/),"float")
    V3KM_2_lon := V3KM_2_id(:,2)
    V3KM_2_lat := V3KM_2_id(:,1)

    V3KM_3 = "./v3km_track_6hour/2106In-Fa_v3km_3056192.txt"
    V3KM_3_id = asciiread(V3KM_3,(/20,4/),"float")
    V3KM_3_lon := V3KM_3_id(:,2)
    V3KM_3_lat := V3KM_3_id(:,1)



    ;n_avail_location = num(.not.ismissing(u60km_lon))
    ;print(n_avail_location)
    time_series     = new(20,integer);from CMA Best Track
    forecast_error  = new((/4,20/),double,-999.)
    regression      = new((/4,20/),double);contain regression
;***Function gc_latlon(lat1,lon1,lat2,lon2,npts,iu) npt.le.2 and iu = -4 indicate kilometers in units and range of longitudes(-180,180)
    time_series  = ispan(6,120,6)
    n = 19
    ;***u3km
    forecast_error(0,:)  = gc_latlon(CMA_lat(0:n),CMA_lon(0:n),V3KM_1_lat(0:n),V3KM_1_lon(0:n),2,-4)
    rc_u3km = regline(time_series,forecast_error(0,:)); only slope
    rc_u3km@units = "km/h"
    ;print("rc_u3km:" + rc_u3km)
    print(forecast_error(0,:))
    regression(0,:)  = rc_u3km*time_series + rc_u3km@yintercept ;regression of NTD
    ;***v3km
    forecast_error(1,:)  = gc_latlon(CMA_lat(0:n),CMA_lon(0:n),V3KM_2_lat(0:n),V3KM_2_lon(0:n),2,-4)
    rc_v3km = regline(time_series,forecast_error(1,:)); only slope
    rc_v3km@units = "km/h"
    print(forecast_error(1,:))
    regression(1,:)  = rc_v3km*time_series + rc_v3km@yintercept ;regression of NTD
    ;***v4km
    forecast_error(2,:)  = gc_latlon(CMA_lat(0:n),CMA_lon(0:n),V3KM_3_lat(0:n),V3KM_3_lon(0:n),2,-4)
    rc_v4km = regline(time_series,forecast_error(2,:)); only slope
    rc_v4km@units = "km/h"
    print(forecast_error(2,:))
    regression(2,:)  = rc_v4km*time_series + rc_v4km@yintercept ;regression of NTD
;***
    x_labels     = (/"24","48","72","96","120"/)
    x_lbvalues   = (/24,48,72,96,120/)
;***
    wks_type = "png"
    wks_type@wkHeight = 4096
    wks_type@wkWidth = 4096
    wks = gsn_open_wks(wks_type,"Figure3e_track_error")
;***Resources
    res   =  True
    res@gsnFrame = False
    res@gsnDraw  = False
    res@gsnMaximize = True

    ;res@tiMainString   =  "~F25~Time series of the track forecast errors"
    ;res@gsnRightString =  "~F25~ Forecast error (KM)"

    res@vpWidthF = 0.9
    res@vpHeightF = 0.5

    res@tmYROn   = False
    res@tmXTOn   = False
    res@tmYLOn   = True
    res@tmBorderThicknessF = 16.0
    res@tmXBMajorThicknessF = 16.0
    res@tmXBMinorThicknessF = 16.0
    res@tmXBMajorLengthF = 0.007
    res@tmXBMajorOutwardLengthF = 0.007
    res@tmYLMajorThicknessF = 16.0
    res@tmYLMinorThicknessF = 16.0
    res@tmYLMajorLengthF = 0.007
    res@tmYLMinorLengthF = 0.002
    res@tmYLMajorOutwardLengthF = 0.007
    res@tmYLLabelFontAspectF = 1.3125
    res@tmYLLabelFontHeightF = 0.015

    res@tmXBOn   = True
    res@tmXBMode = "Explicit"
    res@tmXBLabels = x_labels
    res@tmXBValues = x_lbvalues
    res@tmXBLabelFont = 25
    res@tmYLLabelFont = 25
    res@tmXBMinorValues      = time_series(3:)
    res@tmLabelAutoStride    = True;nice stride on labels
    res@tmXBLabelFontAspectF = 1.3125
    res@tmXBLabelFontHeightF = 0.015

    res@tiXAxisString = "~F25~Forecast period (h)"
    res@tiXAxisFontHeightF = 0.02
    res@tiYAxisString = "~F25~Forecast error (KM)"
    res@tiYAxisFontHeightF = 0.02

    res@trXMinF               = 12                    ; adds space on either end
    res@trXMaxF               = 132.0                    ; of the 1st and last bars

    colors = (/"darkorchid4","tomato4","turquoise4","Black"/)
    res@xyDashPatterns  = (/0,0,0,0/) ; Make curves all solid except offical forecast
    res@xyMarkLineMode = "MarkLines"
    res@xyMarkers      = (/4,4,4,16/)
    res@xyMarkerSizeF = 0.012
    res@xyMarkerThicknessF = 17
    res@xyMarkerColors = colors
    res@xyLineThicknesses = (/2.,2.,2.,2./)*10
    res@xyLineColors   = colors
    dmsg = -999.
    forecast_error(3,:) = (/dmsg,dmsg,dmsg,76,dmsg,dmsg,dmsg,131,dmsg,dmsg,dmsg,189,dmsg,dmsg,dmsg,235,dmsg,dmsg,dmsg,278/)

    plot_forecast   = gsn_csm_xy(wks,time_series(3:),forecast_error(:,3:),res)
    x_polyline =  (/24,48,72,96,120/)
    y_polyline = (/76,131,189,235,278/)
    lnres = True
    lnres@gsLineColor = "black"
    lnres@gsLineThicknessF = 20
    do iline = 1, 4
        dum = iline
        dum@$unique_string("line")$ = gsn_add_polyline(wks,plot_forecast,x_polyline(iline-1:iline),y_polyline(iline-1:iline),lnres)
    end do

    ;res@xyDashPattern  = 0
    ;res@xyMarkLineMode = "Lines"
    ;res@xyLineThicknesses = (/2.,2.,2./)
    ;res@xyLineColors   = (/"Blue4","Red4","Gray"/)

    ;plot_regression = gsn_csm_xy(wks,time_series,regression,res)
    ;overlay(plot_forecast,plot_regression)

;***Simple Legend
    ;Pres   =   True
    ;Pres@YposPercent = 95.;expressed as %, 0->100, sets position of top border of legend
    ;                      ;when Pres@Yposition is set to its default setting of "Top"(Default = 95.)
    ;Pres@XposPercent = 5. ;expressed as %, 0->100, sets position of left border of legend(Default = 5.)
    ;lineres  =  True
    ;lineres@lgLineColors = colors
    ;lineres@lgLineThicknesses = (/2.,2.,2./)*20
    ;lineres@lgDashIndexes = (/0,0,0/);

    ;lineres@LineLengthPercent = 9. ;expressed as % 0->100, length of line

    ;textres  = True
    ;textres@lgLabels = (/"V3KM_1","V3KM_2","V3KM_3"/)
    ;legend = simple_legend(wks,plot_forecast,Pres,lineres,textres)
    lgLabels = "~F25~" + (/"   V3KM_4 ","   V3KM_5 ","   V3KM_6 ","   CMA "/)
    lgres = True
    lgres@tfPolyDrawOrder = "PostDraw"

    lgres@vpWidthF = 0.2
    lgres@vpHeightF = 0.12
    lgres@lgAutoManage = False

    lgres@lgMonoDashIndex = True
    lgres@lgDashIndex = 0

    lgres@lgMonoItemType = True
    lgres@lgItemType = "MarkLines"

    lgres@lgMonoMarkerIndex = False
    lgres@lgMarkerIndexes = (/4,4,4,16/)
    lgres@lgMonoMarkerThickness = True
    lgres@lgMarkerThicknessF = 17
    lgres@lgMarkerSizeF = 0.012
    lgres@lgMarkerColors  = colors

    lgres@lgMonoLineColor = False
    lgres@lgLineColors    = colors

    lgres@lgBoxBackground = "Transparent"
    lgres@lgMonoLineThickness = True
    lgres@lgLineThicknessF = 20

    ;lgres@lgLabelStrings = lgLabels
    lgres@lgPerimFill            = "SolidFill"
    lgres@lgLabelFontHeightF = 0.045
    lgres@lgPerimOn = False
    lgres@lgItemCount = 4
    lgres@lgItemOrder = (/3,2,1,0/)
    lgres@lgBoxMinorExtentF = 0.25
    gsn_legend_ndc(wks,4,lgLabels,0.15,0.73,lgres)

    draw(plot_forecast)
    frame(wks)


;---Set up CSV file and header information for the file
    ;nrow = 20
    ;csv_filename = "track_error_series.txt"
    ;system("rm -f " + csv_filename)                ; Remove file in case it exists.
    ;fields = (/"TIME", "U3KM", "V3KM", "V4KM","U15KM", "U60KM", "ECMWF", "GFS"/)
    ;;---Create a header line for CSV file
    ;dq     = str_get_dq()
    ;fields = dq + fields + dq                      ; Pre/append quotes to field names
    ;header = [/str_join(fields,",")/]              ; Header is field names separated
    ;; by commas.
    ;;
    ;; Format to use for writing each variable to CSV file.
    ;; If you don't want spaces in CSV file, use the following
    ;; format string:
    ;;     format = "%s,%g,%g,%g"
    ;;
    ;format = "%8i,%7.4f,%7.4f,%7.4f,%7.4f,%7.4f,%7.4f,%7.4f"

    ;;
    ;; Loop through each time step and desired list of lat/lon values,
    ;; and write a single line of data to CSV file.
    ;;
    ;write_table(csv_filename, "w", header, "%s")   ; Write header to CSV file.
    ;print_clock("header")
    ;do it = 0, nrow-1
    ;    time_tmp = CMA_time(it)
    ;    u3km_tmp  = forecast_error(0,it)
    ;    v3km_tmp  = forecast_error(1,it)
    ;    v4km_tmp  = forecast_error(2,it)
    ;    u15km_tmp  = forecast_error(3,it)
    ;    u60km_tmp = forecast_error(4,it)
    ;    ECMWF_tmp = forecast_error(5,it)
    ;    GFS_tmp   = forecast_error(6,it)
    ;    alist = [/time_tmp,u3km_tmp,v3km_tmp,v4km_tmp,u15km_tmp,u60km_tmp,ECMWF_tmp,GFS_tmp/]   ; Store data to be written in a list.
    ;    write_table(csv_filename, "a", alist, format)     ; Write list to CSV file.
    ;end do

end 
