A tiny binary format for describing shapes, to show how structured data can be
encoded as a sequence of bytes.

Each shape is encoded as:

| Shape     | Bytes                                                                     |
| --------- | ------------------------------------------------------------------------- |
| Circle    | type `01` · radius (2 bytes) · red, green, blue (1 byte each)             |
| Rectangle | type `02` · width (2 bytes) · height (2 bytes) · red, green, blue (1 byte each) |

The script serializes a few example shapes and prints them in binary and
hexadecimal, including a sequence of shapes framed by a start byte `BB` and an
end byte `FF`.

## Usage

Requires [uv](https://docs.astral.sh/uv/).

    uv run shape_description.py
