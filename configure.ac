AC_INIT([sciafpad], [0.1], [you@example.com])
AM_INIT_AUTOMAKE([foreign subdir-objects dist-xz no-dist-gzip])
AC_PROG_CC
AC_PROG_CXX
AC_LANG([C++])

PKG_CHECK_MODULES([GTK4], [gtk4 >= 4.10])

# Путь к bugaevc/scintilla
AC_ARG_VAR([SCINTILLA_ROOT], [Path to bugaevc/scintilla])
AS_IF([test -z "$SCINTILLA_ROOT"], [SCINTILLA_ROOT="$HOME/cpp/scintilla/bugaevc"])

AC_SUBST([SCINTILLA_ROOT])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
