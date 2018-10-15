extends Node2D

var cursor = preload("res://scenes/cursor.tscn").instance()
var cursor_position = Vector2()
var cursor_offset = Vector2(0, 10)
var current_map
var camera
var camera_zoom = 1
var viewport

var is_dragging = false

func _ready():
#    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    current_map = $container/viewport/terrain
    camera = $container/viewport/camera
    var map_size = current_map.map_to_world(current_map.get_used_rect().size)
    camera.offset = map_size / 2
    viewport = $container/viewport
    viewport.add_child(cursor)
    
func _input(event):
    if event is InputEventMouseMotion:
        is_dragging = Input.is_mouse_button_pressed(BUTTON_MIDDLE) and not event.is_echo()
        
        if is_dragging:
            camera.offset -= event.relative * Vector2(camera_zoom, camera_zoom)
        else:
            update_cursor_position()

func _process(delta):
    if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()
        
    cursor.set_position(cursor_position)

func update_cursor_position():
    var position = get_global_mouse_position() * camera_zoom + camera.offset
    var map_position = current_map.world_to_map(position)
    var world_position = current_map.map_to_world(map_position)
    
    cursor_position = world_position + cursor_offset

func snap_to_map(position):
    return current_map.map_to_world(current_map.world_to_map(position))

func on_camera_zoom_changed(zoom):
    camera_zoom = zoom
