module BinHexUtils exposing (bin, chunk, hex, parseBinaryString, parseDecimalString, parseHexString)

import Binary
import Hex


{-| Builds a binary representation of n
The digitCount is used when n is negative to build a two's complement representation,
if n is positive then digitCount is ignored

    >>> bin 8 3
    "11"
    >>> bin 8 255
    "1111'1111"
    >>> bin 8 -9
    "1111'0111"
    >>> bin 16 -9
    "1111'1111'1111'0111"

-}
bin : Int -> Int -> String
bin digitCount n =
    let
        bits : Binary.Bits
        bits =
            if n >= 0 then
                Binary.fromDecimal n

            else
                n
                    |> abs
                    |> (\x -> x - 1)
                    |> Binary.fromDecimal
                    |> Binary.ensureSize digitCount
                    |> Binary.not
    in
    bits |> Binary.toIntegers |> List.map String.fromInt |> String.concat |> chunk 4 "'"


parseBinaryString : String -> Maybe Int
parseBinaryString s =
    let
        normalized : String
        normalized =
            String.replace "'" "" s |> String.replace " " ""

        charToInt : Char -> Int
        charToInt c =
            case c of
                '0' ->
                    0

                '1' ->
                    1

                _ ->
                    -1

        listOfInts : List Int
        listOfInts =
            List.map charToInt (String.toList normalized)
    in
    if List.isEmpty listOfInts || List.member -1 listOfInts then
        Nothing

    else
        Binary.fromIntegers listOfInts |> Binary.toDecimal |> Just


hex : Int -> String
hex n =
    n |> Binary.fromDecimal |> Binary.toHex


parseHexString : String -> Maybe Int
parseHexString s =
    let
        normalized : String
        normalized =
            String.replace " " "" s |> String.toLower
    in
    Result.toMaybe (Hex.fromString normalized)


parseDecimalString : String -> Maybe Int
parseDecimalString s =
    let
        normalized : String
        normalized =
            String.replace "'" "" s |> String.replace " " ""
    in
    String.toInt normalized


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
