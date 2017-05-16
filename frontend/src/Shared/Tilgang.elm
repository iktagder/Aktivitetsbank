module Shared.Tilgang exposing (..)

import Types exposing (..)
import Html exposing (Html, text, div, span, p, a)


visVedKanRedigere : Taco -> (Taco -> Html msg) -> Html msg
visVedKanRedigere taco visInnhold =
    if kanRedigere taco then
        visInnhold taco
    else
        text ""


kanRedigere : Taco -> Bool
kanRedigere taco =
    if taco.userInfo.rolle == "Rediger" then
        True
    else
        False
