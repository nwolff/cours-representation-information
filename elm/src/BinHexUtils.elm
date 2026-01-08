module BinHexUtils exposing (bin, binRel, chunk, hex, hexRel, parseBinaryString, parseDecimalString, parseHexString)

import Binary
import Hex


prettyPrint : Binary.Bits -> String
prettyPrint b =
    b |> Binary.toIntegers |> List.map String.fromInt |> String.concat |> chunk 4 "'"


{-| Builds a binary representation of n
-}
bin : Int -> String
bin n =
    Binary.fromDecimal n |> prettyPrint


{-| Builds a binary representation of n
The numBits is used when n is negative to build a two's complement representation,
if n is positive then 0's are added to the left of the number to make sure it is numBits

    >>> binRel 8 10
    "0000'1010"
    >>> binRel 8 255
    "1111'1111"
    >>> binRel 8 -9
    "1111'0111"
    >>> binRel 16 -9
    "1111'1111'1111'0111"

-}
binRelBits : Int -> Int -> Binary.Bits
binRelBits numBits n =
    if n >= 0 then
        Binary.fromDecimal n |> Binary.ensureSize numBits

    else
        n
            |> abs
            |> (\x -> x - 1)
            |> Binary.fromDecimal
            |> Binary.ensureSize numBits
            |> Binary.not


binRel : Int -> Int -> String
binRel numBits n =
    binRelBits numBits n |> prettyPrint


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
            String.toList normalized |> List.map charToInt
    in
    if List.isEmpty listOfInts || List.member -1 listOfInts then
        Nothing

    else
        Binary.fromIntegers listOfInts |> Binary.toDecimal |> Just


hex : Int -> String
hex n =
    n |> Binary.fromDecimal |> Binary.toHex


{-| Builds a binary representation of n
The numBits is used when n is negative to build a two's complement representation,
if n is positive then numBits is ignored

    >>> hexRel 8 10
    "0A"
    >>> hexRel 8 127
    "7F"
    >>> hexRel 8 -128
    "80"
    >>> hexRel 8 -1
    "FF"
    >>> hexRel 8 -9
    "F7"
    >>> hexRel 16 -9
    "FFF7"

-}
hexRel : Int -> Int -> String
hexRel numBits n =
    binRelBits numBits n |> Binary.toHex


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
