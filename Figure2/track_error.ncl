;---------------------------------------------------
; File Name: track_error.ncl
; Author: JunGu
; Mail: gj99@mail.ustc.edu.cn
; Created Time: 2020年10月28日 星期三 14时13分25秒
;---------------------------------------------------
begin
    start_time = get_cpu_time()
    CMA                = "./track_6hour/2106In-Fa.txt"
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

    ECMWF = "./track_6hour/2106In-Fa_v2km_28N117E.txt"
    ECMWF_id = asciiread(ECMWF,(/20,4/),"float")
    ECMWF_lon := tofloat(ECMWF_id(:,2))
    ECMWF_lat := tofloat(ECMWF_id(:,1))

    GFS = "./track_6hour/2106In-Fa_v4km_24N125E.txt"
    GFS_id = asciiread(GFS,(/20,4/),"float")
    GFS_lon := tofloat(GFS_id(:,2))
    GFS_lat := tofloat(GFS_id(:,1))

    v4km = "./track_6hour/2106In-Fa_v4km_28N117E.txt"
    v4km_id = asciiread(v4km,(/20,4/),"float")
    v4km_lon = tofloat(v4km_id(:,2))
    v4km_lat = tofloat(v4km_id(:,1))

    ;n_avail_location = num(.not.ismissing(u60km_lon))
    ;print(n_avail_location)
    time_series     = new(20,integer);from CMA Best Track
    forecast_error  = new((/3,20/),double)
    regression      = new((/3,20/),double);contain regression
;***Function gc_latlon(lat1,lon1,lat2,lon2,npts,iu) npt.le.2 and iu = -4 indicate kilometers in units and range of longitudes(-180,180)
    time_series  = ispan(6,120,6)
    n = 19
    ;***ECMWF
    forecast_error(0,:)  = gc_latlon(CMA_lat(0:n),CMA_lon(0:n),ECMWF_lat(0:n),ECMWF_lon(0:n),2,-4)
    rc_ECMWF = regline(time_series,forecast_error(0,:)); only slope
    rc_ECMWF@units = "km/h"
    print("rc_ECMWF:" + rc_ECMWF)
    regression(0,:)  = rc_ECMWF*time_series + rc_ECMWF@yintercept ;regression of NTD
    ;***GFS
    forecast_error(1,:)  = gc_latlon(CMA_lat(0:n),CMA_lon(0:n),GFS_lat(0:n),GFS_lon(0:n),2,-4)
    rc_GFS = regline(time_series,forecast_error(1,:)); only slope
    rc_GFS@units = "km/h"
    print("rc_GFS:" + rc_GFS)
    regression(1,:)  = rc_GFS*time_series + rc_GFS@yintercept ;regression of NTD
    ;***GFS
    forecast_error(2,:)  = gc_latlon(CMA_lat(0:n),CMA_lon(0:n),v4km_lat(0:n),v4km_lon(0:n),2,-4)
    rc_v4km = regline(time_series,forecast_error(2,:)); only slope
    rc_v4km@units = "km/h"
    print("rc_v4km:" + rc_v4km)
    regression(2,:)  = rc_v4km*time_series + rc_v4km@yintercept ;regression of NTD
;***
    x_labels     = (/"6","24","48","72","96","120"/)
    x_lbvalues   = (/6,24,48,72,96,129/)
;***
    pltype = "png"
    wks = gsn_open_wks(pltype,"track_error_In-Fa")
