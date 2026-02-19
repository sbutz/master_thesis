#import "@preview/abbr:0.3.0"

#show: abbr.show-rule
#abbr.config(style: it => it) // normal styling
#abbr.make(
  ("FPGA", "Field-Programmable Gate Array"),
  ("KVM", "Kernel-based Virtual Machine"),
  ("KVM-VMI", "KVM Virtual Machine Introspection"),
  ("QEMU", "Quick Emulator"),
  ("SBI", "Supervisor Binary Interface"),
)

//#let title_ = "[Working title]"
//#let title_ = "Evaluation of virtualized unikernels on RISC-V hardware with hypervisor extension"
#let title_ = [Performance Evaluation of Virtualized Unikernels on RISC-V with Hardware-\ Assisted Virtualization]
#let author = "Stefan Butz"
#let student_id = "q7538820"
#let email = "stefan.butz@studium.fernuni-hagen.de"
#let discipline = "Applied Computer Sciences"
#let period = "March 16th, 2026 - September 16th, 2026"
#let supervisor = "Prof. Dr. Lena Oden"

#set text(font: "New Computer Modern", size: 12pt)
#set par(justify: true)
//#set par(spacing: 1.2em)
//#set block(spacing: 1.5em)
//#set list(spacing: 1.5em, indent: 1.5em, body-indent: 0.5em)


#set page(paper: "a4", numbering: "1")
#set heading(numbering: "1.1  ")
#show heading: it => block(above: 1.75em, below: 1.0em, it)

#set document(
    title: title_,
    author: author,
)

#align(center)[
  Exposé for master thesis at the chair of computer engineering of the University of Hagen
]

#align(center)[
  #v(2em)
  #title()
  #v(1em)
]

#align(center)[
  #author

  #student_id

  #email

  #discipline

  #period

  Supervisor: #supervisor
  #v(1em)
]

= Problem

== Motivation

//- Was ist das Problem, dass in der Arbeit gelöst werden soll?
//- Warum ist dies ein relevantes Problem für die Informatik (Motivation)?

This thesis addresses the lack of comprehensive performance evaluations of virtualized unikernels
on RISC-V hardware with hypervisor extension support.
While RISC-V is gaining adoption as an open instruction set architecture and development boards
with hardware virtualization support have recently become available @eswin_eic7700x_2024 @pine64_september_2024,
performance characteristics of virtualized unikernels on such hardware remain largely unexplored.

Existing evaluations of unikernels on RISC-V focus primarily on RustyHermit. Schöning evaluates
RustyHermit on both bare metal and @QEMU @schoning_porting_2021, while Ruppert-Maas evaluates
it on @QEMU emulation only @ruppert-maas_systematische_2025. However, neither work evaluates
virtualized deployments utilizing hardware hypervisor extensions.
Emulation may not accurately reflect real hardware behavior, particularly regarding interrupt
handling, memory management, and virtualization overhead @fuentes_morales_evaluating_2016.

Furthermore, prior studies employ synthetic microbenchmarks rather than realistic application
workloads @schoning_porting_2021, @ruppert-maas_systematische_2025.
This limits the applicability of results to practical scenarios.

Unikernels are proposed as lightweight virtualization solutions with potential benefits including
reduced boot times, lower memory consumption, and simplified system stacks @madhavapeddy_unikernels_2013.
Evaluating whether these benefits persist on RISC-V systems with hardware virtualization support
is important for systems research.


== Formulation

//- Was ist die konkrete Aufgabenstellung, das Ziel der Arbeit?

The objective of this thesis is to evaluate the performance characteristics of virtualized
unikernels on RISC-V hardware supporting the hypervisor extension.
The evaluation focuses on the RustyHermit unikernel running under @KVM and examines execution
performance, boot latency, i/o behavior, network performance, and resource usage using a combination
of synthetic benchmarks and representative workloads.

