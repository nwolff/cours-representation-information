#!/usr/bin/env python

import random
import textwrap

from flask import Flask, redirect, render_template

app = Flask(__name__)
app.config["SEND_FILE_MAX_AGE_DEFAULT"] = 600


@app.template_filter("bin")
def binary_filter(n):
    bin_num = f"{n:b}"
    bin_num = "'".join(textwrap.wrap(bin_num[::-1], 4))[::-1]
    return f"<code>{bin_num}</code>"


@app.template_filter("hex")
def hex_filter(n):
    return f"({n:X})<sub>16</sub>"


def make_exercices(r: random.Random):
    XXS = list(range(3, 5))
    XS = list(range(5, 8))
    S = list(range(8, 16))
    M = list(range(16, 128))
    L = list(range(128, 256))
    XL = list(range(255, 512))

    def conversion_numbers():
        return [r.choice(x) for x in (S, L, XL)]

    def addition():
        pairs = (S, M), (M, L), (L, M)
        return [(r.choice(a), r.choice(b)) for a, b in pairs]

    def shift_multiplication():
        numbers = [0b111, 0b1111111, 0b111100]
        pows = [2, 4, 8]
        r.shuffle(pows)
        return zip(numbers, pows)

    def multiplication():
        pairs = (S, XS), (M, XS), (XXS, XL)
        return [(r.choice(a), r.choice(b)) for a, b in pairs]

    def shift_division():
        numbers = [0b101, 0b1010101, 0b11110000]
        pows = r.sample([2, 4, 8, 16, 32], 3)
        return zip(numbers, pows)

    return dict(
        dec2bin=conversion_numbers(),
        bin2dec=conversion_numbers(),
        addition=addition(),
        shift_multiplication=shift_multiplication(),
        multiplication=multiplication(),
        shift_division=shift_division(),
        dec2hex=conversion_numbers(),
        hex2dec=conversion_numbers(),
    )


@app.route("/<serie>")
def exercices(serie):
    r = random.Random(serie)
    return render_template("exercices.j2", serie=serie, exercices=make_exercices(r))


@app.route("/")
def home():
    serie = random.randint(0, 10_000)
    return redirect(f"/{serie}")


if __name__ == "__main__":
    # Only when developing
    app.run(host="0.0.0.0", port=8080, debug=True)
