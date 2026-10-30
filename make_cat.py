from PIL import Image, ImageDraw, ImageFont

head = [" /\\_/\\", "( o.o )", " /| |\\"]
feet = [" /   \\", "  / \\", " \\   /", "  / \\"]
font = ImageFont.load_default()
frames = []

for i in range(10):
    image = Image.new("RGB", (170, 65), "#20242b")
    draw = ImageDraw.Draw(image)
    cat = "\n".join(head + [feet[i % len(feet)]])
    draw.multiline_text((6 + i * 12, 6), cat, font=font,
                        fill="#f5e6c8", spacing=2)
    frames.append(image.resize((680, 260), Image.Resampling.NEAREST))

frames[0].save(
    "walking_cat.gif",
    save_all=True,
    append_images=frames[1:],
    duration=140,
    loop=0,
    disposal=2,
)
