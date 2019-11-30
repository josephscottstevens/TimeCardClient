module Clock exposing (view)

import Html exposing (Html, div)
import Svg exposing (circle, g, line, svg)
import Svg.Attributes exposing (..)
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
    div []
        [ svg
            [ fill "white"
            , stroke "black"
            , strokeWidth "1"
            , strokeLinecap "round"
            , width "400px"
            , viewBox "0 0 400 400"
            ]
            [ circle
                [ cx "200", cy "200", r "190" ]
                []
            , g
                []
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
            , viewHand "black" 10 90 (hour / 12)
            , viewHand "black" 6 130 (minute / 60)
            , viewHand "#d00505" 3 160 (second / 60)
            , circle
                [ cx "200"
                , cy "200"
                , r "7"
                , strokeWidth "2"
                , stroke "#d00505"
                ]
                []
            ]
        ]


viewHand : String -> Int -> Float -> Float -> Html msg
viewHand strokeColor width length turns =
    let
        t =
            2 * pi * (turns - 0.25)

        x =
            200 + length * cos t

        y =
            200 + length * sin t
    in
    line
        [ strokeWidth (String.fromInt width)
        , stroke strokeColor
        , x1 "200"
        , y1 "200"
        , x2 (String.fromFloat x)
        , y2 (String.fromFloat y)
        ]
        []


clockTickMark : Int -> Html msg
clockTickMark angle =
    let
        t =
            2 * pi * ((toFloat angle / 360) - 0.25)
    in
    line
        [ if modBy 90 angle == 0 then
            strokeWidth "5"

          else
            strokeWidth "2"
        , x1 (String.fromFloat (200 + 150 * cos t))
        , y1 (String.fromFloat (200 + 150 * sin t))
        , x2 (String.fromFloat (200 + 160 * cos t))
        , y2 (String.fromFloat (200 + 160 * sin t))
        ]
        []
