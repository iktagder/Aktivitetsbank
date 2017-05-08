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

type alias NyAktivitet =
    { id : String
    }
type alias NyDeltaker =
    { id : String
    }

type alias AktivitetsType =
    { id : String
    , navn : String
    }


type alias Aktivitet =
    { id : String
    , navn : String
    , beskrivelse : String
    , omfangTimer : Int
    , skoleId : String
    , skoleNavn : String
    , skole : Maybe Skole
    , aktivitetsTypeId : String
    , aktivitetsTypeNavn : String
    , aktivitetsType : Maybe AktivitetsType
    }

type alias Deltaker =
    { id : String
    , aktivitetId : String
    , aktivitetNavn : String
    , utdanningsprogramId : String
    , utdanningsprogramNavn : String
    , trinnId : String
    , trinnNavn : String
    , fagId : String
    , fagNavn : String
    , timer : Int
    , kompetansemaal : String
    }

type Route
    = RouteAktivitetsListe
    | RouteAktivitetsDetalj String
    | RouteAktivitetOpprett
    | RouteDeltakerOpprett String
    | NotFoundRoute


type TacoUpdate
    = NoUpdate
    | UpdateTime Time
    | UpdateUserInfo UserInformation


type SharedMsg
    = CreateSnackbarToast String
    | NoSharedMsg
    | NavigateToAktivitet String
    | NavigerTilAktivitetOpprett
    | NavigerTilDeltakerOpprett String
    | NavigerTilHjem


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
