class_name JsonReader 

enum state {
	OK = 0,
	READ_ERROR = 1,
	JSON_ERROR = 2,
	WRITE_ERROR = 3,
}

static func read(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return {
			'state': state.READ_ERROR,
			'code': FileAccess.get_open_error(),
			'data': {}
		}
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_error = json.parse(content)
	if parse_error != OK:
		return {
			'state': state.JSON_ERROR,
			'massage': json.get_error_message(),
			'line': json.get_error_line(),
			'data': {}
		}
	
	return {
		'state': state.OK,
		'data': json.data
	}

static func write(path: String, data: Dictionary) -> Dictionary:
	var json_string = JSON.stringify(data, '\t')
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return {
			'state': state.WRITE_ERROR,
			'code': FileAccess.get_open_error()
		}
	file.store_line(json_string)
	file.close()
	return {'state': state.OK}
