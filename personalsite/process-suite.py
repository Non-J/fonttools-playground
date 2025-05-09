"""
Based on Google Font's work on Korean language subsetting.

Further procesing includes:
- Enhanced "all page" (aka, some korean that will appear in pages of other languages)
- Combine some font files so that some file doesn't contain just 1-2 glyphs (higher bandwidth usage for lower file count)
"""

from subprocess import call
from fontTools.ttLib import TTFont
import random
import string


def gen_str(length=8):
    return "".join(random.choices(string.ascii_letters + string.digits, k=length))


def extract_chars_from_font(filepath: str):
    font = TTFont(filepath)
    cmap = font["cmap"]
    chars = set()

    for table in cmap.tables:
        if table.isUnicode():
            chars.update(table.cmap.keys())

    return set(map(lambda x: f"U+{x:04X}", chars))


def merge_unicode_ranges(codepoints: set[str]) -> str:
    values = sorted(int(code[2:], 16) for code in codepoints)
    if not values:
        return []

    merged_ranges: list[str] = []
    start = prev = values[0]

    for code in values[1:]:
        if code == prev + 1:
            prev = code
        else:
            if start == prev:
                merged_ranges.append(f"U+{start:04X}")
            else:
                merged_ranges.append(f"U+{start:04X}-{prev:04X}")
            start = prev = code

    if start == prev:
        merged_ranges.append(f"U+{start:04X}")
    else:
        merged_ranges.append(f"U+{start:04X}-{prev:04X}")

    return ",".join(merged_ranges)


def parse_unicode_range(codepoints: str) -> set[str]:
    result = set()

    for coderange in codepoints.split(","):
        coderange = coderange.strip().upper()
        if "-" in coderange:
            start_str, end_str = coderange.split("-")
            start = int(start_str[2:], 16)
            end = int(end_str, 16)
            for codepoint in range(start, end + 1):
                result.add(f"U+{codepoint:04X}")
        else:
            codepoint = int(coderange[2:], 16)
            result.add(f"U+{codepoint:04X}")

    return result


def file_to_unicode_range(filepath: str) -> set[str]:
    result: set[str] = set()

    with open(filepath) as file:
        for line in file.readlines():
            for char in line.strip():
                codepoint = ord(char)
                if codepoint < 128:
                    continue  # ignore ascii
                result.add(f"U+{codepoint:04X}")

    return result


