module FormComponents exposing (..)

import Material.Textfield
import Material.Button
import Material.Grid
import Material.Toggles
import Material.Options exposing (Style, css, cs)
import Material.Grid exposing (..)
import Material.Typography as Typo
import Html exposing (..)
import Types exposing (..)
import Material.Elevation as Elevation
import Material.Slider as Slider
import JsonUtil exposing (..)


view : TextFieldSettings -> Mdl -> Html Types.Msg
view settings material =
    div []
        [ Material.Textfield.render Mdl
            [ 0 ]
            material
            [ css "margin" "0 24px"
            , Material.Textfield.label settings.label
            , Material.Textfield.floatingLabel
            , Material.Textfield.value settings.text
            ]
        ]


table : List (Html m) -> Material.Grid.Cell m
table contents =
    Material.Grid.cell
        []
        [ Material.Options.div
            [ css "display" "inline-flex"
            , css "flex-direction" "column"
            , css "width" "auto"
            , Elevation.e16
            ]
            contents
        ]


optionsForm : World -> Html Types.Msg
optionsForm model =
    div []
        [ -- Material.Grid.grid
          --     []
          --     [ cell [ size All 8, size Tablet 4 ] [ saveButton model ]
          --     , cell [ size All 8, size Tablet 4 ] [ loadButton model ]
          --     ]
        -- , Material.Grid.grid
        --     []
        --     [ cell 50 [ size All 8, size Tablet 4 ] [ playerOneName model ]
        --     ]
        -- , Material.Grid.grid
        --     []
        --     [ cell 50 [ size All 8, size Tablet 4 ] [ playerTwoName model ]
        --     ]
        Material.Grid.grid
            []
            [ cell 50 [ size All 8, size Tablet 4 ] [ gravitySwitch model ]
            ]
        , Material.Grid.grid
            []
            [ cell 50 [ size All 8, size Tablet 4 ] [ gravityStrength model ]
            ]
        , Material.Grid.grid
            []
            [ cell 50 [ size All 8, size Tablet 4 ] [ pauseButton model ]
            ]
        -- , Material.Grid.grid
        --     []
        --     [ cell 50 [ size All 8, size Tablet 4 ] [ testDisplay model ]
        --     ]
        ]


playerOneName : World -> Html Types.Msg
playerOneName model =
    Material.Textfield.render Mdl
        [ 0 ]
        model.mdl
        [ Material.Textfield.label "Player One Name"
        , Material.Textfield.floatingLabel
        , Material.Textfield.text'
        , Material.Textfield.onInput PlayerOneName
        , Material.Textfield.value (playerName Left model.players)
        ]


playerTwoName : World -> Html Types.Msg
playerTwoName model =
    Material.Textfield.render Mdl
        [ 0 ]
        model.mdl
        [ Material.Textfield.label "Player Two Name"
        , Material.Textfield.floatingLabel
        , Material.Textfield.text'
        , Material.Textfield.onInput PlayerTwoName
        , Material.Textfield.value (playerName Right model.players)
        ]


pauseButton : World -> Html Types.Msg
pauseButton model =
    Material.Button.render Mdl
        [ 0 ]
        model.mdl
        [ css "margin" "0px 0px"
        , css "float" "left"
        , Material.Button.raised
        , Material.Button.ripple
        , Material.Button.colored
        , Material.Button.onClick TogglePause
        ]
        [ Html.text (pauseButtonText model) ]


pauseButtonText : World -> String
pauseButtonText model =
    case model.state of
        Win ->
            "Continue"

        Pause ->
            "Continue"

        Play ->
            "Pause"


gravitySwitch : World -> Html Types.Msg
gravitySwitch model =
    Material.Toggles.switch Mdl
        [ 0 ]
        model.mdl
        [ Material.Toggles.onClick (FlipGravity True)
        , Material.Toggles.ripple
        , Material.Toggles.value (model.physicsSettings.gravityAttractionType == Attract)
        ]
        [ text
            (if (model.physicsSettings.gravityAttractionType == Attract) then
                "Attracting"
             else
                "Repelling"
            )
        ]


style : Int -> List (Style a)
style h =
    [ css "text-sizing" "border-box"
    , css "height" (toString h ++ "px")
    , css "padding-left" "0px"
    , css "padding-top" "0px"
    ]


gravityStrength : World -> Html Types.Msg
gravityStrength model =
    Slider.view
        [ Slider.onChange (Types.Slider 1)
        , Slider.value (model.physicsSettings.gravitationalConstant)
        , Slider.max model.physicsSettings.maxGravitationalConstant
        , Slider.min model.physicsSettings.minGravitationalConstant
        , Slider.step 1
        ]


testDisplay : World -> Html a
testDisplay model =
    Material.Options.styled p
        [ Typo.body2 ]
        [ text (JsonUtil.worldEncoder model |> toString) ]



--Copied from View, refactor


cell : Int -> List (Style a) -> List (Html a) -> Material.Grid.Cell a
cell height styling =
    Material.Grid.cell <| List.concat [ style height, styling ]



-- Helpers


playerName : Side -> List (Player) -> String
playerName side players =
    let
        player =
            findPlayer side players
    in
        case player of
            Nothing ->
                ""

            Just p ->
                p.name


findPlayer : Side -> List (Player) -> Maybe Player
findPlayer side players =
    List.head (List.filter (\e -> e.side == side) players)
