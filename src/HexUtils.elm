module HexUtils exposing (bin, chunk, hex, string)

import Binary exposing (fromDecimal, toHex, toIntegers)


bin : Int -> String
bin n =
    n |> fromDecimal |> toIntegers |> List.map String.fromInt |> String.concat |> chunk 4 "'"


hex : Int -> String
hex n =
    n |> fromDecimal |> toHex


string : Int -> String
string n =
    String.fromInt n


{-| Groups characters into groups of size n from the right and inserts sep

    >>> chunk 4 "'" "1110001"
    "111'0001"

-}
chunk : Int -> String -> String -> String
chunk n sep s =
    let
        chunkHelp : String -> String -> String
        chunkHelp todo done =
            if String.length todo <= n then
                todo ++ done

            else
                chunkHelp (String.dropRight n todo) (sep ++ String.right n todo ++ done)
    in
    chunkHelp s ""
