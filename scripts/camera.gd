extends Camera2D

export var zoom_step = 0.5
export var zoom_min = 0.5
export var zoom_max = 1.0
export var zoom_speed = 2.0

signal zoom_changed

var zoom_target = 1

func move_towards(current, target, maxdelta):
    if abs(target - current) <= maxdelta:
        return target
    return current + sign(target - current) * maxdelta
    
func _process(delta):
    var new_zoom = move_towards(get_zoom().x, zoom_target, zoom_speed * delta)
    
    if get_zoom().x != zoom_target:
        emit_signal("zoom_changed", zoom_target)
    
    set_zoom(Vector2(new_zoom, new_zoom))
  
func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed() and not event.is_echo():
            if event.button_index == BUTTON_WHEEL_UP:
                zoom_target -= zoom_step / zoom_target + 1
            if event.button_index == BUTTON_WHEEL_DOWN:
                zoom_target += zoom_step / zoom_target + 1            
    zoom_target = clamp(zoom_target, zoom_min, zoom_max)