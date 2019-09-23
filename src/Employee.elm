module Employee exposing (..)

import JobRole exposing (JobRole)


type alias Employee =
    { firstName : String
    , lastName : String
    , middleName : String
    , pin : String
    , jobRoles : List JobRole
    }


all : List Employee
all =
    [ { firstName = "Gary"
      , lastName = "Truong"
      , middleName = ""
      , pin = "1234"
      , jobRoles = [ JobRole.generalManager, JobRole.lineCook, JobRole.server ]
      }
    , { firstName = "Joseph"
      , lastName = "Stevens"
      , middleName = ""
      , pin = "1739"
      , jobRoles = [ JobRole.cashier ]
      }
    , { firstName = "Everything"
      , lastName = "All the things"
      , middleName = ""
      , pin = "1111"
      , jobRoles = JobRole.all
      }
    ]


getJobRoles : String -> List JobRole
getJobRoles pin =
    all
        |> List.filter (\t -> t.pin == pin)
        |> List.head
        |> Maybe.map .jobRoles
        |> Maybe.withDefault []
