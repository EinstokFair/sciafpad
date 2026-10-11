#include <string>
#include <glib/gi18n.h>
#include <gtk/gtk.h>
#include <ScintillaView.h>
#include <Scintilla.h>
#include "config.h"
#include "about.h"

// ---------- Вспомогательные функции ----------

static gintptr sci_send(GtkWidget* sci, unsigned int msg,
                        guintptr wParam = 0, gintptr lParam = 0) {
    return scintilla_view_send_message((ScintillaView*)sci, msg, wParam, lParam);
}

static std::string sci_get_text(GtkWidget* sci) {
    auto len = sci_send(sci, SCI_GETLENGTH, 0, 0);
    std::string buf;
    buf.resize(len + 1);
    sci_send(sci, SCI_GETTEXT, (guintptr)(len + 1),
             reinterpret_cast<gintptr>(buf.data()));
    buf.resize(len);
    return buf;
}

static void sci_set_text(GtkWidget* sci, const std::string& text) {
    sci_send(sci, SCI_SETTEXT, 0, reinterpret_cast<gintptr>(text.c_str()));
}

static bool read_file(GFile* file, std::string& out) {
    char* contents = nullptr;
    gsize len = 0;
    GError* err = nullptr;
    if (!g_file_load_contents(file, nullptr, &contents, &len, nullptr, &err)) {
        g_printerr("read error: %s\n", err->message);
        g_error_free(err);
        return false;
    }
    out.assign(contents, len);
    g_free(contents);
    return true;
}

static bool write_file(GFile* file, const std::string& text) {
    GError* err = nullptr;
    if (!g_file_replace_contents(file, text.data(), text.size(),
                                 nullptr, FALSE,
                                 G_FILE_CREATE_NONE, nullptr, nullptr, &err)) {
        g_printerr("write error: %s\n", err->message);
        g_error_free(err);
        return false;
    }
    return true;
}

// ---------- Состояние редактора ----------

struct EditorState {
    GtkWidget* window;
    GtkWidget* sci;
    GFile* file = nullptr;
};

static void update_title(EditorState* st) {
    if (st->file) {
        char* name = g_file_get_basename(st->file);
        gtk_window_set_title(GTK_WINDOW(st->window), name);
        g_free(name);
    } else {
        gtk_window_set_title(GTK_WINDOW(st->window), _("sciafpad"));
    }
}

// ---------- Callback: открытие файла ----------

static void on_open_finish(GObject* source, GAsyncResult* res, gpointer user_data) {
    EditorState* st = static_cast<EditorState*>(user_data);
    GError* err = nullptr;
    GFile* file = gtk_file_dialog_open_finish(GTK_FILE_DIALOG(source), res, &err);
    if (!file) {
        if (err) g_error_free(err);
        return;
    }
    std::string contents;
    if (read_file(file, contents)) {
        sci_set_text(st->sci, contents);
        if (st->file) g_object_unref(st->file);
        st->file = file;
        update_title(st);
    } else {
        g_object_unref(file);
    }
}

// ---------- Callback: сохранение файла ----------

static void on_save_finish(GObject* source, GAsyncResult* res, gpointer user_data) {
    EditorState* st = static_cast<EditorState*>(user_data);
    GError* err = nullptr;
    GFile* file = gtk_file_dialog_save_finish(GTK_FILE_DIALOG(source), res, &err);
    if (!file) {
        if (err) g_error_free(err);
        return;
    }
    std::string text = sci_get_text(st->sci);
    if (write_file(file, text)) {
        if (st->file) g_object_unref(st->file);
        st->file = file;
        update_title(st);
    } else {
        g_object_unref(file);
    }
}

// ---------- Активация окна ----------

