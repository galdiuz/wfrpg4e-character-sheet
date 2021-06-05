module Css.Dark exposing (..)


import Html
import Html.Attributes


button : Html.Attribute msg
button =
    Html.Attributes.class "button"


card : Html.Attribute msg
card =
    Html.Attributes.class "card"


cardHeader : Html.Attribute msg
cardHeader =
    Html.Attributes.class "card-header"


cardHeaderIcon : Html.Attribute msg
cardHeaderIcon =
    Html.Attributes.class "card-header-icon"


cardHeaderTitle : Html.Attribute msg
cardHeaderTitle =
    Html.Attributes.class "card-header-title"


collapsible : Html.Attribute msg
collapsible =
    Html.Attributes.class "collapsible"


collapsibleCollapsed : Html.Attribute msg
collapsibleCollapsed =
    Html.Attributes.class "collapsible-collapsed"


collapsibleInner : Html.Attribute msg
collapsibleInner =
    Html.Attributes.class "collapsible-inner"


collapsibleInnerCollapsed : Html.Attribute msg
collapsibleInnerCollapsed =
    Html.Attributes.class "collapsible-inner-collapsed"


column : Html.Attribute msg
column =
    Html.Attributes.class "column"


content : Html.Attribute msg
content =
    Html.Attributes.class "content"


cursorMove : Html.Attribute msg
cursorMove =
    Html.Attributes.class "cursor-move"


cursorSort : Html.Attribute msg
cursorSort =
    Html.Attributes.class "cursor-sort"


fading : Html.Attribute msg
fading =
    Html.Attributes.class "fading"


floating : Html.Attribute msg
floating =
    Html.Attributes.class "floating"


header : Html.Attribute msg
header =
    Html.Attributes.class "header"


input : Html.Attribute msg
input =
    Html.Attributes.class "input"


label : Html.Attribute msg
label =
    Html.Attributes.class "label"


listRow : Html.Attribute msg
listRow =
    Html.Attributes.class "list-row"


listRowDelete : Html.Attribute msg
listRowDelete =
    Html.Attributes.class "list-row-delete"


listRowDeleteConfirm : Html.Attribute msg
listRowDeleteConfirm =
    Html.Attributes.class "list-row-delete-confirm"


moving : Html.Attribute msg
moving =
    Html.Attributes.class "moving"


row : Html.Attribute msg
row =
    Html.Attributes.class "row"


select : Html.Attribute msg
select =
    Html.Attributes.class "select"


textarea : Html.Attribute msg
textarea =
    Html.Attributes.class "textarea"


transparent : Html.Attribute msg
transparent =
    Html.Attributes.class "transparent"


