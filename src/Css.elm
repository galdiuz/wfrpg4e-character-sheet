module Css exposing (css, dark)

css : String
css =
    """
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
    padding: 8px;
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
    font-size: 32px;
    height: 40px;
    justify-content: center;
    left: 0px;
    position: absolute;
    width: 42px;
}

.card-header-title {
    cursor: move;
    flex: 1;
    padding-left: 38px;
}

.grid {
    display: grid;
    column-gap: 8px;
    row-gap: 4px;
}

.label {
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
    border-style: solid;
    border-bottom-style: dashed;
    border-radius: 2px;
    transition: border-color 0.15s ease-in-out;
}

input:focus {
    border-style: solid;
    border-bottom-style: dashed;
    border-width: 1px;
}

input:focus-visible {
    outline: 0;
}

textarea {
    resize: vertical;
}

input[type=number] {
    -moz-appearance:textfield;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
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

input {
    border-color: #333;
    border-bottom-color: #666
}

input:hover {
    border-color: #555;
    border-bottom-color: #888;
}

input:focus {
    border-color: #999;
    border-bottom-color: #bbb;
}
    """
