extends Node2D

@onready var heartContainer = $CanvasLayer/HeartsContainer;
@onready var player = $Player/Monk;

# Called when the node enters the scene tree for the first time.
func _ready():
	heartContainer.setMaxHearts(player.maxHealth);
	heartContainer.updateHearts(player.currentHealth);
	player.healthChanged.connect(heartContainer.updateHearts)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	onPlayerDeath(player.gameover);
	#_on_to_phase_2_body_entered(player);
	
func onPlayerDeath(gameover: bool):
	# TODO if gameover: get_tree().change_scene_to_file(cena do game over);
	if gameover: 
		get_tree().change_scene_to_file("res://gameover.tscn");


# -= TODO =-
# 1. Knockback do inimigo
# 2. Fazer inimgo mudar a direção quando bater na parede
# 3. Cena de gameover - (Falta implementar o score)
# 4. Melhorar a 1° fase - OK
# 5. Fazer 2° fase 
# 6. Fazer 3° fase
# 7. Cena de vitória 
# 8. Implementar tempo
# 9. Power up
# 10. Troca de fase - (Procurar um sprite maneiro)

func _on_to_phase_2_body_entered(body: Node2D):
	if body.name == "Monk":
		get_tree().change_scene_to_file("res://Level2.tscn");
