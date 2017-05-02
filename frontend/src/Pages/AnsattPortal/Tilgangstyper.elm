module Pages.AnsattPortal.Tilgangstyper exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Json.Decode as Json exposing (field)
import RemoteData exposing (WebData, RemoteData(..))
import Dropdown

type TilgangsTyperMsg =
      OnSelect (Maybe TilgangsType)
    | DropdownMsg (Dropdown.Msg TilgangsType)

type alias TilgangsType =
    { id : Int
    , navn : String
    , beskrivelse : String
    }

decodeTilgangsTyperList : Json.Decoder (List TilgangsType)
decodeTilgangsTyperList =
    Json.list decodeTilgangsType

decodeTilgangsType : Json.Decoder TilgangsType
decodeTilgangsType =
    Json.map3 TilgangsType
        (field "id" Json.int)
        (field "navn" Json.string)
        (field "beskrivelse" Json.string)


dropdownConfig : Dropdown.Config TilgangsTyperMsg TilgangsType
dropdownConfig =
    Dropdown.newConfig OnSelect .navn
        |> Dropdown.withItemClass "border-bottom border-silver p1 gray"
        |> Dropdown.withMenuClass "border border-gray"
        |> Dropdown.withMenuStyles [ ( "background", "white" ) ]
        |> Dropdown.withPrompt "Velg tilgangstype"
        |> Dropdown.withPromptClass "silver"
        |> Dropdown.withSelectedClass "bold"
        |> Dropdown.withSelectedStyles [ ( "color", "black" ) ]
        |> Dropdown.withTriggerClass "col-4 border bg-white p1"


viewTilgangsTyper : WebData (List TilgangsType) -> Maybe TilgangsType -> Dropdown.State -> Html TilgangsTyperMsg
viewTilgangsTyper tilgangsTyper selectedTilgangsTypeId dropdownState =
    case tilgangsTyper of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            viewTilangsTyperDropdown selectedTilgangsTypeId data dropdownState


viewTilangsTyperDropdown : Maybe TilgangsType -> List TilgangsType -> Dropdown.State -> Html TilgangsTyperMsg
viewTilangsTyperDropdown selectedTilgangsTypeId model dropdownState =
        span [ ]
            [
              Html.map DropdownMsg (Dropdown.view dropdownConfig dropdownState model selectedTilgangsTypeId)
            ]