if __name__ == "__main__":
    font_target = "../suite/fonts/variable/woff2/SUITE-Variable.woff2"

    spaces_codepoints = parse_unicode_range("U+D,U+20,U+A0,U+AD,U+2007-200B")
    korean_codepoints = parse_unicode_range(
        "U+AC00-D7A3,U+1100-11FF,U+3130-318F,U+A960-A97F,U+D7B0-D7FF,U+321C,U+FFE6,U+20A9"
    )
    allowed_codepoints = spaces_codepoints.union(korean_codepoints)

    filehash = gen_str()
    font_codepoints = extract_chars_from_font(font_target)
    allpage_codepoints = file_to_unicode_range("korean-all-pages-text.txt")
    allpage_codepoints.update(
        parse_unicode_range("U+0020,U+B9AC,U+ACE0,U+C778,U+C2DC,U+C0AC")
    )

    css_output = ""

    def add_css(id: str, weight: int | None, codepoints: set[str]):
        global css_output
        global filehash
        css_output += f"""/* [{id}{"" if weight == None else weight}] */
@font-face {{
  font-family: 'SUITE';
  font-style: normal;
  font-weight: {"300 900" if weight == None else weight};
  font-display: swap;
  src: url('/assets/fonts/SUITE{"" if weight == None else ("-%d" % weight)}-{id}.{filehash}.woff2') format('woff2');
  unicode-range: {merge_unicode_ranges(codepoints)};
}}\n"""

    glyph_counter = 0
    counter = 1
    rolling: set[str] = set()

    with open("korean-google-fonts-codepoints.txt") as file:
        for idx, line in enumerate(file.readlines()):
            line = parse_unicode_range(line)

            if idx < 100:
                # Mostly really uncommon characters/hanja
                output = (
                    line.intersection(font_codepoints)
                    .intersection(allowed_codepoints)
                    .difference(allpage_codepoints)
                )
                rolling_output = rolling.union(output)

                if len(rolling_output) > 50:
                    # output rolling
                    call(
                        [
                            "pyftsubset",
                            font_target,
                            "--flavor=woff2",
                            f"--output-file=output-suite/SUITE-{counter}.{filehash}.woff2",
                            '--layout-features=""',
                            f"--unicodes={merge_unicode_ranges(rolling)}",
                        ]
                    )
                    add_css(counter, None, rolling)
                    print(f"Output: #{idx}=>{counter}, count={len(rolling)}")
                    glyph_counter += len(rolling)
                    counter += 1
                    rolling = output
                else:
                    rolling = rolling_output

                if idx == 99:
                    # last of rolling
                    call(
                        [
                            "pyftsubset",
                            font_target,
                            "--flavor=woff2",
                            f"--output-file=output-suite/SUITE-{counter}.{filehash}.woff2",
                            '--layout-features=""',
                            f"--unicodes={merge_unicode_ranges(rolling)}",
                        ]
                    )
                    add_css(counter, None, rolling)
                    print(f"Output: #{idx}=>{counter}, count={len(rolling)}")
                    glyph_counter += len(rolling)
                    counter += 1

            else:
                # Common characters
                output = (
                    line.intersection(font_codepoints)
                    .intersection(allowed_codepoints)
                    .difference(allpage_codepoints)
                )

                if len(output) == 0:
                    continue

                call(
                    [
                        "pyftsubset",
                        font_target,
                        "--flavor=woff2",
                        f"--output-file=output-suite/SUITE-{counter}.{filehash}.woff2",
                        '--layout-features=""',
                        f"--unicodes={merge_unicode_ranges(output)}",
                    ]
                )
                add_css(counter, None, output)
                print(f"Output: #{idx}=>{counter}, count={len(output)}")
                glyph_counter += len(output)
                counter += 1

    with open("output-suite/SUITE.css", "w", encoding="utf-8") as file:
        file.write(css_output)

    css_output = ""
    call(
        [
            "pyftsubset",
            font_target,
            "--flavor=woff2",
            f"--output-file=output-suite/SUITE-0.{filehash}.woff2",
            '--layout-features=""',
            f"--unicodes={merge_unicode_ranges(allpage_codepoints)}",
        ]
    )
    add_css(0, None, allpage_codepoints)
    print(f"Output: all page (=0), count={len(allpage_codepoints)}")
    glyph_counter += len(allpage_codepoints)

    allowed_codepoints_str = merge_unicode_ranges(allowed_codepoints)

    for wght, name in [
        [300, "Light"],
        [400, "Regular"],
        [500, "Medium"],
        [600, "SemiBold"],
        [700, "Bold"],
        [800, "ExtraBold"],
        [900, "Heavy"],
    ]:
        call(
            [
                "pyftsubset",
                f"../suite/fonts/static/ttf/SUITE-{name}.ttf",
                f"--output-file=output-suite/SUITE-{wght}.{filehash}.ttf",
                '--layout-features=""',
                f"--unicodes={allowed_codepoints_str}",
            ]
        )
        css_output += f"""@font-face {{
  font-family: 'SUITE';
  font-style: normal;
  font-display: swap;
  font-weight: {wght};
  src: url('/assets/fonts/SUITE-{wght}.{filehash}.ttf') format('truetype');
  unicode-range: {allowed_codepoints_str};
}}\n"""
        print(f"Output: legacy static font {wght} {name}")

    with open("output-suite/SUITE-special.css", "w", encoding="utf-8") as file:
        file.write(css_output)

    print(
        f"Done: {glyph_counter} out of {len(font_codepoints.intersection(allowed_codepoints))}"
    )
