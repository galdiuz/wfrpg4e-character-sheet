module Css exposing (css)

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
