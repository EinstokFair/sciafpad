#include "config.h"
#include "about.h"
#include <glib/gi18n.h>

void show_about(GtkWindow* parent) {
    GtkWidget* about = gtk_about_dialog_new();
    gtk_about_dialog_set_program_name(GTK_ABOUT_DIALOG(about), _("sciafpad"));
    gtk_about_dialog_set_version(GTK_ABOUT_DIALOG(about), PACKAGE_VERSION);
    gtk_about_dialog_set_comments(GTK_ABOUT_DIALOG(about),
        _("Простой текстовый редактор на GTK4 + Scintilla"));
    gtk_about_dialog_set_license_type(GTK_ABOUT_DIALOG(about),
        GTK_LICENSE_GPL_3_0);
    gtk_window_set_transient_for(GTK_WINDOW(about), parent);
    gtk_window_set_modal(GTK_WINDOW(about), TRUE);
    gtk_window_present(GTK_WINDOW(about));
}
