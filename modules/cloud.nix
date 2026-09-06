# modules/cloud-tools.nix
{
  flake.homeModules.cloudTools = { pkgs, ... }: {
    home.packages = with pkgs; [
      # cloud CLIs
      awscli2
      aws-vault
      azure-cli
      google-cloud-sdk

      # kubernetes / gitops
      kubectl
      kubernetes-helm
      k9s
      kubectx
      stern
      kustomize
      argocd
      eksctl

      # iac
      opentofu
      terraform-ls
      terragrunt
      terraform-docs
      tflint
      infracost

      # language runtimes
      python3
      go
      nodejs
    ];
  };
}
