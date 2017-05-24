module Types exposing (..)

import Time exposing (Time)


type alias Taco =
    { currentTime : Time
    , userInfo : UserInformation
    }


type alias Filter =
    { aktivitetsTypeFilter : List String
    , skoleFilter : List String
    , navnFilter : String
    }


type alias Skole =
    { id : String
    , navn : String
    , kode : String
    }


type alias SkoleAar =
    { id : String
    , navn : String
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
    , skoleAar : List SkoleAar
    }


type alias NyAktivitet =
    { id : String
    }


type alias NyDeltaker =
    { id : String
    }


type alias KopiertAktivitet =
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
    , skoleAarId : String
    , skoleAarNavn : String
    , skoleAar : Maybe SkoleAar
    }


type alias AktivitetEdit =
    { id : Maybe String
    , navn : Maybe String
    , beskrivelse : Maybe String
    , omfangTimer : Maybe Int
    , skole : Maybe Skole
    , aktivitetsType : Maybe AktivitetsType
    , skoleAar : Maybe SkoleAar
    }


type alias AktivitetGyldigNy =
    { navn : String
    , beskrivelse : String
    , omfangTimer : Int
    , skole : Skole
    , aktivitetsType : AktivitetsType
    , skoleAar : SkoleAar
    }


type alias AktivitetGyldigKopier =
    { id : String
    , skoleId : String
    }


type alias AktivitetGyldigEndre =
    { id : String
    , navn : String
    , beskrivelse : String
    , omfangTimer : Int
    , skole : Skole
    , aktivitetsType : AktivitetsType
    , skoleAar : SkoleAar
    }


type alias Deltaker =
    { id : String
    , aktivitetId : String
    , aktivitetNavn : String
    , utdanningsprogramId : String
    , utdanningsprogramNavn : String
    , utdanningsprogram : Maybe Utdanningsprogram
    , trinnId : String
    , trinnNavn : String
    , trinn : Maybe Trinn
    , fagId : String
    , fagNavn : String
    , fag : Maybe Fag
    , timer : Int
    , kompetansemaal : String
    }


type alias DeltakerEdit =
    { id : Maybe String
    , aktivitetId : Maybe String
    , utdanningsprogram : Maybe Utdanningsprogram
    , trinn : Maybe Trinn
    , fag : Maybe Fag
    , timer : Maybe Int
    , kompetansemaal : Maybe String
    }


type alias DeltakerGyldigNy =
    { aktivitetId : String
    , utdanningsprogram : Utdanningsprogram
    , trinn : Trinn
    , timer : Int
    , fag : Fag
    , kompetansemaal : String
    }


type alias DeltakerGyldigEndre =
    { id : String
    , aktivitetId : String
    , utdanningsprogram : Utdanningsprogram
    , trinn : Trinn
    , timer : Int
    , fag : Fag
    , kompetansemaal : String
    }


type Route
    = RouteAktivitetsListe
    | RouteAktivitetsDetalj String
    | RouteAktivitetEndre String
    | RouteAktivitetOpprett
    | RouteDeltakerOpprett String
    | RouteDeltakerEndre String String
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
    | NavigerTilAktivitetEndre String
    | NavigerTilDeltakerOpprett String
    | NavigerTilDeltakerEndre String String
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
