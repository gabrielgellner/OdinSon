
function plot_foodweb(adj::Matrix{Int})
    tls = trophic_levels(adj)
    # spread out the x position of each of the species so that the binned groups according
    # to the trophic position are equally spread along with x-axis. The y-axis will just
    # just be the tl
    #
    # assign each species to a tl bin
    nodes = Dict{Float64, Vector{Int}}()
    for (i, tl) in enumerate(tls)
        if haskey(nodes, tl)
            push!(nodes[tl], i)
        else
            nodes[tl] = [i]
        end
    end
    # we get the correct spread in the along the x-axis by dividing the range (0, width)
    # into +1 the number of species we have at each trophic level and then placing the
    # species at the interior divisions
    circs = [] #TODO: would be nice to call this nodes -- need to rename above
    nodelocs = Dict{Int, Array{Float64}}()
    for (tl, species) in nodes
        for (i, sp) in enumerate(species)
            #TODO: it would be nicer to have the nodes centered aligned in the x-direction
            # also is there a nice way to try to avoid vertical overlap? that is to some
            # how move clumps of nodes that would form a column
            nodelocs[sp] = [2*i, tl]
            push!(circs, Circle(nodelocs[sp], 0.1))
        end
    end

    uadj = triu(adj) # only use upper triangle for describing the binary links
    links = []
    for pred = 1:size(uadj, 1)
        preys = find(uadj[:, pred] .== 1)
        #TODO: I can get rid of the vector cast once 0.5 is out
        for prey in preys
            push!(links, PolyLine(Vector{Float64}[nodelocs[prey], nodelocs[pred]]))
        end
    end

    # draw links first so circles are drawn over them
    return Canvas(vcat(links, circs))
end

# Scratch, remove once function is ready
using OdinSon
using FoodWebs
adj = may_network(20, 0.25)
render(plot_foodweb(adj))