To assess the validity of emulation-based studies, results obtained on real hardware are compared
with @QEMU:s#"-based" virtualization.
Additionally, RustyHermit is compared against a minimal virtualized Linux system to contextualize
observed performance characteristics.
Where feasible, results are contrasted with other RISC-V–capable unikernels.

Kernel modifications are limited to instrumentation and targeted adjustments necessary to enable
accurate measurement and analysis.
Functional extensions and general feature development are not primary objectives of this work.

//evaluate performance of virtualized unikernels on RISC-V hardware with hypervisor extension support
//- focus on RustyHermit running under KVM
//- analyze execution performance, i/o, network, boot latency, resource usage in synthetic benchmarks and real workloads
//- compare with qemu-based virtualization to assess validity of emulated evaluations
//- compare with minimal virtualized linux
//- if possible compare with other unikernels (unishyper, nanos)
//
//probably required:
//- kernel instrumentations
//- bug fixes
//- virtio-blk, virtio-balloon support?


== Intended Results

//- Was sind die intendierten Ergebnisse der Arbeit, die mit geeigneten Methoden der Informatik erzielt werden sollen, und die das Problem lösen? (z.#h(0pt)B. Anforderungsdefinition, Spezifikation, Architektur, Algorithmen, Prototyp, Methode etc.)

The thesis is expected to produce a reproducible experimental setup for evaluating virtualized
unikernels on RISC-V hardware with hypervisor extension support.
It provides quantitative performance measurements of the RustyHermit unikernel running under
@KVM on real hardware, covering execution performance, boot latency, i/o and network behavior,
and resource usage.
Based on controlled benchmarking and kernel-level instrumentation, the work analyzes
virtualization-related overheads specific to the RISC-V hypervisor extension and compares
hardware-based results with @QEMU#"-based" virtualization to assess the validity of emulated evaluations.
Where feasible, the results are contextualized through comparison with a minimal virtualized Linux
system and other RISC-V-capable unikernels.
In addition, the thesis produces software artifacts supporting the evaluation, including
kernel-level instrumentation and limited, targeted adjustments to the virtualization and i/o stack
required to enable reproducible and meaningful experiments.


= Current State of the Art

//- Was gibt es an existierenden Lösungen/Ansätzen?
//- Welche Defizite haben diese, d.#h(0pt)h., warum sind die nicht ausreichend zur Lösung des Problems?

// unikernels on risc-v:
// - virtualized unikernels have never been evaluated on real RISC-V hardware with hypervisor extension support.
//   - just a lack
// - they have been tested bare-metal on real hw, and in qemu / fpga @schoning_porting_2021, @ruppert-maas_systematische_2025
//   - but not virtualized with hardware support, which is the intended use case for many unikernels
//   - simulation not accurate @fuentes_morales_evaluating_2016
//   - mostly synthetic benchmarks, not real workloads --> synthentic benchmark have to be carfully designed to be representative of real workloads, otherwise results may not generalize to practical scenarios @sreenivasan_construction_1974
// 
// unikernels in general:
// - have they been tested on x86/arm with hypervisor extensions? @madhavapeddy_unikernels_2013 @kuenzer_unikraft_2021 @hu_unishyper_2024
//   - probably yes, but performance depends on ISA and concrete microarchitecture, so results may not generalize to RISC-V @hennessy_computer_2011 
// 
// evaluation of risc-v hypervisor extensions in general:
//   - dom-v @park_beyond_2026
//   - gem5 implementation @fragkoulis_advancing_2024
//   - h v0.6.1 on rocket chip core @sa_first_2022

Unikernels have recently received increasing attention as lightweight virtualization solutions,
and initial efforts have explored their applicability on the RISC-V architecture.
Existing work has demonstrated the feasibility of running unikernels such as RustyHermit on
RISC-V systems, including execution on bare-metal hardware as well as in emulated or @FPGA#"-based"
environments @schoning_porting_2021 @ruppert-maas_systematische_2025.
However, these studies do not evaluate virtualized deployments making use of hardware-supported
hypervisor extensions, despite virtualization being a primary deployment scenario for many
unikernel-based systems.

