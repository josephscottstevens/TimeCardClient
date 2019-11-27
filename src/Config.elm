module Config exposing (errorConstant_InvalidPin)

import Http exposing (Error)


errorConstant_InvalidPin : String
errorConstant_InvalidPin =
    "no user associated with pin, please again, or contact your manager if you don't have a pin set up"


errorToString : Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Error, invalid url: " ++ url

        TimeOut ->
            "Error, trouble connecting to the internet"

        NetworkError ->
            "Error, an unknown network error has occured, please try again later"

        BadStatus statusInt ->
            "Error, bad status of: " ++ Int.toString statusInt

        BadBody body ->
            "Error, bad body of: " ++ body
