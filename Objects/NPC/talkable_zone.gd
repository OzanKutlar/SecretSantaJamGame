extends Area2D


func _ready():
	connect("body_entered", _on_body_entered)


func _on_body_entered(body):
		if body is CharacterBody2D:
			print("Player entered NPC radius of " + self.parent.npc_name);
			if(self.parent.isTalkable):
				body.ableToTalk = true;
				body.talkTo = self.parent;
		
