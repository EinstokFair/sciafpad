AC_INIT([sciafpad], [0.3.4], [you@example.com])
AM_INIT_AUTOMAKE([foreign subdir-objects dist-xz no-dist-gzip])
AC_PROG_CC
AC_PROG_CXX
AC_LANG([C++])

# i18n: source language is Russian, translations via .po files
AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.21])

PKG_CHECK_MODULES([GTK4], [gtk4 >= 4.10])
PKG_CHECK_MODULES([SCINTILLA], [scintilla-gtk4-bugaevc])

AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE], ["$PACKAGE"], [Gettext package name])

AC_CONFIG_FILES([
    Makefile
    po/Makefile.in
])
AC_OUTPUT
