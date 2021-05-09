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
}

.card-content {
    border-top: solid 1px;
    padding: 2px;
}

.card-title {
    font-size: 20px;
    font-weight: 700;
    padding: 2px;
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
body, button, input, select, textarea {
    color: #ddd;
    background-color: #282828;
}
    """
