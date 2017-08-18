module Main exposing (..)

import Modal
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program String Model Msg
main =
    programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { errorDialogIsOpen : Bool
    , infoDialogIsOpen : Bool
    , mainMenuIsOpen : Bool
    , message : Maybe String
    }


type Msg
    = OpenMainMenu
    | OpenError
    | OpenInfo
    | ShowMessage String
    | CloseAll


{-| Base configuration for (extremely ugly) error messages.
It tweaks the basic `moda` CSS module by adding a red background.
In the real world you would probably want to create a different module.
-}
errorDialogCfg : Modal.Config Msg
errorDialogCfg =
    Modal.maintainableCssConfig "modal" Modal.Top CloseAll


{-| Configuration for the menu. Here I chose to create a completely different module, just because I could.
-}
menuCfg : Modal.Config Msg
menuCfg =
    Modal.maintainableCssConfig "mainMenu" Modal.Left CloseAll


{-| Same as `errorDialogCfg`, but for information messages.
It tweaks the `modal` CSS module even further by simulating a dialog that isn't attached to the top.
In this case, it makes even more sense to create a different CSS module so that we don´t have
to tweak CSS translations!
-}
msgCfg : Modal.Config Msg
msgCfg =
    Modal.maintainableCssConfig "modal" Modal.Bottom CloseAll


reset : Model
reset =
    { errorDialogIsOpen = False
    , infoDialogIsOpen = False
    , mainMenuIsOpen = False
    , message = Nothing
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( reset
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenMainMenu ->
            ( { model | mainMenuIsOpen = True }, Cmd.none )

        OpenError ->
            ( { model | errorDialogIsOpen = True }, Cmd.none )

        OpenInfo ->
            ( { model | infoDialogIsOpen = True }, Cmd.none )

        ShowMessage text ->
            ( { reset | message = Just text }, Cmd.none )

        CloseAll ->
            init ""


view : Model -> Html Msg
view model =
    div []
        [ -- error dialog
          button [ onClick OpenError, class "button button--error" ] [ text "Error" ]
        , Modal.view errorDialogCfg
            model.errorDialogIsOpen
            [ class "modal--error" ]
            [ h1 [] [ text "Ooooops" ]
            , p [] [ text "Something went terribly wrong!" ]
            ]
          -- info dialog
        , button [ onClick OpenInfo, class "button button--info" ] [ text "Info" ]
        , Modal.view errorDialogCfg
            model.infoDialogIsOpen
            [ class "modal--info" ]
            [ h1 [] [ text "Hey" ]
            , p [] [ text "> Been trying to meet you!" ]
            , p [] [ text "> Sorry... Not a Pixies fan." ]
            ]
          -- the main menu
        , button [ onClick OpenMainMenu ] [ text "Menu" ]
        , Modal.view menuCfg model.mainMenuIsOpen [] [ viewMenu ]
          -- show a message, in case we have one
          -- if it´s a Nothing, show nothing
        , Modal.maybeView msgCfg model.message [] viewMessage
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewMenu : Html Msg
viewMenu =
    ul []
        [ li [ class "mainMenu-item", onClick (ShowMessage "No home for you") ] [ text "Home" ]
        , li [ class "mainMenu-item", onClick (ShowMessage "Best use Google!") ] [ text "Search" ]
        , li [ class "mainMenu-item", onClick (ShowMessage "Consider it done") ] [ text "Add" ]
        , li [ class "mainMenu-item mainMenu-item--exit", onClick (ShowMessage "Quitter!") ] [ text "I quit!" ]
        ]


viewMessage : String -> List (Html Msg)
viewMessage msg =
    [ section [ class "message" ] [ text msg ] ]
