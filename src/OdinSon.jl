module OdinSon

# package code goes here
using PyPlot
using PyCall
@pyimport seaborn as sns

# some nice helpers from PyPlot
export @L_str
# PyPlot plot exports
export plot, subplot, scatter
export xlim, ylim, xlabel, ylabel, xticks, yticks
# Seaborn exports
export sns

# Custom Odinson exports

end # module
