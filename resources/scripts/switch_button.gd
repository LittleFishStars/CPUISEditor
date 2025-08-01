@tool
@icon('res://resources/icons/switch_button.svg')
class_name SwitchButton
extends Button

var state = 0:
	set(new_state):
		state = int(new_state)
		self.icon = self.icons[int(new_state)]

@export var button_size: int = 64:
	set(new_size):
		button_size = new_size
		self.custom_minimum_size = Vector2(new_size, new_size)

@export var icons: Array[Texture2D] = [icon]:
	set(new_icons):
		icons = new_icons
		self.icon = new_icons[self.state]

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				self.state = posmod(self.state + 1, len(self.icons))
			if event.button_index == MOUSE_BUTTON_RIGHT:
				self.state = posmod(self.state - 1, len(self.icons))
