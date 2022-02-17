module Main exposing (main)

import Browser
import Html exposing (Html)


type alias Model =
    { title : String
    , toasts : List String
    }


type Msg
    = Noop


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = \model -> { title = model.title, body = view model }
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( { title = "Playground"
      , toasts = []
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )


view : Model -> List (Html Msg)
view _ =
    [ Html.text "hello, world" ]
