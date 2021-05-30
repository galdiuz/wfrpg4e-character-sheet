module GenerateProgram exposing (program)

import Css.Base_Source
import Css.Dark_Source
import Posix.IO as IO exposing (IO)
import Posix.IO.File as File
import Posix.IO.Process as IO
import Webbhuset.Css as Css
import Webbhuset.Css.Module as Module


allFiles : List ( String, List Css.Declaration )
allFiles =
    [ ( "src/Css/Base.elm", Css.Base_Source.declarations )
    , ( "src/Css/Dark.elm", Css.Dark_Source.declarations )
    ]


program : IO.PosixProgram
program =
    IO.program generateElmCode


generateElmCode : IO.Process -> IO ()
generateElmCode process =
    let
        isOptimize =
            List.member "--optimize" process.argv

        isDebug =
            List.member "--debug" process.argv
    in
    allFiles
        |> List.indexedMap
            (\idx ( targetName, decl ) ->
                let
                    _ =
                        Debug.log "Generating" targetName

                    generated =
                        generate isOptimize isDebug targetName idx decl
                in
                File.writeContentsTo targetName generated.elmModule
            )
        |> IO.combine
        |> IO.map (\_ -> ())


generate : Bool -> Bool -> String -> Int -> List Css.Declaration -> { styleSheet : String, elmModule : String }
generate isOptimize isDebug targetFilename idx decl =
    Module.generate
        { moduleName = toModuleName targetFilename
        , useShortName = isOptimize
        , classPrefix = ""
        -- , classPrefix =
        --     if isDebug then
        --         String.replace "." "_" (toModuleName targetFilename) ++ "--"

        --     else
        --         String.fromChar (Char.fromCode (0x61 + idx)) ++ "-"
        }
        decl


toModuleName : String -> String
toModuleName filename =
    filename
        |> String.replace ".elm" ""
        |> String.split "/"
        |> List.filter
            (\str ->
                String.uncons str
                    |> Maybe.map (Tuple.first >> Char.isUpper)
                    |> Maybe.withDefault False
            )
        |> String.join "."
