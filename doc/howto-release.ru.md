# Как выпустить новую версию {#howto-release-ru}

Этот документ описывает, как выпустить новую версию sciafpad.

## 1. Подготовка репозитория

    git checkout main
    git pull origin main
    git status

## 2. Поднять версию

Версия объявлена в двух местах. Обновить оба одновременно.

### 2.1. `configure.ac`

Изменить аргумент версии в `AC_INIT`:

    AC_INIT([sciafpad], [0.4.0], [you@example.com])

### 2.2. `README.md`

Обновить ссылку на документацию API:

    <https://einstokfair.github.io/sciafpad/v/0.4.0/>

## 3. Пересобрать инфраструктуру Autotools

    rm -rf autom4te.cache aclocal.m4 configure Makefile.in m4 po/Makefile.in.in po/stamp-po
    cp /usr/share/gettext/po/Makefile.in.in po/Makefile.in.in
    aclocal -I m4
    autoconf
    automake --add-missing --copy
    cp /usr/share/gettext/po/*.sed po/
    cp /usr/share/gettext/po/*.header po/
    cp /usr/share/gettext/po/Rules-quot po/
    cp /usr/share/gettext/po/Makevars.template po/

**Внимание:** не запускать `autoreconf -fi`. Он вызывает `autopoint`,
который перезаписывает `po/Makefile.in.in` старой версией и приводит к
gettext infrastructure mismatch.

## 4. Собрать tarball

    cd build/autotools
    rm -rf po Makefile config.status sciafpad-*
    ../../configure --with-scintilla=/path/to/scintilla
    make dist
    ls -la *.tar.xz

Ожидаемый результат: `sciafpad-0.4.0.tar.xz`.

## 5. Коммит и push

    git add README.md configure.ac
    git status
    git commit -m "Bump version to 0.4.0; update README link"
    git push

## 6. Создать тег и релиз

    git tag v0.4.0
    git push origin v0.4.0

    gh release create v0.4.0 \
      --title "sciafpad 0.4.0" \
      --notes "A minimal GTK4 text editor built on Scintilla (bugaevc GTK4 port)."

    cd build/autotools
    gh release upload v0.4.0 sciafpad-0.4.0.tar.xz

## 7. Проверить документацию

Workflow `Deploy docs` запускается автоматически на тег.

    gh run list --limit 5

Через одну-две минуты:

    curl -sI https://einstokfair.github.io/sciafpad/v/0.4.0/ | head -3

## 8. Проверить релиз

    gh release view v0.4.0

## Правила именования тегов

- Формат: `v<major>.<minor>.<patch>` — например, `v0.4.0`, `v1.0.0`.
- Суффиксы разрешены: `v0.4.0-rc1`, `v0.4.0-p17`.
- Двойной дефис запрещён: `v0.4.0--x` упадёт.
- Без префикса `v` — упадёт: `0.4.0` не подходит.

## Если версия сломана

1. Поднять версию ещё раз (`0.4.0` → `0.4.1`).
2. Пройти шаги 1–8.
3. Удалить битый тег:

       git tag -d v0.4.0
       git push origin --delete v0.4.0
       gh release delete v0.4.0 --yes

4. Удалить битую документацию из `gh-pages`:

       git checkout gh-pages
       git pull --rebase origin gh-pages
       git rm -r v/0.4.0
       git commit -m "Remove docs for broken v0.4.0"
       git push origin gh-pages
       git checkout main

## Если возникла ошибка gettext infrastructure mismatch

Сообщение об ошибке:

    *** error: gettext infrastructure mismatch: using a Makefile.in.in from gettext version 0.20
        but the autoconf macros are from gettext version 0.22

Причина: `po/Makefile.in.in` — старой версии. Исправление:

    rm -f po/Makefile.in.in
    cp /usr/share/gettext/po/Makefile.in.in po/Makefile.in.in
    grep "GETTEXT_MACRO_VERSION = " po/Makefile.in.in | head -1

Ожидаемый результат: `GETTEXT_MACRO_VERSION = 0.22`.

И **не** запускать `autoreconf -fi` — он вызывает `autopoint`, который
перезаписывает `po/Makefile.in.in` старой версией. Вместо этого —
`aclocal -I m4`, `autoconf`, `automake --add-missing --copy`.
