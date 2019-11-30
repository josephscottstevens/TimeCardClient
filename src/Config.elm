module Config exposing (errorConstant_InvalidPin, errorToString)

import Http exposing (Error(..))


errorConstant_InvalidPin : String
errorConstant_InvalidPin =
    "no user associated with pin, please again, or contact your manager if you don't have a pin set up"


errorToString : Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Error, invalid url: " ++ url

        Timeout ->
            "Error, trouble connecting to the internet"

        NetworkError ->
            "An unknown network error has occured, please try again later"

        BadStatus statusInt ->
            "Error, bad status of: " ++ String.fromInt statusInt

        BadBody body ->
            "Error, bad body of: " ++ body
