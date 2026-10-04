Turns an SVG into pixelated PNGs at several resolutions, to show what happens
when a vector image is rasterized with too few pixels.

Each image is rendered at a small width (8, 16, 32 and 64 pixels), then
blown up without smoothing so that its longest side is 512 pixels and the
individual pixels are visible. The original proportions are kept.

## Prerequisites

Requires [uv](https://docs.astral.sh/uv/) and the native cairo library
(used by cairosvg). On macOS:

    brew install cairo pkg-config

If cairo is installed but Python still can't find it (common on Apple Silicon),
tell your shell where Homebrew keeps its libraries, e.g. in `~/.zshrc`:

    export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
    export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"

## Usage

    uv run rasterize.py letter_s.svg

The images are written to `build/`, e.g. `build/letter_s_faible_16px.png`.
