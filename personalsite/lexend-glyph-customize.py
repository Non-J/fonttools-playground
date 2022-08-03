from glyphsLib import GSFont

font = GSFont("../lexend/sources/Lexend.glyphs")
variables = {}

for idx, axis in enumerate(font.axes):
	variables[axis.axisTag.lower()] = idx

print(f"Variable axes: {variables}")

# for parameter in font.customParameters:
	# print(parameter)

# for master in font.masters:
	# for parameter in master.customParameters:
		# print(parameter)

for instance in font.instances:
	print(instance.fullName)

# font.save("Lexend-custom.glyphs")
