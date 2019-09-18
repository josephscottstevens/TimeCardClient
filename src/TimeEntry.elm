module TimeEntry exposing (TimeEntry)


type alias TimeEntry =
    { pin : String
    , clockedInAt : Int
    , clockedOutAt : Maybe Int
    }
