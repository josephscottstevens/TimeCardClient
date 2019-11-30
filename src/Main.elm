port module Main exposing (..)

import Browser
import Clock
import Config exposing (errorToString)
import Data exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Task
import Time exposing (Posix)



-- port addTimeEntry : ( String, Int, Maybe Int ) -> Cmd msg
--
--
-- port timeEntriesUpdated : (List ( String, Int, Maybe Int ) -> msg) -> Sub msg


port showDialog : String -> Cmd msg


grey =
    Element.rgb 0.8 0.8 0.8


red =
    Element.rgb 0.8 0 0


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick


init : List ( String, Int, Maybe Int ) -> ( Model, Cmd Msg )
init timeEntries =
    ( { time = Time.millisToPosix 0
      , zone = Time.utc
      , pin = ""
      , jobRole = Nothing
      , cashCollected = ""
      , clockedInPosix = Nothing
      , employee = Nothing
      , timeEntries = []
      , jobRoles = []
      , employees = []
      }
    , Cmd.batch
        [ Http.get
            { url = "http://localhost:3000/employees"
            , expect = Http.expectJson GotEmployees (Decode.list decodeEmployee)
            }
        , Http.get
            { url = "http://localhost:3000/jobroles"
            , expect = Http.expectJson GotJobRoles (Decode.list decodeJobRole)
            }
        , Task.perform AdjustTimeZone Time.here
        , Task.perform Tick Time.now
        ]
    )


type alias Model =
    { time : Posix
    , zone : Time.Zone
    , pin : String
    , jobRole : Maybe JobRole
    , cashCollected : String
    , clockedInPosix : Maybe Posix
    , employee : Maybe Employee
    , timeEntries : List TimeEntry
    , jobRoles : List JobRole
    , employees : List Employee
    }


type Msg
    = Tick Posix
    | AdjustTimeZone Time.Zone
    | UpdatePin String
    | UpdateJobRole JobRole
    | UpdateCashCollected String
    | ClockInClockOut
    | NewTime Posix
    | ClockedIn (Result Http.Error String)
    | GotJobRoles (Result Http.Error (List JobRole))
    | GotEmployees (Result Http.Error (List Employee))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        UpdatePin pin ->
            ( if String.length pin <= 4 then
                { model
                    | pin = pin
                    , employee = List.head (List.filter (\t -> Just t.pin == String.toInt pin) model.employees)
                }

              else
                model
            , Cmd.none
            )

        UpdateJobRole jobRole ->
            ( { model | jobRole = Just jobRole }, Cmd.none )

        UpdateCashCollected cashCollected ->
            ( { model | cashCollected = cashCollected }, Cmd.none )

        ClockInClockOut ->
            ( model
            , Task.perform NewTime Time.now
            )

        NewTime now ->
            let
                posix =
                    case model.clockedInPosix of
                        Just clockedInPosix ->
                            clockedInPosix

                        Nothing ->
                            now
            in
            ( { model | clockedInPosix = Just posix }
            , Cmd.batch
                [ --addTimeEntry ( "test", 0, Nothing )
                  Http.post
                    { url = "http://localhost:3000/clockin"
                    , expect = Http.expectString ClockedIn
                    , body =
                        Http.jsonBody <|
                            Encode.object
                                [ ( "pin", Encode.string model.pin )
                                , ( "clockedInAt", Encode.int (Time.posixToMillis posix) )
                                ]
                    }
                ]
            )

        ClockedIn result ->
            -- Todo: This fails in so many ways, it says stuff before network returns, then shows error. Really fails poorly
            case result of
                Ok _ ->
                    ( { model | pin = "", jobRole = Nothing, cashCollected = "", employee = Nothing }
                    , showDialog "You've Clocked In successfully!"
                    )

                Err err ->
                    ( { model | pin = "", jobRole = Nothing, cashCollected = "", employee = Nothing }
                    , showDialog (errorToString err)
                    )

        GotJobRoles result ->
            case result of
                Ok jobRoles ->
                    ( { model | jobRoles = jobRoles }, Cmd.none )

                Err errorMsg ->
                    ( model, showDialog (errorToString errorMsg) )

        GotEmployees result ->
            case result of
                Ok employees ->
                    ( { model | employees = employees }
                    , Cmd.none
                    )

                Err errorMsg ->
                    ( model, showDialog (errorToString errorMsg) )


view : Model -> Html Msg
view model =
    let
        showSecureSection =
            case model.employee of
                Just _ ->
                    True

                Nothing ->
                    False
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
            , viewCurrentPassword model.pin showSecureSection
            , showIfPin showSecureSection (positionSelect model)
            , Element.html (Clock.view model.zone model.time)
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


viewCurrentPassword pin showSecureSection =
    Input.currentPassword
        [ spacing 12
        , width shrink
        , below
            (el
                [ Font.color red
                , Font.size 14
                , alignRight
                , moveDown 6
                ]
                (text (pinErrorMessage pin showSecureSection))
            )
        ]
        { text = pin
        , placeholder = Nothing
        , onChange = UpdatePin
        , label = Input.labelAbove [ Font.size 14 ] (text "Please enter 4 digit PIN Number")
        , show = False
        }


pinErrorMessage : String -> Bool -> String
pinErrorMessage pin showSecureSection =
    if String.length pin == 4 && not showSecureSection then
        Config.errorConstant_InvalidPin

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
    let
        jobRoles =
            case model.employee of
                Just employee ->
                    getEmployeeJobRoles employee model.jobRoles

                Nothing ->
                    []
    in
    Input.radio
        [ spacing 12
        , Font.size 24
        ]
        { selected = model.jobRole
        , onChange = UpdateJobRole
        , label = Input.labelAbove [ Font.size 14, paddingXY 0 12 ] (text "Please select a position")
        , options = List.map toInputOption jobRoles
        }


cashInput : Model -> Element Msg
cashInput model =
    Input.text
        [ spacing 12
        ]
        { text = model.cashCollected
        , placeholder = Just (Input.placeholder [] (text "Please enter cash collected"))
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


toInputOption : JobRole -> Input.Option JobRole Msg
toInputOption jobRole =
    Input.option jobRole (text jobRole.name)
