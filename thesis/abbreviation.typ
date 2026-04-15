#import "@preview/abbr:0.3.0"

#show: abbr.show-rule
#abbr.config(style: it => it)

#abbr.make(
  ("FPGA", "Field-Programmable Gate Array"),
  ("KVM", "Kernel-based Virtual Machine"),
  ("KVM-VMI", "KVM Virtual Machine Introspection"),
  ("QEMU", "Quick Emulator"),
  ("SBI", "Supervisor Binary Interface"),
  ("VM", "Virtual Machine"),
  ("HS", "Hypervisor Supervisor mode"),
  ("VS", "Virtual Supervisor mode"),
)

#let render_acronyms_list = () => {
  abbr.list()
}
