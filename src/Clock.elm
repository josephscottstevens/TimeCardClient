module Clock exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (attribute)
import Svg exposing (circle, g, line, svg)
import Svg.Attributes exposing (viewBox, width, x1, x2, y1, y2)
import Time


view : Time.Zone -> Time.Posix -> Html msg
view zone time =
    let
        hour =
            toFloat (Time.toHour zone time)

        minute =
            toFloat (Time.toMinute zone time)

        second =
            toFloat (Time.toSecond zone time)
    in
    div [ attribute "style" "background: #dedede;" ]
        [ svg
            [ attribute "style" "fill: white; stroke: black; stroke-width: 1; stroke-linecap: round;"
            , width "400px"
            , viewBox "0 0 40 40"
            ]
            [ circle
                [ attribute "cx" "20", attribute "cy" "20", attribute "r" "19" ]
                []
            , g
                [ attribute "style" "transform: translate(20px, 20px); stroke-width: 0.2;" ]
                [ clockTickMark 30
                , clockTickMark 60
                , clockTickMark 90
                , clockTickMark 120
                , clockTickMark 150
                , clockTickMark 180
                , clockTickMark 210
                , clockTickMark 240
                , clockTickMark 270
                , clockTickMark 300
                , clockTickMark 330
                , clockTickMark 360
                ]
            , viewHand Hour 6 60 (hour / 12)
            , minuteHand
            , secondHand
            , circle
                [ attribute "cx" "20"
                , attribute "cy" "20"
                , attribute "r" "0.7"
                , attribute "style" "stroke: #d00505; stroke-width: 0.2;"
                ]
                []
            ]
        ]


type Hand
    = Hour
    | Minute
    | Second


formatHand : Hand -> String
formatHand hand =
    case hand of
        Hour ->
            "stroke-width: 1;"

        Minute ->
            "stroke-width: 0.6;"

        Second ->
            "stroke-width: 0.3; stroke: #d00505;"


viewHand : Hand -> Int -> Float -> Float -> Html msg
viewHand hand width length turns =
    let
        t =
            2 * pi * (turns - 0.25)

        x =
            200 + length * cos t

        y =
            200 + length * sin t

        handStyle =
            formatHand hand
    in
    line
        [ attribute "style" "transform: translate(20px, 20px) rotate(0deg); stroke-width: 1;"
        , x1 "0"
        , x2 "9"
        , y1 "0"
        , y2 "0"
        ]
        []


minuteHand : Html msg
minuteHand =
    line
        [ attribute "style" "transform: translate(20px, 20px) rotate(0deg); stroke-width: 0.6;"
        , x1 "0"
        , x2 "13"
        , y1 "0"
        , y2 "0"
        ]
        []


secondHand : Html msg
secondHand =
    line
        [ attribute "style" "transform: translate(20px, 20px) rotate(0deg); stroke-width: 0.3; stroke: #d00505;"
        , x1 "0"
        , x2 "16"
        , y1 "0"
        , y2 "0"
        ]
        []


clockTickMark : Int -> Html msg
clockTickMark angle =
    let
        strokeWidth =
            if modBy 90 angle == 0 then
                "stroke-width: 0.5;"

            else
                ""
    in
    line
        [ attribute "style" ("transform: rotate(" ++ String.fromInt angle ++ "deg); " ++ strokeWidth)
        , x1 "15"
        , x2 "16"
        , y1 "0"
        , y2 "0"
        ]
        []
