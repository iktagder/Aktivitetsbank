module Decoders exposing (..)
import Types exposing (..)
import Json.Decode as Json exposing (field)
import Json.Encode

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
