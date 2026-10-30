from PIL import Image, ImageDraw
import math
import random

W, H = 720, 400
random.seed(12)
stars = [(random.randrange(W), random.randrange(20, 255),
          random.choice((1, 1, 2))) for _ in range(55)]

frames = []

for frame in range(16):
    im = Image.new("RGB", (W, H), "#101827")
    d = ImageDraw.Draw(im)
    t = frame * 2 * math.pi / 16
    flap = int(19 * math.sin(t))
    sway = int(9 * math.sin(t))

    def poly(points, color, edge="#142b28", width=3):
        d.polygon(points, fill=color)
        d.line(points + [points[0]], fill=edge, width=width, joint="curve")

    # 夜空
    d.ellipse((565, 30, 640, 105), fill="#f3dfa2")
    d.ellipse((584, 20, 653, 95), fill="#101827")
    for x, y, r in stars:
        d.ellipse((x-r, y-r, x+r, y+r), fill="#b8cde0")

    # 卷曲的尾巴
    tail = [
        (337, 259), (266, 260), (205, 283), (153, 319+sway),
        (105, 321+sway), (82, 298+sway), (91, 272+sway),
        (70, 284+sway), (61, 315+sway), (79, 345+sway),
        (118, 354+sway), (168, 338+sway), (222, 313),
        (278, 303), (347, 315),
    ]
    poly(tail, "#247a61")
    # 尾巴上的尖刺
    for x, y in [(105, 318+sway), (143, 323+sway),
                 (184, 303), (225, 284), (267, 270)]:
        poly([(x-9, y), (x-2, y-15), (x+10, y-2)],
             "#a8d783", width=2)

    # 翅膀：每帧上下扇动
    wing = [
        (362, 244), (203, 102+flap), (261, 122+flap),
        (299, 44+flap), (344, 108+flap),
        (406, 55+flap), (419, 151),
        (474, 123+flap//2), (448, 259),
    ]
    poly(wing, "#347f75", width=4)
    for tip in (wing[1], wing[3], wing[5], wing[7]):
        d.line([(383, 236), tip], fill="#9acb9c", width=3)

    # 后腿
    poly([(316, 293), (289, 334), (299, 361), (357, 358),
          (370, 332), (351, 290)], "#287d60")
    for x in (305, 324, 344):
        poly([(x, 354), (x+10, 354), (x+7, 365)],
             "#e8d5a1", width=1)

    # 身体与腹部
    poly([(297, 270), (327, 231), (391, 215), (451, 234),
          (475, 276), (450, 317), (382, 331), (318, 309)],
         "#32966d", width=4)
    poly([(377, 272), (439, 255), (462, 282), (443, 314),
          (393, 320), (362, 303)], "#c7bc83", width=2)
    for x, y in [(334, 261), (353, 248), (371, 239),
                 (343, 282), (368, 276), (389, 290)]:
        d.arc((x, y, x+19, y+14), 10, 170, fill="#a9da98", width=2)

    # 背刺与颈部
    for x, y in [(316, 255), (338, 236), (363, 222),
                 (388, 216), (413, 214)]:
        poly([(x-8, y+7), (x, y-14), (x+12, y+7)],
             "#b5d887", width=2)
    poly([(405, 249), (426, 213), (454, 183), (482, 174),
          (501, 192), (481, 253), (449, 280)],
         "#32966d", width=4)

    # 头、长吻与下颌
    poly([(463, 191), (480, 170), (516, 165), (537, 179),
          (552, 197), (581, 205), (588, 219),
          (570, 229), (529, 222), (506, 230), (480, 216)],
         "#40a879", width=4)
    poly([(506, 229), (536, 222), (566, 230), (580, 225),
          (568, 242), (539, 250), (511, 242)],
         "#26785d", width=3)

    # 双角、耳鳍、眼睛、鼻孔和牙
    poly([(483, 176), (470, 134), (497, 159), (508, 171)],
         "#e5d5a4")
    poly([(510, 168), (520, 137), (533, 173)], "#e5d5a4")
    poly([(463, 187), (438, 176), (454, 204)], "#acd68d")
    d.ellipse((522, 183, 537, 198), fill="#efc563")
    d.ellipse((529, 184, 534, 198), fill="#182322")
    d.ellipse((566, 209, 572, 214), fill="#193b32")
    for x in (535, 553):
        poly([(x, 225), (x+9, 226), (x+4, 234)],
             "#f7ead0", width=1)

    # 前爪
    poly([(439, 278), (464, 296), (467, 334),
          (452, 350), (418, 344), (424, 329)],
         "#2b8965")
    for x in (423, 438, 453):
        poly([(x, 343), (x+9, 343), (x+5, 356)],
             "#e8d5a1", width=1)

    # 火焰：长度和轮廓随帧变化
    reach = 42 + int(15 * (1 + math.sin(t * 2)))
    fire = [
        (577, 214), (604, 202),
        (618+reach, 194-abs(sway)),
        (630+reach//2, 218),
        (647+reach, 239+abs(sway)),
        (611, 232), (581, 225),
    ]
    poly(fire, "#ef693b", edge="#b83d30", width=2)
    poly([(585, 216), (616, 209), (632+reach//2, 216),
          (613, 223), (589, 222)],
         "#ffd069", edge="#ffd069", width=1)

    frames.append(im.resize((1080, 600), Image.Resampling.LANCZOS))

frames[0].save(
    "dragon.gif",
    save_all=True,
    append_images=frames[1:],
    duration=90,
    loop=0,
    disposal=2,
)
print("已生成 dragon.gif")
