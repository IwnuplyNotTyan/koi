<div align="center">
  <h1>🎏 ~ Koi</h1>
  <p>Simple .md Reader</p>
</div>

<p align="center">
  <a href="https://github.com/IwnuplyNotTyan/koi/actions/workflows/ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/IwnuplyNotTyan/koi/ci.yml" alt="Build Status"/>
  </a>
  <img src="https://img.shields.io/github/license/IwnuplyNotTyan/koi" alt="License"/>
  <img src="https://img.shields.io/github/stars/IwnuplyNotTyan/koi" alt="Stars"/>
  <img src="https://img.shields.io/github/last-commit/IwnuplyNotTyan/koi" alt="Last Commit"/>
</p>

<p align="center">
  <img src="https://github.com/IwnuplyNotTyan/Koi/blob/main/.github/assets/logo.png?raw=true" alt="Logo" width="150">
</p>

---

<p align="center">
  <img src="https://github.com/IwnuplyNotTyan/Koi/blob/main/.github/assets/screenshot.png?raw=true" alt="Screenshot">
</p>

``` bash
koi <example.md>
echo "*Markdown suck*" | koi
```

# ⚙️ Setting
```bash
export KOI_DEFAULT_THEME=dark
```
*All default theme: dark, light, notty, pink, tokyo-night or dracula*

---

# 🛠️ Install

## ❄️ Nix
``` bash
nix run github:iwnuplynottyan/koi
```

<details>
<summary><b>Home Manager</b></summary>

**flake.nix**
```nix
{
  inputs = {
    koi.url = "github:IwnuplyNotTyan/koi";
    # ...rest of inputs
  };

  outputs = { koi, home-manager, nixpkgs, ... } @ inputs: {
    homeConfigurations."user@hostname" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        koi.homeManagerModules.default
        ./home.nix
      ];
    };
  };
}
```

**home.nix**
```nix
{
  programs.koi = {
    enable = true;
    theme = "dracula"; # dark | light | notty | dracula | pink | tokyo-night
    nerd = false;
    mosaic = true;
    badges = true;
  };
}
```

</details>

## 💋 Arch
``` bash
makepkg -si
```

## ⛏️ Build from source
``` bash
go mod download
go build -o koi main.go
```

---

## 📚 Libraries Used
- [Glamoured](https://github.com/iwnuplynottyan/glamoured) — Markdown render, fork of [Glamour](https://github.com/charmbracelet/glamour) 
- [Logs](https://github.com/charmbracelet/log) — Pretty logs
- [Cobra](https://github.com/spf13/cobra) — Powerfull flags
    - [Fang](https://github.com/charmbracelet/fang) —  Make it pretty

---

## 📄 License
[MIT](https://github.com/IwnuplyNotTyan/Koi/blob/main/LICENSE).

---

<div align="center">
  <h1>Made with ❤️ </h1>
</div>
