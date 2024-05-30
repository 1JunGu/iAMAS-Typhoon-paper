import os
import time
import sys

import pandas as pd
import numpy as np
import argparse
from matplotlib import pyplot as plt
from matplotlib.ticker import (MultipleLocator, AutoMinorLocator)

#read speed csv data using pandas
def read_speed_csv(speed_csv):
    df_speed = pd.read_csv(speed_csv, sep=",", usecols=['time', 'zonal_speed', 'meridional_speed'],index_col=0, header=0)
    df_speed.index = pd.to_datetime(df_speed.index, format="%Y%m%d%H")
    return df_speed

#read speed csv data using pandas
def read_steer_csv(speed_csv):
    df_speed = pd.read_csv(speed_csv, sep=",", usecols=['TIME', 'uzonal', 'umeridional'],index_col=0, header=0)
    df_speed.index = pd.to_datetime(df_speed.index, format="%Y-%m-%d_%H")
    df_speed['uzonal'] = df_speed['uzonal'] * 3.6 #m/s to km/h
    df_speed['umeridional'] = df_speed['umeridional'] * 3.6 #m/s to km/h    
    return df_speed

def plot_models(model_list, ax0, ax1):
    speed_csv_path = "./speed_csv/"
    speed_csv_prefix = "speed_2106In-Fa_"
    steer_csv_path = "./steering_csv/"
    steer_csv_prefix = "steer_2106In-Fa_"

    line_format_dic = {"CMA": "k-", "u3km": "r-", "v3km": "b-", "v4km": "c-", "u60km": "m-"}
    line_format_dic_steer = { "u3km": "r--", "v3km": "b--", "v4km": "c--", "u60km": "m--"}
    for model_name in model_list:
        if model_name == "CMA":
            model_df = read_speed_csv(speed_csv_path + speed_csv_prefix + model_name + ".csv")
            x_hours= (model_df.index - pd.to_datetime('2021-07-21 00:00:00'))/np.timedelta64(1, 'h')
            line_format = line_format_dic[model_name]
            ax0.plot(x_hours, model_df['zonal_speed'], line_format, label='CMA',visible=True)
            ax1.plot(x_hours, model_df['meridional_speed'], line_format, label='CMA',visible=True)
        elif model_name == "u3km":
            model_df = read_speed_csv(speed_csv_path + speed_csv_prefix + model_name + ".csv")
            x_hours= (model_df.index - pd.to_datetime('2021-07-21 00:00:00'))/np.timedelta64(1, 'h')
            line_format = line_format_dic[model_name]
            ax0.plot(x_hours, model_df['zonal_speed'], line_format, label='U3KM translation speed',visible=True)
            ax1.plot(x_hours, model_df['meridional_speed'], line_format, label='U3KM translation speed',visible=True)

            model_df_steer = read_steer_csv(steer_csv_path + steer_csv_prefix + model_name + ".csv")
            line_format = line_format_dic_steer[model_name]
            ax0.plot(x_hours, model_df_steer['uzonal'], line_format, label='U3KM steering flow',visible=True)
            ax1.plot(x_hours, model_df_steer['umeridional'], line_format, label='U3KM steering flow',visible=True)

        elif model_name == "v3km":
            model_df = read_speed_csv(speed_csv_path + speed_csv_prefix + model_name + ".csv")
            x_hours= (model_df.index - pd.to_datetime('2021-07-21 00:00:00'))/np.timedelta64(1, 'h')
            line_format = line_format_dic[model_name]
            ax0.plot(x_hours, model_df['zonal_speed'], line_format, label='V3KM translation speed',visible=True)
            ax1.plot(x_hours, model_df['meridional_speed'], line_format, label='V3KM steering flow',visible=True)

            model_df_steer = read_steer_csv(steer_csv_path + steer_csv_prefix + model_name + ".csv")
            line_format = line_format_dic_steer[model_name]
            ax0.plot(x_hours, model_df_steer['uzonal'], line_format, label='V3KM translation speed',visible=True)
            ax1.plot(x_hours, model_df_steer['umeridional'], line_format, label='V3KM steering flow',visible=True)
        elif model_name == "v4km":
            model_df = read_speed_csv(speed_csv_path + speed_csv_prefix + model_name + ".csv")
            x_hours= (model_df.index - pd.to_datetime('2021-07-21 00:00:00'))/np.timedelta64(1, 'h')
            line_format = line_format_dic[model_name]
            ax0.plot(x_hours, model_df['zonal_speed'], line_format, label='V4KM translation speed',visible=True)
            ax1.plot(x_hours, model_df['meridional_speed'], line_format, label='V4KM steering flow',visible=True)

            model_df_steer = read_steer_csv(steer_csv_path + steer_csv_prefix + model_name + ".csv")
            line_format = line_format_dic_steer[model_name]
            ax0.plot(x_hours, model_df_steer['uzonal'], line_format, label='V4KM translation speed',visible=True)
            ax1.plot(x_hours, model_df_steer['umeridional'], line_format, label='V4KM steering flow',visible=True)
        elif model_name == "u60km":
            model_df = read_speed_csv(speed_csv_path + speed_csv_prefix + model_name + ".csv")
            x_hours= (model_df.index - pd.to_datetime('2021-07-21 00:00:00'))/np.timedelta64(1, 'h')
            line_format = line_format_dic[model_name]
            ax0.plot(x_hours, model_df['zonal_speed'], line_format, label='U60KM translation speed',visible=True)
            ax1.plot(x_hours, model_df['meridional_speed'], line_format, label='U60KM steering flow',visible=True)

            model_df_steer = read_steer_csv(steer_csv_path + steer_csv_prefix + model_name + ".csv")
            line_format = line_format_dic_steer[model_name]
            ax0.plot(x_hours, model_df_steer['uzonal'], line_format, label='U60KM translation speed',visible=True)
            ax1.plot(x_hours, model_df_steer['umeridional'], line_format, label='U60KM steering flow',visible=True)
        else:
            print("Error: Incorrect file name")
            sys.exit(1)
        # Append legend   
        handles, labels = ax1.get_legend_handles_labels() 
        ax1.legend(handles, labels, loc='upper left',bbox_to_anchor=(0.05,0.95), fontsize=11)


