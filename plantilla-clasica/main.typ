// TODO: Crear un archivo específico para la plantilla

#set page(
  paper: "us-letter",
  // margin: 1in,
)

#set text(
  font: "Fira Sans",
  size: 12pt,
  lang: "es",
  region: "mx",
)

#show math.equation: set text(
  font: "Fira Math",
)

#let titulo = "Título"
#let universidad = text(size: 1.3em)[Universidad Nacional Autónoma de México]
#let facultad = [Facultad de Estudios Superiores Acatlán]
#let licenciatura = "Matemáticas Aplicadas y Computación"
#let asignatura = "Asignatura"
#let profesor = [*Profesor:* Juan Pérez]
#let alumnos = "sav1209"
#let grupo = "XXXX"
#let fecha = [Ciudad de México, XX de XXX de XXXX]
#let portada = (
  mostrar: true,
  escudos: (
    ancho: 20%,
    universidad: "escudos/escudo-unam.svg",
    facultad: "escudos/escudo-fesa-negro.jpg",
  ),
)


#let lineas(angle: 0deg, dir: ttb) = stack(
  spacing: 6pt,
  dir: dir,
  line(length: 100%, stroke: 3pt, angle: angle),
  line(length: 100%, stroke: 1.5pt, angle: angle),
)

#set document(title: titulo, author: alumnos)
#page(
  header: none,
  footer: none,
  margin: 0.75in,
  grid(
    columns: (portada.escudos.ancho, 1fr),
    column-gutter: 10pt,
    rows: (auto, 1fr),
    row-gutter: 15pt,
    align: center+horizon,
    
    // Escudo universidad
    image(portada.escudos.universidad, width: 100%),

    // Escudo facultad y lineas verticales
    grid.cell(
      x: 0, y: 1,
      grid(
        columns: 1,
        rows: (1fr, auto),
        row-gutter: 15pt,
        lineas(dir: ltr, angle: 90deg),
        image(portada.escudos.facultad, width: 100%),
      ),
    ),

    // Nombre universidad y lineas horizontales
    grid.cell(
      align: bottom,
      stack(
        align(
          horizon,
          block(
            width: 100%,
            text(
              size: 25pt,
              weight: "extrabold",
              upper(universidad)
            )
          )
        ),
        lineas()
      )
    ),

    // Cuerpo
    grid.cell(
      x: 1, y: 1,
      align: center+top,
      inset: (y: 5pt),
      {
        set text(14pt)
        
        text(
          size: 21pt,
          weight: "medium",
          facultad
        )
  
        block(
          height: 6.5cm,
          align(center+horizon,
            text(
              size: 35pt,
              weight: "extrabold",
              smallcaps(titulo)
            )
          )
        )
        
        text(
          size: 18pt,
          weight: "regular"
        )[
          Licenciatura en\
          #licenciatura
        ]
  
        v(1.5fr)
  
        if profesor != none [#profesor\ ]
        if asignatura != none [*Asignatura:* #asignatura\ ]
        if grupo != none [*Grupo:* #grupo]

        if (asignatura, profesor, grupo).any(it => it != none) {v(1fr)}
        
        if type(alumnos) == str {alumnos = (alumnos,)}
        for alumno in alumnos [
          #upper(alumno)\
        ]
  
        v(1.5fr)
        
        [#fecha]
      }
    ),
  ),
)

= #lorem(5)
#lorem(100)

- #lorem(20)
- #lorem(20)
- #lorem(20)

== #lorem(3)

Enlace: https://www.acatlan.unam.mx/

+ #lorem(20)
+ #lorem(20)
+ #lorem(20)