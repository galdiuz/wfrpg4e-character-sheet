module Css exposing (css, dark)

css : String
css =
    """
body {
    font-family: Times New Roman;
}

.content {
    display: flex;
    flex-direction: row;
    gap: 4px;
    padding: 4px;
}

.content-column {
    display: flex;
    flex-direction: column;
    flex: 1;
    gap: 4px;
    position: relative;
}

.card {
    background-color: #fff;
    border: solid;
    border-width: 0px;
    border-radius: 4px;
    margin: 4px 2px 4px 8px;
}

.card-container-fading {
    opacity: 0.0;
    transition: opacity 0.5s ease-in-out;
}

.card-container-floating {
    position: absolute;
    width: 100%;
    z-index: 1;
}

.card-container-transparent {
    opacity: 0.2;
}

.card-container-moving {
    transition-duration: 1s;
    transition-property: top, left;
    transition-timing-function: cubic-bezier(0.22, 1, 0.36, 1);
}

.card-content {
    overflow-y: hidden;
    padding: 8px;
    transform-origin: top;
    transition-duration: 0.5s;
    transition-property: max-height, padding, transform;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.card-header {
    align-items: center;
    box-sizing: border-box;
    border-top-right-radius: 4px;
    display: flex;
    font-size: 20px;
    font-weight: 700;
    height: 32px;
    justify-content: space-between;
    padding: 4px;
}

.card-header-buttons {
    display: flex;
    gap: 4px;
}

.card-header-icon {
    align-items: center;
    background-color: #fff;
    border-radius: 50%;
    border-style: solid;
    border-width: 1px;
    cursor: move;
    display: flex;
    font-size: 34px;
    height: 40px;
    justify-content: center;
    left: 0px;
    position: absolute;
    width: 40px;
}

.card-header-title {
    cursor: move;
    flex: 1;
    padding-left: 36px;
}

.flex-column {
    display: flex;
    flex-flow: column;
    gap: 4px;
}

.flex-row {
    display: flex;
    flex-flow: row;
    gap: 8px;
    justify-content: space-between;
}

.grid {
    display: grid;
    column-gap: 8px;
    row-gap: 4px;
}

.label {
    flex: 1;
    font-size: 14px;
}

button {
    white-space: nowrap;
}

.button-style {
    align-items: center;
    border-color: #767676;
    border-radius: 4px;
    border-style: solid;
    border-width: 1px;
    font-size: 16px;
    padding: 1px 6px;
    transition-duration: 0.15s;
    transition-property: background-color, color;
    transition-timing-function: ease-in-out;
}

input {
    box-sizing: border-box;
    padding: 1px;
    width: 100%;
    border-width: 1px;
    border-style: solid solid dashed;
    border-radius: 2px;
    transition: border-color 0.15s ease-in-out;
}

input:focus {
    border-style: solid;
    border-bottom-style: dashed;
    border-width: 1px;
}

input:focus-visible, textarea:focus-visible {
    outline: 0;
}

.textarea {
    border-radius: 2px;
    border-style: solid solid dashed;
    border-width: 1px;
    box-sizing: border-box;
    font-family: Times New Roman;
    font-size: 14px;
    max-height: 80px;
    overflow-wrap: anywhere;
    overflow: auto;
    padding: 2px;
    resize: none;
    transition: border-color 0.15s ease-in-out;
    white-space: break-spaces;
}

textarea {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}

input[type=number] {
    -moz-appearance:textfield;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

input::-webkit-calendar-picker-indicator {
    display: none;
}
    """


dark : String
dark =
    """
body, button, input, select, textarea, .card-header-icon {
    background-color: #282828;
    color: #ddd;
}

.card {
    background-color: #383838;
}

.card-header {
    background-color: #484848;
}

button:hover {
    background-color: #ddd;
    color: #282828;
}

.label {
    color: #999;
}

input, .textarea {
    border-color: #333;
    border-bottom-color: #666
}

input:hover, .textarea:hover {
    border-color: #555;
    border-bottom-color: #888;
}

input:focus, .textarea:focus {
    border-color: #999;
    border-bottom-color: #bbb;
}
    """
