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
    padding: 2px;
}

.card-title {
    border-bottom: solid 1px;
    cursor: move;
    font-size: 20px;
    font-weight: 700;
    padding: 2px;
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