Furthermore, current evaluations are predominantly conducted in emulation environments such as
@QEMU, which may not accurately reflect the performance characteristics of real hardware,
particularly with respect to interrupt handling, memory management, and virtualization overhead
@fuentes_morales_evaluating_2016.
In addition, prior work primarily relies on synthetic microbenchmarks rather than workloads
resembling realistic application scenarios.
While such benchmarks are useful for isolating specific system properties, their results may
not generalize to practical deployments if not carefully designed @sreenivasan_construction_1974.

In contrast, unikernels have been evaluated extensively on established architectures such as
x86 and ARM, including in virtualized environments using hardware-assisted virtualization
@madhavapeddy_unikernels_2013 @kuenzer_unikraft_2021 @hu_unishyper_2024.
However, performance characteristics of software systems depend on both the instruction set
architecture and the underlying microarchitectural implementation, and therefore cannot be
assumed to transfer across platforms @hennessy_computer_2011

Independent of unikernel research, several studies have investigated virtualization support for RISC-V
itself, including hardware implementations of the hypervisor extension @sa_first_2022,
simulator-level integration @fragkoulis_advancing_2024, and its use for memory isolation mechanisms
@park_beyond_2026.
While these works provide insights into architectural mechanisms and implementation aspects of the
RISC-V hypervisor extension, their evaluations focus on hardware behavior, microarchitectural
simulation, or security use cases rather than the performance of higher-level software systems such
as unikernels in realistic deployment scenarios.


= Approach

//- Welche Ideen haben Sie zur Lösung des Problems?
//- Mit welchen Schritten wird die Lösungsidee realisiert?
//  - Mit welchen Methoden der Informatik werden die intendierten Ergebnisse der Arbeit (s.#h(0pt)o.) erreicht?
//  - Warum sind diese angemessen, um die Ergebnisse mit der notwendigen Qualität zu erreichen?
//- Wie wird im Rahmen der Arbeit geprüft (validiert), ob die Ergebnisse korrekt sind, d.#h(0pt)h. das Problem tatsächlich lösen? Welche Unsicherheiten bleiben ggfs. als offene Fragen für Folgearbeiten bestehen?

// Idea:
// - evaluation of virtualized unikernels on RISC-V hardware with hypervisor extension support
// - primary test vehicle: rusty hermit on kvm on real hardware
// - compare with minimal linux and qemu-based virtualization to assess validity of emulated evaluations
// 
// Setup for expiermental evaluation:
// - deploy rusty hermit on kvm on real hardware
// - deploy minimal virtualized linux on kvm as baseline
// - deploy the same systems in qemu-based virtualization for comparative evaluation
// - if possible, deploy other unikernels such as unishyper or nanos for comparative evaluation
// 
// Measurement methodology:
// - define relevant performance metrics for execution performance, interrupt handling lantency, virtualiziation overhead
// - add instrumentation to trace relevant performance events at hypervisor, kernel, and userspace levels
// - use (and if needed enablement on risc-v) of existing tracing tools
// (e.g., perf, rftrace, kvmi, ...) to enable quantitative performance measurement and analysis
// - controlled experiment design to isolate performance relevant variables
//   - selection of appropriate timing source (cycle counter vs virtual timer)
//   - mitigation of noise through repeated measurements, core pinning, disabling of frequency scaling, etc
//   - warm-up vs steady-state performance
// 
// Workload specification
// - specify and implement reproducible synthetic benchmarks for cpu, memory, i/o and network performance
// - define and implement representative real workloads such as web server, database, etc.
// - where needed introduce targeted adjustments to hypervisor or kernel to enable reproducible and meaningful experiments
// 
// Aanalysis and interpretation:
// - comparitive analysis of performance characteristics across different deployment scenarios (real hw vs qemu, unikernel vs linux)
// - interpretation of observed performance characteristics 
// - identification of underlying causes of overheads and bottlenecks
// 
// Validation:
// - reproducibility and consistency of results through repeated experiments
// - cross-validation of results through comparison with qemu
// - contextualization of results through comparison with minimal virtualized linux and other unikernels where feasible
// 
// Limitations:
// - limited scability of available hardware (e..g restricted core count)
// - differences between v0.6 and v1.0 of the hypervisor extension may limit transferability of results to future hardware

