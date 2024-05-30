begin
    code_start = get_cpu_time()

    graphic_start = get_cpu_time()
    wks_type = "png"
    wks_type@wkHeight = 4096
    wks_type@wkWidth = 4096
    wks     = gsn_open_wks(wks_type,"Figure2c_track_error")               ; send graphics to PNG file

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
    y = (/76,32.0303,58.3628,58.5992,\
         131,54.3225,57.7696,87.1266,\
         189,112.4555,147.8338,223.8802,\
         235,278.3669,337.6122,530.9816,\
         278,348.5757,380.9792,733.5030/)


    labels_top = (/"24","48","72","96","120"/)
    ;********************************************************
    ; create the plot
    ;********************************************************   
    bres                       = True                 ; plot mods desired         
    bres@vpXF = 0.09
    bres@vpYF = 0.95
    bres@vpWidthF = 0.9
    bres@vpHeightF = 0.5
    bres@gsnFrame              = False                ; don't advance frame yet
    bres@gsnDraw               = False

    ;bres@gsnXRefLine = 8.5
    ;bres@gsnXRefLineColor = "Black"
    ;bres@gsnXRefLineDashPattern = 2
    ;bres@gsnXRefLineThicknessF = 16.0
    colors = (/"dodgerblue","blueviolet","firebrick"/)
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
    bres1@tmYLValues = ispan(0,750,50)
    bres1@tmYLLabelFontHeightF  = 0.014
    bres1@tmYLMajorLengthF = 0.005
    bres1@tmYLMajorOutwardLengthF = 0.005
    bres1@tmYLMajorThicknessF = 16.0
    bres1@tmYLLabels = "~F25~" + sprinti("%3i",bres1@tmYLValues)
    bres1@tiYAxisString = "~F25~" + "Forecast error (KM)"
    bres1@tiYAxisFontHeightF = 0.015
    bres1@tiXAxisString = "~F25~" + "Forecast period (h)"
    bres1@tiXAxisFontHeightF = 0.015

    bres1@trYMaxF               = 555
    bres1@trYMinF               = 0                    ; bring bars down to zero

    bres1@tmYLTickEndF = 770.

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
    speedup_colors = (/"Black","dodgerblue","blueviolet","firebrick3"/)
    speedup_name  = (/"CMA ","V2KM_28N117E","V4KM_24N125E","V4KM_28N117E"/)

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
        plot_b@$unique_string("dum21")$ = gsn_add_text(wks,plot_b,text_string, 1.20, y_pos ,txres)
        
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

    do n = 0, 18
       plot_b@$unique_string("dum")$= gsn_add_text(wks,plot_b,sprintf("%3.0f",y(n)),x(n),y(n)+ 10.5,txres) ; add labels
    end do
    plot_b@$unique_string("dum19")$= gsn_add_text(wks,plot_b,sprintf("%3.0f",y(19)),x(19),540,txres) ; add labels

    draw(plot_b)
    frame(wks)


;---Print CPU timings
    graphic_end = get_cpu_time()
    print("===> graphics elapsed time  = " + (graphic_end - graphic_start) + " seconds.")
    print("===> full code elapsed time = " + (graphic_end - code_start) + " seconds") 
end
