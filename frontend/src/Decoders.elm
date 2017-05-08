module Decoders exposing (..)
import Types exposing (..)
import Json.Decode as Json exposing (field)
import Json.Encode
import Json.Decode.Pipeline

decodeUserInformation : Json.Decoder UserInformation
decodeUserInformation =
    Json.map3 UserInformation
        (field "navn" Json.string)
        (field "brukernavn" Json.string)
        (field "rolle" Json.string)



decodeSearchAnsattList : Json.Decoder (List AnsattSearchItem)
decodeSearchAnsattList =
    Json.list decodeAnsattSearchItem

decodeAnsattSearchItem : Json.Decoder AnsattSearchItem
decodeAnsattSearchItem =
    Json.map4 AnsattSearchItem
        (field "id" Json.string)
        (field "firstName" Json.string)
        (field "lastName" Json.string)
        -- (field "agressoResourceId" Json.string)
        ((Json.maybe (field "agressoResourceId" Json.string)) |> Json.andThen decodeMaybeString)


decodeAnsattItem : Json.Decoder AnsattItem
decodeAnsattItem =
    Json.map5 AnsattItem
        -- (field "id" Json.string)
        (field "firstName" Json.string)
        (field "lastName" Json.string)
        ((Json.maybe (field "phoneNumber" Json.string)) |> Json.andThen decodeMaybeString)
        ((Json.maybe (field "tittel" Json.string)) |> Json.andThen decodeMaybeString)
        (field "agressoResourceId" Json.string)

decodeMaybeString : Maybe String -> Json.Decoder (Maybe String)
decodeMaybeString maybeString =
    Json.succeed (Maybe.withDefault Nothing (Just maybeString))



encodeChangePhoneNumber : AnsattItem -> Json.Encode.Value
encodeChangePhoneNumber model =
    let
        encodings =
            [ ( "id", Json.Encode.string model.agressoResourceId )
            , ( "phoneNumber", Json.Encode.string <| Maybe.withDefault "11223344" model.phoneNumber )
            ]
    in
        encodings
            |> Json.Encode.object

decodeUtdanningsprogram : Json.Decoder Utdanningsprogram
decodeUtdanningsprogram =
    Json.Decode.Pipeline.decode Utdanningsprogram
        |> Json.Decode.Pipeline.required "id" (Json.string)
        |> Json.Decode.Pipeline.optional "overordnetUtdanningsprogramId" (Json.string) "topp"
        |> Json.Decode.Pipeline.required "navn" (Json.string)


decodeTrinn : Json.Decoder Trinn
decodeTrinn =
    Json.Decode.Pipeline.decode Trinn
        |> Json.Decode.Pipeline.required "id" (Json.string)
        |> Json.Decode.Pipeline.required "navn" (Json.string)


decodeAktivitetsType : Json.Decoder AktivitetsType
decodeAktivitetsType =
    Json.Decode.Pipeline.decode AktivitetsType
        |> Json.Decode.Pipeline.required "id" (Json.string)
        |> Json.Decode.Pipeline.required "navn" (Json.string)


decodeFag : Json.Decoder Fag
decodeFag =
    Json.Decode.Pipeline.decode Fag
        |> Json.Decode.Pipeline.required "id" (Json.string)
        |> Json.Decode.Pipeline.required "navn" (Json.string)

decodeSkole : Json.Decoder Skole
decodeSkole =
    Json.Decode.Pipeline.decode Skole
        |> Json.Decode.Pipeline.required "id" (Json.string)
        |> Json.Decode.Pipeline.required "navn" (Json.string)
        |> Json.Decode.Pipeline.required "kode" (Json.string)

--
decodeAppMetadata : Json.Decoder AppMetadata
decodeAppMetadata =
    Json.Decode.Pipeline.decode AppMetadata
        |> Json.Decode.Pipeline.required "skoler" (Json.list decodeSkole)
        |> Json.Decode.Pipeline.required "fagListe" (Json.list decodeFag)
        |> Json.Decode.Pipeline.required "trinnListe" (Json.list decodeTrinn)
        |> Json.Decode.Pipeline.required "aktivitetstyper" (Json.list decodeAktivitetsType)
        |> Json.Decode.Pipeline.required "utdanningsprogrammer" (Json.list decodeUtdanningsprogram)