The proposed approach consists of a systematic experimental evaluation of virtualized unikernels
on RISC-V hardware supporting the hypervisor extension.
The RustyHermit unikernel running under @KVM serves as the primary evaluation platform.
Its performance is compared with a minimal virtualized Linux system and corresponding deployments
in @QEMU#"-based" virtualization environments in order to assess the representativeness of
emulation-based evaluations.

Relevant performance metrics, including execution performance, interrupt handling latency,
and virtualization overhead, are defined and measured using instrumentation at hypervisor,
kernel, and user-space levels. Existing tracing tools (e.g. perf, rftrace or @KVM-VMI) are employed
to enable quantitative performance analysis.
Controlled experiment design is applied to isolate performance-relevant variables, including the
selection of appropriate timing sources, mitigation of measurement noise through repeated
measurements and core pinning, and separation of system warm-up and steady-state execution phases.

Reproducible synthetic benchmarks for cpu, memory, i/o, and network performance are complemented by
representative application workloads such as web server or database scenarios.
Where necessary, limited, targeted adjustments to the hypervisor or kernel are introduced to enable
reproducible and meaningful experiments.
Measurement results are comparatively analyzed across different deployment scenarios
(e.g., real hardware vs. @QEMU, unikernel vs. Linux) in order to assess performance characteristics
under virtualization.
Reproducibility across repeated experiments and baseline comparisons with a minimal virtualized
Linux system are used to support the interpretation of observed results.

Potential limitations arise from restricted hardware scalability (e.g., limited core count),
which constrains the evaluation of parallelism and scalability.
Differences between currently available boards supporting the RISC-V hypervisor extension draft
version 0.6 @eswin_eic7700x_2024 and future implementations of the ratified version
1.0 @noauthor_risc-v_2025 may limit the transferability of results to subsequent hardware platforms.


= Preliminary Outline

//- Gliederungsvorschlag (Kapitel und Abschnitte mit Stichworten für geplante Inhalte), der die Ergebnisse Ihres Vorgehens als Lösung der Aufgabenstellung (Problem, Ziel der Arbeit) nachvollziehbar und begründet darstellt.

Abstract

Table of Contents

+ Introduction
  + Motivation
  + Problem Statement
  + Objectives

+ Fundamentals
  + Unikernel Architecture
      @tanenbaum_modern_2014
      @madhavapeddy_unikernels_2013 @bratterud_includeos_2015 @madhavapeddy_unikernels_2013-1
      @lankes_hermit_2025 @lankes_hermitcore_2016 @lankes_exploring_2019
    - General OS architecture concepts
    - Unikernel design principles
    - RustyHermit overview
  + Virtualization Concepts
    @tanenbaum_modern_2014 @smith_virtual_2010
    @whitaker_scale_2002 @russell_virtio_2008
    @kivity_kvm_2007 @bellard_qemu_2005 @dall_kvmarm_2014
    - Process vs System VMs
    - Virtualization vs Emulation
    - VM exits and traps
    - Interrupt virtualization
    - Address translation and memory management
    - Hardware-assisted virtualization
    - Paravirtualization, Virtio
    - @QEMU / @KVM overview

+ Architectural Background
  @scheffel_simulation_2018 @fragkoulis_advancing_2024 @noauthor_risc-v_2025 @sa_first_2022
  @park_beyond_2026 @eswin_eic7700x_2024
  + RISC-V Architecture
    - Privilege levels (M, S, U)
    - Trap handling
    - Interrupt delegation
    - @SBI
    - Single Stage Address Translation
  + RISC-V Hypervisor Extension
    - Hypervisor execution modes (HS, VS)
    - Guest context management
    - Two-stage address translation
    - Virtual interrupt handling
    - VM entry and exit mechanisms
    - Timer virtualization
    - Differences draft v0.6 vs ratified v1.0
    - Availability of hardware implementations

