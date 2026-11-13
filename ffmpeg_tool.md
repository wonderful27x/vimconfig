#### convert gif
`ffmpeg.exe -i .\vim_smile.mp4 -filter_complex "[0:v]fps=10,scale=-1:30:flags=lanczos,tpad=stop_mode=clone:stop_duration=1.5,split[a][b];[a]palettegen[p];[b][p]paletteuse" -loop 0 vim_smile.gif`
