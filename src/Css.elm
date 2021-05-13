module Css exposing (css, dark)

css : String
css =
    """
.content {
    display: flex;
    flex-direction: row;
    gap: 4px;
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
    border-width: 1px;
    border-radius: 4px;
    margin: 4px 0px 4px 8px;
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
    display: flex;
    font-size: 34px;
    height: 42px;
    justify-content: center;
    left: 0px;
    position: absolute;
    width: 42px;
}

.card-header-title {
    margin-left: 38px;
}

.grid {
    display: grid;
    column-gap: 8px;
    row-gap: 2px;
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
body, button, input, select, textarea, .card, .card-header-icon {
    color: #ddd;
    background-color: #282828;
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
