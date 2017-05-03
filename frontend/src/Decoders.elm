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
        |> Json.Decode.Pipeline.required "aktivitetstypeId" (Json.string)
        |> Json.Decode.Pipeline.required "aktivitetstypeNavn" (Json.string)


decodeAktivitetListe : Json.Decoder (List Aktivitet)
decodeAktivitetListe =
    Json.list decodeAktivitet
