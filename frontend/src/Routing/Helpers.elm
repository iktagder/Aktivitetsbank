module Routing.Helpers exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>))
import Types exposing (..)


reverseRoute : Route -> String
reverseRoute route =
    case route of
        RouteAktivitetsListe ->
            "#/aktiviteter"

        RouteAktivitetOpprett ->
            "#/opprettaktivitet"

        RouteAktivitetsDetalj id ->
            "#/aktiviteter/" ++ id

        RouteAktivitetEndre id ->
            "#/endreaktivitet/" ++ id

        RouteDeltakerOpprett id ->
            "#/opprettdeltaker/" ++ id

        _ ->
            "#/"


routeParser : Url.Parser (Route -> a) a
routeParser =
    Url.oneOf
        [ Url.map RouteAktivitetsListe Url.top
        , Url.map RouteAktivitetsListe (Url.s "aktiviteter")
        , Url.map RouteAktivitetOpprett (Url.s "opprettaktivitet")
        , Url.map RouteAktivitetsDetalj (Url.s "aktiviteter" </> Url.string)
        , Url.map RouteDeltakerOpprett (Url.s "opprettdeltaker" </> Url.string)
        , Url.map RouteAktivitetEndre (Url.s "endreaktivitet" </> Url.string)
        ]


parseLocation : Location -> Route
parseLocation location =
    location
        |> Url.parseHash routeParser
        |> Maybe.withDefault NotFoundRoute
