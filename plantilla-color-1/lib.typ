// TODO: Agregar soporte para equipos (varias personas)
// TODO: Agregar la opción de modificar los campos
// TODO: Determinar que paramétros pueden ser opciones, y agregar la opción de modificarlos mediante una lista de títulos de los campos

// ╔══════════════════════════════════════════════════════╗
// ║  Plantilla color 1                                   ║
// ║  Uso:                                                ║
// ║    #import "lib.typ": plantilla                      ║
// ║    #show: plantilla.with(universidad: "...", ...)    ║
// ╚══════════════════════════════════════════════════════╝

#import "@preview/catppuccin:1.1.0": flavors

// ── Paleta base (siempre Latte) ───────────────────────────────────────────────
#let _palette = flavors.latte.colors

// ── Resolutor de esquema de colores ──────────────────────────────────────────
// Devuelve un diccionario con los dos colores del degradado y el color
// primario (el que se usa en headings, labels y acentos).
// El color primario es siempre el primero del par, ya que es el más
// saturado y legible para texto sobre fondo blanco.
//
// Modos disponibles:
//   "blue-sky"   → Blue  → Sky   (default)
//   "mauve-pink" → Mauve → Pink
//   "teal-green" → Teal  → Green
//   "peach-red"  → Peach → Red

#let _esquema(modo) = {
  if      modo == "blue-sky"   { (prim: _palette.blue.rgb,  sec: _palette.sky.rgb)   }
  else if modo == "mauve-pink" { (prim: _palette.mauve.rgb, sec: _palette.pink.rgb)  }
  else if modo == "teal-green" { (prim: _palette.teal.rgb,  sec: _palette.green.rgb) }
  else if modo == "peach-red"  { (prim: _palette.peach.rgb, sec: _palette.red.rgb)   }
  // Fallback silencioso al modo por defecto
  else                         { (prim: _palette.blue.rgb,  sec: _palette.sky.rgb)   }
}

// ── Función principal de la plantilla ─────────────────────────────────────────

