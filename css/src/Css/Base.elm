module Css.Base exposing (..)


import Html
import Html.Attributes


button : Html.Attribute msg
button =
    Html.Attributes.class "button"


card : Html.Attribute msg
card =
    Html.Attributes.class "card"


cardContent : Html.Attribute msg
cardContent =
    Html.Attributes.class "card-content"


cardContentCollapsed : Html.Attribute msg
cardContentCollapsed =
    Html.Attributes.class "card-content-collapsed"


cardContentInner : Html.Attribute msg
cardContentInner =
    Html.Attributes.class "card-content-inner"


cardContentInnerCollapsed : Html.Attribute msg
cardContentInnerCollapsed =
    Html.Attributes.class "card-content-inner-collapsed"


cardHeader : Html.Attribute msg
cardHeader =
    Html.Attributes.class "card-header"


cardHeaderIcon : Html.Attribute msg
cardHeaderIcon =
    Html.Attributes.class "card-header-icon"


cardHeaderTitle : Html.Attribute msg
cardHeaderTitle =
    Html.Attributes.class "card-header-title"


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
  font-family: 'Times New Roman';
}

*::after {
  box-sizing: inherit;
}

*::before {
  box-sizing: inherit;
}

.button {
  border-radius: 4px;
  border-style: solid;
  border-width: 1px;
  font-size: 16px;
  padding: 1px 6px;
  transition-duration: 0.15s;
  transition-property: background-color, color;
  transition-timing-function: ease-in-out;
  white-space: nowrap;
  width: 100%;
}

.card {
  background-color: #FFFFFF;
  border-radius: 4px;
  border-style: solid;
  border-width: 0px;
  margin: 4px 2px 4px 8px;
}

.card-content {
  overflow-y: hidden;
  transition-duration: 0.35s;
  transition-property: max-height, opacity, padding;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.card-content-collapsed {
  max-height: 0px;
  opacity: 0;
  padding-bottom: 0px;
  padding-top: 0px;
}

.card-content-inner {
  padding: 8px;
  transform-origin: top;
  transition-duration: 0.35s;
  transition-property: transform;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.card-content-inner-collapsed {
  transform: scale(1, 0);
}

.card-header {
  border-top-right-radius: 4px;
  font-size: 20px;
  font-weight: 700;
  padding: 4px;
  position: relative;
}

.card-header-icon {
  align-items: center;
  background-color: #FFFFFF;
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
  border-radius: 2px;
  border-style: solid solid dashed;
  border-width: 1px;
  font-size: 14px;
  transition: border-color 0.15s ease-in-out;
  width: 100%;
}

.label {
  font-size: 14px;
}

.list-row:nth-child(odd) {
  background-color: #DEDEDE;
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
  width: 100%;
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
  box-sizing: border-box;
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


"""