+ Evaluation Methodology
    @sreenivasan_construction_1974 @mytkowicz_producing_2009 @georges_statistically_2007
  + Evaluation objectives
    - Performance characteristics to be measured:
      execution performance, interrupt latency, i/o performance, network performance,
      resource usage, virtualization overhead
  + Evaluation scenarios
    - RustyHermit on @KVM on real hardware
    - Minimal virtualized Linux on @KVM on real hardware (baseline)
    - RustyHermit in @QEMU#"-based" virtualization
    - Minimal virtualized Linux in @QEMU#"-based" virtualization
    - If feasible: other unikernels (e.g., unishyper, nanos) in similar scenarios
  + Workloads
    - Synthetic benchmarks for cpu, memory, i/o, and network performance
    - Representative application workloads (e.g., web server, database)
  + Measurement strategy
    - Instrumentation levels: hypervisor, kernel, user-space
    - Tracing tools
    - Timing sources and measurement techniques
  + Experiment Design
    - Noise reduction techniques: Core pinning, disabling frequency scaling,
      warm-up vs steady-state performance, repetition and statistical analysis
  + Data Analysis
    - Comparative analysis across deployment scenarios
    - Aggregation and visualization of results
  + Validity 
    - Reproducibility and consistency checks
  + Limitations
    - Hardware scalability
    - Hypervisor extension version differences

+ Implementation
  - Software artifacts supporting the evaluation
  - Instrumentation of hypervisor, kernel, and user-space programs
  - Benchmark implementation
  - Hardware and software configuration and deployment details

+ Evaluation Results
  - Execution performance results
  - Interrupt handling latency results
  - I/O performance results
  - Network performance results
  - Resource usage results
  - Virtualization overhead results
  - Comparision across deployment scenarios

+ Discussion
  - Interpretation of observed performance characteristics
  - Identification of architecture-specific performance effects and bottlenecks
  - Implications for the design and deployment of unikernels on RISC-V hardware
  - Comparative analysis with baseline system and potential other unikernels
  - Impact of methodical choices on results
  - Relation to existing work

+ Conclusion
  - Summary of findings
  - Relation to objectives and problem statement

+ Outlook
  - Open questions
  - Future work

List of Figures

List of Tables

Acronyms

Bibliography

Appendix


= Work Plan

//- Abfolge der notwendigen Schritte inkl. Erstellung der jeweiligen Kapitel der Arbeit
//- Meilensteine von Anmeldung bis Abgabe der Arbeit
Total time: 6 months = 24 weeks

Week 1-4: Literature review completed
- Review of related work
- Refinement of problem statement and objectives
- Draft of chapter 1 (Introduction)
- Outline for chapter 2 (Fundamentals)
- Outline for chapter 3 (Architectural Background)

Week 5-8: Evaluation methodology finalized
- Draft of chapter 2 (Fundamentals)
- Draft of chapter 3 (Architectural Background)
- Specification of workloads and benchmarks

Week 9-12: Functional experimental setup
- Setup of experimental environment
- Instrumentation
- Debugging
- Draft of chapter 4 (Evaluation Methodology)

Week 13-16: Measurments completed
- Execution of measurements
- Refinement of setup
- Preliminary analysis of results
- Outline for chapter 5 (Implementation)

Week 17-20: Analysis completed
- Finalization of evaluation and data analysis
- Chapter 5 (Implementation)
- Chapter 6 (Evaluation Results)
- Chapter 7 (Discussion)

Week 21-24: Thesis writing completed
- Chapter 8 (Conclusion)
- Chapter 9 (Outlook)
- Abstract

Week 23-24: Thesis submitted
- Review, Finalization
- Buffer




//= References
//- relevante Literaturquellen, hier im Exposé an den geeigneten Stellen referenziert
//- Zitierweise gemäß der Mustervorlage für Abschlussarbeiten

#bibliography("library.bib", title: "References")
