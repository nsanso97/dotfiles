---
name: gnome-screenshot
description: Take a screenshot on a GNOME/Wayland Linux desktop (tested on Fedora, GNOME Shell 45+) via the xdg-desktop-portal D-Bus API, with the user picking the window/area each time. Use this whenever you need to visually verify a GUI app, check rendering output, debug a graphical bug, or otherwise "look at" what's on screen on a Linux GNOME session — especially when other screenshot tools (ImageMagick's import, grim, scrot) aren't available or are blocked. Also documents why xdotool/ydotool/gnome-shell Eval/Introspect were deliberately ruled out, so don't re-suggest them without re-reading the "Why not" section first.
---

# GNOME screenshot via xdg-desktop-portal

## Quick use

```bash
bash ~/.claude/skills/gnome-screenshot/scripts/screenshot.sh
```

This triggers GNOME's screenshot picker (tell the user to pick a window/area when it appears), waits for the resulting file, and prints its path on stdout. Then `Read` that path directly — the Read tool renders images inline.

First-ever call on a machine shows a one-time GNOME permission dialog ("Allow screenshot?"); the user needs to accept it once. After that, no further permission prompts — only the picker itself, every time (see "Why interactive-only" below).

## Why this approach, not the alternatives

This was worked out through a real debugging session (see the moonlight project's conversation history for the full trace) on Fedora + GNOME Shell 49.8 + Wayland/Mutter. In rough chronological order, here's what was tried and ruled out — **read this before re-suggesting any of these**, they were rejected for specific reasons, not just because they didn't immediately work:

- **`org.gnome.Shell.Screenshot` D-Bus interface directly** (`ScreenshotWindow`, `Screenshot`, etc.) — returns `AccessDenied`. GNOME 45+ locked this down; it's no longer callable by arbitrary session clients.
- **ImageMagick's `import`/`magick import`** — fails with a confusing generic error ("missing an image filename" despite a filename being given). Root cause: `/etc/ImageMagick*/policy.xml` had a blanket `<policy domain="coder" rights="none" pattern="*" />` with only `{GIF,JPEG,PNG,WEBP}` allowlisted — the `X` coder (X11/XWayland display grab) is blocked. This looked like a deliberate hardening profile (ImageMagick has a real CVE history via coders/delegates — the "ImageTragick" family), so **don't suggest loosening this policy** to fix it. Note: PNG-to-PNG operations (e.g. cropping an already-captured screenshot with `magick in.png -crop WxH+X+Y out.png`) still work fine, since that only touches the allowlisted PNG coder.
- **`xdotool`** — only sees XWayland-backed windows under native Wayland, can't do compositor-level resize/move on Mutter. Unreliable here.
- **`wtype`** — depends on wlroots' virtual-keyboard protocol, which **Mutter doesn't implement**. Dead end specifically on GNOME (works on Sway/wlroots compositors).
- **`ydotool`** — technically works (injects via kernel `uinput`, compositor-agnostic), but the user explicitly decided this was **too much access to grant** (arbitrary synthetic keyboard/mouse input is a much bigger trust surface than "let Claude see the screen") and uninstalled it. Don't re-suggest it without the user raising it first.
- **`org.gnome.Shell.Introspect.GetWindows()`** — would have given window geometry for precise cropping to just an app's window, without any input-injection risk. Also returns `AccessDenied`. Investigated thoroughly: this is **not a grantable permission** — GNOME Shell hardcodes the allowed callers to `xdg-desktop-portal-gnome` itself, or requires Shell-wide "unsafe mode" (which also unlocks `Eval()` — arbitrary JavaScript execution in the Shell process, full desktop control). There is no scoped middle ground. Confirmed via GNOME's own gitlab/discourse threads, not just the empirical `AccessDenied`. **Don't suggest enabling unsafe mode** — it grants far more than the user asked for.
- **`org.freedesktop.portal.Screenshot` non-interactive** (`interactive: false`) — works with zero prompts after the first grant, but only captures the *entire screen* (all monitors), with no way to target a specific window (the portal only exposes `Screenshot` and `PickColor`, nothing window-scoped).

**Landed on**: `org.freedesktop.portal.Screenshot` with `interactive: true`. This opens GNOME's own screenshot picker UI (choose a window / a region / the whole screen), so the user selects the target each time. Slower than full automation, but it's the actual ceiling of what's achievable at the access level the user was comfortable granting — every alternative that could avoid the per-shot click either required broader/riskier access (unsafe mode, input injection) or isn't exposed at all in current GNOME.

## Why interactive every time, not just once

The screenshot portal is designed to re-prompt for consent on every call by default — unlike file-picker-style portals that remember a grant. That's *separate* from why we use `interactive: true`: even with `interactive: false` (which does NOT re-prompt after the first grant), there's still no way to target just one window. So `interactive: true` isn't chosen to satisfy a re-consent requirement — it's chosen because the picker is the only window-targeting mechanism that exists at all.

## Mechanics, if extending this

- The `Screenshot()` D-Bus method returns a request handle immediately (async pattern) and the actual result arrives later via a `Response` signal — but in practice it's simpler to just poll `~/Pictures/` and `~/Pictures/Screenshots/` for a new `Screenshot*.png` file (what `scripts/screenshot.sh` does), rather than wiring up `gdbus monitor` to catch the signal.
- GNOME's default save location changed between versions/configs — this system had files show up directly in `~/Pictures/` in some cases and in `~/Pictures/Screenshots/` in others. The script checks both.
- To verify this API surface is actually available on a new machine before relying on it:
  ```bash
  gdbus introspect --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop | grep -A 10 "interface org.freedesktop.portal.Screenshot"
  ```
- This is GNOME/Mutter-specific. KDE (Plasma), other Wayland compositors, and X11-only sessions will need a different approach entirely (KDE has its own portal backend with the same `org.freedesktop.portal.Screenshot` interface, so this *might* transfer — untested).
