module OdinSon

using PyPlot
# PyPlot exports so only OdinSon is needed for an using import
#TODO: thin this out to only be useful plotting features
export acorr,annotate,arrow,autoscale,autumn,axes,axhline,axhspan,axis,axvline,axvspan
export bar,barbs,barh,bone,box,boxplot,broken_barh,cla,clabel,clf,clim,cohere,colorbar
export colors,contour,contourf,cool,copper,csd,delaxes,disconnect,draw,errorbar,eventplot
export figaspect,figimage,figlegend,figtext,figure,fill_between,fill_betweenx,findobj
export flag,gca,gcf,gci,get_current_fig_manager,get_figlabels,get_fignums,get_plot_commands
export ginput,gray,grid,hexbin,hist2D,hlines,hold,hot,hsv,imread,imsave,imshow,ioff,ion
export ishold,jet,legend,locator_params,loglog,margins,matshow,minorticks_off,minorticks_on
export over,pause,pcolor,pcolormesh,pie,pink,plot,plot_date,plotfile,polar,prism,psd
export quiver,quiverkey,rc,rc_context,rcdefaults,rgrids,savefig,sca,scatter,sci
export semilogx,semilogy,set_cmap,setp,show,specgram,spectral,spring,spy,stackplot
export stem,step,streamplot,subplot,subplot2grid,subplot_tool,subplots,subplots_adjust
export summer,suptitle,table,text,thetagrids,tick_params,ticklabel_format,tight_layout
export title,tricontour,tricontourf,tripcolor,triplot,twinx,twiny,vlines
export winter,xkcd,xlabel,xlim,xscale,xticks,ylabel,ylim,yscale,yticks
# 3D exports
export plot3D
# some nice utilities from PyPlot
export @L_str

# core types
include("coretypes.jl")
export Point

# Colors
import ColorTypes: HSV, RGB, HSL
export HSV, RGB, HSL
include("color_data/crayon.jl")
include("color_data/xkcd.jl")
include("color_data/svg.jl")
include("color.jl")
export PyObject # my overload so that RGB types are turned to python tuples
export crayons, xkcd_rgb, svg_rgb
export @NC_str, @HC_str
# Seaborn like exports TODO: make these names more julian
export set_palette, color_cycle

include("util.jl")
export despine!
# setup the default styling
_set_mpl_kws()

# Styling
include("style.jl")
export Style

# Containers
include("containers.jl")
export Canvas, Viewport

# Basic SVG/Mathematica like language
include("shapes.jl")
export PolyLine, Polygon, Circle

# basic method for all graphic types
export render

end # module
