Shows integer overflow on 8-bit numbers, unsigned versus signed.

The program prints the value and bit pattern of:

- a `uint8_t` going from 127 to 128, and from 0 to 0 - 1 (wraps to 255)
- an `int8_t` going from 127 to 127 + 1 (wraps to -128), and from 0 to -1

The same bit patterns appear in both cases; only their interpretation changes.

## Usage

    cc signed_vs_unsigned.c && ./a.out

Note: in `s = s + 1`, `s` is first promoted to `int`, so the addition itself
does not overflow. Storing 128 back into an `int8_t` is implementation-defined
(GCC and Clang wrap it to -128), not undefined behavior. Overflowing an `int`
directly (`INT_MAX + 1`) would be undefined behavior.
