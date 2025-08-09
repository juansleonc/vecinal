# ApplicationController

Hooks globales: CSRF, `set_locale`, `check_subdomain`, auth, `configure_permitted_parameters`, `change_password`, `set_user_time_zone`.
Helpers: `current_user` (incluye `AdminUser`), `current_user_contacts`, `current_building`, `user_dashboard`, `user_notifications_manager`.
Rescates: `CanCan::AccessDenied`.
Paginación incremental: `set_pagination` + `load_more_at_bottom_respond_to`.
