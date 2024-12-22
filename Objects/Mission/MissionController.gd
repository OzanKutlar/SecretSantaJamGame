extends RichTextLabel

var mission_controller := []
@export var player: CharacterBody2D

func add_mission(name, item_id, amount, given_by, reward := "Hay", reward_amount := 10) -> int:
	var mission = {
		"Mission Name": name,
		"Mission Item": item_id,
		"Mission Goal": amount,
		"Mission Given By": given_by,
		"Mission Reward": reward,
		"Reward Amount": reward_amount,
		"Mission State": 1,
		"Currently Collected": 0
	}
	
	mission_controller.append(mission)
	
	update_mission_display()
	return mission_controller.size() - 1

func collect_item(itemID: int) -> void:
	for i in range(mission_controller.size()):
		var mission = mission_controller[i]
		
		# Check if the mission is active and the item matches
		if mission["Mission State"] == 1 and mission["Mission Item"] == itemID:
			mission["Currently Collected"] += 1
			
			# Ensure it does not exceed the mission goal
			if mission["Currently Collected"] > mission["Mission Goal"]:
				mission["Currently Collected"] = mission["Mission Goal"]
			
			# Check if the mission is now completed
			if is_mission_completed(i):
				finish_mission(i)
	
	update_mission_display()


func finish_mission(missionID) -> void:
	if missionID < 0 or missionID >= mission_controller.size():
		print("Invalid mission ID:", missionID)
		return
	
	mission_controller[missionID]["Mission State"] = 2
	var mission = mission_controller[missionID]
	
	update_mission_display()
		
func is_mission_completed(missionID: int) -> bool:
	if missionID < 0 or missionID >= mission_controller.size():
		print("Invalid mission ID:", missionID)
		return false
	
	var mission = mission_controller[missionID]
	if mission["Currently Collected"] >= mission["Mission Goal"]:
		return true
	return false

func update_mission_display() -> void:
	var mission_text = "[b]Current Missions:[/b]\n"  # Add a bold header
	
	for i in range(mission_controller.size()):
		var mission = mission_controller[i]
		if mission["Mission State"] == 1:  # Display active missions
			mission_text += str(i + 1) + " - " + mission["Mission Name"] + " " + str(mission["Currently Collected"]) + "/" + str(mission["Mission Goal"]) + "\n"
		elif mission["Mission State"] == 2:  # Display completed missions
			mission_text += str(i + 1) + " - " + mission["Mission Name"] + " [Completed]\n"
	
	self.text = mission_text  # Set the text property directly
