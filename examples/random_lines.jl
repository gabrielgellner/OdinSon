using OdinSon

#TODO: add support for HSV so I can do the equivalent of HSV(rand())
render(Canvas([PolyLine(rand(2, 2), style=Style(stroke=RGB(rand(3)...))) for i in 1:100]))
