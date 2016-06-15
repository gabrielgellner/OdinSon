##TODO: the question: do I follow the tree strucutre of matplotlib, or try to emulate
# the more logical structure of SVG? (meaning I would need to do mappings like
# facecolor -> fill, edgecolor -> stroke, linewidth -> stroke_width etc)

# axes style
type AxesStyle
    stroke_width::Real # linewidth
    stroke::RGB # edgecolor
    #grid
    #facecolor::Color
    #labelcolor::Color
    #axisbelow
    function AxesStyle(;stroke_width, stroke)
        AxesStyle(stroke_width, stroke)
    end
end

# grid style

# legend style

# tick style

# Container for all styles
type Style
    axes::AxesStyle
end

function style(;axes)
end

function style!(s::Style)

end
