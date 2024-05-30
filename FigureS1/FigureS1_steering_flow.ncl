begin
    code_start = get_cpu_time()
;read
    speed_csv_fipath = "./speed_csv/"
    CMA_fi = asciiread(speed_csv_fipath + "speed_2106In-Fa_CMA.csv",(/21,9/),"float")
    CMA_time = CMA_fi(:,0)
    CMA_u = CMA_fi(:,7)
    CMA_v = CMA_fi(:,8)

    u3km_fi = asciiread(speed_csv_fipath + "speed_2106In-Fa_u3km.csv",(/21,7/),"float")
    u3km_time = u3km_fi(:,0)
    u3km_u = u3km_fi(:,5)
    u3km_v = u3km_fi(:,6)
    print(u3km_u)

    u15km_fi = asciiread(speed_csv_fipath + "speed_2106In-Fa_u15km.csv",(/21,7/),"float")
    u15km_time = u15km_fi(:,0)
    u15km_u = u15km_fi(:,5)
    u15km_v = u15km_fi(:,6)

    u60km_fi = asciiread(speed_csv_fipath + "speed_2106In-Fa_u60km.csv",(/21,7/),"float")
    u60km_time = u60km_fi(:,0)
    u60km_u = u60km_fi(:,5)
    u60km_v = u60km_fi(:,6)

    uzonal_arr = new((/4,21/),float)
    uzonal_arr(0,:) = CMA_u
    uzonal_arr(1,:) = u3km_u
    uzonal_arr(2,:) = u15km_u
    uzonal_arr(3,:) = u60km_u

    umeridional_arr = new((/4,21/),float)
    umeridional_arr(0,:) = CMA_v
    umeridional_arr(1,:) = u3km_v
    umeridional_arr(2,:) = u15km_v
    umeridional_arr(3,:) = u60km_v

    graphic_start = get_cpu_time()
    wks_type = "png"
    wks_type@wkHeight = 4096
    wks_type@wkWidth = 4096
    wks     = gsn_open_wks(wks_type,"Figure1efg_track_error_speed")               ; send graphics to PNG file

    ;; Figure 1e
    ;draw IO time
    x = (/1,1.8,2.6,3.4,\ 
        5.4,6.2,7.0,7.8,\
        9.8,10.6,11.4,12.2,\
        14.2,15.0,15.8,16.6,\
        18.6,19.4,20.2,21.0/)
    tmxb_value = (/2.2, \
                   6.6, \
                   11.0,\
                   15.4,\
                   19.8/)

    dmsg = default_fillvalue("double")
    dmsg := -99.
    y = (/76,56.8509,70.2273,61.9342,\
         131,64.3506,58.6683,73.9447,\
         189,82.772,125.67,209.513,\
         235,152.981, 290.8965,513.3956,\
         278,75.5253,478.1993,537.739/)


    labels_top = (/"24","48","72","96","120"/)
    ;********************************************************
    ; create the plot
    ;********************************************************   
    bres                       = True                 ; plot mods desired         
    bres@vpXF = 0.09
    bres@vpYF = 0.99
    bres@vpWidthF = 0.6
    bres@vpHeightF = 0.4
    bres@gsnFrame              = False                ; don't advance frame yet
    bres@gsnDraw               = False

    ;bres@gsnXRefLine = 8.5
    ;bres@gsnXRefLineColor = "Black"
    ;bres@gsnXRefLineDashPattern = 2
    ;bres@gsnXRefLineThicknessF = 16.0
    colors = (/"Violetred","NavyBlue","dimgray"/)
    bres@gsnXYBarChart         = True                 ; turn on bar chart
    bres@gsnXYBarChartBarWidth = 0.65                 ; change bar widths
    barchart_colors  = new(20,"string")
    barchart_colors(0:16:4) = "Black"
    barchart_colors(1:17:4) =  colors(0)
    barchart_colors(2:19:4) =  colors(1)
    barchart_colors(3:19:4) =  colors(2)
    bres@gsnXYBarChartColors = barchart_colors

    bres@pmTickMarkDisplayMode = "Always"
    bres@tmBorderThicknessF = 16.0
    bres@tmXBOn                = True                ; turn off tickmarks at bot
    bres@tmXBMode              = "Explicit"
    bres@tmXBValues            = tmxb_value
    ;bres@tmXBMinorValues       = x
    ;bres@tmXBMinorLengthF      = 0.00
    ;bres@tmXBMinorOutwardLengthF = 0.000
    bres@tmXBMinorThicknessF   = 16.0
    bres@tmXBMajorLengthF      = 0.00
    bres@tmXBMajorOutwardLengthF = 0.
    bres@tmXBLabels            = "~F25~"+labels_top
    bres@tmXBLabelFontHeightF  = 0.016
    bres@tmXBLabelAngleF       = 0.
    bres@tmXBLabelJust         = "BottomCenter"
    bres@tmXTOn = False

    bres@trXMinF               = 0                    ; adds space on either end
    bres@trXMaxF               = 22.0                    ; of the 1st and last bars


    bres1 = bres
    bres1@tmYROn = False
    bres1@tmYLOn = True
    bres1@tmYLMinorOn = False
    bres1@tmYLMode = "Explicit"
    bres1@tmYLValues = ispan(0,550,50)
    bres1@tmYLLabelFontHeightF  = 0.014
    bres1@tmYLMajorLengthF = 0.005
    bres1@tmYLMajorOutwardLengthF = 0.005
    bres1@tmYLMajorThicknessF = 16.0
    bres1@tmYLLabels = "~F25~" + sprinti("%3i",bres1@tmYLValues)
    bres1@tiYAxisString = "~F25~" + "Forecast error (km)"
    bres1@tiYAxisFontHeightF = 0.015
    bres1@tiXAxisString = "~F25~" + "Forecast period (h)"
    bres1@tiXAxisFontHeightF = 0.015

    bres1@trYMaxF               = 570
    bres1@trYMinF               = 0                    ; bring bars down to zero

    ;bres1@tmYLTickEndF = 600.

    plot_b = gsn_csm_xy(wks,x,y,bres1)                  ; create plot
    system("echo plot")

    ;add another tickmark label
    ;labels = (/"U60KM(240 processes)","V4KM(12000 processes)","U3KM(30000 processes)"/)

    ;txres = True
    ;txres@txFont                 = 25      ;-- fill color
    ;txres@txFontColor            =  "Black"         ;-- set opacity of polygon
    ;txres@txFontHeightF          = 0.014
    ;txres@txJust                 = "CenterCenter"

    ;x_label_0 = 0.1 + 0.1327 ;calculate from vpwidthf/(trmaxf-trminf)
    ;x_label_1 = 0.1 + 0.3635
    ;x_label_2 = 0.1 + 0.6173
    ;gsn_text_ndc(wks,labels(0), x_label_0 , 0.455 ,txres)
    ;gsn_text_ndc(wks,labels(1), x_label_1 , 0.455 ,txres)
    ;gsn_text_ndc(wks,labels(2), x_label_2 , 0.455 ,txres)


    ;-- polymarker NDC
    mstring = "y"
    fontnum = 35
    xoffset = 0.0
    yoffset = 0.0
    ratio   = 1.0
    size    = 1.0
    angle   = 0.0

    new_index = NhlNewMarker(wks, mstring, fontnum, xoffset, yoffset, ratio, size, angle)

    speedup_colors = new(4,string)
    speedup_colors = (/"Black","Violetred","NavyBlue","dimgray"/)
    speedup_name  = (/"CMA ","U3KM","U15KM","U60KM"/)

    y_pos = 500
    y_interval = 50
    do i=0, 3

        ;-- polygon resources
        pmres                        =  True
        pmres@gsFillColor            = speedup_colors(i)
        pmres@gsMarkerColor          = speedup_colors(i)      ;-- fill color
        pmres@gsFillOpacityF         =  1         ;-- set opacity of polygon
        pmres@gsMarkerIndex          = new_index
        pmres@gsMarkerSizeF          = 0.015;default 0.007
        pmres@gsMarkerThicknessF     = 12.0;1.0
        plot_b@$unique_string("dum11")$ = gsn_add_polymarker(wks,plot_b ,0.6, y_pos , pmres)
        ;-- text resources
        txres                        =  True
        txres@txFont                 = 25      ;-- fill color
        txres@txFontColor            =  "Black"         ;-- set opacity of polygon
        txres@txFontHeightF          = 0.015
        txres@txJust                 = "CenterLeft"
        text_string = speedup_name(i)
        plot_b@$unique_string("dum21")$ = gsn_add_text(wks,plot_b,text_string, 0.90, y_pos ,txres)
        
        y_pos = y_pos - y_interval
    end do

    ;**********************************************************
    ; add text labels
    ;**********************************************************  
    delete(txres)
    txres                     = True                 ; text mods desired
    txres@txFontColor         = "Black"
    txres@txFontHeightF       = 0.013                ; default size is HUGE!
    txres@txAngleF            = 0.                  ; text angle
    txres@txJust              = "CenterCenter"         ; puts text on top of bars
    txres@txFont   = 25

    do n = 0, 19
       plot_b@$unique_string("dum")$= gsn_add_text(wks,plot_b,sprintf("%3.0f",y(n)),x(n),y(n)+ 10.5,txres) ; add labels
    end do
    draw(plot_b)
    ;Figure 1 fg
    line_colors = (/"black","Violetred","NavyBlue","dimgray"/)
    time_x = ispan(0,120,6)
    res = True
    res@vpXF = 0.09
    res@vpYF = 0.51
    res@vpWidthF = 0.6
    res@vpHeightF = 0.18
    res@gsnFrame              = False                ; don't advance frame yet
    res@gsnDraw               = False

    res@gsnYRefLine = 0
    res@gsnYRefLineColor = "Black"
    res@gsnYRefLineDashPattern = 2
    res@gsnYRefLineThicknessF = 16.0

    res@pmTickMarkDisplayMode = "Always"
    res@tmBorderThicknessF = 16.0
    res@tmXBOn                = True                ; turn off tickmarks at bot
    res@tmXBMode              = "Explicit"
    res@tmXBValues            = ispan(0,120,24)

    res@tmXBMinorValues       = ispan(0,120,6)
    res@tmXBMinorLengthF      = 0.006
    res@tmXBMinorOutwardLengthF = 0.006
    res@tmXBMinorThicknessF   = 16.0
    res@tmXBMajorThicknessF   = 16.0
    res@tmXBMajorLengthF      = 0.011
    res@tmXBMajorOutwardLengthF = 0.011


    res@tmXTOn = False

    res@trXMinF               = -1                    ; adds space on either end
    res@trXMaxF               = 121.0                    ; of the 1st and last bars

    res@tmYROn = False
    res@tmYLOn = True
    res@tmYLMinorOn = False
    res@tmYLMode = "Explicit"
    res@tmYLValues = ispan(-20,5,5)
    res@tmYLLabelFontHeightF  = 0.014
    res@tmYLMajorLengthF = 0.005
    res@tmYLMajorOutwardLengthF = 0.005
    res@tmYLMajorThicknessF = 16.0
    res@tmYLLabels = "~F25~" + sprinti("%3i",res@tmYLValues)
    res@tiYAxisString = "~F25~" + "Zonal speed (km/h)"
    res@tiYAxisFontHeightF = 0.015
    res@tiXAxisString = "~F25~" + ""
    res@tiXAxisFontHeightF = 0.015

    res@trYMaxF               = 7
    res@trYMinF               = -22                   ; bring bars down to zero

    res@xyLineColors = line_colors
    res@xyLineThicknessF = 16
    res@xyDashPatterns = (/0,0,0,0/)
    ;print(uzonal_arr)
    plot_x1 = gsn_csm_xy(wks,time_x,uzonal_arr,res)                  ; create plot
    draw(plot_x1)

    res2 = res
    res2@vpYF = 0.27
    res2@tmXBLabels            = "~F25~"+res@tmXBValues
    res2@tmXBLabelFontHeightF  = 0.016
    res2@tmXBLabelAngleF       = 0.
    res2@tmXBLabelJust         = "CenterCenter"

    res2@tmYLValues := ispan(-5,15,5)
    res2@tmYLLabels := "~F25~" + sprinti("%3i",res2@tmYLValues)
    res2@trYMaxF               = 19
    res2@trYMinF               = -7                   ; bring bars down to zero

    res2@tiYAxisString = "~F25~" + "Meridional speed (km/h)"
    res2@tiYAxisFontHeightF = 0.015
    res2@tiXAxisString = "~F25~" + "Forecast period (h)"
    res2@tiXAxisFontHeightF = 0.015
    plot_x2 = gsn_csm_xy(wks,time_x,umeridional_arr,res2)                  ; create plot
    draw(plot_x2)


    frame(wks)

;---Print CPU timings
    graphic_end = get_cpu_time()
    print("===> graphics elapsed time  = " + (graphic_end - graphic_start) + " seconds.")
    print("===> full code elapsed time = " + (graphic_end - code_start) + " seconds") 
end
