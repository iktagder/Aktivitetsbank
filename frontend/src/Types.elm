module Types exposing (..)
import Time exposing (Time)

type alias Taco =
    { currentTime : Time
    , userInfo : UserInformation
    }


type Route
    = RouteAnsattPortal
    | RouteLederForesporsel
    | RouteTilgangsadministrasjon
    | RouteTelefonskjema
    | NotFoundRoute

type TacoUpdate
    = NoUpdate
    | UpdateTime Time
    | UpdateUserInfo UserInformation

type SharedMsg
    = CreateSnackbarToast String
    | NoSharedMsg

type alias UserInformation =
    { navn : String
    , brukerNavn : String
    , rolle : String
    }

type alias AnsattSearchItem =
  { ansattId : String
  , fornavn : String
  , etternavn : String
  , agressoResourceId : Maybe String
}


type alias AnsattItem =
  { --ansattId : String
    fornavn : String
  , etternavn : String
  , phoneNumber : Maybe String
  , tittel : Maybe String
  , agressoResourceId : String
}
