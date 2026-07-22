class_name EventBus
extends Node
## Global Decoupled Event Bus & Command Dispatcher
## Handles publish-subscribe events and queued command dispatching across engine layers.

## Emitted when an event is published through the bus.
signal event_emitted(event_type: StringName, payload: Dictionary)

## Dictionary of event_type -> Array of Callable listeners.
var _listeners: Dictionary = {}

## Queue of commands for deterministic replay/processing.
var _command_queue: Array[Dictionary] = []


## Subscribe a callable listener to an event type.
func subscribe(event_type: StringName, listener: Callable) -> void:
	if not _listeners.has(event_type):
		_listeners[event_type] = []

	var listener_array: Array = _listeners[event_type]
	if not listener_array.has(listener):
		listener_array.append(listener)


## Unsubscribe a callable listener from an event type.
func unsubscribe(event_type: StringName, listener: Callable) -> void:
	if not _listeners.has(event_type):
		return

	var listener_array: Array = _listeners[event_type]
	listener_array.erase(listener)
	if listener_array.is_empty():
		_listeners.erase(event_type)


## Instantly emit an event to all subscribers.
func emit_event(event_type: StringName, payload: Dictionary = {}) -> void:
	event_emitted.emit(event_type, payload)

	if not _listeners.has(event_type):
		return

	var listener_array: Array = _listeners[event_type].duplicate()
	for listener in listener_array:
		if listener.is_valid():
			listener.call(payload)


## Queue a command for deferred or deterministic batch processing.
func enqueue_command(command_type: StringName, data: Dictionary = {}) -> void:
	_command_queue.append({"type": command_type, "data": data, "timestamp": Time.get_ticks_msec()})


## Process and flush all queued commands.
func flush_commands() -> Array[Dictionary]:
	var flushed: Array[Dictionary] = _command_queue.duplicate()
	_command_queue.clear()
	for cmd: Dictionary in flushed:
		emit_event(cmd["type"], cmd["data"])
	return flushed


## Clear all listeners and queued commands.
func clear() -> void:
	_listeners.clear()
	_command_queue.clear()
