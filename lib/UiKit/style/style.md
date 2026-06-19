# Tailwind Parser Reference

## Class Structure

A Tailwind class can generally be represented as:

```text
variant:variant:utility-value
```

Examples:

```text
bg-red-500
p-4
hover:bg-blue-500
md:flex
dark:md:hover:bg-red-500
w-[100px]
bg-[#ff0000]
```

---

# Parsing Result

Example:

```text
dark:md:hover:bg-red-500
```

Parsed as:

```json
{
  "variants": ["dark", "md", "hover"],
  "utility": "bg",
  "value": "red-500"
}
```

---

# Utility Groups

## Layout

```text
container
block
inline
inline-block
hidden
contents
```

---

## Position

```text
static
relative
absolute
fixed
sticky
```

---

## Inset

```text
top-0
right-0
bottom-0
left-0

inset-0
inset-x-0
inset-y-0
```

---

## Display

```text
flex
inline-flex
grid
inline-grid
table
```

---

## Flexbox

```text
flex-row
flex-col
flex-wrap

grow
grow-0

shrink
shrink-0
```

---

## Grid

```text
grid-cols-1
grid-cols-12

grid-rows-1
grid-rows-6

col-span-2
row-span-3
```

---

## Width

```text
w-0
w-4
w-8

w-full
w-screen
w-auto

w-[100px]
```

---

## Height

```text
h-0
h-4
h-8

h-full
h-screen
h-auto

h-[200px]
```

---

## Min / Max Size

```text
min-w-*
max-w-*

min-h-*
max-h-*
```

---

## Padding

```text
p-4

px-4
py-4

pt-4
pr-4
pb-4
pl-4
```

---

## Margin

```text
m-4

mx-4
my-4

mt-4
mr-4
mb-4
ml-4
```

---

## Gap

```text
gap-4

gap-x-4
gap-y-4
```

---

## Background

```text
bg-red-500
bg-blue-500
bg-white

bg-[#ff0000]
```

---

## Border

```text
border

border-2
border-4

border-red-500
```

---

## Border Radius

```text
rounded

rounded-sm
rounded-md
rounded-lg

rounded-full
```

---

## Typography

### Font Size

```text
text-xs
text-sm
text-base
text-lg
text-xl
```

### Font Weight

```text
font-thin
font-light
font-normal
font-medium
font-bold
font-black
```

### Text Alignment

```text
text-left
text-center
text-right
```

### Text Color

```text
text-white
text-black
text-red-500
```

---

## Alignment

```text
items-start
items-center
items-end

justify-start
justify-center
justify-between
justify-around
```

---

## Effects

```text
shadow
shadow-md
shadow-lg

opacity-0
opacity-50
opacity-100
```

---

## Transform

```text
scale-95
scale-100
scale-110

rotate-45
rotate-90

translate-x-4
translate-y-4
```

---

## Transition

```text
transition

duration-75
duration-150
duration-300

ease-linear
ease-in
ease-out
```

---

## Animation

```text
animate-spin
animate-pulse
animate-bounce
animate-ping
```

---

## Overflow

```text
overflow-hidden
overflow-auto
overflow-scroll
```

---

## Cursor

```text
cursor-pointer
cursor-default
cursor-not-allowed
```

---

## Z Index

```text
z-0
z-10
z-20
z-50
```

---

## Object Fit

```text
object-cover
object-contain
object-fill
```

---

## Aspect Ratio

```text
aspect-square
aspect-video
```

---

# Variants

Variants appear before the utility and are separated using `:`.

Example:

```text
hover:bg-red-500
```

---

## State Variants

```text
hover
focus
active
visited
disabled

checked
required
invalid

first
last
odd
even
```

Examples:

```text
hover:bg-blue-500
focus:ring-2
disabled:opacity-50
```

---

## Responsive Variants

```text
sm
md
lg
xl
2xl
```

Examples:

```text
sm:text-center
md:flex
lg:grid-cols-4
```

---

## Theme Variants

```text
dark
rtl
ltr
```

Examples:

```text
dark:bg-black
dark:text-white
```

---

## Parent / Peer Variants

```text
group-hover
group-focus

peer-checked
peer-focus
```

Examples:

```text
group-hover:text-red-500
peer-checked:bg-blue-500
```

---

# Arbitrary Values

Syntax:

```text
utility-[value]
```

Examples:

```text
w-[100px]
h-[50vh]

bg-[#ff0000]

text-[13px]

mt-[23px]
```

Parser Output:

```json
{
  "utility": "w",
  "value": "100px",
  "arbitrary": true
}
```

---

# Suggested AST

```text
Class
├── Variants
│   ├── dark
│   ├── md
│   └── hover
│
├── Utility
│   └── bg
│
└── Value
    └── red-500
```

Example:

```json
{
  "variants": ["dark", "md", "hover"],
  "utility": "bg",
  "value": "red-500"
}
```
