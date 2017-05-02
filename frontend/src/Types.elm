module Types exposing (..)
import Time exposing (Time)

type alias Taco =
    { currentTime : Time
    , userInfo : UserInformation
    }
type alias Skole =
    { id : String
    , navn : String
    , kode : String
    }
type alias Fag =
    { id : String
    , navn : String
    }
type alias Trinn =
    { id : String
    , navn : String
    }
type alias Utdanningsprogram =
    { id : String
    , overordnetUtdanningsprogramId : String
    , navn : String
    }
type alias AppMetadata =
    { skoler : List Skole
    , fagListe : List Fag
    , trinnListe : List Trinn
    , aktivitetstyper : List AktivitetsType
    , utdanningsprogrammer : List Utdanningsprogram
    }
type alias AktivitetsType =
    { id : String
    , navn : String
    }


type Route
    = RouteAnsattPortal
    | RouteLederForesporsel
    | RouteTilgangsadministrasjon
    | RouteTelefonskjema
    | RouteAktivitetsListe
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
