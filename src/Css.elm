module Css exposing (css, dark)

css : String
css =
    """
.content {
    display: flex;
    flex-direction: row;
}

.content-column {
    display: flex;
    flex-direction: column;
    gap: 4px;
    padding: 2px;
}

.card {
    border: solid;
    border-width: 1px;
    margin: 4px 0px 4px 8px;
}

.card-content {
    border-top: solid 1px;
    padding: 8px 4px 4px;
}

.card-header {
    align-items: center;
    box-sizing: border-box;
    display: flex;
    font-size: 20px;
    font-weight: 700;
    height: 32px;
    justify-content: space-between;
    padding: 2px;
}

.card-header-title {
    margin-left: 38px;
}

.card-header-buttons {
    display: flex;
}

.card-header-buttons > div:nth-last-child(n+2) {
    margin-right: 4px;
}

.card-header-icon {
    align-items: center;
    border-radius: 50%;
    border-style: solid;
    border-width: 1px;
    display: flex;
    font-size: 34px;
    height: 42px;
    justify-content: center;
    margin-left: -11px;
    position: absolute;
    width: 42px;
}

button {
    border-width: 2px;
    border-style: outset;
    border-color: #767676;
    padding: 1px 6px;
    font-size: 16px;
    white-space: nowrap;
    cursor: pointer;
}

.button-style {
    border-width: 2px;
    border-style: outset;
    border-color: #767676;
    padding: 1px 6px;
    font-size: 16px;
}

input {
    box-sizing: border-box;
    padding: 1px;
    width: 100%;
    border-width: 0px 0px 1px;
    border-style: dashed;
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
    color: #ddd;
    background-color: #282828;
}
    """
