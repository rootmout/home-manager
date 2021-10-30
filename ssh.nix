{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
      IdentityFile ~/.ssh/yubikey.pub

      Host sw-core
        ProxyJump gate
        User manager
        Hostname 192.168.200.240
        Ciphers 3des-cbc
        KexAlgorithms diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1

      # Gits
      # usage: ssh root@git
      Host git
          Hostname git.cri.epita.fr
          User rootmout

      # Jump par la gate du CRI (fw-1.gate.cri.epita.fr)
      # usage: ssh root@gate
      Host gate
        Hostname fw-1.gate.cri.epita.fr
        User root

      Host *.cri
        User root
        ProxyJump gate
        Hostname %h.epita.fr

      #
      # ProxyJump pour les zones DNS internes
      #

      # PIE et Lab CRI
      # usage: ssh root@HOSTNAME.pie.cri.epita.fr
      # usage: ssh root@HOSTNAME.lab.cri.epita.fr
      Host *.epita.fr
        ProxyJump gate
        User root

      # Lab assistant
      # usage: ssh root@HOSTNAME.lab.assistants
      Host *.lab.assistants
        Hostname %h.epita.fr
        ProxyJump gate-assistants

      # Zone acu, interne CRI, pie, SMs et assistants
      # usage: root@HOSTNAME.acu / root@HOSTNAME.int / root@HOSTNAME.pie
      # usage: root@HOSTNAME.sm / root@HOSTNAME.assistants
      Host *.acu *.int *.pie *.sm *.assistants
        Hostname %h.cri.epita.net
        ProxyJump gate-2

      # Ceph, lab CRI, zone srv CRI
      # usage: root@HOSTNAME.ceph / root@HOSTNAME.lab
      Host *.ceph *.lab *srv
        Hostname %h.cri.epita.fr
        ProxyJump gate-2


      Host *.k8s.assistants
        User ubuntu
        Hostname %h.epita.fr
        ProxyJump gate-k8s

      Host gate-k8s
        Hostname gate-k8s-assistants
        User root
        ProxyJump gate-1

      # Pour le deploiement en prod de scrooge
      Host scrooge-prod1
        Hostname scrooge-1
        ProxyJump gate-1
        User root

    '';
  };
}
