extends CharacterBody2D
const SPEED := 120.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
func _ready():
    var frames := SpriteFrames.new()
    for d in ["down","left","right","up"]:
        frames.add_animation(d)
        frames.set_animation_speed(d, 10.0)
        for i in 3:
            frames.add_frame(d, load("res://assets/player_%s_%d.png" % [d,i]))
    anim.sprite_frames = frames
    anim.animation = "down"
    anim.play()
func _physics_process(delta):
    var v := Vector2.ZERO
    v.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    v.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    if Input.is_key_pressed(KEY_A): v.x = -1
    if Input.is_key_pressed(KEY_D): if v.x == 0: v.x = 1
    if Input.is_key_pressed(KEY_W): v.y = -1
    if Input.is_key_pressed(KEY_S): if v.y == 0: v.y = 1
    if v.length() > 0:
        v = v.normalized()
        velocity = v * SPEED
        if abs(v.x) > abs(v.y):
            anim.animation = "right" if v.x > 0 else "left"
        else:
            anim.animation = "down" if v.y > 0 else "up"
        if not anim.is_playing(): anim.play()
    else:
        velocity = Vector2.ZERO
        anim.stop()
    move_and_slide()