= Evaluation Methodology

// Outline:
// - Evaluation objectives
//   - Performance characteristics to be measured: execution performance,
//     interrupt latency, I/O performance, network performance, resource usage,
//     virtualization overhead
// - Evaluation scenarios
//   - RustyHermit on KVM on real hardware
//   - Minimal virtualized Linux on KVM on real hardware (baseline)
//   - RustyHermit in QEMU-based virtualization
//   - Minimal virtualized Linux in QEMU-based virtualization
//   - If feasible: other unikernels (e.g., unishyper, nanos) in similar scenarios
// - Workloads
//   - Synthetic benchmarks for CPU, memory, I/O, and network performance
//   - Representative application workloads (e.g., web server, database)
// - Measurement strategy
//   - Instrumentation levels: hypervisor, kernel, user space
//   - Tracing tools
//   - Timing sources and measurement techniques
// - Experiment design
//   - Noise reduction techniques: core pinning, disabling frequency scaling,
//     warm-up vs steady-state performance, repetition and statistical analysis
// - Data analysis
//   - Comparative analysis across deployment scenarios
//   - Aggregation and visualization of results
// - Validity
//   - Reproducibility and consistency checks
// - Limitations
//   - Hardware scalability
//   - Hypervisor extension version differences

TODO
