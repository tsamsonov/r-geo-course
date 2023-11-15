def get_component(fid, ids, colors, comp):
    comp.append(fid)
    for fid_next in ids[fid]:
        if (colors[fid] == colors[fid_next]) and fid_next not in comp:
            comp = get_component(fid_next, ids, colors, comp)
    return comp

layer = iface.activeLayer()
renderer = layer.renderer()
provider = layer.dataProvider()
index = provider.fieldNameIndex(renderer.classAttribute())

ids = {}
colors = {}

for feature in layer.getFeatures():
    fid = feature['fid']
    neighbours_expr = QgsExpression("overlay_touches('{0}', $id)".format(layer.id()))
    context = QgsExpressionContext()
    context.setFeature(feature)
    ids[fid] = neighbours_expr.evaluate(context)

    attributes = feature.attributes()
    value = float(attributes[index])
    for r in renderer.ranges():
        if value >= r.lowerValue() and value <= r.upperValue():
            colors[fid] = r.symbol().color().name()

N = len(ids)
components = []

while len(ids)>0:
    fid = next(iter(ids))
    comp = get_component(fid, ids, colors, [])
    components.append(comp)
    
    for fid in comp:
        ids.pop(fid)
        colors.pop(fid)
        
    for fid in comp:
        for fid0 in ids:
            if fid in ids[fid0]:
                ids[fid0].remove(fid)

CF = len(components)/N
print(CF)
