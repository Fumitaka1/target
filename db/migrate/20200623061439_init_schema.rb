class InitSchema < ActiveRecord::Migration[5.2]
  def up
    create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name", null: false
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.bigint "blob_id", null: false
      t.datetime "created_at", null: false
      t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
      t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    end
    create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.bigint "byte_size", null: false
      t.string "checksum", null: false
      t.datetime "created_at", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end
    create_table "bookmarks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.bigint "post_id"
      t.bigint "user_id"
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["post_id"], name: "index_bookmarks_on_post_id"
      t.index ["user_id"], name: "index_bookmarks_on_user_id"
    end
    create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "content", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "post_id"
      t.bigint "user_id"
      t.index ["post_id"], name: "index_comments_on_post_id"
      t.index ["user_id"], name: "index_comments_on_user_id"
    end
    create_table "posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "title", null: false
      t.text "content", null: false
      t.string "image"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "user_id"
      t.index ["created_at"], name: "index_posts_on_user_id_and_created_at"
      t.index ["user_id"], name: "index_posts_on_user_id"
    end
    create_table "relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "follower_id"
      t.integer "followed_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["followed_id", "follower_id"], name: "index_relationships_on_followed_id_and_follower_id", unique: true
      t.index ["followed_id"], name: "index_relationships_on_followed_id"
      t.index ["follower_id"], name: "index_relationships_on_follower_id"
    end
    create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name", default: "", null: false
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "icon"
      t.boolean "admin", default: false
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end
    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
