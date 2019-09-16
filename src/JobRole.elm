module JobRole exposing (..)


type alias JobRole =
    { description : String
    , doesCashOut : Bool
    }


generalManager =
    JobRole "General Manager" False


assistantManager =
    JobRole "Assistant Manager" False


lineCook =
    JobRole "Line Cook" False


cashier =
    JobRole "Cashier" True


server =
    JobRole "Server" True


all : List JobRole
all =
    [ generalManager
    , assistantManager
    , lineCook
    , JobRole "Dishwasher" False
    , JobRole "Drive-Thru Operator" False
    , JobRole "Fast Food Cook" False
    , cashier
    , JobRole "Short Order Cook" False
    , JobRole "Barista" False
    , JobRole "Kitchen Manager" False
    , JobRole "Food and Beverage Manager" False
    , server
    , JobRole "Prep Cook" False
    , JobRole "Runner" False
    , JobRole "Busser" True
    , JobRole "Host" False
    , JobRole "Bartender" True
    , JobRole "Executive Chef" False
    , JobRole "Sous Chef" False
    , JobRole "Maître D’" False
    , JobRole "Sommelier" False
    ]
