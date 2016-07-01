import PyPlot: subplots

type VStyle
    fill::Union{RGB, Void}
    function VStyle(;fill=nothing)
        new(fill)
    end
end
style2mplkw(s::VStyle) = Dict(:fill => s.fill)

##Note: Mathematica and Matplotlib don't have nested scopes for the viewports, you can lay
## them over each other, but not inside one another. I am going to go this route, the
## full nested version is too complex, and I am not sure it buys me much.
type Viewport # a Viewport is not a grob, and therefore can't contain another Viewport
    grobs::Array{Grob}
    # to start I only support npc coordinates for viewports, this needs to change so I can
    # have inheritence for sub-viewports
    xy::Array{Float64}
    width::Float64
    height::Float64
    clip::Symbol
    style::VStyle # should likely be a special viewport style
    # justification
    # xscale
    # yscale
    # angle
    # layout
    # layout.pos.row
    # layout.pos.col
    # name # I think I should use id like SVG
    function Viewport(grobs; xy=[0.0, 0.0], width=1.0, height=1.0, clip=:on, style=VStyle())
        new(grobs, xy, width, height, clip, style)
    end
end

# a Viewport needs to know the Canvas it is in, so the render has an extra argument,
# I think I might need to change the name of render, to something more descriptive
function render!(f, v::Viewport)
    ax = f.add_axes(v.xy[1], v.xy[2], v.xy[1] + width, v.xy[2] + height)
    _addgrob2mpl!(ax, v.grobs)
    return nothing
end

#TODO: need to allow for changes to attributes, but not yet sure what the api shoudl be
Base.push!(vp::Viewport, grob::Grob) = push!(vp.grobs, grob)

type Canvas
    grobs::Array{Grob}
    style::Style
    function Canvas(grobs; style=Style(fill=NC"white"))
        new(grobs, style)
    end
    # function Canvas(vps::Array{Viewport}; style=Style(fill=NC"white"))
    #     new(vps)
    # end
end

function _addgrob2mpl!(ax, grobs::Array{Grob})
    for g in grobs
        p = render(g)
        # assume that we have either lines or patches
        if pyisinstance(p, mlines.Line2D)
            ax[:add_line](p)
        else
            ax[:add_patch](p)
        end
    end
    return nothing
end

function render(go::Canvas)
    # using collections removes all styling, style must be passed into the PatchCollection
    # patches = []
    # for g in go.grobs
    #     push!(patches, render(g))
    # end
    #pcol = mcol.PatchCollection(patches)
    (fig, ax) = subplots()
    _addgrob2mpl!(ax, go.grobs)
    # apply style to axes
    ax[:patch][:set_facecolor](go.style.fill)
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