def main():

    fig, (ax0, ax1) = plt.subplots(2,1,figsize=(12,8)) #create a figure with 2 rows and 1 column
    ax0.set_ylabel('Zonal speed (km/h)', fontsize=12)
    #ax0.set_xlabel('date', fontsize=12)
    ax0.set_title('', fontsize=15)
    #add 0 line
    ax0.axhline(y=0, color='black', linestyle='--', linewidth=1, label="_None")
    #add "a)" in upper left corner
    #ax0.text(0.01, 0.95, "(a)", transform=ax0.transAxes, fontsize=12, fontweight='regular', va='top')

    ax1.set_ylabel('Meridional speed (km/h)', fontsize=12)
    ax1.set_xlabel('Time (hour)', fontsize=12)
    ax1.set_title('', fontsize=15) #set title
    #add 0 line
    ax1.axhline(y=0, color='black', linestyle='--', linewidth=1,label="_None")
    #add "b)" in upper left corner
    #ax1.text(0.01, 0.95, "(b)", transform=ax1.transAxes, fontsize=12, fontweight='regular', va='top')

    #set major tick every 24
    ax0.xaxis.set_major_locator(MultipleLocator(24))
    ax1.xaxis.set_major_locator(MultipleLocator(24))
    #set minor tick every 3
    ax0.xaxis.set_minor_locator(MultipleLocator(3))
    ax1.xaxis.set_minor_locator(MultipleLocator(3))


    # Default models to plot  
    default_models = ["CMA", "u3km"]

    # Parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("models", nargs="*", help="Models to plot", default=default_models)
    args = parser.parse_args()
    model_list = args.models
    print("model_list: ", model_list)

    plot_models(model_list,ax0, ax1)

    if not os.path.exists("./figures/"):
        os.makedirs("./figures/")

    str_case = "_".join(model_list).upper() #convert list to string
    fig_name = "./figures/steer_2106In-Fa_" + str_case + ".png"
    fig.savefig(fig_name, dpi=600, bbox_inches='tight')
    print("********\nFigure saved: ", fig_name)


if __name__ == "__main__":
    code_start_time = time.time()
    main()  
    code_end_time = time.time()
    print("********\nThe elapsed time of " + os.path.basename(__file__) + " is : {:.2f} seconds\n********".format(code_end_time - code_start_time))
