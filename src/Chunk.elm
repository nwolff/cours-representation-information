module Chunk exposing (chunk)

{-| Inserts separator characters into strings.
Useful to format binary numbers into nibbles.
-}


{-| Groups characters into groups of size n from the right and inserts sep

    >>> chunk 4 "'" "1110001"
    "111'0001"

-}
chunk : Int -> String -> String -> String
chunk n sep s =
    let
        chunkHelp todo done =
            if String.length todo <= n then
                todo ++ done

            else
                chunkHelp (String.dropRight n todo) (sep ++ String.right n todo ++ done)
    in
    chunkHelp s ""
