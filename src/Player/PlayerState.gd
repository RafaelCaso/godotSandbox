extends Node

var currentShipID : String = "ship_0000";
var equippedLaserID: String = "laser_0000";
var weapons : Array = ["laser_0000"];
var available_ships : Array = ["ship_0000"];
var missileStock : int = 10;
var fleet : Dictionary = {};
var active_ship = null;

var object_selected = false;

