module OrderedDict exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode


type OrderedDict k v =
    OrderedDict (List k) (Dict k v)


empty : OrderedDict k v
empty =
    OrderedDict [] Dict.empty


insert : v -> OrderedDict number v -> OrderedDict number v
insert value (OrderedDict list dict) =
    case List.maximum list of
        Just max ->
            OrderedDict
                (list ++ [ max + 1 ])
                (Dict.insert (max + 1) value dict)

        Nothing ->
            OrderedDict
                (List.singleton 0)
                (Dict.singleton 0 value)


update : comparable -> (v -> v) -> OrderedDict comparable v -> OrderedDict comparable v
update key updateFun (OrderedDict list dict) =
    OrderedDict
        list
        (case Dict.get key dict of
            Just value ->
                Dict.insert key (updateFun value) dict
            Nothing ->
                dict
        )


remove : comparable -> OrderedDict comparable v -> OrderedDict comparable v
remove key (OrderedDict list dict) =
    OrderedDict
        (List.filter ((/=) key) list)
        (Dict.remove key dict)


isEmpty : OrderedDict k v -> Bool
isEmpty (OrderedDict list _) =
    List.isEmpty list


member : comparable -> OrderedDict comparable v -> Bool
member key (OrderedDict _ dict) =
    Dict.member key dict


get : comparable -> OrderedDict comparable v -> Maybe v
get key (OrderedDict _ dict) =
    Dict.get key dict


keys : OrderedDict k v -> List k
keys (OrderedDict list dict) =
    list


values : OrderedDict comparable v -> List v
values (OrderedDict list dict) =
    List.filterMap
        (\key ->
            Dict.get key dict
        )
        list


toList : OrderedDict comparable v -> List ( comparable, v )
toList (OrderedDict list dict) =
    List.filterMap
        (\key ->
            Maybe.map
                (Tuple.pair key)
                (Dict.get key dict)
        )
        list


fromList : List v -> OrderedDict Int v
fromList list =
    List.indexedMap Tuple.pair list
        |> fromTuples


fromTuples : List ( comparable, v ) -> OrderedDict comparable v
fromTuples list =
    OrderedDict
        (List.map Tuple.first list)
        (Dict.fromList list)


mapToList : (comparable -> v -> a) -> OrderedDict comparable v -> List a
mapToList mapFun orderedDict =
    List.map
        (\( key, value ) ->
            mapFun key value
        )
        (toList orderedDict)


setPosition : Int -> comparable -> OrderedDict comparable v -> OrderedDict comparable v
setPosition position key (OrderedDict list dict) =
    if Dict.member key dict then
        OrderedDict
            (List.concat
                [ List.take position (List.filter ((/=) key) list)
                , List.singleton key
                , List.drop position (List.filter ((/=) key) list)
                ]
            )
            dict

    else
        OrderedDict list dict


setOrder : List comparable -> OrderedDict comparable v -> OrderedDict comparable v
setOrder order (OrderedDict list dict) =
    OrderedDict
        (List.append
            (List.filter
                (\key ->
                    Dict.member key dict
                )
                order
            )
            (List.filter
                (\key ->
                    not (List.member key order)
                )
                list
            )
        )
        dict


decode : Decode.Decoder v -> Decode.Decoder (OrderedDict Int v)
decode decoder =
    Decode.list decoder
        |> Decode.map fromList
