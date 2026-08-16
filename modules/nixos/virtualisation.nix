{ lib, config, pkgs, ... }:

let
  cfg = config.custom.virtualisation;
in
{
  options.custom.virtualisation.enable = lib.mkEnableOption "libvirt/QEMU-KVM virtualization with virt-manager";

  config = lib.mkIf cfg.enable {
    # QEMU/KVM + libvirt daemon
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;          # virtual TPM, needed for Windows 11 guests
        ovmf = {
          enable = true;              # UEFI firmware for guests
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };

    # SPICE guest/host clipboard + USB redirection support
    virtualisation.spiceUSBRedirection.enable = true;

    # GUI manager + supporting tools
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio      # virtio drivers iso, handy for Windows guests
    ];

    # Let virt-manager find guests without manual URI config
    programs.virt-manager.enable = true;

    # Needed so the primary user can manage VMs without sudo
    users.users.${config.hostSettings.primaryUser}.extraGroups = [
      "libvirtd"
      "kvm"
    ];

    # Enable nested virtualization (run a VM inside a VM, useful for testing)
    boot.extraModprobeConfig = "options kvm_intel nested=1";
  };
}
