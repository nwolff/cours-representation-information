module HexUtilsTest exposing (binTests, chunkTests)

import Expect
import HexUtils exposing (chunk, bin)
import Test exposing (Test, describe, test)


chunkTests : Test
chunkTests =
    let
        chunkNibbles : String -> String
        chunkNibbles = chunk 4 "'"
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

binTests: Test
binTests =
    describe "Bin"
     [ test "convert 3 to binary"
        (\_ -> Expect.equal "11" (bin 8 3))
     ,  test "convert 255 to binary"
        (\_ -> Expect.equal "1111'1111" (bin 8 255))
     ,  test "convert -9 on 8 bits"
        (\_ -> Expect.equal "1111'0111" (bin 8 -9))
     ,  test "convert -1 on 8 bits"
        (\_ -> Expect.equal "1111'1111" (bin 8 -1))
     ,  test "convert -128 on 8 bits"
        (\_ -> Expect.equal "1000'0000" (bin 8 -128))
     ,  test "convert -9 on 16 bits"
        (\_ -> Expect.equal "1111'1111'1111'0111" (bin 16 -9))
     ]
