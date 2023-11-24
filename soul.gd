extends CharacterBody2D
class_name Soul;

@onready var soul = get_node("AnimatedSprite2D");

func _physics_process(_delta):
	soul.play("idle")
		