static void on_activate(GtkApplication* app, gpointer user_data) {
    GtkWidget* window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), _("sciafpad"));
    gtk_window_set_default_size(GTK_WINDOW(window), 900, 600);

    // --- Меню ---
    GMenu* menubar = g_menu_new();

    GMenu* file_menu = g_menu_new();
    g_menu_append(file_menu, _("Открыть…"),       "win.open");
    g_menu_append(file_menu, _("Сохранить"),      "win.save");
    g_menu_append(file_menu, _("Сохранить как…"), "win.save-as");
    g_menu_append(file_menu, _("О программе"),    "win.about");
    g_menu_append(file_menu, _("Выход"),          "app.quit");
    g_menu_append_submenu(menubar, _("Файл"), G_MENU_MODEL(file_menu));

    GMenu* edit_menu = g_menu_new();
    g_menu_append(edit_menu, _("Отменить"),   "win.undo");
    g_menu_append(edit_menu, _("Повторить"),  "win.redo");
    g_menu_append(edit_menu, _("Вырезать"),   "win.cut");
    g_menu_append(edit_menu, _("Копировать"), "win.copy");
    g_menu_append(edit_menu, _("Вставить"),   "win.paste");
    g_menu_append_submenu(menubar, _("Правка"), G_MENU_MODEL(edit_menu));

    GtkWidget* menubar_widget =
        gtk_popover_menu_bar_new_from_model(G_MENU_MODEL(menubar));

    // --- Scintilla ---
    GtkWidget* sci = scintilla_view_new();

    sci_send(sci, SCI_STYLESETFONT,  STYLE_DEFAULT, reinterpret_cast<gintptr>("Monospace"));
    sci_send(sci, SCI_STYLESETSIZE,  STYLE_DEFAULT, 12);
    sci_send(sci, SCI_STYLECLEARALL, 0, 0);
    sci_send(sci, SCI_SETMARGINWIDTHN, 0, 0);
    sci_send(sci, SCI_SETMARGINWIDTHN, 1, 0);
    sci_send(sci, SCI_SETMARGINWIDTHN, 2, 0);

    GtkWidget* scrolled = gtk_scrolled_window_new();
    gtk_scrolled_window_set_child(GTK_SCROLLED_WINDOW(scrolled), sci);
    gtk_widget_set_vexpand(scrolled, TRUE);

    GtkWidget* vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_box_append(GTK_BOX(vbox), menubar_widget);
    gtk_box_append(GTK_BOX(vbox), scrolled);
    gtk_window_set_child(GTK_WINDOW(window), vbox);

    // --- Состояние ---
    EditorState* st = new EditorState{ window, sci, nullptr };

    // --- Действие: Выход ---
    GSimpleAction* act_quit = g_simple_action_new("quit", nullptr);
    g_signal_connect_swapped(act_quit, "activate",
                             G_CALLBACK(gtk_window_destroy), window);
    g_action_map_add_action(G_ACTION_MAP(app), G_ACTION(act_quit));

    // --- Действие: Открыть ---
    GSimpleAction* act_open = g_simple_action_new("open", nullptr);
    g_signal_connect(act_open, "activate",
        G_CALLBACK(+[](GSimpleAction*, GVariant*, gpointer data){
            EditorState* s = static_cast<EditorState*>(data);
            GtkFileDialog* dlg = gtk_file_dialog_new();
            gtk_file_dialog_set_title(dlg, _("Открыть файл"));
            gtk_file_dialog_open(dlg, GTK_WINDOW(s->window), nullptr,
                                 on_open_finish, s);
            g_object_unref(dlg);
        }), st);
    g_action_map_add_action(G_ACTION_MAP(window), G_ACTION(act_open));

    // --- Действие: Сохранить как ---
    GSimpleAction* act_save_as = g_simple_action_new("save-as", nullptr);
    g_signal_connect(act_save_as, "activate",
        G_CALLBACK(+[](GSimpleAction*, GVariant*, gpointer data){
            EditorState* s = static_cast<EditorState*>(data);
            GtkFileDialog* dlg = gtk_file_dialog_new();
            gtk_file_dialog_set_title(dlg, _("Сохранить как"));
            gtk_file_dialog_set_initial_name(dlg, _("untitled.txt"));
            gtk_file_dialog_save(dlg, GTK_WINDOW(s->window), nullptr,
                                 on_save_finish, s);
            g_object_unref(dlg);
        }), st);
    g_action_map_add_action(G_ACTION_MAP(window), G_ACTION(act_save_as));

    // --- Действие: Сохранить ---
    GSimpleAction* act_save = g_simple_action_new("save", nullptr);
    g_signal_connect(act_save, "activate",
        G_CALLBACK(+[](GSimpleAction*, GVariant*, gpointer data){
            EditorState* s = static_cast<EditorState*>(data);
            if (s->file) {
                std::string text = sci_get_text(s->sci);
                write_file(s->file, text);
            } else {
                g_action_group_activate_action(
                    G_ACTION_GROUP(s->window), "save-as", nullptr);
            }
        }), st);
    g_action_map_add_action(G_ACTION_MAP(window), G_ACTION(act_save));

    // --- Действие: О программе ---
    GSimpleAction* act_about = g_simple_action_new("about", nullptr);
    g_signal_connect(act_about, "activate",
        G_CALLBACK(+[](GSimpleAction*, GVariant*, gpointer data){
            show_about(GTK_WINDOW(data));
        }), window);
    g_action_map_add_action(G_ACTION_MAP(window), G_ACTION(act_about));

    struct EditAction { const char* name; unsigned int msg; };
    const EditAction edit_actions[] = {
        {"undo",  SCI_UNDO},
        {"redo",  SCI_REDO},
        {"cut",   SCI_CUT},
        {"copy",  SCI_COPY},
        {"paste", SCI_PASTE},
    };
    for (const auto& ea : edit_actions) {
        GSimpleAction* act = g_simple_action_new(ea.name, nullptr);
        g_object_set_data(G_OBJECT(act), "sci", sci);
        g_object_set_data(G_OBJECT(act), "msg", GUINT_TO_POINTER(ea.msg));
        g_signal_connect(act, "activate",
            G_CALLBACK(+[](GSimpleAction* a, GVariant*, gpointer){
                GtkWidget* s = GTK_WIDGET(g_object_get_data(G_OBJECT(a), "sci"));
                unsigned int msg = GPOINTER_TO_UINT(
                    g_object_get_data(G_OBJECT(a), "msg"));
                sci_send(s, msg);
            }), nullptr);
        g_action_map_add_action(G_ACTION_MAP(window), G_ACTION(act));
    }

    gtk_window_present(GTK_WINDOW(window));
}

int main(int argc, char** argv) {
    bindtextdomain(GETTEXT_PACKAGE, LOCALEDIR);
    bind_textdomain_codeset(GETTEXT_PACKAGE, "UTF-8");
    textdomain(GETTEXT_PACKAGE);

    GtkApplication* app = gtk_application_new(
        "org.example.sciafpad", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(on_activate), nullptr);
    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}