decodeAktivitet : Json.Decoder Aktivitet
decodeAktivitet =
    Json.Decode.Pipeline.decode Aktivitet
        |> Json.Decode.Pipeline.required "id" (Json.string)
        |> Json.Decode.Pipeline.required "navn" (Json.string)
        |> Json.Decode.Pipeline.required "beskrivelse" (Json.string)
        |> Json.Decode.Pipeline.required "omfangTimer" (Json.int)
        |> Json.Decode.Pipeline.required "skoleId" (Json.string)
        |> Json.Decode.Pipeline.required "skoleNavn" (Json.string)
        |> Json.Decode.Pipeline.custom ((decodeAktivitetSkole) |> Json.andThen decodeMaybeAktivitetSkole)
        |> Json.Decode.Pipeline.required "aktivitetstypeId" (Json.string)
        |> Json.Decode.Pipeline.required "aktivitetstypeNavn" (Json.string)
        |> Json.Decode.Pipeline.custom ((decodeAktivitetAktivitetsType) |> Json.andThen decodeMaybeAktivitetAktivitetsType)

decodeAktivitetSkole : Json.Decoder Skole
decodeAktivitetSkole =
    Json.map3 Skole
        (field "skoleId" Json.string)
        (field "skoleNavn" Json.string)
        (Json.succeed "")

decodeMaybeAktivitetSkole : Skole -> Json.Decoder (Maybe Skole)
decodeMaybeAktivitetSkole skole =
    let
        maybeSkole = Just skole
    in
        Json.succeed maybeSkole

decodeAktivitetAktivitetsType : Json.Decoder AktivitetsType
decodeAktivitetAktivitetsType =
    Json.map2 AktivitetsType
        (field "aktivitetstypeId" Json.string)
        (field "aktivitetstypeNavn" Json.string)

decodeMaybeAktivitetAktivitetsType : AktivitetsType -> Json.Decoder (Maybe AktivitetsType)
decodeMaybeAktivitetAktivitetsType aktivitetstype =
    let
        maybe = Just aktivitetstype
    in
        Json.succeed maybe

encodeOpprettNyAktivitet : Aktivitet -> Json.Encode.Value
encodeOpprettNyAktivitet model =
    let
        encodings =
            [ ( "navn", Json.Encode.string model.navn )
            , ( "beskrivelse", Json.Encode.string model.beskrivelse )
            , ( "omfangTimer", Json.Encode.int model.omfangTimer )
            , ( "skoleId", Json.Encode.string model.skoleId )
            , ( "aktivitetsTypeId", Json.Encode.string model.aktivitetsTypeId )
            ]
    in
        encodings
            |> Json.Encode.object

encodeOpprettNyDeltaker : String -> Deltaker -> Json.Encode.Value
encodeOpprettNyDeltaker aktivitetId model =
    let
        encodings =
            [ ( "aktivitetId", Json.Encode.string aktivitetId )
            , ( "kompetansemaal", Json.Encode.string model.kompetansemaal )
            , ( "timer", Json.Encode.int model.timer )
            , ( "utdanningsprogramId", Json.Encode.string model.utdanningsprogramId )
            , ( "trinnId", Json.Encode.string model.trinnId )
            , ( "fagId", Json.Encode.string model.fagId )
            ]
    in
        encodings
            |> Json.Encode.object

decodeAktivitetListe : Json.Decoder (List Aktivitet)
decodeAktivitetListe =
    Json.list decodeAktivitet

decodeNyAktivitet : Json.Decoder NyAktivitet
decodeNyAktivitet =
    Json.Decode.Pipeline.decode NyAktivitet
        |> Json.Decode.Pipeline.required "id" (Json.string)

decodeNyDeltaker : Json.Decoder NyDeltaker
decodeNyDeltaker =
    Json.Decode.Pipeline.decode NyDeltaker
        |> Json.Decode.Pipeline.required "id" (Json.string)

decodeDeltaker : Json.Decoder Deltaker
decodeDeltaker =
    Json.Decode.Pipeline.decode Deltaker
        |> Json.Decode.Pipeline.required "id" (Json.string)
        |> Json.Decode.Pipeline.required "aktivitetId" (Json.string)
        |> Json.Decode.Pipeline.required "aktivitetNavn" (Json.string)
        |> Json.Decode.Pipeline.required "utdanningsprogramId" (Json.string)
        |> Json.Decode.Pipeline.required "utdanningsprogramNavn" (Json.string)
        |> Json.Decode.Pipeline.required "trinnId" (Json.string)
        |> Json.Decode.Pipeline.required "trinnNavn" (Json.string)
        |> Json.Decode.Pipeline.required "fagId" (Json.string)
        |> Json.Decode.Pipeline.required "fagNavn" (Json.string)
        |> Json.Decode.Pipeline.required "timer" (Json.int)
        |> Json.Decode.Pipeline.required "kompetansemaal" (Json.string)

decodeDeltakerListe : Json.Decoder (List Deltaker)
decodeDeltakerListe =
    Json.list decodeDeltaker