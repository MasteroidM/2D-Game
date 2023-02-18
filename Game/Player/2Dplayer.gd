extends KinematicBody2D
const MAX_SPEED = 95
const accel = 500
const fric = 500
const roll_speed = 125

enum{
	move,
	roll,
	atk
}

var state = move
var velocity = Vector2.ZERO
var roll_vector = Vector2.ZERO

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")
onready var swordhitbox = $hitboxpivot/swordhitbox

func _ready():
	animationtree.active = true
	swordhitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		move:
			move_(delta)
	
		roll:
			roll_()
	
		atk:
			atk_()
	
func move_(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordhitbox.knockback_vector = input_vector
		animationtree.set("parameters/idle/blend_position",input_vector)
		animationtree.set("parameters/run/blend_position",input_vector)
		animationtree.set("parameters/atk/blend_position",input_vector)
		animationtree.set("parameters/roll/blend_position",input_vector)
		animationstate.travel("run")
		velocity = velocity.move_toward(input_vector*MAX_SPEED,accel*delta)
	
	else :
		animationstate.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, fric*delta)
		
	
	if Input.is_action_just_pressed("atk"):
		state = atk
	if Input.is_action_just_pressed("roll"):
		state = roll
	
	velocity = move_and_slide(velocity)


func roll_():
	velocity = roll_vector * roll_speed
	animationstate.travel("roll")
	velocity = move_and_slide(velocity)

func atk_():
	velocity = Vector2.ZERO
	animationstate.travel("atk")
	
func atk_finish():
	state = move

func roll_finished():
	state = move

func _on_Area2D_area_entered(area):
	if(area.name=='quit'):
		get_tree().quit()
