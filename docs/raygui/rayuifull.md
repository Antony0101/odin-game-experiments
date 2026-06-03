# Raygui Components Reference

## Basic Components

### GuiLabel

Displays static text.

**Signature**

```odin
GuiLabel(bounds: Rectangle, text: cstring)
```

**Parameters**

| Name   | Type      | Description       |
| ------ | --------- | ----------------- |
| bounds | Rectangle | Position and size |
| text   | cstring   | Text to display   |

**Returns**

None

---

### GuiButton

Clickable button.

**Signature**

```odin
GuiButton(bounds: Rectangle, text: cstring) -> c.int
```

**Parameters**

| Name   | Type      | Description       |
| ------ | --------- | ----------------- |
| bounds | Rectangle | Position and size |
| text   | cstring   | Button label      |

**Returns**

| Value    | Meaning            |
| -------- | ------------------ |
| 0        | Not pressed        |
| non-zero | Pressed this frame |

---

### GuiLabelButton

Label that behaves like a button.

**Signature**

```odin
GuiLabelButton(bounds: Rectangle, text: cstring) -> c.int
```

**Returns**

Non-zero when clicked.

---

### GuiToggle

Toggle button.

**Signature**

```odin
GuiToggle(bounds: Rectangle, text: cstring, active: bool) -> bool
```

**Parameters**

| Name   | Description   |
| ------ | ------------- |
| active | Current state |

**Returns**

New state.

---

### GuiToggleGroup

Group of toggle buttons.

**Signature**

```odin
GuiToggleGroup(bounds: Rectangle, text: cstring, active: int) -> int
```

**Returns**

Selected index.

---

### GuiToggleSlider

Slider-like toggle.

**Signature**

```odin
GuiToggleSlider(bounds: Rectangle, text: cstring, active: int) -> int
```

**Returns**

Selected option index.

---

### GuiCheckBox

Checkbox control.

**Signature**

```odin
GuiCheckBox(bounds: Rectangle, text: cstring, checked: bool) -> bool
```

**Returns**

New checked state.

---

### GuiComboBox

Compact item selector.

**Signature**

```odin
GuiComboBox(bounds: Rectangle, text: cstring, active: int) -> int
```

**Returns**

Selected item index.

---

### GuiDropdownBox

Dropdown menu.

**Signature**

```odin
GuiDropdownBox(
    bounds: Rectangle,
    text: cstring,
    active: ^int,
    edit_mode: bool,
) -> bool
```

**Returns**

Whether edit mode changed.

---

### GuiTextBox

Single-line text input.

**Signature**

```odin
GuiTextBox(
    bounds: Rectangle,
    text: [^]u8,
    text_size: int,
    edit_mode: bool,
) -> bool
```

**Returns**

Whether edit mode changed.

---

### GuiTextBoxMulti

Multi-line text input.

**Signature**

```odin
GuiTextBoxMulti(...)
```

**Returns**

Whether edit mode changed.

---

### GuiValueBox

Numeric value editor.

**Signature**

```odin
GuiValueBox(
    bounds: Rectangle,
    text: [^]u8,
    value: ^int,
    min_value: int,
    max_value: int,
    edit_mode: bool,
) -> bool
```

**Returns**

Whether edit mode changed.

---

### GuiSpinner

Value box with increment/decrement buttons.

**Signature**

```odin
GuiSpinner(...)
```

**Returns**

Whether edit mode changed.

---

### GuiSlider

Slider with labels.

**Signature**

```odin
GuiSlider(
    bounds: Rectangle,
    text_left: cstring,
    text_right: cstring,
    value: f32,
    min_value: f32,
    max_value: f32,
) -> f32
```

**Returns**

Updated value.

---

### GuiSliderBar

Simple slider.

**Signature**

```odin
GuiSliderBar(...)
```

**Returns**

Updated value.

---

### GuiSliderPro

Fully configurable slider.

**Signature**

```odin
GuiSliderPro(...)
```

**Returns**

Updated value.

---

### GuiProgressBar

Displays progress.

**Signature**

```odin
GuiProgressBar(...)
```

**Returns**

Current value.

---

### GuiStatusBar

Displays status information.

**Signature**

```odin
GuiStatusBar(bounds: Rectangle, text: cstring)
```

**Returns**

None.

---

### GuiGrid

Draws a grid.

**Signature**

```odin
GuiGrid(
    bounds: Rectangle,
    text: cstring,
    spacing: f32,
    subdivs: int,
) -> Vector2
```

**Returns**

Nearest grid coordinate.

---

### GuiDummyRec

Placeholder rectangle.

**Signature**

```odin
GuiDummyRec(bounds: Rectangle, text: cstring)
```

**Returns**

None.

---

# Containers

## GuiWindowBox

Window with title bar and close button.

**Signature**

```odin
GuiWindowBox(bounds: Rectangle, title: cstring) -> c.int
```

**Returns**

| Value    | Meaning              |
| -------- | -------------------- |
| 0        | Window open          |
| non-zero | Close button pressed |

---

## GuiGroupBox

Visual grouping container.

**Signature**

```odin
GuiGroupBox(bounds: Rectangle, text: cstring)
```

**Returns**

None.

---

## GuiPanel

Simple panel.

**Signature**

```odin
GuiPanel(bounds: Rectangle, text: cstring)
```

**Returns**

None.

---

## GuiScrollPanel

Scrollable viewport.

**Signature**

```odin
GuiScrollPanel(
    bounds: Rectangle,
    text: cstring,
    content: Rectangle,
    scroll: ^Vector2,
    view: ^Rectangle,
)
```

**Returns**

Visible viewport rectangle.

---

## GuiTabBar

Tab control.

**Signature**

```odin
GuiTabBar(...)
```

**Returns**

Selected tab index.

---

## GuiLine

Horizontal separator.

**Signature**

```odin
GuiLine(bounds: Rectangle, text: cstring)
```

**Returns**

None.

---

# Advanced Controls

## GuiListView

Scrollable text list.

**Signature**

```odin
GuiListView(
    bounds: Rectangle,
    text: cstring,
    scroll_index: ^int,
    active: int,
) -> int
```

**Returns**

Selected item index.

---

## GuiListViewEx

Array-based list view.

**Signature**

```odin
GuiListViewEx(
    bounds: Rectangle,
    text: [^]cstring,
    count: int,
    focus: ^int,
    scroll_index: ^int,
) -> int
```

**Returns**

Selected item index.

---

## GuiColorPicker

Complete color picker.

**Signature**

```odin
GuiColorPicker(bounds: Rectangle, color: Color) -> Color
```

**Returns**

Selected color.

---

## GuiColorPanel

Color selection panel.

**Signature**

```odin
GuiColorPanel(bounds: Rectangle, color: Color) -> Color
```

**Returns**

Selected color.

---

## GuiColorBarHue

Hue selector.

**Signature**

```odin
GuiColorBarHue(bounds: Rectangle, value: f32) -> f32
```

**Returns**

Selected hue.

---

## GuiColorBarAlpha

Alpha selector.

**Signature**

```odin
GuiColorBarAlpha(bounds: Rectangle, value: f32) -> f32
```

**Returns**

Selected alpha value.

---

## GuiMessageBox

Modal message dialog.

**Signature**

```odin
GuiMessageBox(
    bounds: Rectangle,
    title: cstring,
    message: cstring,
    buttons: cstring,
) -> int
```

**Returns**

Index of pressed button.

---

## GuiTextInputBox

Modal text input dialog.

**Signature**

```odin
GuiTextInputBox(...)
```

**Returns**

Button index pressed by user.

---
