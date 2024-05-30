import os
import time

import pandas as pd
import numpy as np
from geopy.distance import great_circle

# read TC track data using pandas
def read_CMA_track(CMA):
    df_CMA = pd.read_csv(CMA, sep="\s+", names=['time','intensity','latitude','longitude','pressure','windspeed'],
               index_col=0)
    df_CMA.index = pd.to_datetime(df_CMA.index, format="%Y%m%d%H")
    df_CMA['latitude'] = df_CMA['latitude']/10.
    df_CMA['longitude'] = df_CMA['longitude']/10.
    return df_CMA

def read_self_track(self_track):
    df_self = pd.read_csv(self_track, sep="\s+", names=['time','latitude','longitude','pressure'],
                        index_col=0)
    df_self.index = pd.to_datetime(df_self.index, format="%Y%m%d%H")
    return df_self

# calculate translation speed, direction
def calc_translation_speed(df):
    df['translation_speed'] = 0. #append a new column named "translation_speed" to df
    df['zonal_speed'] = 0.       #append a new column named "zonal_speed" to df
    df['meridional_speed'] = 0.  #append a new column named "meridional_speed" to df
    for i in range(1, len(df)-1):
        print(df.index[i])
        Point1 = (df['latitude'][i-1], df['longitude'][i-1])
        Point2 = (df['latitude'][i+1], df['longitude'][i+1])
        #keep 4 digits after decimal point
        df['translation_speed'][i] = round(great_circle(Point1,Point2).km/(df.index[i+1]-df.index[i-1]).seconds*3600,4)
        print(df['translation_speed'][i])
        df['zonal_speed'][i]= round(great_circle((df['latitude'][i-1], df['longitude'][i-1]), (df['latitude'][i-1], df['longitude'][i+1])).km/(df.index[i+1]-df.index[i-1]).seconds*3600,4)
        if df['longitude'][i+1] < df['longitude'][i-1]:
            df['zonal_speed'][i] = -df['zonal_speed'][i]
        print(df['zonal_speed'][i])
        df['meridional_speed'][i]= round(great_circle((df['latitude'][i-1], df['longitude'][i-1]), (df['latitude'][i+1], df['longitude'][i-1])).km/(df.index[i+1]-df.index[i-1]).seconds*3600,4)
        if df['latitude'][i+1] < df['latitude'][i-1]:
            df['meridional_speed'][i] = -df['meridional_speed'][i]
        print(df['meridional_speed'][i])

def main():
    CMA_path = "./track_6hour"
    CMA_Infa = CMA_path + "/2106In-Fa.txt"

    MPAS_path = "./track_6hour/"
    u3km_Infa = MPAS_path + "2106In-Fa_u3km.txt"
    u15km_Infa = MPAS_path + "2106In-Fa_u15km.txt"
    u60km_Infa = MPAS_path + "2106In-Fa_u60km.txt"

    if not os.path.exists("./speed_csv"):
        os.mkdir("./speed_csv") 

    df_CMA = read_CMA_track(CMA_Infa)
    calc_translation_speed(df_CMA)
    df_CMA.index = df_CMA.index.strftime("%Y%m%d%H")
    df_CMA.to_csv("./speed_csv/speed_2106In-Fa_CMA.csv")

    for i in [u3km_Infa, u15km_Infa, u60km_Infa]:
        df_MPAS = read_self_track(i)
        calc_translation_speed(df_MPAS)
        df_MPAS.index = df_MPAS.index.strftime("%Y%m%d%H")
        df_MPAS.to_csv("./speed_csv/speed_" + os.path.basename(i).split(".")[0] + ".csv") 

if __name__ == "__main__":
    code_start_time = time.time()
    main()
    code_end_time = time.time()
    print("********\nThe elapsed time of " + os.path.basename(__file__) + " is : {:.2f} seconds\n********".format(code_end_time - code_start_time))
