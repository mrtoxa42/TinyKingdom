extends Node

# Genel oyun değikenleşleri
var game_in = false
#Tutulan Sahne Değişkenleri
var currentlevel
var camera2d
var mouseboundary = ""
var BuildSystem
#Oyun içi değişkenler
var middlepoint
var global_mouse_position
var global_mouse_entered = false
var maincastle = null
var redflag
var currentfinish = null
var liveknights = 0
var livearchers = 0
var livepawner = 0
var current_mouse_area = null
var currentsoldiers = []
var currentknights = []
var currentarchers = []
var currentpawn = []
var currentwarriors = 0
var currentarrows = 0
var currentworkers = 0
var mousetouchpos = Vector2.ZERO
var dragged = false
var selectedbox = false


var currentwood = 0
var currentgold = 0
var currentmeat = 0


#Kaydedilecek değerler (sınırsız mod)

#Kaydedilecek oyun dataları


