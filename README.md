[![Build](https://github.com/EinstokFair/sciafpad/actions/workflows/build.yml/badge.svg)](https://github.com/EinstokFair/sciafpad/actions/workflows/build.yml)

# sciafpad

Минималистичный текстовый редактор на GTK4, использующий движок
[Scintilla](https://www.scintilla.org/), а именно порт
[bugaevc/scintilla](https://github.com/bugaevc/scintilla) под GTK4.

Цель — быть таким же простым, как Leafpad, но использовать Scintilla в
качестве движка редактирования вместо `GtkTextView`. Без подсветки
синтаксиса, без плагинов — просто текстовый редактор.

## Возможности

- Нативный интерфейс GTK4
- Виджет редактирования на основе Scintilla
- Открыть / Сохранить / Сохранить как (через `GtkFileDialog`)
- Отменить / Повторить / Вырезать / Копировать / Вставить (через сообщения `SCI_*`)
- Заголовок окна отражает имя текущего файла
- Диалог «О программе»

## Зависимости

- Компилятор C++17 (рекомендуется GCC 14+)
- GTK 4.10 или новее
- Порт `bugaevc/scintilla` под GTK4, собранный и установленный

### Сборка `bugaevc/scintilla`

Если у вас ещё нет `libscintilla.so`:

    git clone https://github.com/bugaevc/scintilla.git
    cd scintilla/gtk4
    make demo

В результате появится `libscintilla.so` в `scintilla/bin/`.

## Сборка

Используется Autotools:

    ./autogen.sh
    ./configure
    make

Запуск:

    ./sciafpad

## Параметры конфигурации

Если `bugaevc/scintilla` находится не в `$HOME/cpp/scintilla/bugaevc`,
передайте путь:

    ./configure SCINTILLA_ROOT=/path/to/scintilla

## Установка

    make install

По умолчанию устанавливается в `/usr/local`. Используйте `--prefix`, чтобы изменить:

    ./configure --prefix=$HOME/.local

## Лицензия

GPL-3.0-or-later. Подробности в `COPYING`.

## Пакеты

- [Gentoo](GENTOO.md) — включён ebuild, инструкция для local overlay
- [Debian/Ubuntu](DEBIAN.md) — включён каталог debian/

## Документация

Документация API доступна по адресу
<https://einstokfair.github.io/sciafpad/v/0.3.8.1/>.
