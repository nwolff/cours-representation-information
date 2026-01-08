module BinHexUtilsTest exposing (binRelTests, binTests, chunkTests, hexRelTests)

import BinHexUtils exposing (bin, binRel, chunk, hexRel)
import Expect
import Test exposing (Test, describe, test)


chunkTests : Test
chunkTests =
    let
        chunkNibbles : String -> String
        chunkNibbles =
            chunk 4 "'"
    in
    describe "Chunk"
        [ test "chunk empty is empty"
            (\_ -> Expect.equal "" (chunkNibbles ""))
        , test "chunk short doesn't change"
            (\_ -> Expect.equal "1000" (chunkNibbles "1000"))
        , test "chunk just once"
            (\_ -> Expect.equal "1'0000" (chunkNibbles "10000"))
        , test "chunk just before twice"
            (\_ -> Expect.equal "1000'0000" (chunkNibbles "10000000"))
        , test "chunk twice"
            (\_ -> Expect.equal "1'0000'0000" (chunkNibbles "100000000"))
        ]


binTests : Test
binTests =
    describe "Bin"
        [ test "convert 3 to binary"
            (\_ -> Expect.equal "11" (bin 3))
        , test "convert 255 to binary"
            (\_ -> Expect.equal "1111'1111" (bin 255))
        ]


binRelTests : Test
binRelTests =
    describe "Bin Rel"
        [ test "convert 10 on 8 bits"
            (\_ -> Expect.equal "0000'1010" (binRel 8 10))
        , test "convert -9 on 8 bits"
            (\_ -> Expect.equal "1111'0111" (binRel 8 -9))
        , test "convert -1 on 8 bits"
            (\_ -> Expect.equal "1111'1111" (binRel 8 -1))
        , test "convert -128 on 8 bits"
            (\_ -> Expect.equal "1000'0000" (binRel 8 -128))
        , test "convert -9 on 16 bits"
            (\_ -> Expect.equal "1111'1111'1111'0111" (binRel 16 -9))
        ]


hexRelTests : Test
hexRelTests =
    describe "Hex Rel"
        [ test "convert 10 on 8 bits"
            (\_ -> Expect.equal "0A" (hexRel 8 10))
        , test "convert 127 on 8 bits"
            (\_ -> Expect.equal "7F" (hexRel 8 127))
        , test "convert -128 on 8 bits"
            (\_ -> Expect.equal "80" (hexRel 8 -128))
        , test "convert -1 on 8 bits"
            (\_ -> Expect.equal "FF" (hexRel 8 -1))
        , test "convert -9 on 8 bits"
            (\_ -> Expect.equal "F7" (hexRel 8 -9))
        , test "convert -9 on 16 bits"
            (\_ -> Expect.equal "FFF7" (hexRel 16 -9))
        ]
