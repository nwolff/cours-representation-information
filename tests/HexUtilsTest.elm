module HexUtilsTest exposing (chunkTests)

import Expect
import HexUtils exposing (chunk)
import Test exposing (Test, describe, test)


chunkThousands : String -> String
chunkThousands =
    chunk 3 "'"


chunkTests : Test
chunkTests =
    describe "Chunk"
        [ test "chunk empty is empty"
            (\_ -> Expect.equal "" (chunkThousands ""))
        , test "chunk short doesn't change"
            (\_ -> Expect.equal "123" (chunkThousands "123"))
        , test "chunk just once"
            (\_ -> Expect.equal "1'234" (chunkThousands "1234"))
        , test "chunk just before twice"
            (\_ -> Expect.equal "123'456" (chunkThousands "123456"))
        , test "chunk twice"
            (\_ -> Expect.equal "1'234'567" (chunkThousands "1234567"))
        ]
