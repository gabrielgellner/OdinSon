#TODO: I feel a bit of a code smell for having to constantly repeat the name in calls like
# style=Style(...). Is there a better way is something like style=(:stroke=NC"red", ...)
# this could be a short-of-shorthand for the full naming? But then I introduce the many-ways
# to do the same thing.
type Style
    stroke::Union{RGB, Void}
    stroke_width::Float64
    fill::Union{RGB, Void}
    fill_opacity::Float64 # should check for being between 0-1
    function Style(;stroke=NC"black", stroke_width=1.0, fill=NC"white", fill_opacity=1.0)
        new(stroke, stroke_width, fill, fill_opacity)
    end
end

# Matplotlib requires the color settings using 'none' and not the python type None, which
# feels very odd. So a simple utility is needed when converting the color options to the
# Dict passed to python. Where nothing is set return :none for the correct conversion.

# This function is not type stable, but neither is the Color fields do to needed to accept
# nothing
function _colorkw(field::Union{RGB, Void})
    if field == nothing
        return :none
    else
        return field
    end
end

# keywords for matplotlib patches are uniform
function style2kw(s::Style)
    Dict(:edgecolor => _colorkw(s.stroke), :linewidth => s.stroke_width, :facecolor => _colorkw(s.fill), :alpha => s.fill_opacity)
end

# keyworks for Line2D are different than patches
function style2kw_l(s::Style)
    Dict(:color => _colorkw(s.stroke), :linewidth => s.stroke_width)
end