#let plantilla(
  // Institución
  universidad:        "Nombre de la universidad",
  facultad:           "Nombre de la facultad",
  // Trabajo
  etiqueta:           "Etiqueta del trabajo",
  titulo:             "Título del trabajo",
  // Alumno
  alumno:             "Nombre del alumno",
  num-cuenta:         "Número de cuenta",
  licenciatura:       "Nombre de la licenciatura",
  // Asignatura
  asignatura:         "Nombre de la Asignatura",
  // Campos opcionales — pasar none para omitirlos
  escudo-universidad: none,
  escudo-facultad:    none,
  profesor:           none,
  grupo:              none,
  semestre:           "Semestre",
  // Esquema de colores — ver _esquema() para las opciones
  modo-color:         "blue-sky",
  // Cuerpo del documento
  body,
) = {

  // ── Resolver colores del esquema elegido ──────────────────
  let col = _esquema(modo-color)
  let c-prim = col.prim   // color principal: headings, labels, acentos
  let c-sec  = col.sec    // color secundario: extremo del degradado

  // ── Funciones internas con colores resueltos ──────────────
  // Se definen aquí para capturar c-prim y c-sec por closure,
  // evitando pasar colores como argumento en cada llamada.

  let campo(label, valor) = stack(
    spacing: 4pt,
    text(
      size: 8pt,
      weight: "bold",
      fill: c-prim,
      tracking: 1.5pt,
      upper(label)
    ),
    text(
      size: 11pt,
      weight: "medium",
      fill: _palette.text.rgb,
      valor
    )
  )

  let asig-icon = box(
    width: 28pt,
    height: 28pt,
    radius: 7pt,
    fill: gradient.linear(c-prim, c-sec, angle: -45deg),
    align(center + horizon)[
      #set text(size: 14pt)
      📚
    ]
  )

  let asig-text(asig) = stack(
    spacing: 3pt,
    text(
      size: 7pt,
      weight: "bold",
      fill: c-prim,
      tracking: 2pt,
      "ASIGNATURA"
    ),
    text(
      size: 13pt,
      weight: "bold",
      fill: _palette.text.rgb,
      asig
    )
  )

  let title-card(tw, tit, lic) = box(
    width: 100%,
    fill: gradient.linear(c-prim, c-sec, angle: -45deg),
    inset: 1cm,
    radius: 15pt,
    clip: true,
  )[
    #set text(fill: white)

    #place(
      top + right,
      dx: 40pt, dy: -40pt,
      circle(radius: 80pt, fill: white.transparentize(94%), stroke: none)
    )
    #place(
      bottom + left,
      dx: -40pt, dy: 40pt,
      circle(radius: 70pt, fill: white.transparentize(96%), stroke: none)
    )

    #grid(
      columns: (1fr, auto),
      align: top,
      box(
        radius: 8pt,
        fill: white.transparentize(80%),
        inset: (x: 10pt, y: 5pt),
        stroke: (paint: white.transparentize(55%), thickness: 1pt),
        tw
      ),
      align(right)[
        #stack(
          spacing: 4pt,
          text(size: 7pt, weight: "bold", fill: white.transparentize(50%),
               tracking: 1.5pt, "LICENCIATURA"),
          text(size: 10.5pt, weight: "semibold",
               fill: white.transparentize(15%), lic)
        )
      ]
    )

    #line(
      length: 100%,
      stroke: (paint: white.transparentize(80%), thickness: 0.5pt)
    )

    #text(size: 23pt, weight: "black", tit)

    #grid(
      columns: 4,
      align: center + horizon,
      column-gutter: 6pt,
      box(width: 15pt, height: 4pt, radius: 2pt,
        fill: white.transparentize(55%)),
      circle(radius: 2pt, fill: white.transparentize(70%), stroke: none),
      circle(radius: 2pt, fill: white.transparentize(70%), stroke: none),
      circle(radius: 2pt, fill: white.transparentize(70%), stroke: none),
    )
  ]

  let data-box(campos) = {
    let celdas = campos
      .filter(c => c.at(1) != none)
      .map(c => campo(c.at(0), c.at(1)))

    if calc.rem(celdas.len(), 2) != 0 { celdas.push([]) }
    if celdas.len() == 0 { return }

    box(
      width: 100%,
      fill: white,
      stroke: (
        left: (
          paint: gradient.linear(c-prim, c-sec, angle: 90deg),
          thickness: 5pt,
        ),
        top:    c-prim,
        right: (
          paint: gradient.linear(c-prim, c-sec, angle: 90deg),
        ),
        bottom: c-sec,
      ),
      radius: (
        top-left: 0pt, bottom-left: 0pt,
        top-right: 6pt, bottom-right: 6pt,
      ),
      inset: (y: 10pt),
      grid(
        columns: (1fr, 1fr),
        inset: (x: 20pt, y: 12pt),
        align: top,
        ..celdas,
      )
    )
  }

  // ── Bloque de logos dinámico ──────────────────────────────
  // Construye el stack horizontal solo con los logos presentes.
  // El separador vertical solo aparece cuando hay exactamente dos logos.
  let logos-row = {
    let sep = align(horizon,
      box(width: 1pt, height: 2.5cm, fill: _palette.surface0.rgb)
    )

    if escudo-universidad != none and escudo-facultad != none {
      stack(
        dir: ltr,
        spacing: 1cm,
        escudo-universidad,
        sep,
        escudo-facultad,
      )
    } else if escudo-universidad != none {
      escudo-universidad
    } else if escudo-facultad != none {
      escudo-facultad
    }
    // Si ambos son none no se renderiza nada
  }

  // ── Configuración global del documento ───────────────────
  set document(title: titulo, author: alumno)

  set page(
    paper: "us-letter",
    margin: 1in,
    numbering: "1",
    number-align: center,
  )

  set text(
    font: "Outfit",
    size: 12pt,
    lang: "es",
    region: "mx",
    fill: _palette.text.rgb,
  )

  set par(leading: 0.75em, justify: true)

  set heading(numbering: "1.1.")

  show heading.where(level: 1): it => [
    #set text(size: 16pt, weight: "bold", fill: c-prim)
    #block(above: 1.5em, below: 0.8em, it)
  ]

  show heading.where(level: 2): it => [
    #set text(size: 13pt, weight: "semibold", fill: _palette.text.rgb)
    #block(above: 1.2em, below: 0.6em, it)
  ]

  // ── Portada ───────────────────────────────────────────────
  page(
    margin: 0.75in,
    header: none,
    numbering: none,
    footer: [
      #set align(center)
      #set text(size: 10pt, weight: "medium",
                fill: _palette.overlay0.rgb, tracking: 1pt)
      SEMESTRE #semestre
    ],
    background: {
      set align(top)
      line(
        length: 100%,
        stroke: 20pt + gradient.linear(c-prim, c-sec),
      )
    }
  )[
    #set align(center)

    #logos-row

    #v(0.5cm)

    #text(size: 18pt, weight: "semibold", universidad)
    #linebreak()
    #text(size: 14pt, weight: "light",
          fill: _palette.subtext0.rgb, smallcaps(facultad))

    #v(0.7fr)
    #set align(left)

    #title-card(etiqueta, titulo, licenciatura)

    #v(0.5fr)
    #align(center)[
      #box(
        fill: white,
        stroke: _palette.surface0.rgb,
        radius: 10pt,
        inset: (x: 20pt, y: 10pt),
        stack(
          dir: ltr,
          spacing: 10pt,
          align(horizon, asig-icon),
          align(horizon, asig-text(asignatura)),
        )
      )
    ]
    #v(0.5fr)

    #set align(left)
    #data-box((
      ("Profesor",         profesor),
      ("Grupo",            grupo),
      ("Alumno",           alumno),
      ("Número de Cuenta", num-cuenta),
    ))
  ]

  counter(page).update(1)

  body
}