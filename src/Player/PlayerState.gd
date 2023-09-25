extends Node

var currentShipID : String = "ship_0000";
var equippedLaserID: String = "laser_0000";
var weapons : Array = ["laser_0000"];
var available_ships : Array = ["ship_0000"];
var missileStock : int = 10;

var object_selected = false;

enum MissileState {NONE, FIRED, DETONATED}
var missile_state = MissileState.NONE
var active_cluster_missile = null;
