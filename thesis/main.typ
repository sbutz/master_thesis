#include "abbreviation.typ"

#let thesis_title = [Performance Evaluation of Virtualized Unikernels on RISC-V with Hardware-Assisted Virtualization]
#let thesis_author = "Stefan Butz"
#let thesis_date = datetime.today().display("[year]-[month]-[day]")

#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true)
#set page(paper: "a4", margin: (x: 2.5cm, y: 2.5cm), numbering: "1")

#align(center)[
  #v(4cm)
  #text(size: 18pt, weight: "bold")[#thesis_title]
  #v(1.2cm)
  #text(size: 12pt)[Master Thesis]
  #v(0.6cm)
  #thesis_author
  #v(0.6cm)
  #thesis_date
]

#pagebreak()

#set heading(numbering: none)
#include "00_abstract.typ"

#pagebreak()
#outline(title: [Table of Contents])

#pagebreak()
#set heading(numbering: "1.")

#include "01_introduction.typ"
#include "02_fundamentals.typ"
#include "03_architectural_background.typ"
#include "04_evaluation_methodology.typ"
#include "05_implementation.typ"
#include "06_evaluation_results.typ"
#include "07_discussion.typ"
#include "08_conclusion.typ"
#include "09_outlook.typ"

#pagebreak()
#set heading(numbering: none)
#include "10_acronyms.typ"

#pagebreak()
#include "11_bibliography.typ"

#pagebreak()
#include "12_appendix.typ"
