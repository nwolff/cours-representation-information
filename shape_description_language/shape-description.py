from dataclasses import dataclass

from bitstring import BitArray, Bits

CIRCLE = 1
RECTANGLE = 2


@dataclass(frozen=True)
class Color:
    r: int
    g: int
    b: int

    def serialize(self) -> Bits:
        r = BitArray()
        r += BitArray(u8=self.r)
        r += BitArray(u8=self.g)
        r += BitArray(u8=self.b)
        return r


@dataclass(frozen=True)
class Circle:
    radius: int
    color: Color

    def serialize(self) -> Bits:
        r = BitArray()
        r += BitArray(u8=CIRCLE)
        r += BitArray(u16=self.radius)
        r += self.color.serialize()
        return r


@dataclass(frozen=True)
class Rectangle:
    width: int
    height: int
    color: Color

    def serialize(self) -> Bits:
        r = BitArray()
        r += BitArray(u8=RECTANGLE)
        r += BitArray(u16=self.width)
        r += BitArray(u16=self.height)
        r += self.color.serialize()
        return r


a_circle = Circle(radius=50, color=Color(r=4, g=3, b=2))

another_circle = Circle(radius=257, color=Color(r=255, g=255, b=0))

a_rectangle = Rectangle(width=0x0202, height=0x0202, color=Color(r=2, g=2, b=2))

another_rectangle = Rectangle(
    width=0x0200, height=2000, color=Color(r=255, g=255, b=255)
)

print(a_circle.serialize())
print(a_rectangle.serialize())
print(another_rectangle.serialize())

all_together = BitArray()
all_together += BitArray(u8=0xBB)
all_together += a_circle.serialize()
all_together += a_rectangle.serialize()
all_together += another_rectangle.serialize()
all_together += BitArray(u8=0xFF)
all_together.pp(fmt="hex", show_offset=False)

another_circle.serialize().pp(fmt="hex", show_offset=False)
