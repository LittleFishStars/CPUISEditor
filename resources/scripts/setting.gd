extends Window

signal close(bit: int, button_size: int)

func _on_close_requested() -> void:
	self.close.emit(
		$ScrollContainer/SettingList/Bit/BitSet.value, 
		$ScrollContainer/SettingList/Size/SizeSet.value
	)
	self.hide()
