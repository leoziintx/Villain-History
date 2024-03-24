extends KinematicBody2D

onready var rayE = get_node("rayE")
onready var rayD = get_node("rayD")
onready var sprite = get_node("sprite")

var vivo = true
var UP = Vector2.UP
var left
var right
var up
var fim = false

signal morreu
signal fim
signal moeda


#-------------------------------------------------------------------------------------------------

const GRAVITY = 1600.0
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 350
const WALK_MAX_SPEED = 350
const STOP_FORCE = 1300
const JUMP_SPEED = 700
const JUMP_MAX_AIRBORNE_TIME = 0.2
const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 0.0
var jumping = false
var prev_jump_pressed = false

func _process(delta):
	pass

func _physics_process(delta:float) -> void:

	var force = Vector2(0, GRAVITY)
	var walk_left = (Input.is_action_pressed("move_left")or left) and vivo
	var walk_right = (Input.is_action_pressed("move_right") or right or fim) and vivo
	var jump = (Input.is_action_pressed("jump") or up) and vivo
	var stop = true

	if walk_left:
		if velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false

	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)

		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0

		velocity.x = vlen * vsign

	velocity += force * delta

	if is_on_floor():
			on_air_time = 0.0
			jumping = false
			
	if jump and on_air_time < JUMP_MAX_AIRBORNE_TIME and !jumping and !prev_jump_pressed:
		if is_on_floor() or on_air_time < JUMP_MAX_AIRBORNE_TIME:
			pular()

	if is_on_floor() and jumping and velocity.y > 0:
		jumping = false
	

	on_air_time += delta
	prev_jump_pressed = jump

	var no_chao = rayE.is_colliding() or rayD.is_colliding()
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	
	if walk_right:
		sprite.set_flip_h(false)
	if walk_left:
		sprite.set_flip_h(true)
		
	if (walk_left or walk_right) and no_chao:
		sprite.play()
	elif (walk_left or walk_right):
		sprite.stop()
		sprite.set_frame(9)
	else:
		sprite.stop()
		sprite.set_frame(0)
	if jumping:
		sprite.stop()
		sprite.set_frame(9)
		
	if get_position().y > 900: morrer()

	#velocity = move_and_slide(velocity, UP)

func _ready():
	set_process(true)

func _on_pes_body_entered(body):
	if not vivo: return
	pular()
	body.esmagar()
	print("esmagou")

func pular():
	velocity.y = -JUMP_SPEED
	jumping = true
	

func _on_corpo_body_entered(body):
	if not vivo: return
	morrer()
	
func morrer():
	if not vivo:return
	vivo = false
	velocity.y = -800
	get_node("shape").set_deferred("disabled", true)
	emit_signal("morreu")
	print("morreu")

func _on_cabeca_body_entered(body):
	if not vivo: return
	if body.has_method("destruir"):
		body.destruir()
		

func _on_toutchLeft_pressed():
	left = true

func _on_toutchLeft_released():
	left = false

func _on_toutchRight_pressed():
	right = true
	
func _on_toutchRight_released():
	right = false

func _on_toutchup_pressed():
	up = true

func _on_toutchup_released():
	up = false

func reviver():
	velocity = Vector2(0, 0)
	get_node("shape").set_deferred("disabled", false)
	get_node("camera").make_current()
	vivo = true
	fim = false

func _on_fim_body_entered(body):
	fim = true
	emit_signal("fim")

func moeda():
	emit_signal("moeda")


func _on_game_timer_timeout():
	morrer()
