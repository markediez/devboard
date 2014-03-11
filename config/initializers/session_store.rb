# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_devboard_session'
Rails.application.config.session_store :active_record_store
ActionDispatch::Session::ActiveRecordStore.session_class = ActiveRecord::SessionStore::SqlBypass
