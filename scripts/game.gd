extends Node2D

var cursor_position = Vector2()
var cursor_offset = Vector2(0, 10)
var camera_zoom = 1

var camera_offset = Vector2()
var camera_half = Vector2()

onready var terrain = $container/viewport/terrain
onready var cursor = $container/viewport/cursor
onready var camera = $container/viewport/camera
onready var label = $container/interface/label

func _ready():
    camera_half = get_viewport_rect().size / 2
    center_terrain()

func _process(delta):
    if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()

func _input(event):
    if event is InputEventMouseMotion or event is InputEventMouseButton:
        set_cursor_grid_position(event)
    
    if event is InputEventMouseMotion:
        var is_dragging = Input.is_mouse_button_pressed(BUTTON_MIDDLE) and not event.is_echo()

        if is_dragging:
            camera.position -= event.relative * Vector2(camera_zoom, camera_zoom)

func on_camera_zoom_changed(zoom):
    camera_zoom = zoom

func hide_mouse():
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_cursor_grid_position(event):
    var zp = Vector2(camera_zoom, camera_zoom)
    cursor_position = terrain.world_to_map(event.position - camera_half + camera.position / zp) * zp
    cursor.position = terrain.map_to_world(cursor_position) + cursor_offset
    
func center_terrain():
    var offset = terrain.map_to_world(terrain.get_used_rect().size) / 2
    camera.position.y = offset.y