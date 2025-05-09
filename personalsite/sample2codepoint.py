from sys import argv

if len(argv) != 2:
	print("Give file path as script argument")
	exit()

result = []

with open(argv[1]) as file:
	for line in file.readlines():
		for char in line.strip():
			char_val = ord(char)
			if char_val < 128:
				continue
			result.append(f"U+{hex(char_val)[2:].upper().zfill(4)}")

print(",".join(sorted(list(dict.fromkeys(result)))))
