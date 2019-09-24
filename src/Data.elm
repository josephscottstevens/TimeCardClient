module Data exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode


type alias JobRole =
    { name : String
    , doesCashOut : Bool
    }


decodeJobRole : Decode.Decoder JobRole
decodeJobRole =
    Decode.map2 JobRole
        (Decode.field "name" Decode.string)
        (Decode.field "doesCashOut" Decode.bool)


type alias Employee =
    { firstName : String
    , lastName : String
    , middleName : String
    , pin : Int
    , jobRoles : List String
    }


getEmployeeJobRoles : Employee -> List JobRole -> List JobRole
getEmployeeJobRoles employee jobRoles =
    List.filter (\jobRole -> List.any (\t -> jobRole.name == t) employee.jobRoles) jobRoles


decodeEmployee : Decode.Decoder Employee
decodeEmployee =
    Decode.map5 Employee
        (Decode.field "firstname" Decode.string)
        (Decode.field "lastname" Decode.string)
        (Decode.field "middlename" Decode.string)
        (Decode.field "pin" Decode.int)
        (Decode.field "jobroles" (Decode.list Decode.string))


type alias TimeEntry =
    { pin : String
    , clockedInAt : Int
    , clockedOutAt : Maybe Int
    }



-- getJobRoles : String -> List JobRole
-- getJobRoles pin =
--     all
--         |> List.filter (\t -> t.pin == pin)
--         |> List.head
--         |> Maybe.map .jobRoles
--         |> Maybe.withDefault []
