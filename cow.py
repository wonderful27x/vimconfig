from PIL import Image, ImageDraw, ImageFont

# 保留你的牛头和身体，交替改变腿的位置
# poses = [
#     """(__)
# (-+)_____
# (oo)    /|\\
#   | |--/ | *
#   w w w  w""",

#     """(__)
# (-+)_____
# (oo)    /|\\
#   | /--/ | *
#   w  w w w""",

#     """(__)
# (-+)_____
# (oo)    /|\\
#   \\ |--/ | *
#    w w  w w""",

#     """(__)
# (-+)_____
# (oo)    /|\\
#   | \\--/ | *
#   w  w w  w""",
# ]

poses = [
    """(__)
(-+)_____
(oo)    /|\\
  | /--/ \\ *
  w  w  w  w""",

    """(__)
(-+)_____
(oo)    /|\\
  \\ |--\\ | *
   w w   w w""",

    """(__)
(-+)_____
(oo)    /|\\
  / |--/ | *
 w   w  w  w""",

    """(__)
(-+)_____
(oo)    /|\\
  | \\--\\ / *
  w   w  w w""",
]

# 尽量使用等宽字体，避免 ASCII 图错位
font = None
for path in [
    "DejaVuSansMono.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
    "C:/Windows/Fonts/consola.ttf",
]:
    try:
        font = ImageFont.truetype(path, 30)
        break
    except OSError:
        pass

if font is None:
    font = ImageFont.load_default()

frames = []
for pose, dx, dy in zip(poses, [0, 5, 10, 5], [0, 2, 0, 2]):
    image = Image.new("RGB", (340, 180), "white")
    draw = ImageDraw.Draw(image)
    draw.multiline_text((25 + dx, 12 + dy), pose, font=font,
                        fill="black", spacing=4)
    frames.append(image)

frames[0].save(
    "cow_walking.gif",
    save_all=True,
    append_images=frames[1:],
    duration=180,  # 每帧 180 毫秒
    loop=0,        # 无限循环
    disposal=2,
)

print("已生成 cow_walking.gif")
