port module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Employee exposing (Employee)
import Html exposing (Html)
import JobRole exposing (JobRole)
import Json.Decode as Decode
import Json.Encode as Encode
import Task
import Time exposing (Posix)
import TimeEntry exposing (TimeEntry)


port addTimeEntry : ( String, Int, Maybe Int ) -> Cmd msg


port timeEntriesUpdated : (List ( String, Int, Maybe Int ) -> msg) -> Sub msg


port temporaryClockedInMsg : String -> Cmd msg


white =
    Element.rgb 1 1 1


grey =
    Element.rgb 0.9 0.9 0.9


blue =
    Element.rgb 0 0 0.8


red =
    Element.rgb 0.8 0 0


darkBlue =
    Element.rgb 0 0 0.9


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    timeEntriesUpdated SetTimeEntries


init : List ( String, Int, Maybe Int ) -> ( Model, Cmd Msg )
init timeEntries =
    ( { pin = ""
      , jobRole = Nothing
      , cashCollected = ""
      , clockedInPosix = Nothing
      , employee = Nothing
      , timeEntries = []
      }
    , Cmd.none
    )


type alias Model =
    { pin : String
    , jobRole : Maybe JobRole
    , cashCollected : String
    , clockedInPosix : Maybe Posix
    , employee : Maybe Employee
    , timeEntries : List TimeEntry
    }


type Msg
    = UpdatePin String
    | UpdateJobRole JobRole
    | UpdateCashCollected String
    | ClockInClockOut
    | NewTime Time.Posix
    | SetTimeEntries (List ( String, Int, Maybe Int ))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePin pin ->
            ( if String.length pin <= 4 then
                { model | pin = pin }

              else
                model
            , Cmd.none
            )

        UpdateJobRole jobRole ->
            ( { model | jobRole = Just jobRole }, Cmd.none )

        UpdateCashCollected cashCollected ->
            ( { model | cashCollected = cashCollected }, Cmd.none )

        ClockInClockOut ->
            ( { model | pin = "", jobRole = Nothing, cashCollected = "" }
            , temporaryClockedInMsg "You've Clocked In successfully!"
              -- , case model.clockedInPosix of
              --     Just _ ->
              --         Task.perform NewTime Time.now
              --     Nothing ->
              --         Cmd.none
            )

        NewTime now ->
            ( { model | clockedInPosix = Just now }, addTimeEntry ( "test", 0, Nothing ) )

        SetTimeEntries timeEntries ->
            ( { model | timeEntries = List.map (\( pin, start, end ) -> TimeEntry pin start end) timeEntries }, Cmd.none )



-- ( case Decode.list (TimeEntry.timeEntryDecoder timeEntryJson) of
--     Ok timeEntries ->
--         { model | timeEntries = timeEntries }
--     Err errorMsg ->
--         Debug.todo errorMsg
-- , Cmd.none
-- )


view : Model -> Html Msg
view model =
    let
        showSecureSection =
            List.length (Employee.getJobRoles model.pin) > 0
    in
    Element.layout
        [ Font.size 20
        ]
    <|
        Element.column
            [ width (px 800)
            , height shrink
            , alignTop
            , centerX
            , spacing 36
            , paddingEach { top = 100, bottom = 10, left = 10, right = 10 }
            ]
            [ el
                [ Region.heading 1
                , alignLeft
                , Font.size 36
                ]
                (text "Time Card Entry")
            , Input.currentPassword
                [ spacing 12
                , width shrink
                , below
                    (el
                        [ Font.color red
                        , Font.size 14
                        , alignRight
                        , moveDown 6
                        ]
                        (text (pinErrorMessage model.pin))
                    )
                ]
                { text = model.pin
                , placeholder = Nothing
                , onChange = UpdatePin
                , label = Input.labelAbove [ Font.size 14 ] (text "Please enter 4 digit PIN Number")
                , show = False
                }
            , showIfPin showSecureSection (positionSelect model)
            , case model.jobRole of
                Just jobRole ->
                    if jobRole.doesCashOut then
                        showIfPin showSecureSection (cashInput model)

                    else
                        el [ paddingXY 0 12, height (px 72) ] (text "")

                Nothing ->
                    el [ paddingXY 0 12, height (px 72) ] (text "")
            , showIfPin showSecureSection (clockInOutButton model)
            ]


pinErrorMessage pin =
    if String.length pin == 4 && List.length (Employee.getJobRoles pin) == 0 then
        "Invalid Pin, please contact your manager"

    else
        ""


showIfPin : Bool -> Element Msg -> Element Msg
showIfPin bool content =
    if bool then
        content

    else
        Element.none


positionSelect : Model -> Element Msg
positionSelect model =
    Input.radio
        [ spacing 12
        , Font.size 24
        ]
        { selected = model.jobRole
        , onChange = UpdateJobRole
        , label = Input.labelAbove [ Font.size 14, paddingXY 0 12 ] (text "Please select a position")
        , options = List.map toInputOption (Employee.getJobRoles model.pin)
        }


cashInput : Model -> Element Msg
cashInput model =
    Input.text
        [ spacing 12
        ]
        { text = model.cashCollected
        , placeholder = Just (Input.placeholder [] (text "Please enter, cash collected"))
        , onChange = UpdateCashCollected
        , label = Input.labelAbove [ Font.size 14 ] (text "Cash Collected")
        }


clockInOutButton : Model -> Element Msg
clockInOutButton model =
    Input.button
        [ paddingXY 32 16
        , Border.rounded 3
        , Border.color grey
        , Border.width 1
        , Border.solid
        , width (px 200)
        ]
        { onPress = Just ClockInClockOut
        , label = Element.text (clockInClockOutText model.clockedInPosix)
        }


clockInClockOutText : Maybe Posix -> String
clockInClockOutText clockedInPosix =
    case clockedInPosix of
        Just _ ->
            "Clock Out"

        Nothing ->
            "Clock In"


toInputOption jobRole =
    Input.option jobRole (text jobRole.description)
