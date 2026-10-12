# How to release a new version {#howto-release-en}

This document describes how to release a new version of sciafpad.

## 1. Prepare the repository

    git checkout main
    git pull origin main
    git status

## 2. Bump the version

The version is declared in two places. Update both at the same time.

### 2.1. `configure.ac`

Change the version argument of `AC_INIT`:

    AC_INIT([sciafpad], [<X.Y.Z>], [you@example.com])

### 2.2. `README.md`

Update the link to the API documentation:

    <https://einstokfair.github.io/sciafpad/v/0.3.8.1/>

## 3. Regenerate Autotools infrastructure

    rm -rf autom4te.cache aclocal.m4 configure Makefile.in m4 po/Makefile.in.in po/stamp-po
    cp /usr/share/gettext/po/Makefile.in.in po/Makefile.in.in
    aclocal -I m4
    autoconf
    automake --add-missing --copy
    cp /usr/share/gettext/po/*.sed po/
    cp /usr/share/gettext/po/*.header po/
    cp /usr/share/gettext/po/Rules-quot po/
    cp /usr/share/gettext/po/Makevars.template po/

**Note:** do not run `autoreconf -fi`. It calls `autopoint`, which overwrites
`po/Makefile.in.in` with an older version and causes a gettext infrastructure
mismatch.

## 4. Build the tarball

    cd build/autotools
    rm -rf po Makefile config.status sciafpad-*
    ../../configure --with-scintilla=/path/to/scintilla
    make dist
    ls -la *.tar.xz

Expected result: `sciafpad-<X.Y.Z>.tar.xz`.

## 5. Commit and push

    git add README.md configure.ac
    git status
    git commit -m "Bump version to 0.3.8.1; update README link"
    git push

## 6. Create the tag and the release

    git tag v<X.Y.Z>
    git push origin v<X.Y.Z>

    gh release create v<X.Y.Z> \
      --title "sciafpad 0.3.8.1" \
      --notes "A minimal GTK4 text editor built on Scintilla (bugaevc GTK4 port)."

    cd build/autotools
    gh release upload v<X.Y.Z> sciafpad-<X.Y.Z>.tar.xz

## 7. Verify the documentation

The `Deploy docs` workflow runs automatically on a tag.

    gh run list --limit 5

After one or two minutes:

    curl -sI https://einstokfair.github.io/sciafpad/v/0.3.8.1/ | head -3

## 8. Verify the release

    gh release view v<X.Y.Z>

## Tag naming rules

- Format: `v<major>.<minor>.<patch>` — for example, `v0.3.8.1`.
- Suffixes are allowed: `v<X.Y.Z>-rc1`, `v<X.Y.Z>-p17`.
- Double dash is forbidden: `v<X.Y.Z>--x` will fail.
- Without the `v` prefix — will fail: `<X.Y.Z>` does not match.

## If a version is broken

1. Bump the version again (`<X.Y.Z>` → `<X.Y.Z+1>`).
2. Repeat steps 1–8.
3. Delete the broken tag:

       git tag -d v<X.Y.Z>
       git push origin --delete v<X.Y.Z>
       gh release delete v<X.Y.Z> --yes

4. Remove the broken documentation from `gh-pages`:

       git checkout gh-pages
       git pull --rebase origin gh-pages
       git rm -r v/0.3.8
       git commit -m "Remove docs for broken v<X.Y.Z>"
       git push origin gh-pages
       git checkout main

## If gettext infrastructure mismatch occurs

Error message:

    *** error: gettext infrastructure mismatch: using a Makefile.in.in from gettext version 0.20
        but the autoconf macros are from gettext version 0.22

Cause: `po/Makefile.in.in` is an old version. Fix:

    rm -f po/Makefile.in.in
    cp /usr/share/gettext/po/Makefile.in.in po/Makefile.in.in
    grep "GETTEXT_MACRO_VERSION = " po/Makefile.in.in | head -1

Expected result: `GETTEXT_MACRO_VERSION = 0.22`.

And **do not** run `autoreconf -fi` — it calls `autopoint`, which overwrites
`po/Makefile.in.in` with an older version. Instead, run `aclocal -I m4`,
`autoconf`, `automake --add-missing --copy`.