styleSheet : String
styleSheet =
    """
* {
  box-sizing: inherit;
  color: inherit;
  font-family: 'Times New Roman';
}

*::after {
  box-sizing: inherit;
}

*::before {
  box-sizing: inherit;
}

.button {
  background-color: #282828;
  border-radius: 4px;
  border-style: solid;
  border-width: 1px;
  display: flex;
  font-size: 16px;
  justify-content: center;
  padding: 2px 6px;
  transition-duration: 0.15s;
  transition-property: background-color, border-color, color;
  transition-timing-function: ease-in-out;
  white-space: nowrap;
  width: 100%;
}

.button:focus-visible {
  border-color: #B0B0B0;
  outline: none;
}

.button:hover {
  background-color: #DDDDDD;
  color: #282828;
}

.card {
  background-color: #383838;
  border-radius: 4px;
  border-style: solid;
  border-width: 0px;
  margin: 4px 2px 4px 8px;
}

.card-header {
  background-color: #484848;
  border-top-right-radius: 4px;
  font-size: 20px;
  font-weight: 700;
  padding: 4px;
  position: relative;
}

.card-header-icon {
  align-items: center;
  background-color: #282828;
  border-radius: 50%;
  border-style: solid;
  border-width: 1px;
  display: flex;
  font-size: 34px;
  height: 40px;
  justify-content: center;
  left: -6px;
  position: absolute;
  width: 40px;
  z-index: 1;
}

.card-header-title {
  flex: 1;
  padding-left: 36px;
}

.collapsible {
  overflow-y: hidden;
  transition-duration: 0.35s;
  transition-property: max-height, opacity;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.collapsible-collapsed {
  max-height: 0px;
  opacity: 0;
}

.collapsible-inner {
  transform-origin: top;
  transition-duration: 0.35s;
  transition-property: transform;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.collapsible-inner-collapsed {
  transform: scale(1, 0);
}

.column {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.content {
  display: flex;
  flex: 1;
  flex-direction: row;
  gap: 4px;
  position: relative;
}

.cursor-move {
  cursor: move;
}

.cursor-sort {
  cursor: ns-resize;
}

.fading {
  opacity: 0;
  transition: opacity 0.5s ease-in-out;
}

.floating {
  position: absolute;
  width: 100%;
  z-index: 10;
}

.header {
  padding: 2px;
}

.input {
  background-color: inherit;
  border-bottom-color: #606060;
  border-left-color: #00000000;
  border-radius: 2px;
  border-right-color: #00000000;
  border-style: solid solid dashed;
  border-top-color: #00000000;
  border-width: 1px;
  font-size: 14px;
  transition: border-color 0.15s ease-in-out;
  width: 100%;
}

.input:focus-visible {
  border-color: #B0B0B0;
  outline: none;
}

.input:hover:not(:focus) {
  border-color: #808080;
}

.label {
  color: #909090;
  font-size: 14px;
}

.label > * {
  color: #DDDDDD;
}

.list-row {
  transition-duration: 0.5s;
  transition-property: background-color;
  transition-timing-function: ease-in-out;
}

.list-row-delete {
  display: none;
  flex-direction: row;
  gap: 4px;
  justify-content: space-between;
  padding: 2px 4px;
  position: absolute;
  right: 0px;
  top: 100%;
  z-index: 1;
}

.list-row-delete-confirm {
  overflow: hidden;
  transition-duration: 0.35s;
  transition-property: width;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  width: 80px;
}

.list-row-delete:hover {
  display: flex;
}

.list-row:focus-within .list-row-delete {
  display: flex;
}

.list-row:hover .list-row-delete {
  display: flex;
}

.list-row:nth-child(odd) {
  background-color: #303030;
}

.moving {
  transition-duration: 1s;
  transition-property: top, left;
  transition-timing-function: cubic-bezier(0.22, 1, 0.36, 1);
}

.row {
  align-items: center;
  display: flex;
  flex-direction: row;
  gap: 8px;
  justify-content: space-between;
}

.select {
  background-color: inherit;
  font-size: 14px;
  transition: border-color 0.15s ease-in-out;
  width: 100%;
}

.select:focus-visible {
  border-color: #B0B0B0;
  outline: none;
}

.textarea {
  position: relative;
}

.textarea > * {
  font-size: 14px;
  max-height: 80px;
  overflow: auto;
  overflow-wrap: anywhere;
  padding: 1px;
  white-space: break-spaces;
}

.textarea > div {
  visibility: hidden;
}

.textarea > textarea {
  background-color: inherit;
  height: 100%;
  left: 0;
  position: absolute;
  resize: none;
  top: 0;
  width: 100%;
}

.transparent {
  opacity: 0.2;
}

body {
  background-color: #282828;
  box-sizing: border-box;
  color: #DDDDDD;
}

input::-webkit-calendar-picker-indicator {
  display: none;
}

input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
}

input::-webkit-outer-spin-button {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
}

input[type=number] {
  -webkit-appearance: textfield;
  -moz-appearance: textfield;
  appearance: textfield;
}

option {
  background-color: #282828;
}


"""