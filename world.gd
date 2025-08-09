extends Node2D
@onready var map: TileMap = $TileMap

const T_GRASS = Vector2i(0,0)
const T_PATH_CENTER = Vector2i(4,0)
const T_COBBLE_CENTER = Vector2i(6,0)
const T_WATER_CENTER = Vector2i(7,0)

func _ready():
    var ts := TileSet.new()
    var src := TileSetAtlasSource.new()
    src.texture = load("res://assets/tiles_autotile.png")
    src.region = Rect2i(0,0,256,256)
    src.texture_region_size = Vector2i(16,16)
    ts.add_source(src, 0)
    map.tile_set = ts

    # Fill grass
    for y in 0:24:
        for x in 0:40:
            map.set_cell(0, Vector2i(x,y), 0, T_GRASS)

    # Helper to fill rectangle with a tile
    func fill_rect(tile: Vector2i, area: Rect2i):
        for yy in area.position.y:area.position.y+area.size.y:
            for xx in area.position.x:area.position.x+area.size.x:
                map.set_cell(0, Vector2i(xx,yy), 0, tile)

    # Areas
    var path_area = Rect2i(2,12,36,2)
    var plaza_area = Rect2i(24,6,12,10)
    var pond_area = Rect2i(4,16,6,4)

    fill_rect(T_PATH_CENTER, path_area)
    fill_rect(T_COBBLE_CENTER, plaza_area)
    fill_rect(T_WATER_CENTER, pond_area)

    _blend_edges(path_area, "path")
    _blend_edges(plaza_area, "cobble")

func _edge_tile(kind:String, dir:String) -> Vector2i:
    if kind == "path":
        match dir:
            "N": return Vector2i(0,1)
            "S": return Vector2i(1,1)
            "W": return Vector2i(2,1)
            "E": return Vector2i(3,1)
            "NW": return Vector2i(4,1)
            "NE": return Vector2i(5,1)
            "SW": return Vector2i(6,1)
            "SE": return Vector2i(7,1)
    if kind == "cobble":
        match dir:
            "N": return Vector2i(0,2)
            "S": return Vector2i(1,2)
            "W": return Vector2i(2,2)
            "E": return Vector2i(3,2)
            "NW": return Vector2i(4,2)
            "NE": return Vector2i(5,2)
            "SW": return Vector2i(6,2)
            "SE": return Vector2i(7,2)
    return Vector2i(0,0)

func _blend_edges(area: Rect2i, kind:String) -> void:
    var x0 = area.position.x
    var y0 = area.position.y
    var x1 = x0 + area.size.x - 1
    var y1 = y0 + area.size.y - 1
    # edges
    for x in x0:x1+1:
        map.set_cell(0, Vector2i(x, y0-1), 0, _edge_tile(kind, "N"))
        map.set_cell(0, Vector2i(x, y1+1), 0, _edge_tile(kind, "S"))
    for y in y0:y1+1:
        map.set_cell(0, Vector2i(x0-1, y), 0, _edge_tile(kind, "W"))
        map.set_cell(0, Vector2i(x1+1, y), 0, _edge_tile(kind, "E"))
    # corners
    map.set_cell(0, Vector2i(x0-1,y0-1), 0, _edge_tile(kind, "NW"))
    map.set_cell(0, Vector2i(x1+1,y0-1), 0, _edge_tile(kind, "NE"))
    map.set_cell(0, Vector2i(x0-1,y1+1), 0, _edge_tile(kind, "SW"))
    map.set_cell(0, Vector2i(x1+1,y1+1), 0, _edge_tile(kind, "SE"))