;***Resources
    res   =  True
    res@gsnFrame = False
    res@gsnDraw  = False
    res@gsnMaximize = True

    res@tiMainString   =  "~F25~Time series of the track forecast errors"
    res@gsnRightString =  "~F25~km"

    res@tmYROn   = False
    res@tmXTOn   = False
    res@tmYLOn   = True
    res@tmBorderThicknessF = 2.0
    res@tmXBMajorThicknessF = 2.0
    res@tmXBMinorThicknessF = 1.5
    res@tmYLMajorThicknessF = 2.0
    res@tmYLMinorThicknessF = 1.5
    res@tmYLLabelFontAspectF = 1.3125
    res@tmYLLabelFontHeightF = 0.015

    res@tmXBOn   = True
    res@tmXBMode = "Explicit"
    res@tmXBLabels = x_labels
    res@tmXBValues = x_lbvalues
    res@tmXBLabelFont = 25
    res@tmYLLabelFont = 25
    res@tmXBMinorValues      = time_series
    res@tmLabelAutoStride    = True;nice stride on labels
    res@tmXBLabelFontAspectF = 1.3125
    res@tmXBLabelFontHeightF = 0.015

    res@tiXAxisString = "~F25~Time (h)"
    res@tiXAxisFontHeightF = 0.02
    res@tiYAxisString = "~F25~Distance (km)"
    res@tiYAxisFontHeightF = 0.02

    res@xyDashPatterns  = (/0,0,0,0,0,1,1/) ; Make curves all solid except offical forecast
    res@xyMarkLineMode = "MarkLines"
    res@xyMarkers      = (/7,7,7,7,7,7,7/)
    res@xyMarkerColors = (/"pink","green","Blue","Red","orange","gray","Black"/)
    res@xyLineThicknesses = (/2.,2.,2.,2.,2.,2.,2./)
    res@xyLineColors   = (/"pink","green","Blue","Red","orange","gray","Black"/)

    plot_forecast   = gsn_csm_xy(wks,time_series,forecast_error,res)

    ;res@xyDashPattern  = 0
    ;res@xyMarkLineMode = "Lines"
    ;res@xyLineThicknesses = (/2.,2.,2./)
    ;res@xyLineColors   = (/"Blue4","Red4","Gray"/)

    ;plot_regression = gsn_csm_xy(wks,time_series,regression,res)
    ;overlay(plot_forecast,plot_regression)

;***Simple Legend
    Pres   =   True
    Pres@YposPercent = 95.;expressed as %, 0->100, sets position of top border of legend
                          ;when Pres@Yposition is set to its default setting of "Top"(Default = 95.)
    Pres@XposPercent = 5. ;expressed as %, 0->100, sets position of left border of legend(Default = 5.)
    lineres  =  True
    lineres@lgLineColors = (/"pink","green","Blue","Red","orange","gray","Black"/)
    lineres@lgLineThicknesses = (/2.,2.,2.,2.,2.,2.,2./)
    lineres@lgDashIndexes = (/0,0,0,0,0,1,1/);
    lineres@LineLengthPercent = 9. ;expressed as % 0->100, length of line

    textres  = True
    textres@lgLabels = (/"U3KM","V3KM","V4KM","U15KM","U60KM","ECMWF","GFS"/)
    legend = simple_legend(wks,plot_forecast,Pres,lineres,textres)
    draw(plot_forecast)
    frame(wks)


;---Set up CSV file and header information for the file
    nrow = 20
    csv_filename = "track_error_series_figure2.txt"
    system("rm -f " + csv_filename)                ; Remove file in case it exists.
    fields = (/"TIME", "V2KM", "V4KM_24N125E", "V4KM_28N117E"/)
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
    format = "%8i,%7.4f,%7.4f,%7.4f"

    ;
    ; Loop through each time step and desired list of lat/lon values,
    ; and write a single line of data to CSV file.
    ;
    write_table(csv_filename, "w", header, "%s")   ; Write header to CSV file.
    print_clock("header")
    do it = 0, nrow-1
        time_tmp = CMA_time(it)
        ECMWF_tmp = forecast_error(0,it)
        GFS_tmp   = forecast_error(1,it)
        v4km_tmp   = forecast_error(2,it)
        alist = [/time_tmp,ECMWF_tmp,GFS_tmp,v4km_tmp/]   ; Store data to be written in a list.
        write_table(csv_filename, "a", alist, format)     ; Write list to CSV file.
    end do

end 
