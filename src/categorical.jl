using OdinSon
using PyPlot

function _establish_colors()
    return OdinSon.SEABORN_PALETTES[:deep]
end

# Attempt to port some of the Seaborn functions for plotting categorical data
function _restyle_boxplot(adict, colors)
    # take a drawn matplotlib boxplot and make it look nice.
    linewidth = 2
    #gray = NC"gray" #TODO: recreate the logic from seaborn for setting this
    #TODO: can replace with convert(HSL, col) once the fix is merged upstream
    l = minimum([convert(HSL, convert(RGB{Float32}, color)).l for color in colors])
    gray = RGB(l*0.6, l*0.6, l*0.6)
    fliersize = 5

    # currently I only change the box on a per column basis
    for (j, box) in enumerate(adict["boxes"])
        box[:update](Dict(:facecolor => colors[j], :zorder => 0.9, :edgecolor => gray, :linewidth => linewidth))
    end
    for whisk in adict["whiskers"]
        whisk[:update](Dict(:color => gray, :linewidth => linewidth, :linestyle => "-"))
    end
    for cap in adict["caps"]
        cap[:update](Dict(:color => gray, :linewidth => linewidth))
    end
    for med in adict["medians"]
        med[:update](Dict(:color => gray, :linewidth => linewidth))
    end
    for fly in adict["fliers"]
        fly[:update](Dict(:markerfacecolor => gray, :marker => "d", :markeredgecolor => gray, :markersize => fliersize))
    end
end

function _draw_boxplot(ax, data)
    colors = _establish_colors()
    vert = true
    artist_dict = ax[:boxplot](data, vert=vert, patch_artist=true)
    _restyle_boxplot(artist_dict, colors)
end

#TODO: I need to use a funny name since otherwise I have problems with overwriting PyPlot
function oboxplot(data)
    # first lets just get the nicer styling of seaborn
    ax = gca()
    _draw_boxplot(ax, data)
end

# test remove once ready
using Distributions
#TODO: I really don't like th (1:6)'/2 bit, is this idomatic? Find out best way.
data = rand(Normal(0, 1), 20, 6) .+ (1:6)'/2
oboxplot(data)
