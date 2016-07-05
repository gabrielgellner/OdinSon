#=
FoodWebPlot[adjmat_, width_: 10] :=
 	Module[{tl = FindTrophicLevels[adjmat], speciesPosition, tlBins},
  		(* spread out the x position of each of the species so that binned groups according to the trophic position are equally spread along the x-axis, y-axis is just the tp *)
  		tlBins = GatherBy[Thread[{Range[Length[tl]], tl}], Ceiling[#[[2]]] &];

		(* we get the correct spread in the along the x-axis by dividing the range (0, width) into +1 the number of species we have at each
		   trophic level and then placing the species at the interior divisions *)
		speciesPosition = Flatten[Table[Thread[{species[[All, 1]], Table[(n width)/(Length[species] + 1), {n, 0, Length[species] + 1}][[2 ;; -2]], species[[All, 2]]}], {species, tlBins}], 1];
		speciesPosition = #[[1]] -> {#[[2]], #[[3]]} & /@ speciesPosition;

  		GraphPlot[adjmat, DirectedEdges -> True, VertexLabeling -> True,
   		VertexCoordinateRules -> speciesPosition]
  	]
=#

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
    circs = []
    for (tl, species) in nodes
        for i in eachindex(species)
            push!(circs, Circle([2*i, tl], 0.1))
        end
    end

    return Canvas(circs)
end

# Scratch, remove once function is ready
using OdinSon
using FoodWebs
adj = may_network(20, 0.25)
render(plot_foodweb(adj))
