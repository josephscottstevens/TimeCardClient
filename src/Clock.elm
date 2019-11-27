module Clock exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Svg exposing (g, line, svg)
import Svg.Attributes exposing (viewBox)

view =
    div [ attribute "style" "background: #dedede;" ]
        [ svg
            [ attribute "style" "width: 400px; fill: white; stroke: black; stroke-width: 1; stroke-linecap: round;"
            , viewBox "0 0 40 40"
            ]
            [ node "circle"
                [ attribute "cx" "20", attribute "cy" "20", attribute "r" "19" ]
                []
            , node "g"
                [ attribute "style" "transform: translate(20px, 20px); stroke-width: 0.2;" ]
                [ line [ attribute "style" "transform: rotate(30deg);", attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "style" "transform: rotate(60deg);", attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "style" "transform: rotate(90deg); stroke-width: 0.5;", attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "style" "transform: rotate(120deg);", attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "style" "transform: rotate(150deg);", attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "style" "transform: rotate(180deg); stroke-width: 0.5;", attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                , line [ attribute "x1" "15", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                    []
                ]
            , line [ class "hour", attribute "style" "transform: translate(20px, 20px) rotate(0deg); stroke-width: 1;", attribute "x1" "0", attribute "x2" "9", attribute "y1" "0", attribute "y2" "0" ]
                []
            , line [ class "minute", attribute "style" "transform: translate(20px, 20px) rotate(0deg); stroke-width: 0.6;", attribute "x1" "0", attribute "x2" "13", attribute "y1" "0", attribute "y2" "0" ]
                []
            , line [ class "seconds", attribute "style" "transform: translate(20px, 20px) rotate(0deg); stroke-width: 0.3;             stroke: #d00505;", attribute "x1" "0", attribute "x2" "16", attribute "y1" "0", attribute "y2" "0" ]
                []
            , node "circle"
                [ class "pin", attribute "cx" "20", attribute "cy" "20", attribute "r" "0.7", attribute "style" "stroke: #d00505; stroke-width: 0.2;" ]
                []
            ]
        ]
