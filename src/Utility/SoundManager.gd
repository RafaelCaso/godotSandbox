extends AudioStreamPlayer2D

var audio_clips = {
	"low_end_laser" : preload("res://Assets/SoundEffects/low_end_laser.wav")
}

func play_clip(clip_name):
	if audio_clips.has(clip_name):
		stream = audio_clips[clip_name];
		play();
	else:
		printerr("audio clip not found: ", clip_name);

func stop_clip():
	stop();
