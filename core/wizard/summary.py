"""
Terminal summary and environment generation for the Dotfiles Installer Wizard.
Eliminates duplicate inline Python and multiple subshells in bootstrap.sh.
"""

import json
import shlex
import sys
import textwrap


def format_summary(data):
    """
    Formats selected packages, apps, and macOS defaults into a clean terminal report.
    """
    pkgs_and_apps = data.get("packages_and_apps", [])
    if not pkgs_and_apps:
        pkgs_and_apps = data.get("packages", [])

    macos = data.get("macos", {})
    total_enabled = 0
    total_disabled = 0
    for funcs in macos.values():
        for f in funcs:
            if f.endswith("=false"):
                total_disabled += 1
            else:
                total_enabled += 1
    total_mac_funcs = total_enabled + total_disabled

    lines = []
    lines.append("\033[1;36m==> Selected Configuration:\033[0m")

    if not pkgs_and_apps and not total_mac_funcs:
        lines.append("  \033[33m(No components selected - skipping installation)\033[0m")
    else:
        if pkgs_and_apps:
            lines.append(f"  \033[1;32m● Packages & Apps\033[0m ({len(pkgs_and_apps)}):")
            lines.append(
                textwrap.fill(
                    "    " + ", ".join(sorted(pkgs_and_apps, key=str.lower)),
                    width=76,
                    subsequent_indent="    ",
                )
            )
        if total_mac_funcs > 0:
            if total_disabled > 0:
                lines.append(
                    f"  \033[1;32m● macOS Defaults\033[0m ({total_enabled} to enable, \033[33m{total_disabled} to disable\033[0m):"
                )
            else:
                lines.append(f"  \033[1;32m● macOS Defaults\033[0m ({total_mac_funcs} settings):")

            for cat, funcs in sorted(macos.items()):
                if not funcs:
                    continue
                enabled_clean = []
                disabled_clean = []
                for f in funcs:
                    is_dis = f.endswith("=false")
                    fn_name = f.split("=")[0]
                    clean_name = (
                        fn_name[len(cat) + 1 :].replace("_", " ").title()
                        if fn_name.startswith(cat + "_")
                        else fn_name.replace("_", " ").title()
                    )
                    if is_dis:
                        disabled_clean.append(clean_name)
                    else:
                        enabled_clean.append(clean_name)

                cat_title = "UI" if cat.lower() == "ui" else cat.title()
                lines.append(f"    \033[1;33m{cat_title}:\033[0m")
                if enabled_clean:
                    en_str = ", ".join(sorted(enabled_clean, key=str.lower))
                    prefix = "      \033[32m✓ Enable:\033[0m " if disabled_clean else "      "
                    lines.append(textwrap.fill(prefix + en_str, width=76, subsequent_indent="        "))
                if disabled_clean:
                    dis_str = ", ".join(sorted(disabled_clean, key=str.lower))
                    lines.append(textwrap.fill(f"      \033[31m✗ Disable:\033[0m {dis_str}", width=76, subsequent_indent="        "))

    return "\n".join(lines)


def print_summary(json_path):
    with open(json_path, "r", errors="ignore") as f:
        data = json.load(f)
    print()
    print(format_summary(data))
    print()


def export_bash_env(json_path):
    """
    Emits bash-evaluable array definitions from the wizard output JSON.
    """
    with open(json_path, "r", errors="ignore") as f:
        data = json.load(f)

    pkgs = data.get("packages", [])
    macos_cats = data.get("macos_categories", [])
    brew = data.get("brew", [])

    pkgs_str = " ".join(shlex.quote(str(p)) for p in pkgs)
    macos_str = " ".join(shlex.quote(str(c)) for c in macos_cats)
    brew_str = " ".join(shlex.quote(str(b)) for b in brew)

    print(f"chosen_packages=({pkgs_str})")
    print(f"chosen_macos_defaults=({macos_str})")
    print(f"chosen_brew=({brew_str})")


def export_cat_funcs(json_path, category):
    with open(json_path, "r", errors="ignore") as f:
        data = json.load(f)
    funcs = data.get("macos", {}).get(category, [])
    if funcs:
        print("\n".join(funcs))


def main():
    if len(sys.argv) < 2:
        return 1

    mode = sys.argv[1]
    if mode == "--env" and len(sys.argv) > 2:
        export_bash_env(sys.argv[2])
    elif mode == "--print" and len(sys.argv) > 2:
        print_summary(sys.argv[2])
    elif mode == "--cat-funcs" and len(sys.argv) > 3:
        export_cat_funcs(sys.argv[2], sys.argv[3])
    elif len(sys.argv) == 2:
        print_summary(sys.argv[1])
    return 0


if __name__ == "__main__":
    sys.exit(main())
