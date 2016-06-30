import PyPlot: subplots

type Canvas
    grobs::Array{Grob}
    style::Style
    function Canvas(grobs; style=Style(fill=NC"white"))
        new(grobs, style)
    end
end

function render(go::Canvas)
    # using collections removes all styling, style must be passed into the PatchCollection
    # patches = []
    # for g in go.grobs
    #     push!(patches, render(g))
    # end
    #pcol = mcol.PatchCollection(patches)
    (fig, ax) = subplots()
    # apply style to axes
    ax[:patch][:set_facecolor](go.style.fill)
    for g in go.grobs
        p = render(g)
        # assume that we have either lines or patches
        if pyisinstance(p, mlines.Line2D)
            ax[:add_line](p)
        else
            ax[:add_patch](p)
        end
    end
    ax[:relim]() # resize the axes limits
    ax[:autoscale_view]() # make sure everyting is visable
    ax[:set_aspect]("equal") # TODO: make this an option
    return fig
end

##TODO: not really sure this is a container, and not just a style, but it is an attribute
# of an AxesView
type Spine
    # this needs to deal with inward/outward styles as well as special "center", or
    # the different coordinate locations
    position::Vector{Float64}
    #bounds
    #visible::Bool # do I want this, is there a more consistent way to have this on/off
    #style::Style
end

type Spines
    top::Spine
    bottom::Spine
    left::Spine
    right::Spine
end

type AxesTicks
end

type Axes
    spines::Spines
    #ticks::AxesTicks
    #labels
end

type AxesView
    grobs::Array{Grob}
    axes::Axes
    style::Style
end
